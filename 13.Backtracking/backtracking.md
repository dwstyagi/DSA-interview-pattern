# Pattern 13 — Backtracking

## Recognize It

Ask yourself:
- Are you asked to **generate all** permutations / combinations / subsets?
- Does the problem require **building a solution incrementally** with constraints?
- Does **"is it possible to…"** require exploring choices with undo?
- Is the output **all valid configurations** (N-Queens, Sudoku, partitions)?

If yes → Backtracking. (It's DFS + constraint-checking + undo.)

---

## The Shape of Every Backtracking Solution

```
def backtrack(state, choices):
    if is_solution(state):
        record(state)
        return

    for choice in choices:
        if valid(choice, state):
            apply(choice, state)
            backtrack(state, next_choices(choice))
            undo(choice, state)         # ← the "back" in backtrack
```

---

## Core Templates

### 1. Subsets (include / exclude each element)

```ruby
def subsets(nums)
  result = []

  backtrack = ->(start, path) {
    result << path.dup
    (start...nums.length).each do |i|
      path << nums[i]
      backtrack.call(i + 1, path)
      path.pop
    end
  }

  backtrack.call(0, [])
  result
end
```

---

### 2. Permutations (any order, track used)

```ruby
def permute(nums)
  result = []
  used = Array.new(nums.length, false)

  backtrack = ->(path) {
    return result << path.dup if path.length == nums.length

    nums.each_with_index do |n, i|
      next if used[i]
      used[i] = true
      path << n
      backtrack.call(path)
      path.pop
      used[i] = false
    end
  }

  backtrack.call([])
  result
end
```

---

### 3. Combinations (choose K from N, no order)

```ruby
def combine(n, k)
  result = []

  backtrack = ->(start, path) {
    return result << path.dup if path.length == k

    (start..n).each do |i|
      path << i
      backtrack.call(i + 1, path)     # i + 1 → no reuse
      path.pop
    end
  }

  backtrack.call(1, [])
  result
end
```

---

### 4. Handling Duplicates

```ruby
# sort first, then in the loop:
next if i > start && nums[i] == nums[i - 1]
# skips duplicates at the SAME tree-depth but allows them at different depths
```

---

## Problem List

### Easy

| # | Problem | LC | Variant | Track |
|---|---------|-----|---------|-------|
| 1 | Binary Tree Paths | [257](https://leetcode.com/problems/binary-tree-paths/) | Tree paths | backtrack build |
| 2 | Letter Case Permutation | [784](https://leetcode.com/problems/letter-case-permutation/) | 2-choice per letter | branch on alpha |
| 3 | Generate Parentheses | [22](https://leetcode.com/problems/generate-parentheses/) | Constrained build | open/close counters |

### Medium

| # | Problem | LC | Variant | Track |
|---|---------|-----|---------|-------|
| 4 | Subsets | [78](https://leetcode.com/problems/subsets/) | Subsets | include/exclude |
| 5 | Subsets II (with duplicates) | [90](https://leetcode.com/problems/subsets-ii/) | Subsets + dedupe | sort + skip |
| 6 | Permutations | [46](https://leetcode.com/problems/permutations/) | Permute | used[] |
| 7 | Permutations II | [47](https://leetcode.com/problems/permutations-ii/) | Permute + dedupe | used + skip dup |
| 8 | Combinations | [77](https://leetcode.com/problems/combinations/) | Choose K | start index |
| 9 | Combination Sum | [39](https://leetcode.com/problems/combination-sum/) | Reuse allowed | i (not i+1) |
| 10 | Combination Sum II | [40](https://leetcode.com/problems/combination-sum-ii/) | No reuse + dedupe | sort + skip |
| 11 | Palindrome Partitioning | [131](https://leetcode.com/problems/palindrome-partitioning/) | String split | check palin |
| 12 | Word Search | [79](https://leetcode.com/problems/word-search/) | Grid + path | mark + unmark |
| 13 | Restore IP Addresses | [93](https://leetcode.com/problems/restore-ip-addresses/) | Split into 4 | validity check |
| 14 | Letter Combinations of a Phone Number | [17](https://leetcode.com/problems/letter-combinations-of-a-phone-number/) | Digit branches | mapping |

### Hard

| # | Problem | LC | Variant | Track |
|---|---------|-----|---------|-------|
| 15 | N-Queens | [51](https://leetcode.com/problems/n-queens/) | Board place | col/diag sets |
| 16 | Sudoku Solver | [37](https://leetcode.com/problems/sudoku-solver/) | Fill + undo | row/col/box sets |
| 17 | Word Break II | [140](https://leetcode.com/problems/word-break-ii/) | All segmentations | memo + backtrack |
| 18 | Expression Add Operators | [282](https://leetcode.com/problems/expression-add-operators/) | Insert +,-,* | last-operand trick |

---

## Key Tricks to Remember

**Include/exclude vs. choose-one-per-step**
```ruby
# subsets (size unknown)   → for each index: include or skip  (start index pattern)
# permutations (all items) → at each depth, pick any unused item
# combinations (size K)    → same as subsets, but stop when length == K
```

**Dedupe at the same depth (not globally)**
```ruby
nums.sort!
...
next if i > start && nums[i] == nums[i - 1]
# >start ensures we don't skip on the FIRST use of a value at this depth,
# only on subsequent duplicates which would produce identical subtrees
```

**N-Queens pruning with sets**
```ruby
# columns, positive_diag (r + c), negative_diag (r - c) as sets
# O(1) validity check per placement instead of O(N) scan
```

**Undo in constant time**
```ruby
# array push/pop: O(1)
# set add/remove: O(1)
# grid mark / unmark: O(1)
# DON'T return new collections — you'll blow out memory
```

**Memoization on top of backtracking**
```ruby
# Word Break II, Target Sum style: memo by (index, remaining_state)
# pure backtracking only generates once; memo saves repeated sub-explorations
```

**Early pruning = the real speedup**
```ruby
# sort + early-exit when running sum exceeds target (Combination Sum)
# this is often the difference between TLE and passing
```

---

## Decision Checklist

```
"all combinations / subsets / perms"?   → backtracking
constraint satisfaction (queens, sudoku)→ backtracking with pruning
count configurations?                   → usually DP, not backtracking
shortest / optimal path only?           → BFS or DP, not backtracking
input too large (n > ~20)?              → DP or greedy, not full enumeration
```

---

## Solved
- [ ] 257 — Binary Tree Paths
- [ ] 784 — Letter Case Permutation
- [ ] 22 — Generate Parentheses
- [ ] 78 — Subsets
- [ ] 90 — Subsets II
- [ ] 46 — Permutations
- [ ] 47 — Permutations II
- [ ] 77 — Combinations
- [ ] 39 — Combination Sum
- [ ] 40 — Combination Sum II
- [ ] 131 — Palindrome Partitioning
- [ ] 79 — Word Search
- [ ] 93 — Restore IP Addresses
- [ ] 17 — Letter Combinations of a Phone Number
- [ ] 51 — N-Queens
- [ ] 37 — Sudoku Solver
- [ ] 140 — Word Break II
- [ ] 282 — Expression Add Operators