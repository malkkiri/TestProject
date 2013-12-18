package view.aStar {
import flash.geom.Point;


// This class implements an A* algorithm for pathfinding. It's hardcoded to use a 10x10 map of integers, where
// 0 marks a floor tile, while 1 marks a wall. It could easily be changed to fit anything.
// For an explanation of the A* algorithm, see the article: http://www.policyalmanac.org/games/aStarTutorial.htm
public class Pathfinder {
    private var _open:Array; // The open array.
    private var _closed:Array; // The closed array.
    private var _map:Array; // The map of 10x10 integers.
    private var _startPoint:Point; // The starting point - eg. Point(2, 3).
    private var _targetPoint:Point; // The target point - eg. Point(8, 5).
    private var _isFourWays:Boolean;// is for searching path for 4 way< not for 9;

    // Find a path from start to target on the map.
    public function FindPath(startPoint:Point, targetPoint:Point, map:Array, isFourWays:Boolean = false):Array {
        _isFourWays = isFourWays;
        // Create open and closed arrays for A* pathfinding.
        _open = new Array();
        _closed = new Array();

        // Set the start and target points.
        _startPoint = startPoint;
        _targetPoint = targetPoint;

        // Set the map.
        _map = map;

        // Create start a node.
        var startNode:Node = new Node(startPoint, null, 99, 0, 0);

        // Add the start node to closed list.
        _closed.push(startNode);

        // Add all ajacent squares in the map to the open list (if they survive tests).
        AddAjacentToOpen(startNode);

        // Always find the lowest cost 'f' in the open list and iterate until target is found or no path is possible.
        while (true) {
            // If the open list is empty, there is no path from start to target.
            if (_open.length == 0) {
         //       trace('no path!');
                return null;
            }

            // Sort the open list so the lowest cost 'f' is at the bottom, using a custom sort function.
            _open.sort(Node.Sorter, Array.DESCENDING);

            // Remove the lowest cost 'f' from the open list and use it as the current node.
            var currentNode:Node = Node(_open.pop());

            // Put it on the closed list.
            _closed.push(currentNode);

            // Add all ajacent squares in the map to the open list (if they survive tests).
            AddAjacentToOpen(currentNode);

            // Test if the current node's position is equal to the target position.
            if (currentNode.position.equals(_targetPoint)) {
                // If so, we've reached the target. Store the path and return to caller.
                var path:Array = TracePath(currentNode);
                return path;
            }
        }

        // Never called.
        return null;
    }


    // Trace a path from the target back to the start point, using the last node found (which matched the target).
    // This is possible using the parent property of each node.
    public function TracePath(node:Node):Array {
        // Create an array to hold the path.
        var path:Array = new Array();

        // Keep going backwards from the node that matched the target to the start point.
        while (node.parent != null) {
            // Push the node's position in the path onto the array.
            path.push(node.position);

            // Get the parent node.
            node = FindNodeByPosition(node.parent, _closed);
        }

        // Now that there are no more parent nodes, return the path to caller.
        return path;
    }


    // Add ajacent squares in the map to the open list, if they survive a few tests.
    public function AddAjacentToOpen(node:Node):void {
        // First, lookup all ajacent squares in the map.
        for (var dx:int = -1; dx <= 1; dx++) {
            for (var dy:int = -1; dy <= 1; dy++) {
                // The middle (current) square is not relevant.
                if (dx == 0 && dy == 0)
                    continue;


                if (_isFourWays) {
                    if (dx != 0 && dy != 0)
                        continue;
                }


                // Do a bounds check so we don't fall off the 10x10 map.
                if (node.position.y + dy < 0 || node.position.x + dx < 0)
                    continue;

                if (node.position.y + dy > (_map[0].length - 1) || node.position.x + dx > (_map.length - 1))
                    continue;

                // No cutting corners: Diagonal squares with ajacent walls are not walkable. This is optional!
                /* if (Math.abs(dx) + Math.abs(dy) > 1)
                 {
                 if (_map[node.position.x][node.position.y + dy] == "1") continue;
                 if (_map[node.position.x + dx][node.position.y] == "1") continue;
                 } */

                // If the ajacent square is walkable..
                if (_map[node.position.x + dx][node.position.y + dy] == "0") {
                    // Create a new node and calculate 'f', 'g' and 'h'.
                    var pos:Point = new Point(node.position.x + dx, node.position.y + dy);
                    var g:int = CalculateG(pos, node);
                    var h:int = CalculateH(pos);
                    var f:int = g + h;
                    var newnode:Node = new Node(pos, node.position, f, g, h);

                    // If the new node is not already on the open list..
                    var alreadyOpenNode:Node = FindNodeByPosition(newnode.position, _open);

                    if (alreadyOpenNode == null) {
                        // And it's not in the closed list..
                        if (FindNodeByPosition(newnode.position, _closed) == null) {
                            // Add it to the open list!
                            _open.push(newnode);
                        }
                    }
                    else {
                        // If it's already in the open list, check if this is a better path than the existing one.
                        if (g < alreadyOpenNode.g) {
                            // If the new path is better, replace the old node info in the open list with this new node.
                            ReplaceNodeByPosition(pos, newnode, _open);
                        }
                    }
                }
            }
        }
    }


    // Utility function used to find a node in an array by its position, which serves as an identifier.
    // The array is typically either the open or closed list.
    private function FindNodeByPosition(pos:Point, array:Array):Node {
        // Loop through the array of nodes.
        for (var i:int = 0; i < array.length; i++) {
            // If a node has the right position, return it.
            if (pos.equals(Node(array[i]).position)) {
                // Return to caller.
                return Node(array[i]);
            }
        }

        // Return null if not found.
        return null;
    }


    // Utility function to replace an existing node in an array by its position with a new node.
    private function ReplaceNodeByPosition(pos:Point, node:Node, array:Array):void {
        // Loop through the array of nodes.
        for (var i:int = 0; i < array.length; i++) {
            // If a node has the right position, replace it.
            if (pos.equals(Node(array[i]).position)) {
                // Replace and return.
                array[i] = node;
                return;
            }
        }
    }


    // Utility function to calculate 'g', which is the movement cost from the start to a specific node,
    // following an already established path to get here.
    public function CalculateG(pos:Point, node:Node):int {
        // The cost of traversing diagonally is higher than orthogonally (use pythagoras to figure it out :)).
        var result:int;
        var dif:int = Math.abs(pos.x - node.position.x) + Math.abs(pos.y - node.position.y);

        if (dif == 1)
            result = 10;

        if (dif == 2)
            result = 14;

        // Add the already existing 'g' cost.
        result += node.g;

        return result;
    }


    // Utility function to calculate the heuristic 'h', which serves as a best guess for the distance from any point
    // to the target. We use the so-called 'Manhattan technique', which basically is the grid difference in x plus
    // the difference in y.
    public function CalculateH(pos:Point):int {
        // Calculate the result.
        var result:int = (Math.abs(pos.x - _targetPoint.x) + Math.abs(pos.y - _targetPoint.y)) * 10;

        // Return to caller.
        return result;
    }

}
}