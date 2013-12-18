/**
 * PenguimItem.
 * Date: 13.03.13
 * Time: 16:11
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package view {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class UnitItem extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------
		private const MOVE_LEFT:String = "move_left";
		private const MOVE_RIGHT:String = "move_right";
		private const MOVE_DOWN:String = "move_down";
		private const MOVE_UP:String = "move_up";

		private const WIN:String = "win";
		private const LOST:String = "lost";
		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var _position:Point = new Point(0, 0);
		private var _lastPosition:Point = new Point(0, 0);
		private var _nextPosition:Point = new Point(0, 0);
		private var _isEnemy:Boolean;
		private var _isGoalItem:Boolean;

		private var currentDirection:String = "";

		private var _itemWidth:int;
		private var _itemHeight:int;

		private var directions:Dictionary = new Dictionary(false);

		private var currentImage:MovieClip;
		private var hitTestSprite:Sprite;

		private var rotationPoint:Number = 0;
		//--------------------------------------------------------------------------
		//  Public properties
		//--------------------------------------------------------------------------
		public function get position():Point {
			return _position;
		}

		public function set position(value:Point):void {
			_position = value;
		}

		public function get lastPosition():Point {
			return _lastPosition;
		}

		public function set lastPosition(value:Point):void {
			_lastPosition = value;
		}

		public function get nextPosition():Point {
			return _nextPosition;
		}

		public function set nextPosition(value:Point):void {
			_nextPosition = value;
		}

		public function get isEnemy():Boolean {
			return _isEnemy;
		}

		public function get itemWidth():int {
			return _itemWidth;
		}

		public function get itemHeight():int {
			return _itemHeight;
		}

		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------

		public function UnitItem(w:int, h:int, isEnemyItem:Boolean = false, isGoal:Boolean = false) {
			_itemWidth = w;
			_itemHeight = h;
			_isEnemy = isEnemyItem;
			_isGoalItem = isGoal;
			setImage();
			stopMoving();
		}

		public function updateDirection(dir:String):void {
			currentDirection = dir;
			if (currentImage) {
				if (this.contains(currentImage)) {
					this.removeChild(currentImage);
				}
				currentImage.gotoAndStop(1);
			}
			if (directions[rotationPoint.toString()][dir]) {
				currentImage = directions[rotationPoint.toString()][dir];
				/*
				 var scaleKoef:Number = currentImage.width / _itemWidth;
				 currentImage.scaleX = currentImage.scaleY = scaleKoef;
				 */

				currentImage.gotoAndStop(1);
				currentImage.mouseChildren = false;
				currentImage.mouseEnabled = false;
				//currentImage.rotationZ = rotationPoint;

				if (currentImage.scaleX == -1) {
					currentImage.scaleX = 1;
					if ((rotationPoint == 90) || (rotationPoint == 270)) {
						currentImage.rotationZ = -rotationPoint;
					} else {
						currentImage.rotationZ = rotationPoint;
					}
					currentImage.scaleX = -1;
				} else {
					if ((rotationPoint == 90) || (rotationPoint == 270)) {
						currentImage.rotationZ = -rotationPoint;
					} else {
						currentImage.rotationZ = rotationPoint;
					}
				}
				currentImage.x = currentImage.width >> 1;
				currentImage.y = currentImage.height >> 1;

				currentImage.x = (((_itemWidth - currentImage.width) >> 1) + currentImage.x);
				currentImage.y = (((_itemHeight - currentImage.height) >> 1) + currentImage.y);

				this.addChild(currentImage);
				//currentImage.alpha=0.1;
				currentImage.mouseChildren = false;
				currentImage.mouseEnabled = false;

				currentImage.gotoAndPlay(1);
			}
		}

		public function continueMoving():void {
			if (currentImage) {
				currentImage.gotoAndPlay(1);
			}
		}

		public function pauseAnimation():void {
			if (currentImage) {
				currentImage.gotoAndStop(1);
			}
		}

		public function stopMoving():void {
			if (currentImage) {
				if (currentDirection != WIN) {
					if (currentDirection != LOST) {
						currentImage.gotoAndStop(1);
					}
				}
			}
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function updateAfterRotation(_rotationPoint:Number = 0):void {
			rotationPoint = _rotationPoint;
			updateDirection(currentDirection);
		}

		public function getHitTestObject():DisplayObject {
			return hitTestSprite;
		}

		public function getCurrentDir():String {
			return currentDirection;
		}

		public function showlastAnimation(isWinAnimation:Boolean):void {
			currentDirection = isWinAnimation ? WIN : LOST;
			updateDirection(currentDirection);
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function setImage():void {

			//_itemWidth = 32;
			//_itemHeight = 32;

			if (!_isGoalItem) {
				var color:uint = isEnemy ? 0x0000FF00 : 0x000000FF;
				this.addChild(new Bitmap(new BitmapData(_itemWidth, _itemHeight, true, color)));

				setDirections();
				updateDirection(MOVE_DOWN);

				var color2:uint = isEnemy ? 0x00FF0000 : 0x00FF0000;
				hitTestSprite = new Sprite();
				hitTestSprite.addChild(new Bitmap(new BitmapData(_itemWidth - 4, _itemHeight - 4, true, color2)));
				hitTestSprite.x = (_itemWidth - hitTestSprite.width) >> 1;
				hitTestSprite.y = (_itemHeight - hitTestSprite.height) >> 1;
				this.addChild(hitTestSprite);
			} else {
				hitTestSprite = new Sprite();
				hitTestSprite.addChild(new Bitmap(new cheese()));
				this.addChild(hitTestSprite);
			}
			//this.hitArea = hitTestSprite;
		}

		private function setDirections():void {

			var moving_s:MovieClip;
			var moving_n:MovieClip;
			var moving_e:MovieClip;
			var moving_w:MovieClip;
			var win:MovieClip;
			var lose:MovieClip;

			if (_isEnemy) {
				moving_s = new mouse1_moving_s();
				moving_s.stop();

				moving_n = new mouse1_moving_n();
				moving_n.stop();

				moving_e = new mouse1_moving_bok();
				moving_e.stop();

				moving_w = new mouse1_moving_bok();
				moving_w.scaleX = -1;
				moving_w.stop();

				win = new mouse1_win();

				lose = new mouse1_lose();
			} else {
				moving_s = new mouse2_moving_s();
				moving_s.stop();

				moving_n = new mouse2_moving_n();
				moving_n.stop();

				moving_e = new mouse2_moving_bok();
				moving_e.stop();

				moving_w = new mouse2_moving_bok();
				moving_w.scaleX = -1;
				moving_w.stop();

				win = new mouse2_win();

				lose = new mouse2_lose();
			}

			//	directions[MOVE_DOWN] = moving_s;
			//	directions[MOVE_UP] = moving_n;
			//	directions[MOVE_RIGHT] = moving_e;
			//	directions[MOVE_LEFT] = moving_w;

			directions["0"] = new Dictionary(false);
			directions["0"][MOVE_UP] = moving_n;
			directions["0"][MOVE_DOWN] = moving_s;
			directions["0"][MOVE_RIGHT] = moving_e;
			directions["0"][MOVE_LEFT] = moving_w;
			directions["0"][WIN] = win;
			directions["0"][LOST] = lose;

			directions["90"] = new Dictionary(false);
			directions["90"][MOVE_UP] = moving_e;
			directions["90"][MOVE_DOWN] = moving_w;
			directions["90"][MOVE_RIGHT] = moving_s;
			directions["90"][MOVE_LEFT] = moving_n;
			directions["90"][WIN] = win;
			directions["90"][LOST] = lose;

			directions["180"] = new Dictionary(false);
			directions["180"][MOVE_UP] = moving_s;
			directions["180"][MOVE_DOWN] = moving_n;
			directions["180"][MOVE_RIGHT] = moving_w;
			directions["180"][MOVE_LEFT] = moving_e;
			directions["180"][WIN] = win;
			directions["180"][LOST] = lose;

			directions["270"] = new Dictionary(false);
			directions["270"][MOVE_UP] = moving_w;
			directions["270"][MOVE_DOWN] = moving_e;
			directions["270"][MOVE_RIGHT] = moving_n;
			directions["270"][MOVE_LEFT] = moving_s;
			directions["270"][WIN] = win;
			directions["270"][LOST] = lose;

			directions["360"] = new Dictionary(false);
			directions["360"][MOVE_UP] = moving_n;
			directions["360"][MOVE_DOWN] = moving_s;
			directions["360"][MOVE_RIGHT] = moving_e;
			directions["360"][MOVE_LEFT] = moving_w;
			directions["360"][WIN] = win;
			directions["360"][LOST] = lose;
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Destroy
		//--------------------------------------------------------------------------

		public function destroy():void {

			if (currentImage) {
				currentImage.stop();
				if (this.contains(currentImage)) {
					this.removeChild(currentImage);
				}
				currentImage = null;
			}

			while (this.numChildren) {
				this.removeChildAt(0);
			}

		}

		public function set itemWidth(value:int):void {
			_itemWidth = value;
		}

		public function set itemHeight(value:int):void {
			_itemHeight = value;
		}

	}
}
