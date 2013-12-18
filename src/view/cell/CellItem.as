/**
 * CellItem.
 * Date: 13.03.13
 * Time: 15:49
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package view.cell {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.ui.ContextMenuBuiltInItems;

	public class CellItem extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var _posX:int;
		private var _posY:int;

		private const MOVE_LEFT:String = "move_left";
		private const MOVE_RIGHT:String = "move_right";
		private const MOVE_DOWN:String = "move_down";
		private const MOVE_UP:String = "move_up";

		//--------------------------------------------------------------------------
		//  Public properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private properties
		//--------------------------------------------------------------------------
		private var itemWidth:int;
		private var itemHeight:int;

		private var isCompleted:Boolean;
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------

		public function CellItem(_x:int, _y:int, _w:int, _h:int) {
			posX = _x;
			posY = _y;
			itemWidth = _w;
			itemHeight = _h;
			init();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function setAsCompleted(direction:String = ""):void {
			if (isCompleted) return;

			//trace("<< isCompleted >>");

			//this.addChild(new Bitmap(new BitmapData(itemWidth, itemHeight, true, 0x20FF0000)));

			isCompleted = true;
			var traces:Sprite = new Sprite();
			var step:Sprite = new mouse_traces();
			step.x = -step.width*0.5;
			step.y = -step.height *0.5;
			traces.addChild(step);
			if (direction == MOVE_DOWN) {
				traces.rotationZ = 180;
			}
			if (direction == MOVE_UP) {
				traces.rotationZ = 0;
			}
			if (direction == MOVE_LEFT) {
				traces.rotationZ = 270;
			}
			if (direction == MOVE_RIGHT) {
				traces.rotationZ = 90;
			}
			traces.x = ((this.width - traces.width) >> 1) + traces.width * 0.5;
			traces.y = ((this.height - traces.height) >> 1) + traces.height * 0.5;
			this.addChild(traces);
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function init():void {
			this.addChild(new Bitmap(new BitmapData(itemWidth, itemHeight, true, 0x00FF0000)));
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Destroy
		//--------------------------------------------------------------------------

		public function get posX():int {
			return _posX;
		}

		public function set posX(value:int):void {
			_posX = value;
		}

		public function get posY():int {
			return _posY;
		}

		public function set posY(value:int):void {
			_posY = value;
		}

		public function destroy():void {
			isCompleted = false;
			while (this.numChildren) {
				this.removeChildAt(0);
			}
		}
	}
}
