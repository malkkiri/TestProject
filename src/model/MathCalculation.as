/**
 * MathCalCulation.
 * Date: 13.03.13
 * Time: 18:33
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package model {
import flash.geom.Point;
import flash.utils.Dictionary;

public class MathCalculation {
    //--------------------------------------------------------------------------
    //  Constants
    //--------------------------------------------------------------------------
    private const MOVE_LEFT:String = "move_left";
    private const MOVE_RIGHT:String = "move_right";
    private const MOVE_DOWN:String = "move_down";
    private const MOVE_UP:String = "move_up";
    //--------------------------------------------------------------------------
    //  Variables
    //--------------------------------------------------------------------------
    private var _pathArray:Array = [];
    private var _cellModelList:Array = [];
    private var _cellItemsDict:Dictionary;
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

    public function MathCalculation() {

    }

    //--------------------------------------------------------------------------
    //  Public methods
    //--------------------------------------------------------------------------
    public function calculatePath():Object {
        return {};
    }

    public function getPath(direction:String, position:Point):Point {
        if (direction == MOVE_UP) {

        }
        return new Point(0, 0);
    }

    //--------------------------------------------------------------------------
    //  Protected methods
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //  Private methods
    //--------------------------------------------------------------------------
    private function checkPath():void{
        var cellModel:CellItemModel;

    }
    private function checkCell():Boolean{
        return true;
    }

    //--------------------------------------------------------------------------
    //  Handlers
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //  Destroy
    //--------------------------------------------------------------------------

    public function get cellItemsDict():Dictionary {
        return _cellItemsDict;
    }

    public function set cellItemsDict(value:Dictionary):void {
        _cellItemsDict = value;
    }

    public function get pathArray():Array {
        return _pathArray;
    }

    public function set pathArray(value:Array):void {
        _pathArray = value;
    }

    public function get cellModelList():Array {
        return _cellModelList;
    }

    public function set cellModelList(value:Array):void {
        _cellModelList = value;
    }
}
}
