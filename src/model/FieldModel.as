/**
 * FieldModel.
 * Date: 13.03.13
 * Time: 15:03
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package model {
import flash.utils.Dictionary;

public class FieldModel {
	//--------------------------------------------------------------------------
	//  Constants
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//  Variables
	//--------------------------------------------------------------------------
	private var cellDict:Dictionary = new Dictionary();
	private var pathList:Array = [];
	private var cellItemsList:Array = [];

	private var matrix:Array = [];

	private var _rows:int;
	private var _columns:int;

	private var player1Position:String;
	private var player2Position:String;
	private var goalPositionFirst:String;
	private var goalPositionSecond:String;
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

	public function FieldModel() {

	}

	//--------------------------------------------------------------------------
	//  Public methods
	//--------------------------------------------------------------------------
	public function setData(value:Object = null):void {
		var data:Object = value;
		if (data) {

		}
		//data = {path:[{x:0,y:0},{x:1,y:0},{x:2,y:0},{x:2,y:1},{x:2,y:2},{x:1,y:2},{x:1,y:1},{x:0,y:1},{x:0,y:2}]};

		/*data = {path: ["0,7", "1,0"],
		 //data = {path: ["0,7", "1,7", "2,7", "3,7", "3,6", "3,5", "4,5", "5,5", "6,5", "7,5"],
		 field: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]};

		 _rows = 15;
		 _columns = 15;*/

		/*
		 0	0	0	0	0	1	0
		 [trace] 1	1	0	1	0	1	1
		 [trace] 0	1	0	1	0	0	0
		 [trace] 0	1	0	1	1	1	0
		 [trace] 0	0	0	1	0	0	0
		 [trace] 1	1	0	1	1	1	0
		 [trace] 0	0	0	0	0	1	0*/

//		pathList = data.path;

		player1Position = getStringPositionForMainMap(data.herouPosition);
		player2Position = getStringPositionForMainMap(data.enemyPosition);
		goalPositionFirst = getStringPositionForMainMap(data.itemPositionFirst);
		goalPositionSecond = getStringPositionForMainMap(data.itemPositionSecond);

		_rows = data.rows;
		_columns = data.colums;

		setMatrix(data.field);

		/*var itemModel:CellItemModel;
		 for (var i:int = 0; i < pathList.length; i++) {
		 itemModel = new CellItemModel({key: pathList[i], index: i});
		 cellItemsList.push(itemModel);
		 }*/
	}

	private function getStringPositionForMainMap(pos:String):String {
		var arSt:Array = pos.split(",");
		var position:String;
		var posX:int = (arSt[0] * 0.5);
		var posY:int = (arSt[1] * 0.5);
		position = posX + "," + posY;
		return position;
	}

	public function getPlayersPositions():Array {
		return [player1Position, player2Position, goalPositionFirst, goalPositionSecond];
	}

	public function getRows():int {
		return (rows + 1) * 0.5
	}

	public function getColumns():int {
		return (columns + 1) * 0.5
	}

	private function setMatrix(_matrixCells:Array):void {
		var _map:Array = [];
		for (var i:int = 0; i < rows; i++) {
			_map[i] = new Array();
			for (var j:Number = 0; j < columns; j++) {
//				if (1 == 1) {
//					_map[i][j] = 1;
//				} else {
//					_map[i][j] = 0;
//				}
				_map[i][j] = _matrixCells[j * rows + i];
			}
		}
		matrix = _map;
		//showMatrix(_map);
	}

	private function showMatrix(_matrix:Array):void {
		var show:String = "";
		//for (var i:int = 0; i < rows; i++)
		var key:String = "";
		for (var i:int = 0; i < columns; i++) {
			//for (var j:int = 0; j < colums; j++)
			for (var j:int = 0; j < rows; j++) {
				//var item:MapItem = matrix[i][j];
				//var item:MapItem = _matrix[j][i];
				var emptyId:int = _matrix[j][i];
				show += emptyId.toString() + "\t";
				key += emptyId.toString() + ",";
			}
			show += "\n";
		}
		trace(show);
		//trace(key);
		//key = key.slice(0, key.length - 1);
		//trace(key);
	}

	/* public function getPathList():Array {
	 return pathList;
	 }*/

	public function getItmesModelList():Array {
		return cellItemsList;
	}

	/* public function getFirstPathCell():String {
	 if (pathList && pathList[0]) {
	 return pathList[0];
	 }
	 return "";

	 }*/

	public function getPathFinderMap():Array {
		return matrix;
	}

	//--------------------------------------------------------------------------
	//  Protected methods
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//  Private methods
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//  Handlers
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//  Destroy
	//--------------------------------------------------------------------------

	public function get rows():int {
		return _rows;
	}


	public function get columns():int {
		return _columns;
	}


}
}
