# Pattern 10 — Binary Search on Answer

## Recognize It

Ask yourself:
- Is the answer a **number within a known range** [lo, hi]?
- Does a predicate `can_do(x)` have **monotonic behavior** — once true, stays true (or vice versa)?
- Is the problem phrased as **"minimum X such that…"** or **"maximum X such that…"**?
- Does brute force mean trying every integer in [lo, hi] one at a time?

If yes → Binary Search on Answer. You binary-search the *answer space*, not the input array.

---

## The Mental Model

```
define feasible(x): boolean — can we achieve the goal with value x?
the answer space is monotonic:
    f f f f f T T T T T     ← looking for MIN true  → lower-bound
    T T T T T f f f f f     ← looking for MAX true  → upper-bound
binary search on [lo, hi] using feasible() as the predicate.
```

---

## Core Template

### Minimum Feasible Value

```ruby
def min_feasible(lo, hi)
  while lo < hi
    m = (lo + hi) / 2
    feasible?(m) ? hi = m : lo = m + 1
  end
  lo
end
```

### Maximum Feasible Value

```ruby
def max_feasible(lo, hi)
  while lo < hi
    m = (lo + hi + 1) / 2      # bias UP to avoid infinite loop
    feasible?(m) ? lo = m : hi = m - 1
  end
  lo
end
```

---

## Worked Example — Koko Eating Bananas

```
piles = hours of bananas Koko can eat; h = total hours allowed
find min speed k such that she finishes in <= h hours
```

```ruby
def min_eating_speed(piles, h)
  feasible = ->(k) {
    piles.sum { |p| (p + k - 1) / k } <= h   # ceil div per pile
  }

  lo, hi = 1, piles.max
  while lo < hi
    m = (lo + hi) / 2
    feasible.call(m) ? hi = m : lo = m + 1
  end
  lo
end
```

The pattern is: **pick the answer range** → **define feasibility** → **binary search**.

---

## Problem List

### Easy

| # | Problem | LC | Feasibility | Track |
|---|---------|-----|-------------|-------|
| 1 | Sqrt(x) | [69](https://leetcode.com/problems/sqrtx/) | m² ≤ x | floor sqrt |
| 2 | Arranging Coins | [441](https://leetcode.com/problems/arranging-coins/) | k(k+1)/2 ≤ n | max full rows |
| 3 | Valid Perfect Square | [367](https://leetcode.com/problems/valid-perfect-square/) | m² == n | exact match |

### Medium

| # | Problem | LC | Feasibility | Track |
|---|---------|-----|-------------|-------|
| 4 | Koko Eating Bananas | [875](https://leetcode.com/problems/koko-eating-bananas/) | hours(k) ≤ h | ceil-div sum |
| 5 | Capacity to Ship Packages | [1011](https://leetcode.com/problems/capacity-to-ship-packages-within-d-days/) | days(cap) ≤ D | greedy pack |
| 6 | Split Array Largest Sum | [410](https://leetcode.com/problems/split-array-largest-sum/) | chunks(max) ≤ m | greedy split |
| 7 | Minimum Days to Make M Bouquets | [1482](https://leetcode.com/problems/minimum-number-of-days-to-make-m-bouquets/) | bouquets(day) ≥ m | sweep bloom |
| 8 | Find the Smallest Divisor Given a Threshold | [1283](https://leetcode.com/problems/find-the-smallest-divisor-given-a-threshold/) | sum ceil(a/d) ≤ t | divisor scan |
| 9 | Aggressive Cows | SPOJ | gap ≥ d placeable | greedy place |
| 10 | Allocate Books (min max pages) | GFG | students(max) ≤ m | greedy partition |
| 11 | Magnetic Force Between Two Balls | [1552](https://leetcode.com/problems/magnetic-force-between-two-balls/) | can place m balls ≥ d apart | greedy |
| 12 | Minimum Time to Complete Trips | [2187](https://leetcode.com/problems/minimum-time-to-complete-trips/) | trips(t) ≥ total | sum t/bus |
| 13 | Maximum Candies Allocated to K Children | [2226](https://leetcode.com/problems/maximum-candies-allocated-to-k-children/) | kids(piece) ≥ k | max piece |
| 14 | Find K-th Smallest Pair Distance | [719](https://leetcode.com/problems/find-k-th-smallest-pair-distance/) | pairs ≤ d ≥ k | sort + count |

### Hard

| # | Problem | LC | Feasibility | Track |
|---|---------|-----|-------------|-------|
| 15 | Minimize Max Distance to Gas Station | [774](https://leetcode.com/problems/minimize-max-distance-to-gas-station/) | stations used ≤ k | real-valued BS |
| 16 | Kth Smallest Prime Fraction | [786](https://leetcode.com/problems/k-th-smallest-prime-fraction/) | #pairs ≤ f ≥ k | real-valued BS |
| 17 | Swim in Rising Water | [778](https://leetcode.com/problems/swim-in-rising-water/) | reachable at time t | BFS on threshold |
| 18 | Minimum Time to Repair Cars | [2594](https://leetcode.com/problems/minimum-time-to-repair-cars/) | cars(t) ≥ n | √ per worker |

---

## Key Tricks to Remember

**Picking the answer range**
```ruby
# lo = smallest possibly valid answer (often 1 or min(arr))
# hi = largest possibly valid answer (often sum(arr) or max(arr))
# wrong bounds → off-by-one or infinite loop
```

**Direction of feasibility matters**
```ruby
# "min X such that feasible(X)" → f f f T T T  (shrink hi when true)
# "max X such that feasible(X)" → T T T f f f  (grow lo when true, bias mid UP)
```

**Mid bias for max-feasible**
```ruby
m = (lo + hi + 1) / 2
# prevents infinite loop when lo = hi - 1 and feasible(mid) = true
# otherwise m rounds down, lo stays put, loop spins forever
```

**Feasibility is a simulator**
```ruby
# can_do(k) is usually an O(n) greedy pass:
# - Koko: sum of ceil(pile / k)
# - Ship: simulate packing days
# - Split Array: simulate chunk starts
# total complexity = O(n log(answer_range))
```

**Real-valued binary search**
```ruby
# use a fixed number of iterations (say 60-100)
# instead of while lo < hi, which never terminates with floats
60.times do
  m = (lo + hi) / 2.0
  feasible?(m) ? hi = m : lo = m
end
```

---

## Decision Checklist

```
"minimum / maximum value such that X"    → binary search on answer
feasibility is greedy-checkable in O(n)? → strong signal
answer has a natural [lo, hi] range?     → good candidate
n too big for DP, but monotonic?         → often this pattern
real-valued answer (float)?              → fixed-iteration BS
```

---

## Solved
- [ ] 69 — Sqrt(x)
- [ ] 441 — Arranging Coins
- [ ] 367 — Valid Perfect Square
- [ ] 875 — Koko Eating Bananas
- [ ] 1011 — Capacity to Ship Packages
- [ ] 410 — Split Array Largest Sum
- [ ] 1482 — Min Days to Make M Bouquets
- [ ] 1283 — Smallest Divisor with Threshold
- [ ] SPOJ — Aggressive Cows
- [ ] GFG — Allocate Books
- [ ] 1552 — Magnetic Force Between Two Balls
- [ ] 2187 — Min Time to Complete Trips
- [ ] 2226 — Max Candies Allocated to K Children
- [ ] 719 — Find K-th Smallest Pair Distance
- [ ] 774 — Minimize Max Gas Station Dist
- [ ] 786 — Kth Smallest Prime Fraction
- [ ] 778 — Swim in Rising Water
- [ ] 2594 — Min Time to Repair Cars