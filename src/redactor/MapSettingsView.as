/**
 * MapSettingsView.
 * Date: 18.03.13
 * Time: 11:00
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package redactor {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	//	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	import redactor.model.SimpleMapData;

	public class MapSettingsView extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------

		private var rowsTF:TextField;
		private var columnsTF:TextField;
		private var cellSizeTF:TextField;
		private var filedTF:TextField;

		private var _rows:int;
		private var _columns:int;
		private var _cellSize:int;
		private var _filed:String;

		private var _itemsWidth:Number;
		private var _itemsHeight:Number;

		private var testTF:TextField;
		private var addTestTf:Boolean;

		private var mapData:SimpleMapData;

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

		public function MapSettingsView() {
			//			this.addEventListener(Event.ADDED_TO_STAGE, init);
			//			init();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function setData():void {
			var rowsCount:int = int(rowsTF.text) * 2 - 1;
			var columnsCount:int = int(columnsTF.text) * 2 - 1;

			_rows = rowsCount;
			_columns = columnsCount;
			//			_filed = "0,0,0,1,0,0,0,1,0,0,0,1,1,0,1,0,1,0,1,0,1,1,0,0,0,1,0,1,0,1,0,0,0,0,1,1,1,0,1,0,1,1,1,0,0,0,0,1,0,1,0,1,0,0,0,1,1,0,1,0,1,0,1,0,1,1,0,0,0,1,0,1,0,1,0,0,0,0,1,1,1,0,1,0,1,1,1,0,0,0,0,1,0,1,0,1,0,0,0,1,1,0,1,0,1,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0"/*filedTF.text*/;
			_filed = filedTF.text;

			cellSize = int(cellSizeTF.text);

			//			itemsWidth = cellSize;
			//			itemsHeight = cellSize;
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		public function init(event:Event = null):void {

			rowsTF = createTf("6");
			rowsTF.x = 100;
			rowsTF.y = 0;
			this.addChild(rowsTF);

			var rowsDescription:TextField = createDescriptionText("ширина");
			//rowsDescription.htmlText = "ширина";
			rowsDescription.y = rowsTF.y;
			this.addChild(rowsDescription);

			columnsTF = createTf("6");
			columnsTF.x = 100;
			columnsTF.y = rowsTF.y + rowsTF.height + 10;
			this.addChild(columnsTF);

			var columnsDescription:TextField = createDescriptionText("высота");
			columnsDescription.y = columnsTF.y;
			this.addChild(columnsDescription);

			var currentCellSize:int = mapData ? mapData.cellWidth : 50;
			cellSizeTF = createTf(currentCellSize.toString());
			cellSizeTF.x = 100;
			cellSizeTF.y = columnsTF.y + columnsTF.height + 10;
			this.addChild(cellSizeTF);

			var cellSizeDescription:TextField = createDescriptionText("размер");
			cellSizeDescription.y = cellSizeTF.y;
			this.addChild(cellSizeDescription);

			filedTF = createTf("");
			filedTF.x = 100;
			filedTF.y = cellSizeTF.y + cellSizeTF.height + 10;
			this.addChild(filedTF);

			testTF = createTf();
			testTF.width = 300;
			testTF.height = 300;
			testTF.text = "";
			testTF.x = 100;
			testTF.y = filedTF.y + filedTF.height + 10;
			if (addTestTf) {
				this.addChild(testTF);
			}

			var fieldDescription:TextField = createDescriptionText("поле");
			fieldDescription.y = filedTF.y;
			this.addChild(fieldDescription);
			_rows = 15;
			_columns = 15;

			itemsWidth = 50;
			itemsHeight = 50;
		}

		public function setBaseData(_mapData:SimpleMapData):void {
			mapData = _mapData;
		}

		private function setTextFormat(tf:TextField):void {
			var format:TextFormat = new TextFormat();
			format.size = 20;
			tf.setTextFormat(format);
		}

		private function createTf(text:String = ""):TextField {
			var tf:TextField = new TextField();
			tf.text = text;
			setTextFormat(tf);
			tf.border = true;
			tf.width = 30;
			tf.height = 25;
			tf.type = TextFieldType.INPUT;
			return tf;
		}

		private function createDescriptionText(text:String = ""):TextField {
			var tf:TextField = new TextField();
			tf.text = text;
			tf.type = TextFieldType.DYNAMIC;
			setTextFormat(tf);
			return tf;
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Destroy
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

		public function get itemsWidth():Number {
			return _itemsWidth;
		}

		public function set itemsWidth(value:Number):void {
			_itemsWidth = value;
		}

		public function get itemsHeight():Number {
			return _itemsHeight;
		}

		public function set itemsHeight(value:Number):void {
			_itemsHeight = value;
		}

		public function get cellSize():int {
			return _cellSize;
		}

		public function set cellSize(value:int):void {
			_cellSize = value;
		}

		public function get filed():String {
			return _filed;
		}

		public function set filed(value:String):void {
			_filed = value;
		}

		public function setTestData(value:*):void {
			testTF.text = value.toString();
		}

		public function setTestData1(value:*):void {
			var xml:XML = new XML((value as String));
			testTF.text = xml.toString();
		}

		public function getCellSize():int {
			return int(cellSizeTF.text);
		}
	}
}
