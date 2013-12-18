/**
 * MoveEnemyController.
 * Date: 18.03.13
 * Time: 13:39
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package model {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

	import flash.display.PixelSnapping;
	import flash.display.Sprite;

	import flash.events.Event;

	import flash.events.EventDispatcher;

	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	import view.GameFieldView;

	import view.UnitItem;
	import view.cell.CellItem;

	public class MoveEnemyController extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------
		public static var ENEMY_WINS:String = "enemy_wins";

		private const MOVE_LEFT:String = "move_left";
		private const MOVE_RIGHT:String = "move_right";
		private const MOVE_DOWN:String = "move_down";
		private const MOVE_UP:String = "move_up";
		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var _mathCalc:MathFieldCalculation;
		private var _item:UnitItem;
		private var _goalPosition:String;
		private var _cellDictionary:Dictionary;
		private var currentDirection:String;

		private var moveStep:int;
		private var pathArray:Array = [];

		//private var tweenObject:IObjectTween;

		private var isNeedToCheck:Boolean;
		private var goalItem:UnitItem;

		private var isRotation:Boolean;
		private var fullSteps:int;
		private var startEnemyPosition:Point;
		//--------------------------------------------------------------------------
		//  Public properties
		//--------------------------------------------------------------------------

		public function get mathCalc():MathFieldCalculation {
			return _mathCalc;
		}

		public function set mathCalc(value:MathFieldCalculation):void {
			_mathCalc = value;
		}

		public function set item(value:UnitItem):void {
			_item = value;
		}

		public function set goalPosition(value:String):void {
			_goalPosition = value;
		}

		public function set cellDictionary(value:Dictionary):void {
			_cellDictionary = value;
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

		public function MoveEnemyController() {

		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function setMove(_goalItem:UnitItem):void {
			goalItem = _goalItem
			var stAr:Array = _goalPosition.split(",");
			var posX:int = stAr[0] * 2;
			var posY:int = stAr[1] * 2;
			var endPos:Point = new Point(posX, posY);
			var startPos:Point = new Point(_item.position.clone().x * 2, _item.position.clone().y * 2);

			startEnemyPosition = startPos.clone();
			pathArray = mathCalc.getPath(startPos, endPos);
			fullSteps = (mathCalc.getPath(startPos, endPos, false) as Array).length;
			fullSteps--;

			moveStep = 0;
		}

		public function startMove():void {
			delayMove();
		}

		public function freezEnemy(isWin:Boolean = true):void {
			_item.showlastAnimation(isWin);
			stopTween();
		}

		public function continueActions():void {
			isRotation = false;
			/*if (tweenObject) {
			 tweenObject.play();
			 }*/
			if (_item) {
				_item.continueMoving();
			}
		}

		public function stopActions():void {
			isRotation = true;
			/*if (tweenObject) {
			 tweenObject.stop();
			 }*/
			if (_item) {
				_item.pauseAnimation();
			}
		}

		public function getFullSteps():int {
			return fullSteps;
		}

		public function getGoneSteps():int {
			var endPos:Point = new Point(_item.position.clone().x * 2, _item.position.clone().y * 2);
			var currentSteps:Array = mathCalc.getPath(startEnemyPosition, endPos, false);
			if (currentSteps) return currentSteps.length;
			return 0;
			//fullSteps = (mathCalc.getPath(startPos, endPos, false) as Array).length;
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function delayMove():void {
			setTimeout(beginMove, 200);
			//beginMove();
		}

		private function beginMove():void {
			moveItem(pathArray[moveStep]);
		}

		private function moveItem(position:Point):void {
			if (!position)return;
			var cell:CellItem;
			var posX:int;
			var posY:int;

			var dx:Number;
			var dy:Number;
			var speed:Number;

			cell = _cellDictionary[position.x.toString() + "," + position.y.toString()];
			posX = cell.x + int((cell.width - _item.width) >> 1);
			posY = cell.y + int((cell.height - _item.height) >> 1);

			_item.lastPosition = _item.position;
			_item.nextPosition = new Point(cell.posX, cell.posY);

			setDirection(_item.lastPosition, _item.nextPosition);
			_item.updateDirection(currentDirection);
			dx = Math.abs(cell.posX - _item.position.x);
			dy = Math.abs(cell.posY - _item.position.y);

			speed = dy >= dx ? dy : dx;

			stopTween();
			speed = speed * GameFieldView.SPEED_BY_ONE * 3;

			/*   tweenObject = BetweenAS3.to(_item, {x: posX, y: posY}, speed);
			 tweenObject.onComplete = onFinishTween;
			 // tweenObject.onUpdate = updateFunction;
			 tweenObject.play(); */
			trace("moveItem " + posX + "x" + posY + "    " + "_item. " + _item.x + "x" + _item.y);
			TweenMax.to(_item, speed, {x: posX, y: posY, onComplete: onFinishTween, ease: Linear.easeNone});
			addEnterFrameListner();
		}

		private function addEnterFrameListner():void {
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}

		private function removeEnterFrameListner():void {
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event:Event):void {
			if (_item) {
				updateFunction();
			}
		}

		private function setDirection(lastPos:Point, newPos:Point):void {
			currentDirection = "";

			if (lastPos.x > newPos.x) {
				currentDirection = MOVE_LEFT;
			}
			if (lastPos.x < newPos.x) {
				currentDirection = MOVE_RIGHT;
			}
			if (lastPos.y > newPos.y) {
				currentDirection = MOVE_UP;
			}
			if (lastPos.y < newPos.y) {
				currentDirection = MOVE_DOWN;
			}
		}

		private function updateFunction():void {
			if (isRotation) return;
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

			var changeFromLastPosX:int;
			var changeFromLastPosY:int;

			herouPosX = _item.position.x;
			herouPosY = _item.position.y;

			herouLastPosX = _item.lastPosition.x;
			herouLastPosY = _item.lastPosition.y;

			nextPosX = _item.nextPosition.x;
			nextPosY = _item.nextPosition.y;

			var middlePositionX:int;
			var middlePositionY:int;

			for (var key:String in _cellDictionary) {
				cell = _cellDictionary[key];

				middlePositionX = _item.x + _item.width * 0.5;
				middlePositionY = _item.y + _item.height * 0.5;

				if ((middlePositionX < (cell.x + cell.width)) && (middlePositionX > (cell.x))) {
					if ((middlePositionY < (cell.y + cell.height)) && (middlePositionY > (cell.y))) {
						cellPosX = cell.posX;
						cellPosY = cell.posY;
						if ((cellPosX != herouPosX) || (cellPosY != herouPosY)) {
							if ((cellPosX != herouLastPosX) || (cellPosY != herouLastPosY)) {

								changeDx = Math.abs(cellPosX - nextPosX);
								changeDy = Math.abs(cellPosY - nextPosY);

								if (changeDx == 0 || changeDy == 0) {
									showTraces(_item.position, _item.getCurrentDir());
									_item.lastPosition = _item.position;
									_item.position = new Point(cellPosX, cellPosY);

								}

							}
						}

					}

				}

			}

			/*	for (var key:String in _cellDictionary) {
			 cell = _cellDictionary[key];

			 if ((_item.x + _item.getHitTestObject().x < (cell.x + cell.width)) && (_item.x + _item.getHitTestObject().x > (cell.x))) {
			 if ((_item.y + _item.getHitTestObject().y < (cell.y + cell.height)) && (_item.y + _item.getHitTestObject().y > (cell.y))) {
			 if (cell.hitTestObject(_item.getHitTestObject())) {
			 cellPosX = cell.posX;
			 cellPosY = cell.posY;
			 //	if((cellPosX==herouPosX)&&(cellPosY==herouPosY))return;
			 //	if((cellPosX==herouLastPosX)&&(cellPosY==herouLastPosY))return;

			 if ((cellPosX != herouPosX) || (cellPosY != herouPosY)) {
			 if ((cellPosX != herouLastPosX) || (cellPosY != herouLastPosY)) {

			 changeDx = Math.abs(cellPosX - nextPosX);
			 changeDy = Math.abs(cellPosY - nextPosY);

			 if (changeDx == 0 || changeDy == 0) {
			 //trace("    changeDx= ", changeDx, "   changeDy=", changeDy, "     ", cellPosX + "x" + cellPosY + "  item ", herouPosX, "x", herouPosY);
			 //	if ((Math.abs(cellPosX - herouLastPosX)) != (Math.abs(cellPosY - herouLastPosY))) {

			 changeFromLastPosX = cellPosX - herouPosX;
			 changeFromLastPosY = cellPosY - herouPosY;

			 //trace(changeFromLastPosX + "   " + changeFromLastPosY);
			 if (Math.abs(changeFromLastPosY - changeFromLastPosX)) {
			 //	showTraces(_item.position, _item.getCurrentDir());
			 _item.lastPosition = _item.position;
			 _item.position = new Point(cellPosX, cellPosY);

			 herouLastPosX = herouPosX;
			 herouLastPosY = herouPosY;

			 herouPosX = cellPosX;
			 herouPosY = cellPosY;
			 }

			 //if ((cellPosX == herouPosX) && (cellPosY == herouPosY))return;
			 //if ((cellPosX == herouLastPosX) && (cellPosY == herouLastPosY))return;

			 break;

			 }

			 }
			 }
			 }
			 }
			 }
			 }    */

			if (isNeedToCheck) {
				if (_item.getHitTestObject().hitTestObject(goalItem)) {
					stopTween();
					freezEnemy(true);
					dispatchEvent(new Event(ENEMY_WINS));
				}
			}
		}

		private function showTraces(position:Point, direction:String = ""):void {
			if (direction) {
				var keyPosition:String = position.x + "," + position.y;
				var cell:CellItem = _cellDictionary[keyPosition];
				if (cell) {
					cell.setAsCompleted(direction);
				}
			}
		}

		private function stopTween():void {
			/*if (tweenObject) {
			 tweenObject.stop();
			 tweenObject = null;
			 //tweenObject.onComplete = null;
			 //tweenObject.onUpdate = null;
			 } */
			removeEnterFrameListner();
			if (_item) {
				TweenMax.killTweensOf(_item);
			}
		}

		private function onFinishTween():void {
			_item.position = _item.nextPosition;
			_item.lastPosition = _item.nextPosition;
			moveStep++;

			//if (moveStep == pathArray.length - 1) {
			isNeedToCheck = true;
			//}

			if (pathArray[moveStep]) {
				moveItem(pathArray[moveStep]);
			} else {
				trace("FINISH");
			}

		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Destroy
		//--------------------------------------------------------------------------

		public function destroy():void {
			stopTween();
		}

	}
}
