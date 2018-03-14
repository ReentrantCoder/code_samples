public class DiameterFinder {

    public static void main(String[] args) {

        //Make a 10 trials on new graphs to see the distribution of diameters
        for (int trial = 0; trial < 10; trial++) {
            UndirectedGraph graph = new UndirectedGraph();
            System.out.println("The diameter of trial " + trial + " is " + graph.getDiameter());
        }

    }

}
