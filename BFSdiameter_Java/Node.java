/**
 * The vertices of the graph. They may or maynot be connected by edges.
 */
public class Node {
    public static final String
            WHITE = "white",    //Unvisited
            GRAY = "gray",      //Visited
            BLACK = "black";    //Completely Searched
    public String color;
    public int distance;
    public int predecessor;

    public Node() {
        this.color = WHITE;
        this.distance = -1;
        this.predecessor = -1;
    }
}
