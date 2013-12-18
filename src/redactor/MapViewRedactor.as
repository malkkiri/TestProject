/**
 * MApViewRedactor.
 * Date: 14.03.13
 * Time: 18:08
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package redactor {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import redactor.ActiveMapItem;

	import redactor.MapCell;
	import redactor.model.SimpleMapData;

	import view.aStar.Pathfinder;

	import view.cell.CellItem;

	public class MapViewRedactor extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var _rows:int;
		private var _colums:int;

		private var _cellItemWidth:int;
		private var _cellItemHeight:int;

		private var _cellSize:int;

		private var _field:String;

		private var cellsList:Array = [];

		private var pathArray:Array = [];
		private var pathFind:Pathfinder;

		private var baseData:Object = {};

		private var isHoldingShift:Boolean;
		private var lineList:Array = [];

		private var mapHolder:Sprite;

		private var allCells:Array = [];

		private var itemsDict:Dictionary = new Dictionary(false);

		private var activeItem:ActiveMapItem;
		private var activeCellsList:Array;

		private var hero:ActiveMapItem;
		private var enemy:ActiveMapItem;
		private var cheese:ActiveMapItem;

		private var borderItems:Array = [];

		private var simpleMapData:SimpleMapData;

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

		public function MapViewRedactor() {
			pathFind = new Pathfinder();
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function setMapParams(mapData:SimpleMapData):void {
			simpleMapData = mapData;
			rows = simpleMapData.rows;
			colums = simpleMapData.columns;
			cellItemWidth = 50//simpleMapData.cellWidth;
			cellItemHeight = 50//simpleMapData.cellWidth;
			_cellSize = simpleMapData.cellWidth;
			field = simpleMapData.field;
		}

		public function createReadyMap():void {
			createMouse();
			createMapItems();
			createBorder();

			showActiveCells();
			showSelectedItems();
		}

		public function createMap():void {
			createMouse();
			createMapItems();
			createBorder();

			if (_field && _field.length > 5) {
				showActiveCells();
				//showSelectedItems();
			}
		}

		private function showActiveCells():void {
			var mapCell:MapCell;
			var innerCount:int = 0;
			var fieldList:Array = _field.split(",");
			for (var i:int = 0; i < _rows; i++) {
				for (var j:int = 0; j < _colums; j++) {
					mapCell = cellsList[j][i];
					if (fieldList[innerCount] && fieldList[innerCount] > 0) {
						mapCell.setActive();
					}
					innerCount++;
				}
			}
		}

		private function showSelectedItems():void {
			//			setItemOnPosition(hero, cellsList[0][6]);
			if (simpleMapData.heroPosition.x > -1) {
				setItemOnPosition(hero, cellsList[simpleMapData.heroPosition.x][simpleMapData.heroPosition.y]);
			}

			if (simpleMapData.enemyPosition.x > -1) {
				setItemOnPosition(enemy, cellsList[simpleMapData.enemyPosition.x][simpleMapData.enemyPosition.y]);
			}

			/*
			 * var cell:MapCell = activeCellsList[0];
			 var cell2:MapCell = activeCellsList[1];
			 * */
			if (simpleMapData.cheesePositionFirst.x > -1) {
				var cell:MapCell = cellsList[simpleMapData.cheesePositionFirst.x][simpleMapData.cheesePositionFirst.y];
				var cell2:MapCell = cellsList[simpleMapData.cheesePositionSecond.x][simpleMapData.cheesePositionSecond.y];
				setGoalOnPosition(cheese, cell, cell2);
			}

		}

		private function setItemOnPosition(item:ActiveMapItem, cell:MapCell):void {
			item.x = mapHolder.x + cell.x + ((cell.width - item.width) * 0.5) + item.width * 0.5;
			item.y = mapHolder.y + cell.y + ((cell.height - item.height) * 0.5) + item.height * 0.5;
			item.positionOnMapX = cell.posX;
			item.positionOnMapY = cell.posY;
			this.addChild(item);
		}

		private function setGoalOnPosition(item:ActiveMapItem, cell:MapCell, cell2:MapCell):void {
			var posX1:int = mapHolder.x + cell.x;
			var posX2:int = mapHolder.x + cell2.x;

			if (posX2 > posX1) {
				item.x = posX2 - 5;
			} else {
				item.x = posX1 - 5
			}
			if (posX2 == posX1) {
				item.x = posX1 + cell.width * 0.5;
			}

			var posY1:int = mapHolder.y + cell.y;
			var posY2:int = mapHolder.y + cell2.y;

			if (posY2 > posY1) {
				item.y = posY2 - 5;
			} else {
				item.y = posY1 - 5
			}
			if (posY2 == posY1) {
				item.y = posY1 + cell.height * 0.5;
			}
			item.positionForGoal = [new Point(cell.posX, cell.posY), new Point(cell2.posX, cell2.posY)];
			this.addChild(item);
		}

		public function getBaseData():Object {
			return baseData;
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------

		private function createMouse():void {

			var padding:int = 40;
			hero = addItem(ActiveMapItem.HERO_ID);
			hero.mouseChildren = false;
			hero.y = 20;
			hero.positionX = 0;
			hero.positionY = hero.y;
			hero.positionOnMapX = -1;
			hero.positionOnMapY = -1;
			this.addChild(hero);

			enemy = addItem(ActiveMapItem.ENEMY_ID);
			enemy.mouseChildren = false;
			enemy.y = hero.y + hero.height + padding;
			enemy.positionX = 0;
			enemy.positionY = enemy.y;
			enemy.positionOnMapX = -1;
			enemy.positionOnMapY = -1;
			this.addChild(enemy);

			cheese = addItem(ActiveMapItem.CHEESE_ID);
			cheese.mouseChildren = false;
			cheese.y = enemy.y + enemy.height + padding;
			cheese.positionX = 0;
			cheese.positionY = cheese.y;
			cheese.positionOnMapX = -1;
			cheese.positionOnMapY = -1;
			this.addChild(cheese);

			hero.addEventListener(MouseEvent.MOUSE_DOWN, onChoose, false, 0, true);
			enemy.addEventListener(MouseEvent.MOUSE_DOWN, onChoose, false, 0, true);
			cheese.addEventListener(MouseEvent.MOUSE_DOWN, onChoose, false, 0, true);

			hero.addEventListener(MouseEvent.MOUSE_UP, onChooseComplete, false, 0, true);
			enemy.addEventListener(MouseEvent.MOUSE_UP, onChooseComplete, false, 0, true);
			cheese.addEventListener(MouseEvent.MOUSE_UP, onChooseComplete, false, 0, true);

		}

		private function addItem(id:int):ActiveMapItem {
			var mapItem:ActiveMapItem = new ActiveMapItem(id);
			itemsDict[id] = mapItem;
			return mapItem;
		}

		private function onChooseComplete(event:MouseEvent):void {
			if (activeCellsList.length > 0) {
				if (activeItem.id == ActiveMapItem.CHEESE_ID) {
					setPositionsForGoal();
				} else {
					setPositionsForItems();
				}
			} else {
				returnToBasePosition();
			}
			needToCheckCollision(false);
			activeItem.stopDrag();
			activeItem = null;
		}

		private function setPositionsForItems():void {
			var cell:MapCell = activeCellsList[0];
			activeItem.x = mapHolder.x + cell.x + ((cell.width - activeItem.width) * 0.5) + activeItem.width * 0.5;
			activeItem.y = mapHolder.y + cell.y + ((cell.height - activeItem.height) * 0.5) + activeItem.height * 0.5;
			activeItem.positionOnMapX = cell.posX;
			activeItem.positionOnMapY = cell.posY;
			cell.setOnMouseActive(true);

			for (var i:int = 1; i < activeCellsList.length; i++) {
				cell = activeCellsList[i];
				cell.setOnMouseActive(false);
			}
			activeCellsList = [];
		}

		private function setPositionsForGoal():void {
			if (activeCellsList.length < 2) {
				activeItem.positionForGoal = [];
				returnToBasePosition();
				return
			}

			var cell:MapCell = activeCellsList[0];
			var cell2:MapCell = activeCellsList[1];

			var posX1:int = mapHolder.x + cell.x;
			var posX2:int = mapHolder.x + cell2.x;

			if (posX2 > posX1) {
				activeItem.x = posX2 - 5;
			} else {
				activeItem.x = posX1 - 5
			}
			if (posX2 == posX1) {
				activeItem.x = posX1 + cell.width * 0.5;
			}

			var posY1:int = mapHolder.y + cell.y;
			var posY2:int = mapHolder.y + cell2.y;

			if (posY2 > posY1) {
				activeItem.y = posY2 - 5;
			} else {
				activeItem.y = posY1 - 5
			}
			if (posY2 == posY1) {
				activeItem.y = posY1 + cell.height * 0.5;
			}

			cell.setOnMouseActive(true);
			cell2.setOnMouseActive(true);
			activeItem.positionForGoal = [new Point(cell.posX, cell.posY), new Point(cell2.posX, cell2.posY)];

			for (var i:int = 2; i < activeCellsList.length; i++) {
				cell = activeCellsList[i];
				cell.setOnMouseActive(false);
			}
			activeCellsList = [];

		}

		private function returnToBasePosition():void {
			activeItem.x = activeItem.positionX;
			activeItem.y = activeItem.positionY;
			activeItem.positionOnMapX = -1;
			activeItem.positionOnMapY = -1;
		}

		private function onChoose(event:MouseEvent):void {
			activeItem = event.currentTarget as ActiveMapItem;
			activeItem.startDrag(true);
			this.setChildIndex(activeItem, this.numChildren - 1);
			needToCheckCollision();
		}

		private function needToCheckCollision(isNeed:Boolean = true):void {
			if (isNeed) {
				this.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			} else {
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		private function onEnterFrame(event:Event):void {
			checkCollision();
		}

		private function checkCollision():void {
			var len:int = allCells.length;
			var cell:MapCell;
			activeCellsList = [];
			for (var i:int = 0; i < len; i++) {
				cell = allCells[i];
				if (!cell.isWall && !cell.isCorner) {
					if (cell.hitTestObject(activeItem)) {
						cell.setOnMouseActive();
						activeCellsList.push(cell);
					} else {
						cell.setOnMouseActive(false);
					}
				}
			}
		}

		private function addListner():void {
			if (stage) {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyBoarHandler, false, 0, true);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyBoarHandler, false, 0, true);
			}
		}

		private function createMapItems():void {
			var mapCell:MapCell;

			var localWidth:int = cellItemWidth;
			var localHeight:int = cellItemHeight;
			var wallPadding:int = 4;

			var dx:int;
			var dy:int;
			mapHolder = new Sprite();
			for (var i:int = 0; i < rows; i++) {
				cellsList[i] = new Array();
				for (var j:int = 0; j < colums; j++) {
					mapCell = new MapCell(i, j, cellItemWidth, cellItemHeight);
					mapCell.addEventListener(MouseEvent.CLICK, mouseEventHandler, false, 0, true);

					if (i == 0) {
						dx = 0;
					} else {
						dx = ((mapCell.posX + 1) * 0.5);
					}
					if (j == 0) {
						dy = 0;
					} else {
						dy = ((mapCell.posY + 1) * 0.5);
					}

					mapCell.x = dx * (localWidth + wallPadding);
					mapCell.y = dy * (localWidth + wallPadding);

					if (mapCell.isWall) {
						if (mapCell.isVerticale) {
							mapCell.x = dx * (localWidth) + (dx - 1) * wallPadding;
						}
						if (mapCell.isHorizontale) {
							mapCell.y = dy * (localHeight) + (dy - 1) * wallPadding;
						}
						if (mapCell.isCorner) {
							mapCell.x = dx * (localWidth) + (dx - 1) * wallPadding;
							mapCell.y = dy * (localHeight) + (dy - 1) * wallPadding;
						}

					}
					cellsList[i][j] = mapCell;
					allCells.push(mapCell);
					//cellsList.push(mapCell);
					mapHolder.addChild(mapCell);
				}
			}
			mapHolder.x = 30;
			this.addChild(mapHolder);
			reSortMapItems();
		}

		public function saveSettings():void {
			showActiveMap();
		}

		public function getAllWalls():Array {
			var result:Array = [];
			var len:int = allCells.length;
			var mapCell:MapCell;
			for (var i:int = 0; i < len; i++) {
				mapCell = allCells[i];
				if (mapCell.isWall) {
					if (!mapCell.isCorner) {
						if (mapCell.isActive) {
							result.push(mapCell);
						}
					}
				}
			}
			return result;
		}

		private function createBorder():void {
			addVerticaleBorder(mapHolder.x - 6, mapHolder.y - 2, colums * 0.5);
			addVerticaleBorder(mapHolder.x + mapHolder.width - 8, mapHolder.y - 2, colums * 0.5);

			addHorizontalBorder(mapHolder.x - 6, mapHolder.y - 6, rows * 0.5);
			addHorizontalBorder(mapHolder.x - 6, mapHolder.y + mapHolder.height - 8, rows * 0.5);

			//#339966

		}

		private function addVerticaleBorder(posX:int, posY:int, count:int):void {
			var border:Sprite = new Sprite();
			border.mouseChildren = false;
			border.mouseEnabled = false;
			var borderHeight:int = mapHolder.height;
			var bt:Bitmap = new Bitmap(new BitmapData(6, borderHeight, true, 0xFF339966));
			border.addChild(bt);
			border.x = posX;
			border.y = posY;
			this.addChild(border);
		}

		private function addHorizontalBorder(posX:int, posY:int, count:int):void {
			var border:Sprite = new Sprite();
			border.mouseChildren = false;
			border.mouseEnabled = false;
			var borderHeight:int = mapHolder.width + 4;
			var bt:Bitmap = new Bitmap(new BitmapData(borderHeight, 6, true, 0xFF339966));
			border.addChild(bt);
			border.x = posX;
			border.y = posY;
			this.addChild(border);
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------

		private function reSortMapItems():void {
			var len:int = allCells.length;
			var mapCell:MapCell;
			for (var i:int = 0; i < len; i++) {
				mapCell = allCells[i];
				if (mapCell.isWall) {
					mapHolder.removeChild(mapCell);
					mapHolder.addChildAt(mapCell, mapHolder.numChildren - 1);
				}
			}
		}

		private function mouseEventHandler(event:MouseEvent):void {
			var cellItem:MapCell = (event.currentTarget as MapCell);
			//			cellItem.setActive();

			if (cellItem.isWall) {
				cellItem.choose();
			}

			return;

			var isActive:Boolean = cellItem.isActive;

			if (!cellItem.isWall) {
				if (pathArray.indexOf(cellItem) == -1) {
					pathArray.push(event.currentTarget as MapCell);
				} else {
					removeFromList(cellItem);
				}
			}
			//trace(pathArray);

			/*if (cellItem.isWall) {
			 if (isHoldingShift) {
			 lineList.push(cellItem);
			 trace("lineList= " + lineList);
			 if (lineList.length == 2) {
			 makeLine();
			 }
			 }
			 }*/

			if (pathArray.length == 4) {
				showActiveMap();
			}

		}

		private function makeLine():void {

			var startPosX:int = (lineList[0] as MapCell).posX;
			var startPosY:int = (lineList[0] as MapCell).posY;

			var endPosX:int = (lineList[1] as MapCell).posX;
			var endPosY:int = (lineList[1] as MapCell).posY;

			var isVerticale:Boolean = (startPosX == endPosX) ? true : false;

			var len:int = isVerticale ? (Math.abs(endPosY - startPosY)) : (Math.abs(endPosX - startPosX));
			var isIncrease:Boolean = ((startPosX < endPosX) || (startPosY < endPosY)) ? true : false;

			for (var i:int = 0; i < len; i++) {
				if (isVerticale) {
					if (!isIncrease) {
						setLineItemChoosen(startPosX, startPosY - (len - i));
					} else {
						setLineItemChoosen(startPosX, startPosY + i);
					}
				} else {
					if (!isIncrease) {
						setLineItemChoosen(startPosX - (len - i), startPosY);
					} else {
						setLineItemChoosen(startPosX + i, startPosY);
					}
				}
			}

			lineList = [];
		}

		private function setLineItemChoosen(posX:int, posY:int):void {
			var item:MapCell;
			trace(posX + " x " + posY);
			item = (cellsList[posX][posY] as MapCell);
			if (item.isWall) {
				if (!item.isActive) {
					item.setActive();
				}
			}
		}

		private function showActiveMap():void {
			var _map:Array = new Array();
			var _way:Array = new Array();
			for (var i:int = 0; i < rows; i++) {
				_map[i] = new Array();
				for (var j:Number = 0; j < colums; j++) {
					if ((cellsList[i][j] as MapCell).isActive) {
						_map[i][j] = 1;
					} else {
						_map[i][j] = 0;
					}
				}
			}
			showMatrix(_map);
			//			var start:Point = new Point((pathArray[0] as MapCell).posX, (pathArray[0] as MapCell).posY);
			//			var end:Point = new Point((pathArray[1] as MapCell).posX, (pathArray[1] as MapCell).posY);
			//
			//			trace(start, end);
			//
			//			_way = pathFind.FindPath(start, end, _map, true);

			//			if (_way) {
			//				_way.reverse();
			//				_way.unshift();
			//			}
			//			trace("___________WAY ______ " + _way);

			//			baseData.herouPosition = String((pathArray[0] as MapCell).posX + "," + (pathArray[0] as MapCell).posY);
			baseData.herouPosition = hero.positionOnMapX.toString() + "," + hero.positionOnMapY.toString();
			baseData.enemyPosition = enemy.positionOnMapX.toString() + "," + enemy.positionOnMapY.toString();
			baseData.cellWidth = _cellSize;

			var goalPosition1:Point = new Point(0, 0);
			var goalPosition2:Point = new Point(0, 0);

			if (cheese.positionForGoal.length > 0) {
				goalPosition1.x = (cheese.positionForGoal[0]).x;
				goalPosition1.y = (cheese.positionForGoal[0]).y;
			}
			if (cheese.positionForGoal.length > 1) {
				goalPosition2.x = (cheese.positionForGoal[1]).x;
				goalPosition2.y = (cheese.positionForGoal[1]).y;
			}
			baseData.itemPositionFirst = goalPosition1.x.toString() + "," + goalPosition1.y.toString();
			baseData.itemPositionSecond = goalPosition2.x.toString() + "," + goalPosition2.y.toString();
			baseData.rows = rows;
			baseData.colums = colums;

			trace("itemPositionFirst " + baseData.itemPositionFirst);
			trace("itemPositionSecond " + baseData.itemPositionSecond);
			trace("herouPosition " + baseData.herouPosition);
			trace("enemyPosition " + baseData.enemyPosition);
			//			baseData.enemyPosition = String((pathArray[1] as MapCell).posX + "," + (pathArray[1] as MapCell).posY);         TODO: change correct
			//			baseData.itemPositionFirst = String((pathArray[2] as MapCell).posX + "," + (pathArray[2] as MapCell).posY);
			//			baseData.itemPositionSecond = String((pathArray[3] as MapCell).posX + "," + (pathArray[3] as MapCell).posY);

		}

		private function removeFromList(mapItem:MapCell):void {
			for (var i:int = 0; i < pathArray.length; i++) {
				if ((pathArray[i] as MapCell) == mapItem) {
					pathArray.splice(i, 1);
					return;
				}
			}
		}

		private function showMatrix(_matrix:Array):void {
			var show:String = "";
			var field:Array = [];
			//for (var i:int = 0; i < rows; i++)
			var key:String = "";
			for (var i:int = 0; i < colums; i++) {
				//for (var j:int = 0; j < colums; j++)
				for (var j:int = 0; j < rows; j++) {
					//var item:MapItem = matrix[i][j];
					//var item:MapItem = _matrix[j][i];
					var emptyId:int = _matrix[j][i];
					show += emptyId.toString() + "\t";
					key += emptyId.toString() + ",";
					field.push(emptyId);
				}
				show += "\n";
			}
			trace(show);
			trace(key);
			key = key.slice(0, key.length - 1);
			trace(key);

			//baseData.key = key;
			baseData.field = field;
		}

		private function onAdded(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			//			addListner();
		}

		private function keyBoarHandler(event:KeyboardEvent):void {
			if (event.type == KeyboardEvent.KEY_DOWN) {
				if (event.keyCode == Keyboard.SHIFT) {
					isHoldingShift = true;
				}
			}
			if (event.type == KeyboardEvent.KEY_UP) {
				if (event.keyCode == Keyboard.SHIFT) {
					isHoldingShift = false;
				}
			}
		}

		//--------------------------------------------------------------------------
		//  Destroy
		//--------------------------------------------------------------------------

		public function get rows():int {
			return _rows;
		}

		public function set rows(value:int):void {
			_rows = value;
		}

		public function get colums():int {
			return _colums;
		}

		public function set colums(value:int):void {
			_colums = value;
		}

		public function get cellItemWidth():int {
			return _cellItemWidth;
		}

		public function set cellItemWidth(value:int):void {
			_cellItemWidth = value;
		}

		public function get cellItemHeight():int {
			return _cellItemHeight;
		}

		public function set cellItemHeight(value:int):void {
			_cellItemHeight = value;
		}

		public function get field():String {
			return _field;
		}

		public function set field(value:String):void {
			_field = value;
		}

		public function get cellSize():int {
			return _cellSize;
		}

		public function set cellSize(value:int):void {
			_cellSize = value;
		}
	}
}
