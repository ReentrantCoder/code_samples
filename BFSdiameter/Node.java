
public class Node{
		public int color;//0=white, 1=gray, 2=black
		public int dist;
		public int pred;
		
		public Node(){
		this.color = 0;
		this.dist = -1;
		this.pred = -1;
	}
}