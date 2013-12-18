/**
 * MapCell.
 * Date: 14.03.13
 * Time: 18:08
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package redactor {
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;

	public class MapCell extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var _posX:int;
		private var _posY:int;

		private var activeSp:Sprite;
		private var _isActive:Boolean;

		private var _isWall:Boolean;
		private var _isVerticale:Boolean;
		private var _isHorizontale:Boolean;
		private var _isCorner:Boolean;

		private var itemWidth:int;
		private var itemHeight:int;
		private var wallSize:int;

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

		public function MapCell(_x:int, _y:int, cellWidth:int = 50, cellHeight:int = 50) {
			posX = _x;
			posY = _y;
			itemWidth = cellWidth;
			itemHeight = cellHeight;
			init();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function setActive():void {
			if (!_isCorner) {
				if (isWall) {
					_isActive = !_isActive;
				} else {
				}
				changeView();
			}
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function init():void {
			if ((posX % 2) != 0) isWall = true;
			if ((posY % 2) != 0) isWall = true;

			if (isWall) {
				checkForType();
			}
			wallSize = 10;
			activeSp = new Sprite();
			if (isWall) {

				if (isCorner) {
					_isActive = true;
				} else {
					addWall();
				}
			} else {
				addCell()
			}
			this.addChild(activeSp);

			changeView();
		}

		private function addWall():void {
			var sp:Sprite = new wallMap();
			if (sp["back"]) {
				sp["back"].alpha = 0;
			}
			sp.y = -sp.height * 0.5 + 1;
			sp.x = int((50 - sp.width) * 0.5);
			if (_isVerticale) {
				sp.rotationZ = 90;
				sp.x = sp.width * 0.5 + 1;
				sp.y = int((50 - sp.height) * 0.5);
			}
			activeSp.addChild(sp);
			activeSp.buttonMode = true;
		}

		private function addCell():void {
			var sp:Sprite = new roundCell();
			activeSp.addChild(sp);
		}

		private function checkForType():void {
			if ((posX % 2) != 0) {
				_isVerticale = true;
			}
			if ((posY % 2) != 0) {
				_isHorizontale = true;
			}
			if (((posX % 2) != 0) && ((posY % 2) != 0)) {
				isCorner = true;
				_isVerticale = false;
				_isHorizontale = false;
			}

		}

		override public function toString():String {
			var key:String = '"' + posX.toString() + "," + posY.toString() + '"';
			return key;
		}

		public function choose():void {
			_isActive = !_isActive;
			changeView();
		}

		private function changeView():void {
			if (isWall) {
				if (!_isCorner) {
					activeSp.alpha = _isActive ? 1 : 0;
				}
			} else {
			}
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

		public function get isActive():Boolean {
			return _isActive;
		}

		public function get isWall():Boolean {
			return _isWall;
		}

		public function set isWall(value:Boolean):void {
			_isWall = value;
		}

		public function get isVerticale():Boolean {
			return _isVerticale;
		}

		public function set isVerticale(value:Boolean):void {
			_isVerticale = value;
		}

		public function get isHorizontale():Boolean {
			return _isHorizontale;
		}

		public function set isHorizontale(value:Boolean):void {
			_isHorizontale = value;
		}

		public function get isCorner():Boolean {
			return _isCorner;
		}

		public function set isCorner(value:Boolean):void {
			_isCorner = value;
		}

		public function setOnMouseActive(isActiveItem:Boolean = true):void {
			if (!isWall) {
				if (!isCorner) {
					this.filters = isActiveItem ? [new GlowFilter(0xFF9900, 1, 4, 4, 5, BitmapFilterQuality.LOW)] : [];
				}
			}
		}

	}
}
