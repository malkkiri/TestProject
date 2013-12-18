/**
 * ActiveMapItem.
 * Date: 18.09.13
 * Time: 18:38
 * Oleg Kornienko - oleg.kornienko.flash@gmail.com
 */

package redactor {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class ActiveMapItem extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------
		public static const HERO_ID:int = 1;
		public static const ENEMY_ID:int = 2;
		public static const CHEESE_ID:int = 3;
		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var _id:int;
		private var image:DisplayObject;

		private var _positionX:int;
		private var _positionY:int;

		private var _positionOnMapX:int;
		private var _positionOnMapY:int;

		private var _positionForGoal:Array = [];
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

		public function ActiveMapItem(itemId:int) {
			_id = itemId;
			setImage();
			super();
		}

		private function setImage():void {
			if (id == HERO_ID) {
				image = new mouse2_map();
			}
			if (id == ENEMY_ID) {
				image = new mouse1_map();
			}
			if (id == CHEESE_ID) {
				image = new CheeseForMap();
			}
			this.addChild(image);
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

		public function get id():int {
			return _id;
		}

		public function get positionX():int {
			return _positionX;
		}

		public function set positionX(value:int):void {
			_positionX = value;
		}

		public function get positionY():int {
			return _positionY;
		}

		public function set positionY(value:int):void {
			_positionY = value;
		}

		public function get positionOnMapX():int {
			return _positionOnMapX;
		}

		public function set positionOnMapX(value:int):void {
			_positionOnMapX = value;
		}

		public function get positionOnMapY():int {
			return _positionOnMapY;
		}

		public function set positionOnMapY(value:int):void {
			_positionOnMapY = value;
		}

		public function get positionForGoal():Array {
			return _positionForGoal;
		}

		public function set positionForGoal(value:Array):void {
			_positionForGoal = value;
		}
	}
}
