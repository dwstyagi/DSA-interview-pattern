# Pattern 20 — Graph Algorithms

## Recognize It

Ask yourself:
- Are there **dependencies / ordering** between tasks (topological sort)?
- Do you need the **shortest path with weights** (Dijkstra, Bellman-Ford)?
- Is the input a **graph represented explicitly** (edges, adjacency) or implicitly (grid, state machine)?
- Is connectivity / MST / bridges / SCC the question?

If yes → Graph Algorithms.

---

## Representations

```ruby
# Adjacency list (most common)
graph = Hash.new { |h, k| h[k] = [] }
edges.each { |u, v, w| graph[u] << [v, w]; graph[v] << [u, w] }   # undirected

# Adjacency matrix (dense graphs only)
matrix = Array.new(n) { Array.new(n, Float::INFINITY) }
```

---

## Canonical Algorithms

### 1. Topological Sort — Kahn's (BFS-style)

```ruby
def topo_sort(n, edges)
  graph = Hash.new { |h, k| h[k] = [] }
  indeg = Array.new(n, 0)
  edges.each { |u, v| graph[u] << v; indeg[v] += 1 }

  q = (0...n).select { |i| indeg[i] == 0 }
  order = []

  until q.empty?
    u = q.shift
    order << u
    graph[u].each { |v| indeg[v] -= 1; q << v if indeg[v] == 0 }
  end

  order.length == n ? order : []      # empty means a cycle
end
```

---

### 2. Topological Sort — DFS Post-order

```ruby
def topo_dfs(n, graph)
  state = Array.new(n, 0)   # 0=unseen, 1=in-stack, 2=done
  order = []

  dfs = ->(u) {
    return true if state[u] == 2
    return false if state[u] == 1               # cycle!
    state[u] = 1
    graph[u].each { |v| return false unless dfs.call(v) }
    state[u] = 2
    order << u
    true
  }

  (0...n).each { |u| return nil unless dfs.call(u) }
  order.reverse
end
```

---

### 3. Dijkstra's (non-negative weights)

```ruby
require 'algorithms'
include Containers

def dijkstra(n, graph, source)
  dist = Array.new(n, Float::INFINITY)
  dist[source] = 0
  pq = MinHeap.new                              # [dist, node]
  pq.push([0, source])

  until pq.empty?
    d, u = pq.pop
    next if d > dist[u]                         # stale entry
    graph[u].each do |v, w|
      if d + w < dist[v]
        dist[v] = d + w
        pq.push([dist[v], v])
      end
    end
  end

  dist
end
```

---

### 4. Bellman-Ford (handles negative edges)

```ruby
def bellman_ford(n, edges, source)
  dist = Array.new(n, Float::INFINITY)
  dist[source] = 0

  (n - 1).times do
    edges.each do |u, v, w|
      dist[v] = dist[u] + w if dist[u] + w < dist[v]
    end
  end

  # one more pass → if anything updates, there's a negative cycle
  edges.each do |u, v, w|
    return nil if dist[u] + w < dist[v]
  end

  dist
end
```

---

### 5. Grid / Matrix Traversal

```ruby
# same as BFS/DFS patterns — treat the grid as an implicit graph
# 4-directional:  [[1,0],[-1,0],[0,1],[0,-1]]
# 8-directional adds diagonals
```

---

## Problem List

### Easy

| # | Problem | LC | Algorithm | Track |
|---|---------|-----|-----------|-------|
| 1 | Find the Town Judge | [997](https://leetcode.com/problems/find-the-town-judge/) | Degree count | in - out |
| 2 | Find Center of Star Graph | [1791](https://leetcode.com/problems/find-center-of-star-graph/) | Degree | high-deg node |
| 3 | Flood Fill | [733](https://leetcode.com/problems/flood-fill/) | DFS / BFS on grid | 4-dir spread |

### Medium

| # | Problem | LC | Algorithm | Track |
|---|---------|-----|-----------|-------|
| 4 | Course Schedule | [207](https://leetcode.com/problems/course-schedule/) | Topo sort (cycle) | Kahn's or DFS |
| 5 | Course Schedule II | [210](https://leetcode.com/problems/course-schedule-ii/) | Topo sort (order) | Kahn's |
| 6 | Network Delay Time | [743](https://leetcode.com/problems/network-delay-time/) | Dijkstra | max of min dists |
| 7 | Cheapest Flights Within K Stops | [787](https://leetcode.com/problems/cheapest-flights-within-k-stops/) | Bellman-Ford | K+1 iterations |
| 8 | Path with Minimum Effort | [1631](https://leetcode.com/problems/path-with-minimum-effort/) | Dijkstra on grid | max edge weight |
| 9 | Number of Provinces | [547](https://leetcode.com/problems/number-of-provinces/) | DFS / DSU | components |
| 10 | Reconstruct Itinerary | [332](https://leetcode.com/problems/reconstruct-itinerary/) | Hierholzer's (Eulerian) | lex-smallest |
| 11 | Minimum Height Trees | [310](https://leetcode.com/problems/minimum-height-trees/) | Topo-style trim | leaves inward |
| 12 | Evaluate Division | [399](https://leetcode.com/problems/evaluate-division/) | Graph DFS | ratio multiply |
| 13 | All Paths From Source to Target | [797](https://leetcode.com/problems/all-paths-from-source-to-target/) | DFS enumeration | DAG |
| 14 | Is Graph Bipartite? | [785](https://leetcode.com/problems/is-graph-bipartite/) | BFS / DFS 2-color | color conflict |
| 15 | Redundant Connection | [684](https://leetcode.com/problems/redundant-connection/) | DSU | last cycle edge |
| 16 | Alien Dictionary | [269](https://leetcode.com/problems/alien-dictionary/) | Topo sort on chars | compare pairs |
| 17 | Shortest Path in Binary Matrix | [1091](https://leetcode.com/problems/shortest-path-in-a-binary-matrix/) | BFS on grid | 8-direction |

### Hard

| # | Problem | LC | Algorithm | Track |
|---|---------|-----|-----------|-------|
| 18 | Word Ladder | [127](https://leetcode.com/problems/word-ladder/) | BFS on word graph | wildcard adjacency |
| 19 | Critical Connections in a Network | [1192](https://leetcode.com/problems/critical-connections-in-a-network/) | Tarjan's bridges | disc/low |
| 20 | Min Cost to Make All Islands Connected | [1584](https://leetcode.com/problems/min-cost-to-connect-all-points/) | Kruskal's / Prim's MST | sort edges |

---

## Key Tricks to Remember

**Kahn's vs DFS for topo sort**
```ruby
# Kahn's (BFS):  natural for lexicographic order or level processing
# DFS:           natural when you already need cycle detection (3-color)
# both detect cycles; Kahn's reports cycle if final |order| < n
```

**Dijkstra's "stale entry" guard**
```ruby
# heaps don't support decrease-key cheaply
# pop the minimum, but SKIP if d > dist[u] (it's stale, better already processed)
# this keeps Dijkstra correct despite duplicate entries
```

**0/1 BFS (weights in {0, 1})**
```ruby
# use a DEQUE, not a heap; add-front for weight-0, add-back for weight-1
# gives Dijkstra's correctness at BFS's speed (O(V + E))
```

**Bellman-Ford negative cycle check**
```ruby
# after (n-1) iterations, distances are final for a graph without negative cycles
# one extra iteration: any further relaxation = negative cycle on path to v
```

**MST: Kruskal vs Prim**
```ruby
# Kruskal: sort edges + DSU (sparse graphs, E log E)
# Prim:    heap of candidate edges from grown tree (dense graphs, E log V)
```

**Eulerian path (Reconstruct Itinerary)**
```ruby
# Hierholzer's: DFS, postpone inserting the current node until backtrack
# post-order append, reverse at the end → valid Eulerian circuit/path
```

**"Minimum effort / bottleneck path"**
```ruby
# replace sum with MAX in Dijkstra's relaxation:
#   candidate = max(d, edge_weight)
#   update if candidate < dist[v]
# gives the path whose largest edge is minimized
```

---

## Decision Checklist

```
ordering with dependencies?       → topological sort (Kahn's / DFS)
detect cycle in directed graph?   → topo (fail) or 3-color DFS
shortest path, all positive?      → Dijkstra's (min-heap)
shortest path, negatives allowed? → Bellman-Ford
shortest in unweighted graph?     → BFS
weights 0/1 only?                 → 0/1 BFS with deque
MST (connect all at min cost)?    → Kruskal's (DSU) or Prim's
bridges / articulation points?    → Tarjan's (disc/low)
strongly connected components?    → Kosaraju or Tarjan
bipartite check?                  → BFS / DFS 2-coloring
all-pairs shortest paths (small n)?→ Floyd-Warshall (O(n³))
```

---

## Solved
- [ ] 997 — Find the Town Judge
- [ ] 1791 — Find Center of Star Graph
- [ ] 733 — Flood Fill
- [ ] 207 — Course Schedule
- [ ] 210 — Course Schedule II
- [ ] 743 — Network Delay Time
- [ ] 787 — Cheapest Flights Within K Stops
- [ ] 1631 — Path with Minimum Effort
- [ ] 547 — Number of Provinces
- [ ] 332 — Reconstruct Itinerary
- [ ] 310 — Minimum Height Trees
- [ ] 399 — Evaluate Division
- [ ] 797 — All Paths From Source to Target
- [ ] 785 — Is Graph Bipartite?
- [ ] 684 — Redundant Connection
- [ ] 269 — Alien Dictionary
- [ ] 1091 — Shortest Path in Binary Matrix
- [ ] 127 — Word Ladder
- [ ] 1192 — Critical Connections in a Network
- [ ] 1584 — Min Cost to Connect All Points