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

    //TODO: Add a trivial unit test to check if count(adjacent) = numberOfNodes
    public UndirectedGraph() {
        this.numberOfNodes = 3400;
        this.cParameter = 5.0;
        this.diameter = 0;
        this.adjacent = new HashMap<Integer, LinkedList<Integer>>();

        //Build graph adjacency list
        for (int i = 0; i < this.numberOfNodes; ++i) {
            this.adjacent.put(i, new LinkedList<Integer>());
        }
        for (int i = 0; i < this.numberOfNodes; ++i) {
            for (int j = i + 1; j < this.numberOfNodes; ++j) {
                if (Math.random() < this.cParameter / (this.numberOfNodes - 1)) {
                    //Add undirected edge
                    this.adjacent.get(i).add(j);
                    this.adjacent.get(j).add(i);
                }
            }
        }
    }

    /**
     *
     * @param start
     * @return longestShortestDistance
     */
    private int searchBreadthFirst(int start) {

        Node[] node = new Node[this.numberOfNodes];
        for (int i = 0; i < this.numberOfNodes; ++i) {
            node[i] = new Node();
        }
        node[start].color = Node.GRAY;
        node[start].distance = 0;
        Queue<Integer> queue = new LinkedList<Integer>();
        queue.add(start);
        while (queue.peek() != null) {
            int u = queue.remove();
            for (int i = 0; i < this.adjacent.get(u).size(); ++i) {
                int v = this.adjacent.get(u).get(i);
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
        for (int i = 0; i < this.numberOfNodes; ++i) {
            longest = Math.max(longest, node[i].distance);
        }

        return longest;
    }

    /**
     * Calculate the diameter using BFS
     *
     * @return diameter
     */
    public int getDiameter() {
        //Find the longest shortest-distance of every start point. The max is the diameter.
        for (int i = 0; i < this.numberOfNodes; ++i) {
            this.diameter = Math.max(this.diameter, searchBreadthFirst(i));
        }
        return this.diameter;
    }

    /**
     * Getter
     *
     * @return adjacent
     */
    public HashMap<Integer, LinkedList<Integer>> getAdjacent() {
        return this.adjacent;
    }

    /**
     * Getter
     *
     * @return
     */
    public int getNumberOfNodes() {
        return this.numberOfNodes;
    }
}
