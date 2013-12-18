/**
 * MathCalCulation.
 * Date: 13.03.13
 * Time: 18:33
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package model {
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import view.aStar.Pathfinder;

	public class MathFieldCalculation {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------
		private const MOVE_LEFT:String = "move_left";
		private const MOVE_RIGHT:String = "move_right";
		private const MOVE_DOWN:String = "move_down";
		private const MOVE_UP:String = "move_up";
		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var _pathArray:Array = [];
		private var _cellModelList:Array = [];
		private var _cellItemsDict:Dictionary;

		private var _matrix:Array = [];

		private var pathFind:Pathfinder;

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

		public function MathFieldCalculation() {
			pathFind = new Pathfinder();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------

		public function getPath(start:Point, end:Point, isWithClear:Boolean = true):Array {
			var way:Array = [];
			var path:Array = [];
			way = pathFind.FindPath(start, end, matrix, true);
			if (way) {
				way.reverse();
				way.unshift();
			} else {
				return [];
			}
			var len:int = way.length;
			var posX:int;
			var posY:int;
			for (var i:int = 0; i < len; i++) {
				posX = (way[i] as Point).x;
				posY = (way[i] as Point).y;
				if (posX % 2 == 0) {
					if (posY % 2 == 0) {
						posX = posX * 0.5;
						posY = posY * 0.5;
						path.push(new Point(posX, posY));
					}
				}
			}
			//trace("before{= " + path);
			if (isWithClear) {
				clearWayArray(path);
			}

			//trace("after= " + path);
			return path;
		}

		public function getPathForCell(direction:String, key:String):String {
			var stAr:Array = key.split(",");
			var posX:int = stAr[0];
			var posY:int = stAr[1];

			var position:Point;
			position = new Point(posX * 2, posY * 2);

			var lastPosition:String;
			lastPosition = "bad";

			while (position) {
				position = checkUp(position, direction);
				if (position) {
					lastPosition = position.x * 0.5 + "," + position.y * 0.5;
					//trace("Math  2 ", position);
				}
			}

			return lastPosition;
		}

		public function getPathForStar(start:Point, end:Point):Array {
			var pathArray:Array = getPath(start, end, false);
			// pathArray.reverse();
			return pathArray;
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------

		private function clearWayArray(_ar:Array):void {

			var step1:String = "";
			var step2:String = "";
			var _ar2:Array = new Array();
			for (var i:int = 0; i < _ar.length - 1; i++) {
				step1 = String(_ar[i].x - _ar[i + 1].x);
				step2 = String(_ar[i].y - _ar[i + 1].y);
				_ar2.push((step1 + "x" + step2));
			}

			for (var i2:int = 0; i2 < _ar2.length; i2++) {
				if (_ar2[i2] == _ar2[i2 + 1]) {
					_ar.splice(i2 + 1, 1);
					_ar2.splice(i2 + 1, 1);
					i2--;
				}
			}
			//_ar.splice(0, 1);
			//trace("_ar " + _ar);
		}

		private function checkUp(startPosition:Point, directionMove:String):Point {

			var dx:int = 0;
			var dy:int = 0;

			if (directionMove == MOVE_UP) {
				dy = dy - 2;
			}
			if (directionMove == MOVE_DOWN) {
				dy = dy + 2;
			}
			if (directionMove == MOVE_LEFT) {
				dx = dx - 2;
			}
			if (directionMove == MOVE_RIGHT) {
				dx = dx + 2;
			}

			var _way:Array = [];
			var start:Point = startPosition;
			var end:Point = new Point(startPosition.x + dx, startPosition.y + dy);
			//trace("Math  1 ", start, end);
			_way = pathFind.FindPath(start, end, matrix, true);
			if (_way) {
				_way.reverse();
				_way.unshift();
				if (_way.length == 2) {
					return _way[_way.length - 1];
				}
			}
			return null;
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Destroy
		//--------------------------------------------------------------------------

		public function get cellItemsDict():Dictionary {
			return _cellItemsDict;
		}

		public function set cellItemsDict(value:Dictionary):void {
			_cellItemsDict = value;
		}

		public function get pathArray():Array {
			return _pathArray;
		}

		public function set pathArray(value:Array):void {
			_pathArray = value;
		}

		public function get cellModelList():Array {
			return _cellModelList;
		}

		public function set cellModelList(value:Array):void {
			_cellModelList = value;
		}

		public function get matrix():Array {
			return _matrix;
		}

		public function set matrix(value:Array):void {
			_matrix = value;
		}

	}
}
