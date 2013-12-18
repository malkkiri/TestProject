/**
 * GameLayer.
 * Date: 18.03.13
 * Time: 12:59
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package view.layer {
	import com.greensock.TweenMax;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;

	import flashx.textLayout.edit.IInteractionEventHandler;

	import model.LevelController;
	import model.SoundController;

	import view.GameFieldView;
	import view.ViewController;

	public class GameLayer extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		public var gameView:GameFieldView;

		private var gameMapList:Array = ["lab_6x6_1", "lab_8x8_1", "lab_10x10_2"];
		private var index:int = 0;
		private var rotationPoint:Number;

		private var gameRoundBg:Sprite;
		private var arrowSp:Sprite;
		private var mountHolder:Sprite;
		private var gameHolder:Sprite;
		private var rotationLayer:Sprite;
		private var mainBackGround:Sprite;
		private var infoPanel:Sprite;

		private var levelController:LevelController;
		private var viewController:ViewController;

		private var finishRotationPoint:Number;
		private var isRotation:Boolean;

		//--------------------------------------------------------------------------
		//  Public properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------

		public function GameLayer(_viewController:ViewController) {
			viewController = _viewController;
			init();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function addListner():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUP);
			stage.focus = this;
			stage.focus = null;
		}

		public function updateAfterRotation(rotationPoint:Number = 0):void {
			gameView.updateAfterRotation(rotationPoint);
		}

		public function onPause(val:Boolean):void {
			if (val) {
				if (isRotation) {
					TweenMax.killTweensOf(rotationLayer);
					TweenMax.killTweensOf(mountHolder);
				} else {
					gameView.stopActions(false);
				}
			} else {
				if (isRotation) {
					var step:int = (finishRotationPoint - rotationLayer.rotationZ) / 90;
					TweenMax.to(rotationLayer, Math.abs(step * 0.75), {rotationZ: finishRotationPoint, onComplete: onCompleteRotation});
					TweenMax.to(mountHolder, Math.abs(step * 0.75), {rotationZ: -finishRotationPoint});
				} else {
					gameView.continueActions();
				}
			}
			gameView.onPause(val);
			levelController.onPause(val);
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function init():void {

			levelController = LevelController.instance;
			levelController.startFirastLevel();
			addBackGround();
			addInfo();
			addLevel();
		}

		private function addInfo():void {
			infoPanel = new topInfoPanel();
			infoPanel.x = (this.width - infoPanel.width) * 0.5;
			infoPanel.y = 0;
			this.addChild(infoPanel);
		}

		private function updateInfoPabel():void {
			(infoPanel["levelTf"] as TextField).text = levelController.currentLevelNumber.toString();
			(infoPanel["scoreTf"] as TextField).text = levelController.getScoreTotalPoint().toString();
			(infoPanel["lifeTf"] as TextField).text = levelController.userLives.toString();
		}

		private function rotationView():void {
			if (gameView) {
				if (gameView.levelIsEnd)return;
				rotationPoint = levelController.getRotationPoint();
				gameView.stopActions();
				rotationPoint = rotationLayer.rotationZ + levelController.getRotationPoint();
				if (rotationPoint > 360) {
					rotationPoint = rotationPoint - 360;
				}
				var speed:Number = 0.75;
				speed = speed * (rotationPoint / 90);
				finishRotationPoint = rotationPoint;
				isRotation = true;
				var step:int = (finishRotationPoint - rotationLayer.rotationZ) / 90;
				//				trace(finishRotationPoint, rotationLayer.rotationZ, step);

				TweenMax.to(rotationLayer, Math.abs(step * 0.75), {rotationZ: finishRotationPoint, onComplete: onCompleteRotation});
				TweenMax.to(mountHolder, Math.abs(step * 0.75), {rotationZ: -finishRotationPoint});
			}

		}

		private function onCompleteRotation():void {
			isRotation = false;
			updateAfterRotation(rotationPoint);
			gameView.continueActions();
		}

		private function addBackGround():void {
			mainBackGround = new Sprite();
			mainBackGround.addChild(new Bitmap(new mainBack));
			this.addChild(mainBackGround);

			gameHolder = new Sprite();
			mountHolder = new Sprite();
			rotationLayer = new Sprite();
			gameRoundBg = new gr_kryg();

		}

		private function addLevel():void {

			levelController.configNextLevel();
			levelController.addEventListener(LevelController.EVENT_ROTATION, rotationEventHandler, false, 0, true);
			//			var levelName:String = levelController.getConfigMapData();
			gameView = new GameFieldView(levelController.getConfigMapData());
			gameView.addEventListener(GameFieldView.EVENT_IS_READY, eventHandler, false, 0, true);
			gameView.addEventListener(GameFieldView.EVENT_IS_FINISH, eventHandler, false, 0, true);
			this.addChild(gameView);

			/*var levelName:String = gameMapList[index];
			 gameView = new GameFieldView(levelName);
			 gameView.addEventListener(GameFieldView.EVENT_IS_READY, eventHandler, false, 0, true);
			 gameView.addEventListener(GameFieldView.EVENT_IS_FINISH, eventHandler, false, 0, true);
			 index++;
			 */
		}

		private function eventHandler(event:Event):void {

			if (event.type != GameFieldView.EVENT_IS_READY) {} else {
				gameView.removeEventListener(GameFieldView.EVENT_IS_READY, eventHandler);
				createLevelContent();
				levelController.startLevel(gameView.enemyMoveFullTime);
				gameView.start();
				updateInfoPabel();
			}

			if (event.type == GameFieldView.EVENT_IS_FINISH) {
				trace("<< LevelFinished >>");
				rotationPoint = 0;
				rotationLayer.rotationZ = 0;
				mountHolder.rotationZ = 0;
				gameHolder.removeChild(gameRoundBg);
				gameRoundBg = null;

				gameHolder.removeChild(gameView);
				gameView.destroy();
				gameView = null;

				levelController.endLevel();
				if (levelController.isNextLevelAvaible()) {
					addLevel();
				} else {
					//levelController.saveScore();
					//Main.cSCClientController.saveScore(currentLevelNumber - 1, getScoreTotalPoint());
					SoundController.instance.playSound(SoundController.FINISH_SOUND);
					viewController.showFinishScene();
				}

			}
		}

		private function createLevelContent():void {
			//trace(gameView.width + " x " + gameView.height);
			gameRoundBg = new gr_kryg();
			var scaleKoef:Number;
			var result:Object = getWidthForCircle(gameView.width);
			var circleWidth:int = result["circle"];
			var mountWidth:int = result["mount"];

			scaleKoef = circleWidth / gameRoundBg.width;
			gameRoundBg.scaleX = gameRoundBg.scaleY = scaleKoef;

			trace("scaleKoef= " + scaleKoef);

			gameRoundBg.y = -13 * scaleKoef;
			gameHolder.addChild(gameRoundBg);

			gameView.x = ((gameRoundBg.width - gameView.width) >> 1);
			gameView.y = ((gameRoundBg.width - gameView.height) >> 1);

			gameHolder.addChild(gameView);
			var bt:Bitmap = new Bitmap(new BitmapData(gameHolder.width, gameHolder.height));

			gameHolder.x = -gameHolder.width * 0.5;
			gameHolder.y = -gameHolder.height * 0.5;
			rotationLayer.addChild(gameHolder);

			var mountSp:Sprite = new mount();
			var mountScaleKoef:Number = mountWidth / mountSp.width;
			mountSp.scaleX = mountSp.scaleY = mountScaleKoef;
			mountSp.x = -mountSp.width * 0.5;
			mountSp.y = -mountSp.height * 0.5;
			mountHolder.addChild(mountSp);

			rotationLayer.x = rotationLayer.width * 0.5 + (this.width - rotationLayer.width) * 0.5 - 2;
			rotationLayer.y = rotationLayer.height * 0.5 + (this.height - rotationLayer.height) * 0.5 //+ 26 * scaleKoef;

			mountHolder.x = mountHolder.width * 0.5 + (this.width - mountHolder.width) * 0.5;
			mountHolder.y = mountHolder.height * 0.5 + (this.height - mountHolder.height) * 0.5;
			this.addChild(mountHolder);
			this.addChild(rotationLayer);
			this.addChild(infoPanel);
			addListner();
		}

		private function getWidthForCircle(gameWidth:int):Object {
			var result:Object
			if (gameWidth > 340) {
				return result = {"circle": 470, "mount": 714}
			}
			if (gameWidth > 300) {
				return result = {"circle": 440, "mount": 664}
			}
			if (gameWidth > 230) {
				return result = {"circle": 360, "mount": 560}
			}
			return result = {"circle": 320, "mount": 480}
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------
		private function onKeyUP(event:KeyboardEvent):void {
			if (gameView) {
				gameView.stopHerou(event.keyCode.toString());
			}
		}

		private function onKeyDown(event:KeyboardEvent):void {
			if (gameView) {
				gameView.moveHerou(event.keyCode.toString());
			}
		}

		private function rotationEventHandler(event:Event):void {
			rotationView();
		}

		//--------------------------------------------------------------------------
		//  Destroy
		//--------------------------------------------------------------------------
		public function destroy():void {
			while (numChildren) {
				this.removeChildAt(0);
			}
		}

	}
}
