
public class Node {
    public static final String
            WHITE = "white",
            GRAY = "gray",
            BLACK = "black";
    public String color;
    public int distance;
    public int predecessor;

    public Node() {
        this.color = WHITE;
        this.distance = -1;
        this.predecessor = -1;
    }
}
