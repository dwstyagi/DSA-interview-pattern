# Pattern 11 — BFS (Breadth-First Search)

## Recognize It

Ask yourself:

- Do you need a **shortest path** in an **unweighted** graph or grid?
- Is the problem **level-order** (tree levels, wavefront, time-step simulation)?
- Do you need to find **nearest / minimum-hops** to a target state?
- Is there **multi-source** expansion (rotten oranges, nearest 0)?

If yes → BFS with a queue.

---

## Core Templates

### 1. Level-Order on Tree / Graph

```ruby
def level_order(root)
  return [] unless root
  q = [root]
  result = []

  until q.empty?
    level = []
    q.size.times do
      node = q.shift
      level << node.val
      q << node.left  if node.left
      q << node.right if node.right
    end
    result << level
  end

  result
end
```

---

### 2. Grid BFS (shortest path on grid)

```ruby
def shortest_grid(grid, start, target)
  rows, cols = grid.length, grid[0].length
  dirs = [[-1,0],[1,0],[0,-1],[0,1]]
  q = [[*start, 0]]                    # [r, c, steps]
  seen = { start => true }

  until q.empty?
    r, c, d = q.shift
    return d if [r, c] == target

    dirs.each do |dr, dc|
      nr, nc = r + dr, c + dc
      next if nr < 0 || nr >= rows || nc < 0 || nc >= cols
      next if grid[nr][nc] == 1        # wall
      next if seen[[nr, nc]]
      seen[[nr, nc]] = true
      q << [nr, nc, d + 1]
    end
  end

  -1
end
```

---

### 3. Multi-Source BFS

```
seed the queue with ALL sources at distance 0
standard BFS then expands a wavefront simultaneously
```

```ruby
def multi_source(grid)
  q = []
  grid.each_with_index do |row, r|
    row.each_with_index do |v, c|
      q << [r, c, 0] if v == 2   # all "2"s are sources
    end
  end

  # standard BFS from here...
end
```

---

## Problem List

### Easy

| #   | Problem                           | LC                                                                      | Variant          | Track             |
| --- | --------------------------------- | ----------------------------------------------------------------------- | ---------------- | ----------------- |
| 1   | Binary Tree Level Order Traversal | [102](https://leetcode.com/problems/binary-tree-level-order-traversal/) | Tree levels      | q.size per level  |
| 2   | Average of Levels in Binary Tree  | [637](https://leetcode.com/problems/average-of-levels-in-binary-tree/)  | Tree levels      | sum/count         |
| 3   | Minimum Depth of Binary Tree      | [111](https://leetcode.com/problems/minimum-depth-of-binary-tree/)      | First leaf       | early return      |
| 4   | Binary Tree Right Side View       | [199](https://leetcode.com/problems/binary-tree-right-side-view/)       | Last per level   | last in level     |
| 5   | Set Matrix Zeroes                 | [73](https://leetcode.com/problems/set-matrix-zeroes/)                  | In-place marking | use row/col flags |

### Medium

| #   | Problem                        | LC                                                                             | Variant         | Track              |
| --- | ------------------------------ | ------------------------------------------------------------------------------ | --------------- | ------------------ |
| 5   | Number of Islands              | [200](https://leetcode.com/problems/number-of-islands/)                        | Grid BFS        | flood component    |
| 6   | Rotting Oranges                | [994](https://leetcode.com/problems/rotting-oranges/)                          | Multi-source    | time wavefront     |
| 7   | Walls and Gates                | [286](https://leetcode.com/problems/walls-and-gates/)                          | Multi-source    | gates at 0         |
| 8   | 01 Matrix                      | [542](https://leetcode.com/problems/01-matrix/)                                | Multi-source    | nearest 0          |
| 9   | Shortest Bridge                | [934](https://leetcode.com/problems/shortest-bridge/)                          | DFS + BFS       | paint + expand     |
| 10  | Word Ladder                    | [127](https://leetcode.com/problems/word-ladder/)                              | Graph BFS       | wildcard adj       |
| 11  | Open the Lock                  | [752](https://leetcode.com/problems/open-the-lock/)                            | State BFS       | 8 transitions      |
| 12  | Perfect Squares                | [279](https://leetcode.com/problems/perfect-squares/)                          | BFS on nums     | subtract squares   |
| 13  | Keys and Rooms                 | [841](https://leetcode.com/problems/keys-and-rooms/)                           | Graph BFS       | reachability       |
| 14  | As Far from Land as Possible   | [1162](https://leetcode.com/problems/as-far-from-land-as-possible/)            | Multi-source    | max dist           |
| 15  | Binary Tree Zigzag Level Order | [103](https://leetcode.com/problems/binary-tree-zigzag-level-order-traversal/) | Levels + toggle | reverse odd levels |

### Hard

| #   | Problem                        | LC                                                                      | Variant        | Track             |
| --- | ------------------------------ | ----------------------------------------------------------------------- | -------------- | ----------------- |
| 16  | Word Ladder II                 | [126](https://leetcode.com/problems/word-ladder-ii/)                    | BFS + paths    | parent map        |
| 17  | Shortest Path in Binary Matrix | [1091](https://leetcode.com/problems/shortest-path-in-a-binary-matrix/) | 8-dir grid BFS | diagonals allowed |
| 18  | Sliding Puzzle                 | [773](https://leetcode.com/problems/sliding-puzzle/)                    | State BFS      | serialize board   |

---

## Key Tricks to Remember

**Level counting via `q.size`**

```ruby
# snapshot queue size at the START of each "level" iteration
# iterate exactly that many pops before calling it the next level
until q.empty?
  q.size.times { ... }     # this exact level only
  depth += 1
end
```

**Mark visited when ENQUEUING (not when dequeuing)**

```ruby
# prevents the same cell being queued multiple times via different neighbors
# dequeue-time marking can blow up the queue size O(E) → O(V*E) in the worst case
```

**Multi-source BFS for "nearest X"**

```ruby
# instead of BFS from each cell to the nearest X,
# seed the queue with ALL X cells at distance 0 and expand once
# gives distance-to-nearest-X for every cell in O(V + E)
```

**Word Ladder adjacency trick**

```ruby
# don't compute adj for every pair (O(n² * L))
# for each word, generate its wildcard patterns ("h*t", "ho*", "*ot")
# words sharing a pattern are 1-edit apart
```

**Bidirectional BFS (for very large state spaces)**

```ruby
# expand from both start AND end simultaneously
# meet in the middle → roughly √ the frontier size
# great for Word Ladder style problems
```

---

## Decision Checklist

```
shortest path UNWEIGHTED?     → BFS
weighted with equal weights?  → still BFS
weighted (different weights)? → Dijkstra (use a heap)
tree level-order?             → BFS with q.size level snapshots
nearest X from every cell?    → multi-source BFS
shortest sequence of states?  → BFS on state-space
all shortest paths?           → BFS + parent set (not single parent)
```

---

## Solved

- [ ] 102 — Level Order Traversal
- [ ] 637 — Average of Levels
- [ ] 111 — Min Depth of Binary Tree
- [ ] 199 — Right Side View
- [ ] 73 — Set Matrix Zeroes
- [ ] 200 — Number of Islands
- [ ] 994 — Rotting Oranges
- [ ] 286 — Walls and Gates
- [ ] 542 — 01 Matrix
- [ ] 934 — Shortest Bridge
- [ ] 127 — Word Ladder
- [ ] 752 — Open the Lock
- [ ] 279 — Perfect Squares
- [ ] 841 — Keys and Rooms
- [ ] 1162 — As Far from Land as Possible
- [ ] 103 — Zigzag Level Order
- [ ] 126 — Word Ladder II
- [ ] 1091 — Shortest Path in Binary Matrix
- [ ] 773 — Sliding Puzzle
