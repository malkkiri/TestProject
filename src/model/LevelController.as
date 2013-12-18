/**
 * LevelController.
 * Date: 26.03.13
 * Time: 14:53
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package model {
	import com.adobe.serialization.json.JSON;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import redactor.model.SimpleMapData;

	public class LevelController extends EventDispatcher {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------
		public static var EVENT_ROTATION:String = "event_rotation";

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private static var _instance:LevelController;
		private var _userLives:int = 3;
		//		private var mapDict:Object = {
		//			"1": {
		//				mapList: ["lab_6x6_1", "lab_6x6_2", "lab_6x6_3", "lab_6x6_4", "lab_6x6_5"]
		//			},
		//			"2": {
		//				mapList: ["lab_8x8_1", "lab_8x8_2", "lab_8x8_3", "lab_8x8_4", "lab_8x8_5"]
		//			},
		//			"3": {
		//				mapList: ["lab_10x10_1", "lab_10x10_2", "lab_10x10_3", "lab_10x10_4"]
		//			},
		//			"4": {
		//				mapList: ["lab_12x12_1", "lab_12x12_2", "lab_12x12_3", "lab_12x12_4", "lab_12x12_5"]
		//			}
		//		}

		private var levelsData:Object = {};
		//			"1":  {
		//				level:          1,
		//				mapIndex:       1,
		//				rotationNumber: 1
		//			},
		//			"2":  {
		//				level:          2,
		//				mapIndex:       1,
		//				rotationNumber: 1
		//			},
		//			"3":  {
		//				level:          3,
		//				mapIndex:       1,
		//				rotationNumber: 1
		//			},
		//			"4":  {
		//				level:          4,
		//				mapIndex:       2,
		//				rotationNumber: 2
		//			},
		//			"5":  {
		//				level:          5,
		//				mapIndex:       2,
		//				rotationNumber: 2
		//			},
		//			"6":  {
		//				level:          6,
		//				mapIndex:       2,
		//				rotationNumber: 3
		//			},
		//			"7":  {
		//				level:          7,
		//				mapIndex:       3,
		//				rotationNumber: 3
		//			},
		//			"8":  {
		//				level:          8,
		//				mapIndex:       3,
		//				rotationNumber: 4
		//			},
		//			"9":  {
		//				level:          9,
		//				mapIndex:       4,
		//				rotationNumber: 4
		//			},
		//			"10": {
		//				level:          10,
		//				mapIndex:       4,
		//				rotationNumber: 5
		//			}
		//		};
		private var rotationTime:int;
		private var mapsDataModel:Object = {};

		private var _recoursePath:String;
		private var finishedMaps:Array = [];
		private var levelListDict:Dictionary = new Dictionary(true);
		private var _currentLevelNumber:Number = 0;
		private var currentLevelData:SimpleLevelModel;
		private var currentRotationCount:int;

		private var currentMap:String;
		private var currentMapData:SimpleMapData;

		private var rotationAngel:int;
		private var timer:Timer;
		private var score:ScoreData;
		private var maxLife:int;
		private var rotationsCount:int;
		private var _itemSpeed:Number = 200;

		private var levelData:Object = {};
		//--------------------------------------------------------------------------
		//  Public properties
		//--------------------------------------------------------------------------
		public static function get instance():LevelController {
			if (!_instance) {
				_instance = new LevelController();
			}
			return _instance;
		}

		public function parceBaseData(data:Object):void {
			parceLevels(data.levels);
			//			parceMapDict(data.mapGroups);
			//			parceDataForField(data.maps);
			_itemSpeed = data.timeToMove50px ? data.timeToMove50px : 200;
			rotationTime = data.rotationTime ? data.rotationTime : 2000;
			maxLife = data.lifeCount ? data.lifeCount : 3;
			init();
		}

		public function startFirastLevel():void {
			cleanLevel();
			_userLives = maxLife;
		}

		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private properties
		//--------------------------------------------------------------------------

		private function parceDataForField(maps:Array):void {
			mapsDataModel = {};
			var mapData:Object = {};
			for (var i:int = 0; i < maps.length; i++) {
				mapData = maps[i];
				if (mapData) {
					mapsDataModel[mapData.name] = {};
					mapData.field = (mapData.field as String).split(",");
					mapsDataModel[mapData.name] = mapData;
				}
			}
		}

		/*private function parceMapDict(mapGroups:Array):void {
		 mapDict = {};
		 var mapData:Object = {};
		 for (var i:int = 0; i < mapGroups.length; i++) {
		 mapData = mapGroups[i];
		 if (mapData) {
		 mapDict[mapData.id] = {};
		 mapDict[mapData.id].mapList = (mapData.mapList as String).split(",");
		 }
		 }
		 }*/

		private function parceLevels(levelsList:Array):void {
			levelsData = {};
			var levelData:Object = {};
			for (var i:int = 0; i < levelsList.length; i++) {
				levelData = levelsList[i];
				if (levelData) {
					levelsData[levelData.id] = levelData;
				}
			}
		}

		private function getRandomIndex(low:int, high:int):int {
			//for debug
			//return low;
			return Math.floor(low + Math.random() * (high - low + 1));
		}

		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------

		public function LevelController() {
			super();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function configNextLevel():void {

			_currentLevelNumber++;
			currentLevelData = levelListDict[_currentLevelNumber];

			var mapAr:Array = currentLevelData.mapDataList;

			var avaibleMapList:Array = [];

			if (!levelData.isEnemy) {
				for (var i:int = 0; i < mapAr.length; i++) {
					if (finishedMaps.indexOf((mapAr[i] as SimpleMapData).innerId) == -1) {
						avaibleMapList.push(mapAr[i]);
					}
				}
				trace(avaibleMapList.length);
				currentMapData = avaibleMapList[getRandomIndex(0, avaibleMapList.length - 1)];
				//				currentMap = avaibleMapList[getRandomIndex(0, avaibleMapList.length - 1)];
			}
			// for debug
			//currentMap = "lab_10x10_1";
			finishedMaps.push(currentMapData.innerId);
		}

		private function convertToMapData(dataObject:Object):SimpleMapData {
			var mapData:SimpleMapData = new SimpleMapData();
			mapData.rows = dataObject.rows;
			mapData.columns = dataObject.colums;
			mapData.field = dataObject.field;
			mapData.heroPosition = stringToPoint(dataObject.herouPosition);
			mapData.enemyPosition = stringToPoint(dataObject.enemyPosition);
			mapData.cheesePositionFirst = stringToPoint(dataObject.itemPositionFirst);
			mapData.cheesePositionSecond = stringToPoint(dataObject.itemPositionSecond);
			mapData.cellWidth = dataObject.cellSize;
			return mapData;
		}

		private function stringToPoint(value:String):Point {
			var ar:Array = value.split(",");
			return new Point(ar[0], ar[1]);
		}

		public function onPause(val:Boolean):void {
			if (timer) {
				if (val) {
					timer.stop();
				} else {
					var needRotations:int = currentLevelData.rotations - rotationsCount;
					if (needRotations > 0) {
						clearTimer();
						timer = new Timer(rotationTime, needRotations);
						timer.addEventListener(TimerEvent.TIMER, timerEventHandler, false, 0, true);
						timer.start();
					}
				}
			}
		}

		public function getConfigMapData():SimpleMapData {
			return currentMapData;
		}

		public function startLevel(enemyMoveFullTime:Number):void {
			var rotationCount:int;
			rotationCount = currentLevelData.rotations;
			rotationTime = enemyMoveFullTime * 1000 / (rotationCount + 1);
			//			rotationCount = 50;  //debug
			if (rotationCount > 0) {
				timer = new Timer(rotationTime, rotationCount);
				timer.addEventListener(TimerEvent.TIMER, timerEventHandler, false, 0, true);
				timer.start();
			}

			score.setStartLevelParam({"level": _currentLevelNumber});
		}

		public function saveScore():void {
			Main.cSCClientController.saveScore(currentLevelNumber - 1, getScoreTotalPoint());
		}

		public function isNextLevelAvaible():Boolean {
			score.updateData(levelData);

			if (levelListDict[_currentLevelNumber + 1]) {
				if (_userLives > 0) return true;
			}
			return false;
		}

		public function cleanLevel():void {
			// for debug
			//_currentLevelNumber = 6;
			_currentLevelNumber = 0;
			finishedMaps = [];
			_userLives = 0;
			score.clear();
		}

		public function getScoreTotalPoint():int {
			if (score) {
				return score.scorePoint;
			}
			return 0;
		}

		public function getRotationPoint():int {
			return rotationAngel;
		}

		public function endLevel():void {
			clearTimer();
			rotationAngel = 0;
			rotationsCount = 0;

			if (levelData["isEnemy"]) {
				_userLives--;

				_currentLevelNumber--;
				for (var i:int = 0; i < finishedMaps.length; i++) {
					if (finishedMaps[i] == currentMap) {
						finishedMaps.splice(i, 1);
					}
				}
			}
		}

		private function clearTimer():void {
			if (timer) {
				timer.stop();
			}
		}

		public function getMapDaraModelById(value:String = ""):Object {
			if (mapsDataModel[value]) {
				return mapsDataModel[value];
			}
			return {};
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function init():void {
			var levelData:SimpleLevelModel;
			for (var key:String in levelsData) {
				levelData = new SimpleLevelModel(levelsData[key]);
				convertMapList(levelData);
				levelListDict[levelData.levelNumber.toString()] = levelData;
			}
			score = new ScoreData();
		}

		private var innerCount:int = 0;

		private function convertMapList(levelData:SimpleLevelModel):void {
			var len:int = levelData.mapList.length;
			var data:Object;
			var st:String;
			var mapDataItem:SimpleMapData;

			for (var i:int = 0; i < len; i++) {
				st = String(levelData.mapList[i].setting);
				data = JSON.decode(st);
				mapDataItem = convertToMapData(data);
				mapDataItem.innerId = innerCount;
				levelData.mapDataList.push(mapDataItem);
				innerCount++;
			}
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------
		private function timerEventHandler(event:TimerEvent):void {
			var index:int = int(Math.random() * 100);
			rotationsCount++;
			if (index > 66) {
				rotationAngel = 270;
			} else if (index > 33) {
				rotationAngel = 90;
			} else {
				rotationAngel = 90;
			}
			// for debug
			//			rotationAngel = 0;
			if (rotationAngel) {
				dispatchEvent(new Event(EVENT_ROTATION));
			}

		}

		public function get recoursePath():String {
			return _recoursePath;
		}

		public function set recoursePath(value:String):void {
			_recoursePath = value;
		}

		public function setLevelResultData(resultData:Object):void {
			if (resultData) {
				levelData = resultData;
			}
		}

		public function get currentLevelNumber():Number {
			return _currentLevelNumber;
		}

		public function get userLives():int {
			return _userLives;
		}

		public function get itemSpeed():Number {
			return _itemSpeed;
		}

		public function set itemSpeed(value:Number):void {
			_itemSpeed = value;
		}
	}
}
