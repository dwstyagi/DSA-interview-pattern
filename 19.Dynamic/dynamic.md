# Pattern 19 — Dynamic Programming (DP)

## Recognize It

Ask yourself:

- Are there **overlapping subproblems** (same sub-question answered many times)?
- Does it have **optimal substructure** (optimal answer = combo of optimal sub-answers)?
- Is it asking for **count / min / max / boolean existence** over choices?
- Does brute force recursion hit exponential blowup?

If yes → DP.

---

## The Four Steps (every DP problem)

```
1. State:      what variables uniquely describe a subproblem?
2. Transition: how does dp[state] relate to smaller states?
3. Base case:  what's dp[trivial state]?
4. Order:      bottom-up iteration direction (or top-down memo)
```

If you can answer all four, coding the solution is mechanical.

---

## DP Categories

### 1. 1D DP (one-dimensional state)

```ruby
# Climbing Stairs: dp[i] = dp[i-1] + dp[i-2]
def climb_stairs(n)
  a, b = 1, 1
  (n - 1).times { a, b = b, a + b }
  b
end

# House Robber: dp[i] = max(dp[i-1], dp[i-2] + nums[i])
def rob(nums)
  prev, curr = 0, 0
  nums.each { |n| prev, curr = curr, [curr, prev + n].max }
  curr
end
```

---

### 2. 2D DP (two-dimensional state — common for strings and grids)

```ruby
# Unique Paths: dp[i][j] = dp[i-1][j] + dp[i][j-1]
def unique_paths(m, n)
  dp = Array.new(m) { Array.new(n, 1) }
  (1...m).each do |i|
    (1...n).each do |j|
      dp[i][j] = dp[i - 1][j] + dp[i][j - 1]
    end
  end
  dp[m - 1][n - 1]
end
```

---

### 3. DP on Subsets / Knapsack

```ruby
# 0/1 Knapsack: dp[i][w] = best value using first i items with capacity w
def knapsack(weights, values, cap)
  n = weights.length
  dp = Array.new(cap + 1, 0)
  (0...n).each do |i|
    cap.downto(weights[i]) do |w|               # reverse to avoid reuse
      dp[w] = [dp[w], dp[w - weights[i]] + values[i]].max
    end
  end
  dp[cap]
end
```

---

### 4. DP on Strings

```ruby
# Longest Common Subsequence
def lcs(a, b)
  m, n = a.length, b.length
  dp = Array.new(m + 1) { Array.new(n + 1, 0) }
  (1..m).each do |i|
    (1..n).each do |j|
      dp[i][j] = a[i - 1] == b[j - 1] \
                 ? dp[i - 1][j - 1] + 1
                 : [dp[i - 1][j], dp[i][j - 1]].max
    end
  end
  dp[m][n]
end
```

---

### 5. Top-Down (memoization)

```ruby
def solve(n, memo = {})
  return memo[n] if memo.key?(n)
  return base_value if n == base_case
  memo[n] = combine(solve(n - 1, memo), solve(n - 2, memo))
end
```

Top-down is often easier to write; bottom-up is often faster and avoids stack overhead.

---

## Problem List

### Easy (1D)

| #   | Problem                  | LC                                                             | Category      | Track                   |
| --- | ------------------------ | -------------------------------------------------------------- | ------------- | ----------------------- |
| 1   | Climbing Stairs          | [70](https://leetcode.com/problems/climbing-stairs/)           | 1D            | dp[i] = dp[i-1]+dp[i-2] |
| 2   | House Robber             | [198](https://leetcode.com/problems/house-robber/)             | 1D            | take vs skip            |
| 3   | Min Cost Climbing Stairs | [746](https://leetcode.com/problems/min-cost-climbing-stairs/) | 1D            | min of two prev         |
| 4   | Fibonacci Number         | [509](https://leetcode.com/problems/fibonacci-number/)         | 1D            | base case               |
| 5   | Is Subsequence           | [392](https://leetcode.com/problems/is-subsequence/)           | 2-ptr (or DP) | advance on match        |

### Medium

| #   | Problem                                       | LC                                                                                  | Category           | Track              |
| --- | --------------------------------------------- | ----------------------------------------------------------------------------------- | ------------------ | ------------------ |
| 6   | House Robber II (circular)                    | [213](https://leetcode.com/problems/house-robber-ii/)                               | 1D twice           | skip first or last |
| 7   | Coin Change                                   | [322](https://leetcode.com/problems/coin-change/)                                   | Unbounded knapsack | min coins          |
| 8   | Coin Change II (count ways)                   | [518](https://leetcode.com/problems/coin-change-ii/)                                | Unbounded knapsack | outer loop on coin |
| 9   | Longest Increasing Subsequence                | [300](https://leetcode.com/problems/longest-increasing-subsequence/)                | 1D (or patience)   | max over j < i     |
| 10  | Partition Equal Subset Sum                    | [416](https://leetcode.com/problems/partition-equal-subset-sum/)                    | Subset sum         | target = sum / 2   |
| 11  | Unique Paths                                  | [62](https://leetcode.com/problems/unique-paths/)                                   | 2D grid            | down + right       |
| 12  | Minimum Path Sum                              | [64](https://leetcode.com/problems/minimum-path-sum/)                               | 2D grid            | min of top/left    |
| 13  | Decode Ways                                   | [91](https://leetcode.com/problems/decode-ways/)                                    | 1D on string       | 1 or 2 chars       |
| 14  | Word Break                                    | [139](https://leetcode.com/problems/word-break/)                                    | 1D on string       | dictionary check   |
| 15  | Target Sum                                    | [494](https://leetcode.com/problems/target-sum/)                                    | Subset DP          | reduce to count    |
| 16  | Longest Common Subsequence                    | [1143](https://leetcode.com/problems/longest-common-subsequence/)                   | 2D string          | match vs not       |
| 17  | Longest Palindromic Subsequence               | [516](https://leetcode.com/problems/longest-palindromic-subsequence/)               | 2D string          | LCS of s, rev(s)   |
| 18  | Maximum Product Subarray                      | [152](https://leetcode.com/problems/maximum-product-subarray/)                      | 1D + track min     | negatives flip     |
| 19  | Best Time to Buy and Sell Stock with Cooldown | [309](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-with-cooldown/) | State machine      | hold/sold/rest     |

### Hard

| #   | Problem                           | LC                                                                       | Category    | Track                 |
| --- | --------------------------------- | ------------------------------------------------------------------------ | ----------- | --------------------- |
| 20  | Edit Distance                     | [72](https://leetcode.com/problems/edit-distance/)                       | 2D string   | insert/delete/replace |
| 21  | Shortest Common Supersequence     | [1092](https://leetcode.com/problems/shortest-common-supersequence/)     | 2D string   | LCS + reconstruct     |
| 22  | Regular Expression Matching       | [10](https://leetcode.com/problems/regular-expression-matching/)         | 2D string   | '\*' = zero or more   |
| 23  | Interleaving String               | [97](https://leetcode.com/problems/interleaving-string/)                 | 2D string   | match from either     |
| 24  | Distinct Subsequences             | [115](https://leetcode.com/problems/distinct-subsequences/)              | 2D string   | match + skip          |
| 25  | Burst Balloons                    | [312](https://leetcode.com/problems/burst-balloons/)                     | Interval DP | last to burst         |
| 26  | Egg Drop With 2 Eggs and N Floors | [1884](https://leetcode.com/problems/egg-drop-with-2-eggs-and-n-floors/) | Interval DP | minimize worst case   |

---

## Key Tricks to Remember

**1D space optimization (rolling variables)**

```ruby
# if dp[i] only depends on dp[i-1] and dp[i-2], you only need 2 variables
# O(n) space → O(1) space — always worth doing for linear DPs
```

**0/1 vs Unbounded Knapsack**

```ruby
# 0/1 (each item once):    iterate CAPACITY in REVERSE
# Unbounded (reuse items): iterate CAPACITY FORWARD
# one-line difference, huge semantic gap
```

**Coin Change: min vs count**

```ruby
# min coins → outer loop amounts, inner loop coins (order doesn't matter)
# count ways → outer loop COINS, inner loop amounts (prevents double-counting permutations)
```

**Interval DP (burst balloons, matrix chain)**

```ruby
# dp[i][j] = best over subarray [i..j]
# iterate by LENGTH, not endpoints directly:
for length in 2..n
  for i in 0..(n - length)
    j = i + length - 1
    # pick a split point k ∈ [i+1, j-1]
```

**State machine for stock problems**

```ruby
# hold[i]   = max profit if holding at end of day i
# sold[i]   = max profit if just sold
# rest[i]   = max profit if resting
# transitions capture buy/sell/cooldown constraints
```

**2D → 1D rolling (LCS, edit distance)**

```ruby
# if dp[i][j] only needs dp[i-1][*] and dp[i][*], use two rows (or one with care)
# be careful with overwrite order when compressing to one row
```

**Top-down when transitions are complex**

```ruby
# memoization + recursion is often clearer for tricky transitions
# downside: recursion depth + hash lookup overhead
# upside: only computes states you actually need
```

---

## Decision Checklist

```
overlapping subproblems?           → DP
single sequence, linear state?     → 1D DP
two sequences / grid?              → 2D DP
pick-or-skip over items?           → knapsack family
string-alignment / edit?           → 2D DP on indices
count vs min/max?                  → same structure, different reducer
interval decisions?                → interval DP (by length)
state has many dimensions (≤ 5)?   → top-down memo, usually
huge state space?                  → look for monotonic / greedy structure
```

---

## Solved

- [ ] 70 — Climbing Stairs
- [ ] 198 — House Robber
- [ ] 746 — Min Cost Climbing Stairs
- [ ] 509 — Fibonacci Number
- [ ] 392 — Is Subsequence
- [ ] 213 — House Robber II
- [ ] 322 — Coin Change
- [ ] 518 — Coin Change II
- [ ] 300 — Longest Increasing Subsequence
- [ ] 416 — Partition Equal Subset Sum
- [ ] 62 — Unique Paths
- [ ] 64 — Minimum Path Sum
- [ ] 91 — Decode Ways
- [ ] 139 — Word Break
- [ ] 494 — Target Sum
- [ ] 1143 — Longest Common Subsequence
- [ ] 516 — Longest Palindromic Subsequence
- [ ] 152 — Max Product Subarray
- [ ] 309 — Buy and Sell Stock with Cooldown
- [ ] 72 — Edit Distance
- [ ] 1092 — Shortest Common Supersequence
- [ ] 10 — Regex Matching
- [ ] 97 — Interleaving String
- [ ] 115 — Distinct Subsequences
- [ ] 312 — Burst Balloons
- [ ] 1884 — Egg Drop With 2 Eggs and N Floors
