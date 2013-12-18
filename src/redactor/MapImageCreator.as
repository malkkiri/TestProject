/**
 * MapImageCreator.
 * Date: 02.10.13
 * Time: 19:02
 * Oleg Kornienko - oleg.kornienko.flash@gmail.com
 */

package redactor {
	import com.adobe.images.JPGEncoder;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	public class MapImageCreator extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var resultData:Object;

		private var _wallList:Array;
		private var _mapList:Array;
		private var _cellSize:int = 30;
		private var _rows:int = 11;
		private var _columns:int = 11;

		private var holder:Sprite;
		private var mainHolder:Sprite;

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

		public function MapImageCreator() {
			holder = new Sprite();
			mainHolder = new Sprite();
			holder.x = 0;
			holder.y = 0;
			mainHolder.addChild(holder);
			this.addChild(mainHolder);
			super();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function setResultData(data:Object):void {
			resultData = data;
			_rows = data.rows;
			_columns = data.colums;
			_cellSize = data.cellSize;
		}

		public function createImage():void {
			var imageWidth:int = (rows + 1) * 0.5 * cellSize;
			var imageHeight:int = (columns + 1) * 0.5 * cellSize;
			var bt:Bitmap = new Bitmap(new BitmapData(imageWidth, imageHeight, false, 0x513E06));
			//			var bt:Bitmap = new Bitmap(new BitmapData(imageWidth, imageHeight, true, 0x20FF0000));
			holder.addChild(bt);
			addWalls();
			addBorder();
			//			saveImage();
		}

		private function addBorder():void {

			var minWidth:int = int(cellSize / 6);

			var line1:Sprite = addBorderLine(true);
			var line2:Sprite = addBorderLine(true, null, true);

			var line3:Sprite = addBorderLine();
			var line4:Sprite = addBorderLine(false, null, true);

			line1.x = 0
			line1.y = 0;
			holder.addChild(line1);

			line3.x = 0;
			line3.y = int(-minWidth * 0.25);
			holder.addChild(line3);

			line2.x = int(line3.width - minWidth * 0.75);
			line2.y = 0;
			holder.addChild(line2);

			line4.x = 0;
			line4.y = int(line2.height - minWidth * 0.75);
			holder.addChild(line4);
		}

		private function addBorderLine(isVerticale:Boolean = false, ignorePosition:Array = null, isReverse:Boolean = false):Sprite {
			var count:int = isVerticale ? rows : columns;
			count = (count + 1) * 0.5;
			var lineHolder:Sprite = new Sprite();
			var item:Sprite;
			var positionX:int;
			var positionY:int;
			var minWidth:int = int(cellSize / 7);
			for (var i:int = 0; i < count; i++) {
				if (isVerticale) {
					item = isReverse ? new wallItemReverse() : new wallItem();
					item.width = minWidth;
					item.height = cellSize;
					positionX = 0;
					positionY = i * item.height;
				} else {
					item = isReverse ? new wallItemHorizontalReverse() : new wallItemHorizontal();
					item.width = cellSize;
					item.height = minWidth;
					positionX = i * item.width;
					positionY = 0;
				}
				item.x = positionX;
				item.y = positionY;
				lineHolder.addChild(item);
			}
			return lineHolder;
		}

		private var cellsList:Array = [];

		private function creatWallList():Array {
			var mapCell:MapCell;

			var localWidth:int = cellSize;
			var localHeight:int = cellSize;

			var wallListResult:Array;

			for (var i:int = 0; i < _rows; i++) {
				cellsList[i] = new Array();
				for (var j:int = 0; j < _columns; j++) {
					mapCell = new MapCell(i, j, localWidth, localHeight);
					cellsList[i][j] = mapCell;
				}
			}
			wallListResult = showActiveCells();

			return wallListResult;
		}

		private function showActiveCells():Array {
			var result:Array = []
			var mapCell:MapCell;
			var innerCount:int = 0;
			var fieldList:Array = resultData.field;
			for (var i:int = 0; i < _rows; i++) {
				for (var j:int = 0; j < _columns; j++) {
					mapCell = cellsList[j][i];
					if (fieldList[innerCount] && fieldList[innerCount] > 0) {
						mapCell.setActive();
					}

					if (mapCell.isWall) {
						if (!mapCell.isCorner) {
							if (mapCell.isActive) {
								result.push(mapCell);
							}
						}
					}

					innerCount++;
				}
			}
			return result;
		}

		private function addWalls():void {
			var mapItem:MapCell
			wallList = creatWallList();
			var len:int = wallList.length;
			var positionX:int;
			var positionY:int;

			var wallWidth:int;
			var wallHeght:int;

			var horPad:int;
			var vertPad:int;

			var koefX:int;
			var koefY:int;

			var bt:Bitmap;
			var testItem:Sprite;

			var minWidth:int = int(cellSize / 7);

			for (var i:int = 0; i < len; i++) {
				mapItem = wallList[i];
				horPad = 0;
				vertPad = 0;
				koefX = 0;
				koefY = 0;
				if (mapItem.isVerticale) {
					testItem = new wallItem();
					wallWidth = minWidth;
					wallHeght = cellSize;
					testItem.width = wallWidth;
					testItem.height = wallHeght;
					positionX = (mapItem.posX - 1) * 0.5;
					positionY = mapItem.posY * 0.5;
					horPad = minWidth * 0.25;
					koefX = 1;
					testItem.x = int((positionX + koefX) * cellSize - horPad);
					testItem.y = int((positionY + +koefY) * cellSize - vertPad);
					holder.addChild(testItem);
				} else {
					testItem = new wallItemHorizontal();
					wallWidth = cellSize;
					wallHeght = minWidth;
					testItem.width = wallWidth;
					testItem.height = wallHeght;
					positionX = mapItem.posX * 0.5;
					positionY = (mapItem.posY - 1) * 0.5;
					vertPad = minWidth * 0.25;
					koefY = 1;
					testItem.x = int((positionX + koefX) * cellSize - horPad);
					testItem.y = int((positionY + +koefY) * cellSize - vertPad);
					holder.addChild(testItem);
				}
			}
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		public function saveImage(isNeedToSave:Boolean = false):BitmapData {
			var myBitmapData:BitmapData = new BitmapData(holder.width, holder.height);
			myBitmapData.draw(holder);

			if (isNeedToSave) {
				var jpgEncoder:JPGEncoder = new JPGEncoder(100);
				var imgByteData:ByteArray = jpgEncoder.encode(myBitmapData);
				var MyFile:FileReference = new FileReference();
				//			MyFile.browse(new Array(new FileFilter("Images (*.jpg, *.jpeg)", "*.jpg;*.jpeg")));
				MyFile.save(imgByteData, "testLabirint.jpg");
			}
			return myBitmapData;
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------
		public function get wallList():Array {
			return _wallList;
		}

		public function set wallList(value:Array):void {
			_wallList = value;
		}

		public function get mapList():Array {
			return _mapList;
		}

		public function set mapList(value:Array):void {
			_mapList = value;
		}

		public function get cellSize():int {
			return _cellSize;
		}

		public function set cellSize(value:int):void {
			_cellSize = value;
		}

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

	}
}
