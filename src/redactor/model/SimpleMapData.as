/**
 * User: Malkkiri
 * Date: 11.11.13
 * Time: 16:21
 * Oleg Kornienko - oleg.kornienko.flash@gmail.com
 */

package redactor.model {
	import flash.geom.Point;

	public class SimpleMapData {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var _rows:int;
		private var _columns:int;
		private var _cellWidth:int;
		private var _field:String;
		private var _heroPosition:Point;
		private var _enemyPosition:Point;
		private var _cheesePositionFirst:Point;
		private var _cheesePositionSecond:Point;

		private var _innerId:int;

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

		public function SimpleMapData() {
			super();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Handlers 
		//--------------------------------------------------------------------------

		public function get rows():int {
			return _rows;
		}

		public function set rows(value:int):void {
			_rows = value;
		}

		public function get columns():int {
			return _columns;
		}

		public function set columns(value:int):void {
			_columns = value;
		}

		public function get cellWidth():int {
			return _cellWidth;
		}

		public function set cellWidth(value:int):void {
			_cellWidth = value;
		}

		public function get field():String {
			return _field;
		}

		public function set field(value:String):void {
			_field = value;
		}

		public function get heroPosition():Point {
			return _heroPosition;
		}

		public function set heroPosition(value:Point):void {
			_heroPosition = value;
		}

		public function get enemyPosition():Point {
			return _enemyPosition;
		}

		public function set enemyPosition(value:Point):void {
			_enemyPosition = value;
		}

		public function get cheesePositionFirst():Point {
			return _cheesePositionFirst;
		}

		public function set cheesePositionFirst(value:Point):void {
			_cheesePositionFirst = value;
		}

		public function get cheesePositionSecond():Point {
			return _cheesePositionSecond;
		}

		public function set cheesePositionSecond(value:Point):void {
			_cheesePositionSecond = value;
		}

		public function get innerId():int {
			return _innerId;
		}

		public function set innerId(value:int):void {
			_innerId = value;
		}
	}
}
