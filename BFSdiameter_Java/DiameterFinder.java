import java.util.HashMap;
import java.util.LinkedList;
import java.util.Queue;

public class DiameterFinder {

    public static int searchBreadthFirst(int start, int numberOfNodes, HashMap<Integer, LinkedList<Integer>> adjacent) {

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

        //Find the longest shortest distance
        int longest = 0;
        for (int i = 0; i < numberOfNodes; ++i) {
            longest = Math.max(longest, node[i].distance);
        }

        return longest;
    }

    public static void main(String[] args) {

        for (int trial = 0; trial < 10; trial++) {
            //Parameters for Erdos-Renyi model
            int numberOfNodes = 3400;
            double cParameter = 5.0;
            int diameter = 0;
            HashMap<Integer, LinkedList<Integer>> adjacent = new HashMap<Integer, LinkedList<Integer>>();

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

            //Next use BFS to find the diameter
            for (int i = 0; i < numberOfNodes; ++i) {
                diameter = Math.max(diameter, searchBreadthFirst(i, numberOfNodes, adjacent));
            }

            //Print the diameter
            System.out.println("The diameter of trial " + trial + " is " + diameter);
        }

    }
}
