import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Created by tylerbehm on 3/18/18.
 */
class UndirectedGraphTest {
    @Test
    void getAdjacent() {
        UndirectedGraph graph = new UndirectedGraph();
        assertTrue(graph.getAdjacent().size() == graph.getNumberOfNodes());
    }

    @Test
    void getDiameter() {
        UndirectedGraph graph = new UndirectedGraph();
        assertTrue(graph.getDiameter() >= 0);
    }
}