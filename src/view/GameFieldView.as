/**
 * GameFieldView.
 * Date: 13.03.13
 * Time: 15:02
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package view {

	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

	import flash.display.Bitmap;

	import flash.display.Loader;
	import flash.display.MovieClip;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	import flashx.textLayout.edit.IInteractionEventHandler;

	import model.FieldModel;
	import model.LevelController;
	import model.MathFieldCalculation;
	import model.MoveEnemyController;
	import model.ShowStarController;
	import model.SoundController;

	import redactor.MapImageCreator;

	import redactor.model.SimpleMapData;

	import serialization.JSON1;

	import view.cell.CellItem;

	public class GameFieldView extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------
		private const MOVE_LEFT:String = "move_left";
		private const MOVE_RIGHT:String = "move_right";
		private const MOVE_DOWN:String = "move_down";
		private const MOVE_UP:String = "move_up";

		public static const EVENT_IS_READY:String = "is_ready";
		public static const EVENT_IS_FINISH:String = "is_finish";

		public static var DISTANSE:Number = 50;
		public static var SPEED_BY_ONE:Number = 0.1;

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------

		private var fieldImage:Sprite;

		private var fieldModel:FieldModel;
		private var mathCalc:MathFieldCalculation;
		private var enemyMoveController:MoveEnemyController;
		private var startController:ShowStarController;

		private var cellDictionary:Dictionary = new Dictionary(false);

		private var herouItem:UnitItem;
		private var enemyItem:UnitItem;
		private var goalItem:UnitItem;

		private var isMovingHerou:Boolean;
		private var movingDirection:String;
		private var _levelIsEnd:Boolean;

		private var isFirstAction:Boolean;
		private var isRotation:Boolean;
		private var isPause:Boolean;

		private var loader:URLLoader;

		private var backGround:MovieClip = new MovieClip();
		//private var tweenObject:IObjectTween;

		private var moveDirection:Object = {"39": MOVE_RIGHT, "37": MOVE_LEFT, "38": MOVE_UP, "40": MOVE_DOWN};

		private var nextMovingDirection:String;

		//		private var gameSettingsName:String;

		private var cellItemWidth:int;
		private var cellItemHeight:int;

		private var totalSteps:int = 0;

		private var isMoving:Boolean;

		private var simpleMapData:SimpleMapData;

		private var _enemyMoveFullTime:Number;

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

		public function GameFieldView(value:SimpleMapData) {
			simpleMapData = value;
			/* setData();
			 setField();
			 addItems();*/
			this.addEventListener(Event.ADDED_TO_STAGE, initGameField, false, 0, true);
		}

		private function initGameField(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, initGameField);
			loadData();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function moveHerou(direction:String = ""):void {
			isFirstAction = true;
			if (_levelIsEnd)return;
			if (moveDirection[direction]) {

				if (movingDirection == moveDirection[direction])return;
				SoundController.instance.playSound(SoundController.CLICK_SOUND);
				if (isMovingHerou) {
					nextMovingDirection = direction;

					return;
				}
				if (!herouItem)return;
				movingDirection = moveDirection[direction];
				setItemMoveItem(movingDirection);

				//	trace("CLICK_SOUND")
			}
		}

		public function stopActions(isRotationStop:Boolean = true):void {
			isRotation = true;
			TweenMax.pauseAll();
			if (enemyMoveController) {
				enemyMoveController.stopActions();
			}
			if (herouItem) {
				herouItem.pauseAnimation();
			}
			stopTween();
			//movingDirection = "";
		}

		public function continueActions():void {

			isRotation = false;
			nextMovingDirection = "";
			TweenMax.resumeAll();
			if (enemyMoveController) {
				enemyMoveController.continueActions();
			}
			if (herouItem) {
				trace("movingDirection= " + movingDirection);
				if (movingDirection) {
					movingDirection = "";
					lastTween();
					//	setItemMoveItem(movingDirection);
				}
			}

		}

		public function updateAfterRotation(rotationPoint:Number = 0):void {
			herouItem.stopMoving();
			herouItem.updateAfterRotation(rotationPoint);
			enemyItem.updateAfterRotation(rotationPoint);

			if (isMovingHerou) {
				herouItem.continueMoving();
			} else {
				herouItem.stopMoving();
			}

			/*if (movingDirection) {
			 trace("___ 2   __" + herouItem.position + "   " + herouItem.x + " x " + herouItem.y + " " + herouItem.width + " xx " + herouItem.height);
			 //setItemMoveItem(movingDirection);
			 trace("___ 3   __" + herouItem.position + "   " + herouItem.x + " x " + herouItem.y + "   " + herouItem.width + " xx " + herouItem.height);
			 }*/
		}

		public function stopHerou(keyCode:String = ""):void {
			if (_levelIsEnd)return;

			/*if (isPause){
			 return;
			 }*/
			if (nextMovingDirection == keyCode) {
				nextMovingDirection = "";
			}
			if (!moveDirection[keyCode]) return;
			if (moveDirection[keyCode] != movingDirection) return;

			//isMovingHerou = false;

			if (isRotation)return;
			lastTween();
		}

		public function onPause(val:Boolean):void {
			if (startController) {
				startController.onPause(val);
			}
			isPause = val;
		}

		private function lastTween():void {

			var keyPosition:String = herouItem.position.x + "," + herouItem.position.y;
			herouItem.nextPosition = herouItem.position;
			var cell:CellItem = cellDictionary[keyPosition];
			var posX:int = cell.x + int((cell.width - herouItem.itemWidth) >> 1);
			var posY:int = cell.y + int((cell.height - herouItem.itemHeight) >> 1);

			var maxDx:Number = 2;

			var distance:Number = Math.abs(herouItem.x - cell.x) < 1.5 ? Math.abs(herouItem.y - cell.y) : Math.abs(herouItem.x - cell.x);
			var lastSpeedKoef:Number = distance / cell.width;
			if (lastSpeedKoef == 0) {
				onFinishTween();
			} else {
				TweenMax.to(herouItem, lastSpeedKoef * SPEED_BY_ONE, {x: posX, y: posY, onComplete: onFinishTween, onUpdate: checkForFinish, ease: Linear.easeNone});
				//	isMovingHerou = true;
			}
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function loadData():void {
			setGame();
			//			return;
			//
			//			var url:String = LevelController.instance.recoursePath + gameSettingsName;
			//			//var url:String = "../../../assets/" + gameSettingsName;
			//			var urlRequest:URLRequest = new URLRequest(url);
			//			loader = new URLLoader();
			//			loader.dataFormat = URLLoaderDataFormat.TEXT;
			//			loader.addEventListener(Event.COMPLETE, onCompleteEvent2);
			//			loader.load(urlRequest);
		}

		private function setGame():void {
			//			var data:Object = LevelController.instance.getMapDaraModelById(gameSettingsName);
			setData(simpleMapData);
			setBackGround();
			continueWorking();
			//			setImage(data.img);
		}

		private function setBackGround():void {
			var imageCreator:MapImageCreator = new MapImageCreator();
			//			data.cellSize = viewSettings.cellSize;
			var data:Object = {};
			data.rows = simpleMapData.rows;
			data.colums = simpleMapData.columns;
			data.cellSize = simpleMapData.cellWidth
			data.field = simpleMapData.field.split(",");

			imageCreator.setResultData(data);
			imageCreator.createImage();
			var bt:Bitmap = new Bitmap(imageCreator.saveImage());
			backGround.addChild(bt);
		}

		//		private function onError2(event:IOErrorEvent):void {
		//			trace("BOLT")
		//		}

		//		private function onCompleteEvent2(event:Event):void {
		//			trace(loader.data)
		//			var data:Object = JSON1.decode(loader.data);
		//			if (data) {
		//				setData(data);
		//			}
		//			//loadRes();
		//			setImage(gameSettingsName);
		//		}

		private function addItems():void {

			var cell:CellItem;
			var key:String;

			var herouItemWidth:int = cellItemWidth - 1;
			var herouItemHeight:int = cellItemHeight - 1;

			herouItem = new UnitItem(herouItemWidth, herouItemHeight);
			//	herouItem.scaleX = herouItem.scaleY = 0.95;
			key = fieldModel.getPlayersPositions()[0];
			cell = cellDictionary[key];
			herouItem.x = (cell.x + int((cell.width - herouItem.itemWidth) >> 1));
			herouItem.y = cell.y + int((cell.height - herouItem.itemHeight) >> 1);
			herouItem.position = new Point(cell.posX, cell.posY);
			this.addChild(herouItem);

			enemyItem = new UnitItem(herouItemWidth, herouItemHeight, true);
			//	enemyItem.scaleX = enemyItem.scaleY = 0.95;
			key = fieldModel.getPlayersPositions()[1];
			cell = cellDictionary[key];
			enemyItem.x = cell.x + int((cell.width - enemyItem.width) >> 1);
			enemyItem.y = cell.y + int((cell.height - enemyItem.height) >> 1);
			enemyItem.position = new Point(cell.posX, cell.posY);
			this.addChild(enemyItem);

			goalItem = new UnitItem(herouItemWidth, herouItemHeight, false, true);

			var goalPos1:String = fieldModel.getPlayersPositions()[2];
			var goalPos2:String = fieldModel.getPlayersPositions()[3];
			var cell2:CellItem;

			cell = cellDictionary[goalPos1];
			cell2 = cellDictionary[goalPos2];

			var posXFirst:int = cell.x + int((cell.width - goalItem.width) >> 1);
			var posYFirst:int = cell.y + int((cell.height - goalItem.height) >> 1);

			var posXSecond:int = cell2.x + int((cell2.width - goalItem.width) >> 1);
			var posYSecond:int = cell2.y + int((cell2.height - goalItem.height) >> 1);

			goalItem.x = posXFirst + Math.abs(posXFirst - posXSecond) * 0.5;
			goalItem.y = posYFirst + Math.abs(posYFirst - posYSecond) * 0.5;

			goalItem.position = new Point(cell.posX, cell.posY);
			this.addChild(goalItem);

			enemyMoveController.cellDictionary = cellDictionary;
			enemyMoveController.item = enemyItem;
			enemyMoveController.goalPosition = fieldModel.getPlayersPositions()[2];

			enemyMoveController.setMove(goalItem);
			enemyMoveController.alpha = 0;
			this.addChild(enemyMoveController);
			//finishLevel();
		}

		private function setData(value:SimpleMapData):void {
			fieldModel = new FieldModel();

			var data:Object = {};
			data.herouPosition = value.heroPosition.x + "," + value.heroPosition.y;
			data.enemyPosition = value.enemyPosition.x + "," + value.enemyPosition.y;
			data.itemPositionFirst = value.cheesePositionFirst.x + "," + value.cheesePositionFirst.y;
			data.itemPositionSecond = value.cheesePositionSecond.x + "," + value.cheesePositionSecond.y;
			data.rows = value.rows;
			data.colums = value.columns;
			data.field = value.field.split(",");

			fieldModel.setData(data);

			mathCalc = new MathFieldCalculation();

			//mathCalc.pathArray = fieldModel.getPathList();
			mathCalc.cellModelList = fieldModel.getItmesModelList();
			mathCalc.matrix = fieldModel.getPathFinderMap();

			enemyMoveController = new MoveEnemyController();
			enemyMoveController.addEventListener(MoveEnemyController.ENEMY_WINS, eventHandler, false, 0, true);
			enemyMoveController.mathCalc = mathCalc;

		}

		private function setField():void {

			var rows:int = fieldModel.getRows();
			var colums:int = fieldModel.getColumns();

			var cell:CellItem;
			for (var i:int = 0; i < rows; i++) {
				for (var j:int = 0; j < colums; j++) {
					cell = new CellItem(i, j, cellItemWidth, cellItemHeight);
					var key:String = i.toString() + "," + j.toString();
					//				cellDictionary[{x: i, y: j}] = new CellItem(i, j);
					cellDictionary[key] = cell;
					cell.x = cell.posX * (cell.width);
					cell.y = cell.posY * (cell.height);
					this.addChild(cell);
				}
			}
		}

		private function continueWorking():void {
			backGround.x = -3;
			backGround.y = -2;
			this.addChildAt(backGround, 0);

			setBaseParams();

			cellItemWidth = int(backGround.width / fieldModel.getRows());
			cellItemHeight = int(backGround.height / fieldModel.getColumns());

			setField();
			addItems();

			var steps:int = enemyMoveController.getFullSteps();
			_enemyMoveFullTime = SPEED_BY_ONE * steps * 3;

			dispatchEvent(new Event(EVENT_IS_READY));
		}

		private function setBaseParams():void {
			var mapWidth:int = backGround.width;
			var cellWidth:int = mapWidth / ((simpleMapData.rows + 1) * 0.5);
			var koef:Number = DISTANSE / cellWidth;
			SPEED_BY_ONE = koef * LevelController.instance.itemSpeed * 0.001;

			//			trace("SPEED_BY_ONE ", SPEED_BY_ONE, cellWidth, mapWidth, simpleMapData.rows);

		}

		private function setItemMoveItem(direction:String = ""):void {

			if (_levelIsEnd)return;
			if (isRotation)return;

			var posX:int = herouItem.position.x;
			var posY:int = herouItem.position.y;
			var key:String = "";
			key = posX + "," + posY;
			var startTime:int;
			var endTime:int;
			//startTime = getTimer();
			var newPositionKey:String = mathCalc.getPathForCell(direction, key);

			//endTime = getTimer();
			herouItem.updateDirection(direction);
			if (newPositionKey != "bad") {
				stopTween();

				moveItem(newPositionKey, herouItem);
				isMovingHerou = true;
				trace("   <<<    herouItem " + herouItem.position + "   " + " newPositionKey " + newPositionKey);
			} else {
				totalSteps++;
				SoundController.instance.playSound(SoundController.PENALTY_SOUND);
			}

		}

		private function stopTween():void {
			if (herouItem) {
				TweenMax.killTweensOf(herouItem);
			}
			removeEnterFrameListner();
		}

		private function moveItem(keyPosition:String, item:UnitItem):void {
			var cell:CellItem;
			var posX:int;
			var posY:int;

			var dx:Number;
			var dy:Number;
			var speed:Number;
			//			= SPEED_BY_ONE;

			cell = cellDictionary[keyPosition];
			posX = cell.x + int((cell.width - herouItem.itemWidth) >> 1);
			posY = cell.y + int((cell.height - herouItem.itemHeight) >> 1);

			item.lastPosition = herouItem.position;
			item.nextPosition = new Point(cell.posX, cell.posY);
			dx = Math.abs(item.nextPosition.x - herouItem.position.x);
			dy = Math.abs(item.nextPosition.y - herouItem.position.y);
			speed = dy >= dx ? dy : dx;

			TweenMax.to(item, speed * SPEED_BY_ONE, {x: posX, y: posY, onComplete: onFinishTween, ease: Linear.easeNone});

			/*tweenObject = BetweenAS3.to(herouItem, {x: posX, y: posY}, speed * SPEED_BY_ONE);
			 tweenObject.onComplete = onFinishTween;
			 tweenObject.onUpdate = updateFunction;
			 tweenObject.play(); */
			addEnterFrameListner();
		}

		private function addEnterFrameListner():void {
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}

		private function removeEnterFrameListner():void {
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event:Event):void {
			if (herouItem) {
				updateFunction(herouItem);
			}

		}

		private function updateFunction(currentItem:UnitItem):void {
			if (isRotation)return;

			var cell:CellItem;
			var changeDx:int;
			var changeDy:int;

			var cellPosX:int;
			var cellPosY:int;

			var herouPosX:int;
			var herouPosY:int;

			var herouLastPosX:int;
			var herouLastPosY:int;

			var nextPosX:int;
			var nextPosY:int;

			herouPosX = currentItem.position.x;
			herouPosY = currentItem.position.y;

			herouLastPosX = currentItem.lastPosition.x;
			herouLastPosY = currentItem.lastPosition.y;

			nextPosX = currentItem.nextPosition.x;
			nextPosY = currentItem.nextPosition.y;

			var middlePositionX:int;
			var middlePositionY:int;

			if (!isFirstAction)return;

			checkForFinish();

			for (var key:String in cellDictionary) {
				cell = cellDictionary[key];
				if (cell.hitTestObject(currentItem.getHitTestObject())) {
					cellPosX = cell.posX;
					cellPosY = cell.posY;

					if ((cellPosX != herouPosX) || (cellPosY != herouPosY)) {
						if ((cellPosX != herouLastPosX) || (cellPosY != herouLastPosY)) {

							changeDx = Math.abs(cellPosX - nextPosX);
							changeDy = Math.abs(cellPosY - nextPosY);

							middlePositionX = Math.abs(cellPosX - herouLastPosX);
							middlePositionY = Math.abs(cellPosY - herouLastPosY);

							if (changeDx == 0 || changeDy == 0) {
								if ((middlePositionX == 0 && middlePositionY != 0) || (middlePositionX != 0 && middlePositionY == 0)) {
									//									trace("    changeDx= ", changeDx, "   changeDy=", changeDy, "     ", cellPosX + "x" + cellPosY + "  item ", herouPosX, "x", herouPosY);

									showTraces(currentItem.position, currentItem.getCurrentDir());
									currentItem.lastPosition = currentItem.position;
									currentItem.position = new Point(cellPosX, cellPosY);

									herouLastPosX = herouPosX;
									herouLastPosY = herouPosY;

									herouPosX = cellPosX;
									herouPosY = cellPosY;

									totalSteps++;

								}

							}
						}
					}
				}
			}
			/*herouPosX = currentItem.position.x;
			 herouPosY = currentItem.position.y;

			 herouLastPosX = currentItem.lastPosition.x;
			 herouLastPosY = currentItem.lastPosition.y;

			 nextPosX = currentItem.nextPosition.x;
			 nextPosY = currentItem.nextPosition.y;

			 var middlePositionX:int;
			 var middlePositionY:int;

			 for (var key:String in cellDictionary) {
			 cell = cellDictionary[key];

			 middlePositionX = currentItem.x + currentItem.width * 0.5;
			 middlePositionY = currentItem.y + currentItem.height * 0.5;

			 if ((middlePositionX < (cell.x + cell.width)) && (middlePositionX > (cell.x))) {
			 if ((middlePositionY < (cell.y + cell.height)) && (middlePositionY > (cell.y))) {
			 cellPosX = cell.posX;
			 cellPosY = cell.posY;
			 if ((cellPosX != herouPosX) || (cellPosY != herouPosY)) {
			 if ((cellPosX != herouLastPosX) || (cellPosY != herouLastPosY)) {

			 changeDx = Math.abs(cellPosX - nextPosX);
			 changeDy = Math.abs(cellPosY - nextPosY);

			 if (changeDx == 0 || changeDy == 0) {
			 showTraces(currentItem.position, currentItem.getCurrentDir());
			 currentItem.lastPosition = currentItem.position;
			 currentItem.position = new Point(cellPosX, cellPosY);
			 }

			 }
			 }

			 }

			 }

			 }*/

		}

		private function showTraces(position:Point, direction:String = ""):void {
			if (direction) {
				var keyPosition:String = position.x + "," + position.y;
				var cell:CellItem = cellDictionary[keyPosition];
				if (cell) {
					cell.setAsCompleted(direction);
					SoundController.instance.playSound(SoundController.STEP_SOUND);
				}
			}
		}

		private function checkForFinish():Boolean {
			//if (herouItem.hitTestObject(goalItem)) {
			if (!herouItem)return false;
			if (!goalItem)return false;
			var hit1:Boolean = goalItem.hitTestObject(herouItem.getHitTestObject());
			var hit2:Boolean = goalItem.hitTestObject(herouItem);
			//trace("hit1 " + hit1 + "  hit2 " + hit2);
			if (hit1 || hit2) {
				freezHerou();
				enemyMoveController.freezEnemy(false);
				_levelIsEnd = true;
				finishLevel();
				return true;
			}
			return false;
		}

		private function finishLevel(isEnemyWins:Boolean = false):void {

			var resultData:Object = {};
			resultData["enemySteps"] = enemyMoveController.getGoneSteps();
			resultData["enemyFullSteps"] = enemyMoveController.getFullSteps();
			resultData["heroSteps"] = totalSteps;
			resultData["isEnemy"] = isEnemyWins;

			LevelController.instance.setLevelResultData(resultData);

			startController = new ShowStarController(this);
			startController.addEventListener(ShowStarController.EVENT_END_STAR, onEndedStarAction, false, 0, true);

			var startPos:Point = new Point(goalItem.position.clone().x * 2, goalItem.position.clone().y * 2);
			var endPos:Point = new Point(enemyItem.position.clone().x * 2, enemyItem.position.clone().y * 2);

			if (isEnemyWins) {
				endPos = new Point(herouItem.position.clone().x * 2, herouItem.position.clone().y * 2);
			}

			var ar:Array = mathCalc.getPathForStar(startPos, endPos);
			if (isEnemyWins) {
				if (ar.length) {
					ar.length--;
				}
			}
			startController.showStars(ar, cellDictionary);

			var soundName:String = isEnemyWins ? SoundController.LOSE_SOUND : SoundController.WIN_SOUND;
			SoundController.instance.playSound(soundName);

		}

		private function endLevel():void {
			dispatchEvent(new Event(EVENT_IS_FINISH));
		}

		private function freezHerou(isWin:Boolean = true):void {
			stopTween();
			isMovingHerou = true;
			goalItem.visible = false;
			herouItem.showlastAnimation(isWin);
		}

		private function onFinishTween():void {
			isMovingHerou = false;
			movingDirection = "";
			herouItem.position = herouItem.nextPosition;
			herouItem.lastPosition = herouItem.nextPosition;
			herouItem.stopMoving();

			if (nextMovingDirection) {
				if (_levelIsEnd)return;
				if (isRotation)return;
				setItemMoveItem(moveDirection[nextMovingDirection]);
				movingDirection = moveDirection[nextMovingDirection];
				nextMovingDirection = "";
			}
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------

		private function eventHandler(event:Event):void {
			enemyMoveController.removeEventListener(MoveEnemyController.ENEMY_WINS, eventHandler);
			freezHerou(false);
			_levelIsEnd = true;
			finishLevel(true);
		}

		private function onEndedStarAction(event:Event):void {
			startController.removeEventListener(ShowStarController.EVENT_END_STAR, onEndedStarAction);
			endLevel();
		}

		//--------------------------------------------------------------------------
		//  Destroy
		//--------------------------------------------------------------------------
		public function destroy():void {
			if (enemyMoveController) {
				enemyMoveController.removeEventListener(MoveEnemyController.ENEMY_WINS, eventHandler);
				this.removeChild(enemyMoveController);
				enemyMoveController.destroy();
				enemyMoveController = null;
			}
			if (goalItem) {
				goalItem.destroy();
				this.removeChild(goalItem);
				goalItem = null;
			}
			if (enemyItem) {
				enemyItem.destroy();
				this.removeChild(enemyItem);
				enemyItem = null;
			}
			if (herouItem) {
				herouItem.destroy();
				this.removeChild(herouItem);
				herouItem = null;
			}
			if (mathCalc) {
				mathCalc = null;
			}
			if (fieldModel) {
				fieldModel = null;
			}
			var cellItem:CellItem;
			for (var key:String in cellDictionary) {
				cellItem = cellDictionary[key];
				this.removeChild(cellItem);
				cellItem.destroy();
				cellItem = null;
			}
			if (startController) {
				startController.destroy();
				startController = null;
			}
			while (this.numChildren) {
				this.removeChildAt(0);
			}

		}

		public function get levelIsEnd():Boolean {
			return _levelIsEnd;
		}

		public function start():void {
			enemyMoveController.startMove();
		}

		public function get enemyMoveFullTime():Number {
			return _enemyMoveFullTime;
		}
	}
}
