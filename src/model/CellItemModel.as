/**
 * Created with IntelliJ IDEA.
 * User: MALKKIRI-HOME-PC
 * Date: 13.03.13
 * Time: 22:26
 * To change this template use File | Settings | File Templates.
 */
package model {
import flash.geom.Point;

public class CellItemModel {

	private var _position:Point;
	private var _cellKey:String;
	private var _index:int;

	public function CellItemModel(data:Object) {
		_cellKey = data.key;
		_index = data.index;
		var stAr:Array = _cellKey.split(",");
		_position = new Point(stAr[0], stAr[1]);
	}

	public function get position():Point {
		return _position;
	}

	public function get cellKey():String {
		return _cellKey;
	}

	public function get index():int {
		return _index;
	}
}
}
