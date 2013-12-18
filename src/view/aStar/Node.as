package view.aStar {
import flash.geom.Point;


// This class describes a 'node' in the pathfinding graph.
public class Node {
    public var position:Point; // Position serves as identifier of the node.
    public var parent:Point; // The parent of the node is a position (see above).
    public var f:int; // 'f' equals 'g' + 'h'.
    public var g:int; // 'g' is the movement cost from the start to this node, following the path to get here.
    public var h:int; // 'h' is the heuristic (best guess) for the distance from this node to the target.


    // Constructor, which creates a node based on position, parent, 'f', 'g' and 'h'.
    public function Node(nodepos:Point, nodeparent:Point, nodef:int, nodeg:int, nodeh:int) {
        // Set the position and parent.
        position = nodepos;
        parent = nodeparent;

        // Set the elements of the basic A* equation.
        f = nodef;
        g = nodeg;
        h = nodeh;
    }


    // Sorting function used to sort an array of Nodes based on the value of 'f'.
    public static function Sorter(a:Node, b:Node):Number {
        // Sort by 'f' value.
        if (a.f > b.f) {
            return 1;
        }
        else if (a.f < b.f) {
            return -1;
        }
        else {
            return 0;
        }
    }
}
}