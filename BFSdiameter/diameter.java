import java.util.HashMap;
import java.util.LinkedList;
import java.util.Queue;

public class diameter {
	
	public static int BFS(int s, int n, HashMap<Integer, LinkedList<Integer>> adj){
		Node[] node = new Node[n];
		for (int i = 0; i < n; ++i){
			node[i] = new Node();
			/*node[i].color = 0;
			node[i].dist = -1;
			node[i].pred = -1;*/
		}
		node[s].color = 1;
		node[s].dist = 0;
		Queue<Integer> queue = new LinkedList<Integer>();
		queue.add(s);
		while (queue.peek() != null ){
			int u = queue.remove();
			for(int i = 0; i < adj.get(u).size(); ++i ){
				int v = adj.get(u).get(i);
				if (node[v].color == 0){
					node[v].color = 1;
					node[v].dist = node[u].dist + 1;
					node[v].pred = u;
					queue.add(v);
				}
			node[u].color = 2;		
			}
		}
		
		int lon = 0; //Find the longest shortest distance
		for (int i = 0; i < n; ++i){
			lon = Math.max(lon, node[i].dist);
		}
			
		return lon;
	}
	
	public static void main(String[] args){
		for (int r = 0; r < 10; r++){
			//First build the Erdos-Renyi adjacency list
			int n = 3400;
			int c = 5;
			int dia = 0;
			HashMap<Integer, LinkedList<Integer>> adj = new HashMap<Integer, LinkedList<Integer>>();
			for (int i = 0; i < n; ++i) {
	            adj.put(i, new LinkedList<Integer>());
			}
			for (int i = 0; i < n; ++i) {
				for (int j = i+1; j < n; ++j){
					if (Math.random() < ((float)c)/(n-1)){
						adj.get(i).add(j); //add edge if probability
						adj.get(j).add(i); //undirected graph
					}
				}
			}
			//System.out.println(adj);
			
			//Next use BFS to find the diameter
			for (int i = 0; i < n; ++i){
				dia = Math.max(dia, BFS(i, n, adj));
			}
			
			System.out.println(dia); //Print the diameter
		}
	}
}
