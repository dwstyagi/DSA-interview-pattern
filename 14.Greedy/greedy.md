# Pattern 14 — Greedy Algorithms

## Recognize It

Ask yourself:

- Does a **locally optimal choice** at each step lead to a **globally optimal** answer?
- Is there a **natural ordering** (by end-time, ratio, deadline) that simplifies decisions?
- Is the problem tempting as DP but you notice you never revisit earlier decisions?
- Does the problem read like **"maximum / minimum number of …"** with obvious picks?

If yes → try Greedy. **Warning:** always prove it works; many "greedy" attempts fail subtly.

---

## The Greedy Mental Model

```
sort by the right criterion → iterate → make the best local pick
that's it. the whole difficulty is picking the right sort key.
```

---

## Canonical Patterns

### 1. Sort by End-Time (activity selection, non-overlapping)

```ruby
def non_overlapping_count(intervals)
  intervals.sort_by! { |i| i[1] }     # sort by END time
  last_end = -Float::INFINITY
  count = 0

  intervals.each do |s, e|
    if s >= last_end
      count += 1
      last_end = e
    end
  end

  count
end
```

---

### 2. Sort by Ratio (fractional knapsack)

```ruby
def fractional_knapsack(items, capacity)
  items.sort_by! { |w, v| -v.to_f / w }   # highest value/weight first
  total = 0.0
  items.each do |w, v|
    if capacity >= w
      total += v
      capacity -= w
    else
      total += v * (capacity.to_f / w)
      break
    end
  end
  total
end
```

---

### 3. Exchange Argument (canonical greedy proof)

```
Suppose OPT differs from GREEDY at step i.
Show: swapping OPT's choice for GREEDY's is at least as good.
By induction, GREEDY is optimal.
```

This is how you _prove_ a greedy works; memorize the shape, invoke it in interviews.

---

### 4. Frontier / Current-Best Pattern

```ruby
# Jump Game: track furthest reachable index at each step
def can_jump(nums)
  reach = 0
  nums.each_with_index do |v, i|
    return false if i > reach
    reach = [reach, i + v].max
  end
  true
end
```

---

## Problem List

### Easy

| #   | Problem                            | LC                                                                       | Sort Key / Rule         | Track           |
| --- | ---------------------------------- | ------------------------------------------------------------------------ | ----------------------- | --------------- |
| 1   | Assign Cookies                     | [455](https://leetcode.com/problems/assign-cookies/)                     | Sort both asc           | two pointers    |
| 2   | Lemonade Change                    | [860](https://leetcode.com/problems/lemonade-change/)                    | Give largest bill first | count 5/10/20   |
| 3   | Best Time to Buy and Sell Stock II | [122](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-ii/) | Sum positive diffs      | day-to-day gain |
| 4   | Array Partition I                  | [561](https://leetcode.com/problems/array-partition-i/)                  | Sort + pairs            | sum evens       |

### Medium

| #   | Problem                        | LC                                                                               | Sort Key / Rule         | Track                  |
| --- | ------------------------------ | -------------------------------------------------------------------------------- | ----------------------- | ---------------------- |
| 5   | Jump Game                      | [55](https://leetcode.com/problems/jump-game/)                                   | Furthest reach          | frontier               |
| 6   | Jump Game II                   | [45](https://leetcode.com/problems/jump-game-ii/)                                | Current jump bound      | BFS-like layers        |
| 7   | Gas Station                    | [134](https://leetcode.com/problems/gas-station/)                                | Total + reset           | running tank           |
| 8   | Task Scheduler                 | [621](https://leetcode.com/problems/task-scheduler/)                             | Fill most-frequent gaps | max_freq math          |
| 9   | Partition Labels               | [763](https://leetcode.com/problems/partition-labels/)                           | Last-occurrence map     | extend endpoint        |
| 10  | Non-overlapping Intervals      | [435](https://leetcode.com/problems/non-overlapping-intervals/)                  | Sort by END             | activity select        |
| 11  | Minimum Number of Arrows       | [452](https://leetcode.com/problems/minimum-number-of-arrows-to-burst-balloons/) | Sort by END             | group burst            |
| 12  | Queue Reconstruction by Height | [406](https://leetcode.com/problems/queue-reconstruction-by-height/)             | Tall first, by k        | insert at k            |
| 13  | Reorganize String              | [767](https://leetcode.com/problems/reorganize-string/)                          | Max freq ≤ (n+1)/2      | heap fill              |
| 14  | Hand of Straights              | [846](https://leetcode.com/problems/hand-of-straights/)                          | Smallest first          | consume W-run          |
| 15  | Boats to Save People           | [881](https://leetcode.com/problems/boats-to-save-people/)                       | Sort + 2-ptr            | pair heaviest+lightest |
| 16  | Majority Element               | [169](https://leetcode.com/problems/majority-element/)                           | Boyer-Moore voting      | cancel pairs           |
| 17  | Largest Number                 | [179](https://leetcode.com/problems/largest-number/)                             | Custom comparator       | compare a+b vs b+a     |

### Hard

| #   | Problem                           | LC                                                                      | Sort Key / Rule             | Track          |
| --- | --------------------------------- | ----------------------------------------------------------------------- | --------------------------- | -------------- |
| 16  | Candy                             | [135](https://leetcode.com/problems/candy/)                             | Two sweeps                  | L→R then R→L   |
| 17  | Minimum Number of Refueling Stops | [871](https://leetcode.com/problems/minimum-number-of-refueling-stops/) | Max-heap of passed stations | "regret" fills |
| 18  | IPO                               | [502](https://leetcode.com/problems/ipo/)                               | Affordable → max profit     | two heaps      |

---

## Key Tricks to Remember

**Identify the sort key first**

```ruby
# activity selection      → by END time
# min arrows / deadlines  → by END time (or DEADLINE)
# fractional knapsack     → by value/weight RATIO
# meeting rooms           → by START time (then min-heap on ends)
```

**Exchange argument (proof sketch)**

```
Assume there's a better solution B that differs from greedy G at the first choice.
Swap G's choice into B → still valid, not worse.
Repeat until B == G. Contradiction if you claimed B was strictly better.
```

**Frontier / reachability**

```ruby
# Jump Game: at index i, update reach = max(reach, i + nums[i])
# if reach < i at any point → unreachable
# powerful whenever "can we reach X" is the question
```

**Two-sweep pattern (Candy, Trapping Water)**

```ruby
# left→right pass handles one constraint (left neighbor)
# right→left pass handles the other, taking max of both
# global optimum falls out of two simple passes
```

**Heap-assisted greedy**

```ruby
# greedy is just "pick the best of a pool" — a heap IS that pool
# Refueling Stops: keep a max-heap of fuel available from stations passed
# IPO: affordable projects go into max-profit heap; pop K times
```

**Boyer-Moore Voting (Majority Element)**

```ruby
# candidate = nums[0], count = 1
# for each n: count == 0 → new candidate; n == candidate → count++; else count--
# candidate at end is the majority (appears > n/2 times)
# works because majority element "outlives" all opposition
```

**Custom comparator for largest number**

```ruby
# compare strings a, b as: (a + b) <=> (b + a)   (lexicographic)
# e.g. "9" + "34" = "934" > "34" + "9" = "349"  → 9 comes first
nums.map(&:to_s).sort { |a, b| (b + a) <=> (a + b) }.join
```

**When greedy fails → it's DP**

```ruby
# 0/1 knapsack (integer): greedy by ratio FAILS; must use DP
# Longest Increasing Subsequence: pure greedy fails; patience sort + DP works
# always sanity-check with a small counterexample before committing to greedy
```

---

## Decision Checklist

```
pick most/least each step?         → try greedy
activity / meeting selection?      → sort by end, pick earliest end
scheduling with penalties?         → deadline sort + heap
ratio optimization (fractional)?   → sort by ratio
reachability on a line?            → frontier / max-reach
counterexample kills greedy?       → fall back to DP
```

---

## Solved

- [ ] 455 — Assign Cookies
- [ ] 860 — Lemonade Change
- [ ] 122 — Best Time to Buy and Sell Stock II
- [ ] 561 — Array Partition I
- [ ] 55 — Jump Game
- [ ] 45 — Jump Game II
- [ ] 134 — Gas Station
- [ ] 621 — Task Scheduler
- [ ] 763 — Partition Labels
- [ ] 435 — Non-overlapping Intervals
- [ ] 452 — Min Arrows to Burst Balloons
- [ ] 406 — Queue Reconstruction by Height
- [ ] 767 — Reorganize String
- [ ] 846 — Hand of Straights
- [ ] 881 — Boats to Save People
- [ ] 169 — Majority Element
- [ ] 179 — Largest Number
- [ ] 135 — Candy
- [ ] 871 — Min Refueling Stops
- [ ] 502 — IPO
