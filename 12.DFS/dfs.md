# Pattern 12 — DFS (Depth-First Search)

## Recognize It

Ask yourself:

- Do you need to **explore all paths / all subtrees**?
- Is this a **tree** problem (any kind of recursion over nodes)?
- Is it about **connected components** in a graph or grid?
- Do you need to **detect cycles** or do topological ordering?

If yes → DFS (recursion or explicit stack).

---

## Core Templates

### 1. Tree DFS (pre/in/post order)

```ruby
def dfs(node)
  return unless node

  # pre-order:    do stuff before recursion
  dfs(node.left)
  # in-order:     do stuff between children
  dfs(node.right)
  # post-order:   do stuff after both children
end
```

---

### 2. Grid DFS (connected components)

```ruby
def grid_dfs(grid, r, c)
  return if r < 0 || r >= grid.length
  return if c < 0 || c >= grid[0].length
  return if grid[r][c] != '1'          # or visited

  grid[r][c] = '0'                     # mark visited in-place

  grid_dfs(grid, r + 1, c)
  grid_dfs(grid, r - 1, c)
  grid_dfs(grid, r, c + 1)
  grid_dfs(grid, r, c - 1)
end
```

---

### 3. Graph DFS (adjacency list + visited set)

```ruby
def graph_dfs(graph, start)
  visited = {}
  stack   = [start]

  while (node = stack.pop)
    next if visited[node]
    visited[node] = true
    # process node...
    graph[node].each { |nei| stack << nei unless visited[nei] }
  end
end
```

---

### 4. Cycle Detection (directed graph, 3-color DFS)

```
WHITE = unvisited, GRAY = in current path, BLACK = fully explored
gray → gray edge = back edge = cycle
```

```ruby
def has_cycle?(graph)
  color = Hash.new(:white)

  dfs = ->(u) {
    color[u] = :gray
    graph[u].each do |v|
      return true if color[v] == :gray
      return true if color[v] == :white && dfs.call(v)
    end
    color[u] = :black
    false
  }

  graph.keys.any? { |u| color[u] == :white && dfs.call(u) }
end
```

---

## Problem List

### Easy

| #   | Problem                      | LC                                                                 | Variant        | Track            |
| --- | ---------------------------- | ------------------------------------------------------------------ | -------------- | ---------------- |
| 1   | Maximum Depth of Binary Tree | [104](https://leetcode.com/problems/maximum-depth-of-binary-tree/) | Tree DFS       | 1 + max(l,r)     |
| 2   | Same Tree                    | [100](https://leetcode.com/problems/same-tree/)                    | Parallel DFS   | structure + val  |
| 3   | Symmetric Tree               | [101](https://leetcode.com/problems/symmetric-tree/)               | Mirror DFS     | l.l vs r.r       |
| 4   | Path Sum                     | [112](https://leetcode.com/problems/path-sum/)                     | DFS with accum | leaf check       |
| 5   | Invert Binary Tree           | [226](https://leetcode.com/problems/invert-binary-tree/)           | Mutate DFS     | swap children    |
| 6   | Diameter of Binary Tree      | [543](https://leetcode.com/problems/diameter-of-binary-tree/)      | Post-order     | update on return |

### Medium

| #   | Problem                                | LC                                                                                              | Variant            | Track            |
| --- | -------------------------------------- | ----------------------------------------------------------------------------------------------- | ------------------ | ---------------- |
| 7   | Number of Islands                      | [200](https://leetcode.com/problems/number-of-islands/)                                         | Grid DFS           | mark in place    |
| 8   | Max Area of Island                     | [695](https://leetcode.com/problems/max-area-of-island/)                                        | Grid DFS           | area return      |
| 9   | Clone Graph                            | [133](https://leetcode.com/problems/clone-graph/)                                               | Graph DFS + map    | visited = clone  |
| 10  | Path Sum II                            | [113](https://leetcode.com/problems/path-sum-ii/)                                               | DFS + backtrack    | path list        |
| 11  | Binary Tree Paths                      | [257](https://leetcode.com/problems/binary-tree-paths/)                                         | DFS + backtrack    | build string     |
| 12  | Lowest Common Ancestor of a BT         | [236](https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree/)                   | Post-order         | split point      |
| 13  | Surrounded Regions                     | [130](https://leetcode.com/problems/surrounded-regions/)                                        | Border DFS         | mark safe        |
| 14  | Number of Closed Islands               | [1254](https://leetcode.com/problems/number-of-closed-islands/)                                 | Border escape      | eliminate open   |
| 15  | Pacific Atlantic Water Flow            | [417](https://leetcode.com/problems/pacific-atlantic-water-flow/)                               | 2-sided DFS        | reachability AND |
| 16  | Course Schedule                        | [207](https://leetcode.com/problems/course-schedule/)                                           | Cycle detect       | 3-color DFS      |
| 17  | Validate Binary Search Tree            | [98](https://leetcode.com/problems/validate-binary-search-tree/)                                | In-order + bounds  | min/max window   |
| 18  | Construct BT from Preorder and Inorder | [105](https://leetcode.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/) | Pre-order DFS      | index map        |
| 19  | All Nodes Distance K in Binary Tree    | [863](https://leetcode.com/problems/all-nodes-distance-k-in-binary-tree/)                       | Parent map + BFS   | convert to graph |
| 20  | Recover Binary Search Tree             | [99](https://leetcode.com/problems/recover-binary-search-tree/)                                 | In-order + swap    | find two swapped |
| 21  | Linked List Intersection               | [160](https://leetcode.com/problems/intersection-of-two-linked-lists/)                          | Two pointer length | len diff align   |

### Hard

| #   | Problem                               | LC                                                                          | Variant               | Track           |
| --- | ------------------------------------- | --------------------------------------------------------------------------- | --------------------- | --------------- |
| 22  | Binary Tree Maximum Path Sum          | [124](https://leetcode.com/problems/binary-tree-maximum-path-sum/)          | Post-order            | gain vs through |
| 23  | Serialize and Deserialize Binary Tree | [297](https://leetcode.com/problems/serialize-and-deserialize-binary-tree/) | Pre-order + sentinels | null marker     |
| 24  | Critical Connections in a Network     | [1192](https://leetcode.com/problems/critical-connections-in-a-network/)    | Tarjan's bridges      | disc/low        |

---

## Key Tricks to Remember

**Post-order "return up" pattern**

```ruby
# compute something on each subtree, combine at parent
# classic for: diameter, max path sum, height, balanced checks
dfs = ->(node) {
  return 0 unless node
  l = dfs.call(node.left)
  r = dfs.call(node.right)
  @answer = [@answer, l + r].max           # update global
  1 + [l, r].max                            # return contribution upward
}
```

**Mark in-place to save a visited set**

```ruby
# grid problems: overwrite the cell to a sentinel value
# saves O(R*C) space; but don't do this if input must stay immutable
```

**Border / escape DFS**

```ruby
# "which cells can reach the border / can't be surrounded"
# start DFS FROM the border inward, mark reachable cells
# inverts the problem into something simpler
```

**Backtracking = DFS + undo**

```ruby
# append to path, recurse, pop
# when state is passed by value (new strings, frozen args), undo is implicit
```

**3-color DFS for directed cycles**

```ruby
# WHITE → unseen,  GRAY → in current recursion stack,  BLACK → done
# only GRAY-to-GRAY edge signals a cycle; BLACK is safe (subtree already explored)
```

**Iterative DFS when stack overflow is a concern**

```ruby
# use explicit array stack; push neighbors, pop until empty
# trade recursion clarity for stack safety on huge inputs
```

---

## Decision Checklist

```
tree problem?                → DFS, usually recursion
count islands / components?  → grid DFS (flood)
need a path, not just count? → DFS + backtracking
shortest anything?           → probably BFS, not DFS
directed cycle detection?    → 3-color DFS
combine subtree answers?     → post-order DFS
```

---

## Solved

- [ ] 104 — Max Depth of Binary Tree
- [ ] 100 — Same Tree
- [ ] 101 — Symmetric Tree
- [ ] 112 — Path Sum
- [ ] 226 — Invert Binary Tree
- [ ] 543 — Diameter of Binary Tree
- [ ] 200 — Number of Islands
- [ ] 695 — Max Area of Island
- [ ] 133 — Clone Graph
- [ ] 113 — Path Sum II
- [ ] 257 — Binary Tree Paths
- [ ] 236 — LCA of Binary Tree
- [ ] 130 — Surrounded Regions
- [ ] 1254 — Number of Closed Islands
- [ ] 417 — Pacific Atlantic Water Flow
- [ ] 207 — Course Schedule
- [ ] 98 — Validate Binary Search Tree
- [ ] 105 — Construct BT from Preorder and Inorder
- [ ] 863 — All Nodes Distance K in Binary Tree
- [ ] 99 — Recover Binary Search Tree
- [ ] 160 — Intersection of Two Linked Lists
- [ ] 124 — Binary Tree Max Path Sum
- [ ] 297 — Serialize and Deserialize Binary Tree
- [ ] 1192 — Critical Connections in a Network
