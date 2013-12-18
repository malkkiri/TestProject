/**
 * MapRedactor.
 * Date: 14.03.13
 * Time: 18:07
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package {
	import com.adobe.serialization.json.JSON;

	import flash.display.LoaderInfo;

	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;

	import redactor.MapImageCreator;

	import redactor.MapSettingsView;
	import redactor.MapViewRedactor;
	import redactor.ResultView;
	import redactor.model.SimpleMapData;

	import serialization.JSON1;

	[SWF(width="840", height="680", frameRate="30", backgroundColor="#CCE3FF")]
	public class MapRedactor extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Public properties
		//--------------------------------------------------------------------------
		private var map:MapViewRedactor;
		private var btn1:SimpleButton;
		private var btn2:SimpleButton;
		private var resultView:ResultView;
		private var imageCreator:MapImageCreator;

		private var mapData:SimpleMapData;
		private var isReadyMap:Boolean;

		private var gameName:String;
		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private properties
		//--------------------------------------------------------------------------
		private var viewSettings:MapSettingsView;
		private var isLocal:Boolean
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		public function MapRedactor() {
			isLocal = true;
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);

		}

		private function enterFrameHandler(event:Event):void {
			trace("loaderInfo.bytesLoaded " + loaderInfo.bytesLoaded + " / " + loaderInfo.bytesTotal);
			if (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal) {
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}

		private function setComponents():void {
			viewSettings = new MapSettingsView();
			if (isReadyMap) {
				viewSettings.setBaseData(mapData);
			}
			viewSettings.init();
			viewSettings.y = 10;
			this.addChild(viewSettings);

			btn1 = new generateMapBtn();
			btn1.width = 120;
			btn1.height = 30;
			btn1.x = 10;
			btn1.y = viewSettings.y + viewSettings.height + 10;
			this.addChild(btn1);

			btn2 = new saveSettingsBtn();
			btn2.width = 120;
			btn2.height = 30;
			btn2.x = 10;
			btn2.y = btn1.y + btn1.height + 30;
			this.addChild(btn2);

			btn1.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			btn2.addEventListener(MouseEvent.CLICK, save, false, 0, true);

			if (isReadyMap) {
				clearResult();
				viewSettings.setData();
				if (map) {
					this.removeChild(map);
					map = null;
				}

				map = new MapViewRedactor();
				map.setMapParams(mapData);
				map.createReadyMap();
				map.x = viewSettings.x + viewSettings.width + 20;
				map.y = 20;
				this.addChild(map);
			}
		}

		public function initGameEditorWidget(_flashVars:Object = null):void {
			trace("initGameEditorWidget");
		}

		//{"herouPosition":"0,0","cellSize":30,"itemPositionFirst":"4,0","itemPositionSecond":"6,0","field":[0,0,0,1,0,0,0,1,0,0,0,1,1,0,1,0,1,0,1,0,1,1,0,0,0,1,0,1,0,1,0,0,0,0,1,1,1,0,1,0,1,1,1,0,0,0,0,1,0,1,0,1,0,0,0,1,1,0,1,0,1,0,1,0,1,1,0,0,0,1,0,1,0,1,0,0,0,0,1,1,1,0,1,0,1,1,1,0,0,0,0,1,0,1,0,1,0,0,0,1,1,0,1,0,1,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0],"colums":11,"rows":11,"enemyPosition":"10,0"}
		public function ready(_flashVars:Object = null):void {
			var flashVarsData:Object = LoaderInfo(stage.loaderInfo).parameters;
			if (flashVarsData) {
				for (var key:String in flashVarsData) {
					trace(key + "  " + flashVarsData[key]);
				}
				gameName = flashVarsData.name;
				if (flashVarsData.value) {
					testJson(flashVarsData.value);
					isReadyMap = true;
				}
			}

			//						testJson('{"herouPosition":"0,0","cellSize":35,"itemPositionFirst":"4,0","itemPositionSecond":"6,0","field":[0,0,0,1,0,0,0,1,0,0,0,1,1,0,1,0,1,0,1,0,1,1,0,0,0,1,0,1,0,1,0,0,0,0,1,1,1,0,1,0,1,1,1,0,0,0,0,1,0,1,0,1,0,0,0,1,1,0,1,0,1,0,1,0,1,1,0,0,0,1,0,1,0,1,0,0,0,0,1,1,1,0,1,0,1,1,1,0,0,0,0,1,0,1,0,1,0,0,0,1,1,0,1,0,1,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0],"colums":11,"rows":11,"enemyPosition":"10,0"}');
			//						isReadyMap = true;

			setComponents();
		}

		private function init(event:Event):void {
			if (isLocal) {
				ready();
			}
			//this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function save(event:MouseEvent):void {
			map.saveSettings();
			var data:Object = map.getBaseData();
			clearResult();
			showResult(data);
		}

		private function createMap():void {

			if (map) {
				this.removeChild(map);
				map = null;
			}

			map = new MapViewRedactor();

			map.rows = viewSettings.rows;
			map.colums = viewSettings.columns;
			map.cellItemWidth = viewSettings.itemsWidth;
			map.cellItemHeight = viewSettings.itemsHeight;

			map.cellSize = viewSettings.cellSize;

			map.field = viewSettings.filed;

			map.createMap();
			map.x = viewSettings.x + viewSettings.width + 20;
			map.y = 20;
			this.addChild(map);
		}

		private function onClick(event:MouseEvent):void {
			clearResult();
			viewSettings.setData();
			createMap();

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
		private function showResult(data:Object):void {
			resultView = new ResultView(data);
			resultView.y = btn2.y + btn2.height + 10;
			this.addChild(resultView);

			data.cellSize = viewSettings.getCellSize();
			convertData(data);

			imageCreator = new MapImageCreator();
			imageCreator.x = map.x + 100;
			imageCreator.y = map.y + 20;
			imageCreator.setResultData(data);
			imageCreator.createImage();
			//this.addChild(imageCreator);
		}

		private function convertData(data:Object):void {
			trace("convertData ");
			if (data) {
				//				var resultData:SimpleMapData = new SimpleMapData();
				//				resultData.rows = data.rows;
				//				resultData.columns = data.colums;
				//				resultData.field = data.field;
				//				//				resultData.heroPosition = stringToPoint(data.herouPosition);
				//				//				resultData.enemyPosition = stringToPoint(data.enemyPosition);
				//				//				resultData.cheesePositionFirst = stringToPoint(data.itemPositionFirst);
				//				//				resultData.cheesePositionSecond = stringToPoint(data.itemPositionSecond);
				//				resultData.heroPosition = data.herouPosition;
				//				resultData.enemyPosition = data.enemyPosition;
				//				resultData.cheesePositionFirst = data.itemPositionFirst;
				//				resultData.cheesePositionSecond = data.itemPositionSecond;
				//				resultData.cellWidth = data.cellWidth;
				var testSt:String = JSON.encode(data);
				if (ExternalInterface.available) {
					try {
						ExternalInterface.call('doUpdateInput', gameName, testSt);
					} catch (e:Error) {
						trace(e);
					}
				}
			}
		}

		private function testJson(value:String):void {
			var dataObject:Object = JSON.decode(value);
			//			trace("<< testJson >>");

			//			for (var key:String in dataObject) {
			//				trace(key + "  " + dataObject[key]);
			//			}

			//			trace("<< FINISH >>");

			mapData = new SimpleMapData();
			mapData.rows = dataObject.rows;
			mapData.columns = dataObject.colums;
			mapData.field = dataObject.field;
			mapData.heroPosition = stringToPoint(dataObject.herouPosition);
			mapData.enemyPosition = stringToPoint(dataObject.enemyPosition);
			mapData.cheesePositionFirst = stringToPoint(dataObject.itemPositionFirst);
			mapData.cheesePositionSecond = stringToPoint(dataObject.itemPositionSecond);
			mapData.cellWidth = dataObject.cellSize;

			//			trace("<< testJson 2>>");
			//			for (var key:String in dataObject) {
			//				trace(key + "  " + dataObject[key]);
			//			}
			//			trace("<< FINISH >> 2");
		}

		private function stringToPoint(value:String):Point {
			var ar:Array = value.split(",");
			return new Point(ar[0], ar[1]);
		}

		private function clearResult():void {
			if (resultView) {
				this.removeChild(resultView);
				resultView = null;
			}

			if (imageCreator) {
				//	this.removeChild(imageCreator);
				imageCreator = null;
			}
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Destroy
		//--------------------------------------------------------------------------

	}
}
