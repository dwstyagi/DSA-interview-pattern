# DSA Patterns — LeetCode Practice in Ruby

A structured collection of **300+ LeetCode solutions** organized by algorithm pattern, implemented in **Ruby**. Each pattern comes with a concept guide, a recognition cheat sheet, and problems sorted by difficulty (Easy / Medium / Hard).

---

## Why Pattern-First?

Most interview prep focuses on memorizing solutions. This repo focuses on **recognizing which pattern to apply** — so you can solve problems you've never seen before.

> Learn 21 patterns → solve thousands of problems.

---

## Patterns Index

| # | Pattern | Easy | Medium | Hard | Guide |
|---|---------|:----:|:------:|:----:|-------|
| 00 | [Strings](./00.Strings/) | 8 | 12 | 4 | [strings.md](./00.Strings/strings.md) |
| 01 | [Sliding Window](./01.Sliding-Window/) | 3 | 10 | 4 | [sliding_window.md](./01.Sliding-Window/sliding_window.md) |
| 02 | [Two Pointers](./02.Two-Pointers/) | 6 | 9 | 2 | [two_pointers.md](./02.Two-Pointers/two_pointers.md) |
| 03 | [Fast & Slow Pointers](./03.Fast-Slow/) | 4 | 9 | 3 | [fast_slow.md](./03.Fast-Slow/fast_slow.md) |
| 04 | [Merge Intervals](./04.%20Merge-Intervals/) | 3 | 10 | 3 | [merge_interval.md](./04.%20Merge-Intervals/merge_interval.md) |
| 05 | [Cyclic Sort](./05.Cyclic-sort/) | 3 | 7 | 3 | [cyclic_sort.md](./05.Cyclic-sort/cyclic_sort.md) |
| 06 | [Heap / Priority Queue](./06.Heap/) | 3 | 10 | 4 | [heap.md](./06.Heap/heap.md) |
| 07 | [Prefix Sum](./07.Prefix-Sum/) | 3 | 11 | 3 | [prefix_sum.md](./07.Prefix-Sum/prefix_sum.md) |
| 08 | [Bit Manipulation](./08.Bit-Manipulation/) | 6 | 10 | 2 | [bit_manipulation.md](./08.Bit-Manipulation/bit_manipulation.md) |
| 09 | [Binary Search](./09.Binary-Search/) | 5 | 8 | 3 | [binary_search.md](./09.Binary-Search/binary_search.md) |
| 10 | [Binary Search on Answer](./10.Binary-Search-On-Answer/) | 3 | 9 | 4 | [binary_search_on_answer.md](./10.Binary-Search-On-Answer/binary_search_on_answer.md) |
| 11 | [BFS](./11-BFS/) | 5 | 11 | 3 | [bfs.md](./11-BFS/bfs.md) |
| 12 | [DFS](./12.DFS/) | 6 | 15 | 3 | [dfs.md](./12.DFS/dfs.md) |
| 13 | [Backtracking](./13.Backtracking/) | 3 | 11 | 4 | [backtracking.md](./13.Backtracking/backtracking.md) |
| 14 | [Greedy](./14.Greedy/) | 4 | 13 | 3 | [greedy.md](./14.Greedy/greedy.md) |
| 15 | [Union Find](./15.Union-Find/) | 3 | 10 | 4 | [union_find.md](./15.Union-Find/union_find.md) |
| 16 | [Stack](./16.Stack/) | 6 | 10 | 4 | [stack.md](./16.Stack/stack.md) |
| 17 | [Monotonic Stack](./17.Monotonic-Stack/) | 3 | 10 | 4 | [monotonic_stack.md](./17.Monotonic-Stack/monotonic_stack.md) |
| 18 | [Trie](./18.Trie/) | 2 | 10 | 5 | [trie.md](./18.Trie/trie.md) |
| 19 | [Dynamic Programming](./19.Dynamic/) | 5 | 14 | 5 | [dynamic.md](./19.Dynamic/dynamic.md) |
| 20 | [Graph](./20.Graph/) | 3 | 12 | 5 | [graph.md](./20.Graph/graph.md) |

**Total: ~310 problems across 21 patterns**

---

## Repository Structure

```
pattern/
├── 01.Sliding-Window/
│   ├── sliding_window.md     ← pattern guide (when to use, templates, tips)
│   ├── 1.Easy/
│   │   └── 643_maximum_average_subarray_i.rb
│   ├── 2.Medium/
│   │   └── 3_longest_substring_without_repeating.rb
│   └── 3.Hard/
│       └── 76_minimum_window_substring.rb
├── 02.Two-Pointers/
│   └── ...
└── interview_pattern.md      ← interview problem-solving framework
```

Each solution file is named `{leetcode_id}_{problem_slug}.rb` so you can look up the original problem instantly.

---

## Pattern Guides

Every pattern folder contains a `*.md` guide covering:

- **When to recognize it** — the signal words and problem shapes that scream this pattern
- **Two or more variants** — e.g. fixed vs. dynamic sliding window
- **Ruby template** — copy-paste starting point with comments
- **Complexity** — time and space for each variant
- **Common mistakes** — off-by-one, shrink condition, etc.

---

## Interview Framework

[`interview_pattern.md`](./interview_pattern.md) is a step-by-step guide for approaching any problem in a live interview:

1. Understand the problem
2. Ask clarifying questions
3. Brute force first
4. Identify the bottleneck
5. Optimize with a pattern
6. Code clean
7. Dry run
8. Complexity analysis
9. Handle edge cases

---

## How to Use This Repo

**Study mode (new pattern)**
1. Read the pattern guide (`*.md`) in the pattern folder
2. Try 2–3 Easy problems without looking at the solution
3. Move to Medium, then Hard

**Review mode (before an interview)**
1. Skim all 21 pattern guides to refresh recognition signals
2. Re-solve 1 Medium per pattern from memory
3. Review `interview_pattern.md`

**Reference mode (stuck on a problem)**
1. Identify which pattern fits
2. Open the guide → copy the template
3. Adapt to the problem constraints

---

## Language

All solutions are written in **Ruby**. The patterns and logic are language-agnostic — the concepts transfer directly to Python, Java, Go, or any other language.

---

## Stats

| Difficulty | Count |
|-----------|------:|
| Easy | ~92 |
| Medium | ~200 |
| Hard | ~75 |
| **Total** | **~367** |

---

## Contributing

This is a personal study repo, but PRs are welcome for:
- Bug fixes in existing solutions
- Alternative approaches with different time/space tradeoffs
- Additional test cases

---

*Built for consistent, pattern-driven interview preparation.*
