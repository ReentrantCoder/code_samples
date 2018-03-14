import java.util.HashMap;
import java.util.LinkedList;
import java.util.Queue;

/**
 * A collection of nodes connected by undirected edges.
 * Generated using a Erdos-Renyi model.
 */
public class UndirectedGraph {

    private int numberOfNodes;
    private double cParameter;
    private int diameter;
    private HashMap<Integer, LinkedList<Integer>> adjacent;

    public UndirectedGraph() {
        this.numberOfNodes = 3400;
        this.cParameter = 5.0;
        this.diameter = 0;
        this.adjacent = new HashMap<Integer, LinkedList<Integer>>();

        //Build graph adjacency list
        for (int i = 0; i < numberOfNodes; ++i) {
            adjacent.put(i, new LinkedList<Integer>());
        }
        for (int i = 0; i < numberOfNodes; ++i) {
            for (int j = i + 1; j < numberOfNodes; ++j) {
                if (Math.random() < cParameter / (numberOfNodes - 1)) {
                    //Add undirected edge
                    adjacent.get(i).add(j);
                    adjacent.get(j).add(i);
                }
            }
        }
    }

    /**
     *
     * @param start
     * @param numberOfNodes
     * @param adjacent
     * @return longestShortestDistance
     */
    private static int searchBreadthFirst(int start, int numberOfNodes, HashMap<Integer, LinkedList<Integer>> adjacent) {

        Node[] node = new Node[numberOfNodes];
        for (int i = 0; i < numberOfNodes; ++i) {
            node[i] = new Node();
        }
        node[start].color = Node.GRAY;
        node[start].distance = 0;
        Queue<Integer> queue = new LinkedList<Integer>();
        queue.add(start);
        while (queue.peek() != null) {
            int u = queue.remove();
            for (int i = 0; i < adjacent.get(u).size(); ++i) {
                int v = adjacent.get(u).get(i);
                if (Node.WHITE.equals(node[v].color)) {
                    node[v].color = Node.GRAY;
                    node[v].distance = node[u].distance + 1;
                    node[v].predecessor = u;
                    queue.add(v);
                }
                node[u].color = Node.BLACK;
            }
        }

        //Find the longest shortest-distance for this starting point.
        int longest = 0;
        for (int i = 0; i < numberOfNodes; ++i) {
            longest = Math.max(longest, node[i].distance);
        }

        return longest;
    }

    /**
     *
     * @return diameter
     */
    public int getDiameter() {
        //Find the longest shortest-distance of every start point. The max is the diameter.
        for (int i = 0; i < numberOfNodes; ++i) {
            diameter = Math.max(diameter, searchBreadthFirst(i, numberOfNodes, adjacent));
        }
        return diameter;
    }
}
