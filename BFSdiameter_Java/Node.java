
public class Node{
        //0=white, 1=gray, 2=black
		public int color;
		public int distance;
		public int predecessor;
		
		public Node(){
		this.color = 0;
		this.distance = -1;
		this.predecessor = -1;
	}
}
