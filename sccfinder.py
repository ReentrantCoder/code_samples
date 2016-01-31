###Code for problem 7
from collections import defaultdict

### Read data. Return graph and reverse graph
### Graph is a dict of sets where key is u and vaules are v's in edges (u,v)
def read_file(fname):
    graph, rgraph, vertices = defaultdict(set), defaultdict(set), set() 
    with open(fname) as file:
        for edge in file:
            u, v = edge.split()
            u, v = int(u), int(v)
            vertices.add(u)
            vertices.add(v)
            if not graph.has_key(u):
                graph[u] = set()                
            graph[u].add(v)
            if not rgraph.has_key(v):
                rgraph[v] = set()
            rgraph[v].add(u)       
    return graph, rgraph
   
### Explore all vertices reachable from start
### Return cumulative visited nodes so far and number of edges in run  
def explore(graph, start, visited):
    stack, edge_count, this_run = [start], 0, set()
    while stack:
        node = stack.pop()
        if node not in visited and node not in this_run:
            this_run.add(node)
            next = graph[node] - visited
            edge_count += len(next)
            stack.extend(next - this_run) 
    visited |= this_run                               
    return visited, edge_count
    
### Depth first search the graph 
### Return a list of nodes ordered by descending postvisit time  
### http://rgrig.blogspot.com/2014/07/depth-first-search-in-python.html 
def dfs(g):
    seen, done, post = {}, {}, []
    time = 0
    def previsit(x, time):
        time += 1
        seen[x] = time
        return time
    def postvisit(x, time, post):
        time += 1
        done[x] = time
        post.append(x)
        return time, post
    for x, ys in g.items():
        if x in done:
            continue
        time = previsit(x, time)
        stack = [(x, ys.__iter__())]
        while stack:
            y, i = stack.pop()
            try:
                z = next(i)
                stack.append((y, i))
                if z in done:
                    continue
                if z in seen:
                    continue
                previsit(z, time)
                stack.append((z, g[z].__iter__()))
            except StopIteration:
                time, post = postvisit(y, time, post)
    return post 
          
    
if __name__ == "__main__":
    
    graph, rgraph = read_file("soc-Slashdot0811.txt")
    max_nodes, max_edges = -1, -1
    visited = set()
    postvisit = dfs(rgraph)
    while postvisit:
        old_visited_count = len(visited)
        visited, edge_count = explore(graph, postvisit.pop(), visited)
        scc_nodes = len(visited) - old_visited_count
        if scc_nodes > max_nodes:
            max_nodes = scc_nodes
            max_edges = edge_count
        postvisit = [x for x in postvisit if x not in visited]
    print "The number of nodes in the largest SCC is " + str(max_nodes)
    print "The number of edges in the largest SCC is " + str(max_edges)
