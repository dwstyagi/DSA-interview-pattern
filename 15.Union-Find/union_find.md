# Pattern 15 — Union-Find (Disjoint Set Union)

## Recognize It

Ask yourself:
- Do you need to track **connected components** dynamically as edges arrive?
- Is the problem about **"are these two in the same group?"** queries?
- Does it involve **Kruskal's MST**, accounts merge, or cycle detection in an **undirected** graph?
- Are nodes being **linked / grouped / merged** over time?

If yes → Union-Find (DSU).

---

## The Two Operations

```
find(x)   → return the representative (root) of x's set
union(x, y) → merge the sets containing x and y
both near-O(1) amortized with path compression + union by rank/size
```

---

## Core Template (with Path Compression + Union by Rank)

```ruby
class DSU
  def initialize(n)
    @parent = (0...n).to_a
    @rank   = Array.new(n, 0)
    @count  = n                              # number of components
  end

  def find(x)
    @parent[x] = find(@parent[x]) if @parent[x] != x   # path compression
    @parent[x]
  end

  def union(x, y)
    rx, ry = find(x), find(y)
    return false if rx == ry                  # already connected

    if @rank[rx] < @rank[ry]
      @parent[rx] = ry
    elsif @rank[rx] > @rank[ry]
      @parent[ry] = rx
    else
      @parent[ry] = rx
      @rank[rx] += 1
    end

    @count -= 1
    true
  end

  def connected?(x, y) = find(x) == find(y)
  attr_reader :count
end
```

---

## Variant: Union by Size (tracks component sizes)

```ruby
# instead of rank, store size[root] = size of the component
# merge: smaller tree hangs under larger tree; size[new_root] += size[other]
# gives the size of any component in O(α(n))
```

---

## Problem List

### Easy

| # | Problem | LC | Use | Track |
|---|---------|-----|-----|-------|
| 1 | Number of Connected Components | [323](https://leetcode.com/problems/number-of-connected-components-in-an-undirected-graph/) | Component count | DSU.count |
| 2 | Find if Path Exists in Graph | [1971](https://leetcode.com/problems/find-if-path-exists-in-graph/) | Connectivity | connected? |
| 3 | Graph Valid Tree | [261](https://leetcode.com/problems/graph-valid-tree/) | Cycle + connectivity | n-1 edges, no cycle |

### Medium

| # | Problem | LC | Use | Track |
|---|---------|-----|-----|-------|
| 4 | Number of Islands | [200](https://leetcode.com/problems/number-of-islands/) | Grid DSU | flatten r*C+c |
| 5 | Redundant Connection | [684](https://leetcode.com/problems/redundant-connection/) | Cycle detect | last edge that unions failed |
| 6 | Accounts Merge | [721](https://leetcode.com/problems/accounts-merge/) | Union by email | map email → idx |
| 7 | Satisfiability of Equality Equations | [990](https://leetcode.com/problems/satisfiability-of-equality-equations/) | Union ==, check ≠ | two passes |
| 8 | Most Stones Removed with Same Row/Col | [947](https://leetcode.com/problems/most-stones-removed-with-same-row-or-column/) | Union row+col | n - components |
| 9 | Number of Operations to Make Network Connected | [1319](https://leetcode.com/problems/number-of-operations-to-make-network-connected/) | Extra edges vs components | unions - good |
| 10 | Surrounded Regions | [130](https://leetcode.com/problems/surrounded-regions/) | Virtual node | border 'O's united |
| 11 | Smallest String with Swaps | [1202](https://leetcode.com/problems/smallest-string-with-swaps/) | Group + sort | sort chars in group |
| 12 | Number of Provinces | [547](https://leetcode.com/problems/number-of-provinces/) | Component count | matrix → DSU |
| 13 | Evaluate Division | [399](https://leetcode.com/problems/evaluate-division/) | Weighted DSU | ratio to root |

### Hard

| # | Problem | LC | Use | Track |
|---|---------|-----|-----|-------|
| 14 | Number of Islands II | [305](https://leetcode.com/problems/number-of-islands-ii/) | Dynamic adds | add + union neighbors |
| 15 | Swim in Rising Water | [778](https://leetcode.com/problems/swim-in-rising-water/) | DSU by time | Kruskal-like |
| 16 | Making a Large Island | [827](https://leetcode.com/problems/making-a-large-island/) | Size per component | try flipping each 0 |
| 17 | Bricks Falling When Hit | [803](https://leetcode.com/problems/bricks-falling-when-hit/) | Reverse time DSU | connect to top |

---

## Key Tricks to Remember

**Path compression, always**
```ruby
# without compression: find is O(n) worst case
# with compression + union by rank: nearly O(1) amortized
# half-compression (path halving) is also fine and simpler
```

**Use a virtual / sentinel node**
```ruby
# Surrounded Regions: create an imaginary "border" node
# union all border 'O's to it; anything connected to border is safe
# cleaner than multi-step DFS from borders
```

**Map non-integer ids to indices**
```ruby
# Accounts Merge: email → integer id first, then DSU on ids
# Most Stones: treat row_i and col_j as distinct DSU nodes (offset cols)
```

**Weighted DSU (Evaluate Division)**
```ruby
# store weight[x] = ratio from x to parent[x]
# during find, multiply weights as you path-compress
# handles "a/b = 2, b/c = 3 → a/c = ?" queries
```

**Detecting the redundant edge**
```ruby
# for each edge, try union; the first edge whose union FAILS is the cycle edge
# in Redundant Connection, that's the answer
```

**Kruskal's MST (DSU use-case)**
```ruby
# sort edges by weight
# iterate, union if endpoints in different sets, accumulate weight
# stop when n-1 edges added
```

---

## Decision Checklist

```
dynamic connectivity queries?  → DSU
count connected components?    → DSU.count
cycle in UNDIRECTED graph?     → DSU (fail-to-union means cycle)
cycle in DIRECTED graph?       → 3-color DFS, NOT DSU
Kruskal's MST?                 → DSU backbone
grid group counting?           → DSU (flatten) or DFS; both work
rollback needed?               → DSU doesn't support rollback cheaply
```

---

## Solved
- [ ] 323 — Number of Connected Components
- [ ] 1971 — Find if Path Exists in Graph
- [ ] 261 — Graph Valid Tree
- [ ] 200 — Number of Islands (DSU variant)
- [ ] 684 — Redundant Connection
- [ ] 721 — Accounts Merge
- [ ] 990 — Satisfiability of Equality Equations
- [ ] 947 — Most Stones Removed
- [ ] 1319 — Network Connected
- [ ] 130 — Surrounded Regions (DSU variant)
- [ ] 1202 — Smallest String with Swaps
- [ ] 547 — Number of Provinces
- [ ] 399 — Evaluate Division
- [ ] 305 — Number of Islands II
- [ ] 778 — Swim in Rising Water (DSU variant)
- [ ] 827 — Making a Large Island
- [ ] 803 — Bricks Falling When Hit