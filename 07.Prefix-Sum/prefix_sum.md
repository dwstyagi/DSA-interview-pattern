# Pattern 07 — Prefix Sum

## Recognize It

Ask yourself:
- Do you need **range sums / range XOR / range counts** answered repeatedly?
- Is the problem about **subarrays summing to K** (or divisible by K)?
- Is there a **"balance" / equilibrium** notion (left sum = right sum)?
- Can you replace an O(n) inner loop with an O(1) precomputed lookup?

If yes → Prefix Sum.

---

## Core Template

### 1. Static Range Sum

```
prefix[i] = sum of nums[0..i-1]       (prefix[0] = 0)
range_sum(l, r) = prefix[r + 1] - prefix[l]
```

```ruby
def build_prefix(nums)
  prefix = [0]
  nums.each { |n| prefix << prefix[-1] + n }
  prefix
end

def range_sum(prefix, l, r)
  prefix[r + 1] - prefix[l]
end
```

---

### 2. Subarray Sum Equals K (hash-map of running sums)

```
for each running sum S at index i:
  if (S - k) exists in hash, those are valid subarrays ending at i
store count of each running sum seen so far
```

```ruby
def subarray_sum(nums, k)
  count = 0
  running = 0
  freq = { 0 => 1 }   # prefix sum 0 seen once (empty prefix)

  nums.each do |n|
    running += n
    count += freq[running - k] || 0
    freq[running] = (freq[running] || 0) + 1
  end

  count
end
```

---

### 3. 2D Prefix Sum

```ruby
# prefix[i+1][j+1] = mat[0..i, 0..j] inclusive sum
# sum of rect (r1,c1) to (r2,c2):
#   prefix[r2+1][c2+1] - prefix[r1][c2+1] - prefix[r2+1][c1] + prefix[r1][c1]
```

---

### 4. Difference Array (range updates, single finalize)

```ruby
# diff[l] += v, diff[r + 1] -= v
# final array = prefix sum of diff
def range_updates(n, updates)
  diff = Array.new(n + 1, 0)
  updates.each do |l, r, v|
    diff[l] += v
    diff[r + 1] -= v
  end
  (1...n).each { |i| diff[i] += diff[i - 1] }
  diff[0...n]
end
```

---

## Problem List

### Easy

| # | Problem | LC | Variant | Track |
|---|---------|-----|---------|-------|
| 1 | Running Sum of 1d Array | [1480](https://leetcode.com/problems/running-sum-of-1d-array/) | Basic prefix | cumulative |
| 2 | Find Pivot Index | [724](https://leetcode.com/problems/find-pivot-index/) | Balance | total - left - self |
| 3 | Range Sum Query — Immutable | [303](https://leetcode.com/problems/range-sum-query-immutable/) | Static range | prefix[r+1]-prefix[l] |

### Medium

| # | Problem | LC | Variant | Track |
|---|---------|-----|---------|-------|
| 4 | Subarray Sum Equals K | [560](https://leetcode.com/problems/subarray-sum-equals-k/) | Hash prefix | freq of running |
| 5 | Contiguous Array | [525](https://leetcode.com/problems/contiguous-array/) | Rebalance (0 as -1) | first-seen map |
| 6 | Continuous Subarray Sum | [523](https://leetcode.com/problems/continuous-subarray-sum/) | Prefix mod K | first-seen remainder |
| 7 | Subarray Sums Divisible by K | [974](https://leetcode.com/problems/subarray-sums-divisible-by-k/) | Prefix mod K | count remainders |
| 8 | Range Sum Query 2D — Immutable | [304](https://leetcode.com/problems/range-sum-query-2d-immutable/) | 2D prefix | inclusion-exclusion |
| 9 | Product of Array Except Self | [238](https://leetcode.com/problems/product-of-array-except-self/) | Prefix + suffix | no division |
| 10 | Corporate Flight Bookings | [1109](https://leetcode.com/problems/corporate-flight-bookings/) | Diff array | range update |
| 11 | Maximum Size Subarray Sum Equals K | [325](https://leetcode.com/problems/maximum-size-subarray-sum-equals-k/) | Hash prefix | longest window |
| 12 | Binary Subarrays With Sum | [930](https://leetcode.com/problems/binary-subarrays-with-sum/) | Hash prefix | count |
| 13 | Number of Submatrices That Sum to Target | [1074](https://leetcode.com/problems/number-of-submatrices-that-sum-to-target/) | 2D + hash | compress rows |
| 14 | Minimum Value to Get Positive Prefix Sum | [1413](https://leetcode.com/problems/minimum-value-to-get-positive-step-by-step-sum/) | Running min | start = 1 - min |

### Hard

| # | Problem | LC | Variant | Track |
|---|---------|-----|---------|-------|
| 15 | Maximum Sum of 3 Non-Overlapping Subarrays | [689](https://leetcode.com/problems/maximum-sum-of-3-non-overlapping-subarrays/) | Prefix sums + DP | left/right best |
| 16 | Range Sum Query — Mutable (BIT) | [307](https://leetcode.com/problems/range-sum-query-mutable/) | Fenwick tree | update + query |
| 17 | Count of Range Sum | [327](https://leetcode.com/problems/count-of-range-sum/) | Prefix + merge sort | order stat |

---

## Key Tricks to Remember

**The "prefix[0] = 0" sentinel**
```ruby
# always prepend a 0 so prefix[i..j] = prefix[j+1] - prefix[i] works uniformly
# for hash-map variant: freq[0] = 1 handles subarrays starting from index 0
```

**0 → -1 remapping**
```ruby
# "equal 0s and 1s" problems: treat 0 as -1
# then an equal-0s/1s subarray has sum = 0
# apply standard prefix-sum-equals-K (with K = 0) template
```

**Prefix modulo K**
```ruby
# subarray sum divisible by K iff prefix[j] % K == prefix[i-1] % K
# store counts of each remainder, combinations give the answer
```

**2D inclusion-exclusion**
```ruby
prefix[r+1][c+1] = mat[r][c] + prefix[r][c+1] + prefix[r+1][c] - prefix[r][c]
rect_sum        = prefix[r2+1][c2+1] - prefix[r1][c2+1] - prefix[r2+1][c1] + prefix[r1][c1]
```

**Difference array vs prefix sum**
```ruby
# prefix:  range QUERY in O(1) after O(n) build
# diff:    range UPDATE in O(1), single O(n) finalize at the end
```

---

## Decision Checklist

```
many range-sum queries?        → static prefix array
one-pass subarray-sum-equals-K?→ hash-map of running sums
divisible by K / even parity?  → prefix mod K + frequency map
2D submatrix sums?             → 2D prefix + inclusion-exclusion
range updates, single read?    → difference array
updates + queries mixed?       → Fenwick / Segment tree (beyond prefix)
```

---

## Solved
- [ ] 1480 — Running Sum of 1d Array
- [ ] 724 — Find Pivot Index
- [ ] 303 — Range Sum Query Immutable
- [ ] 560 — Subarray Sum Equals K
- [ ] 525 — Contiguous Array
- [ ] 523 — Continuous Subarray Sum
- [ ] 974 — Subarray Sums Divisible by K
- [ ] 304 — Range Sum Query 2D Immutable
- [ ] 238 — Product of Array Except Self
- [ ] 1109 — Corporate Flight Bookings
- [ ] 325 — Max Size Subarray Sum Equals K
- [ ] 930 — Binary Subarrays With Sum
- [ ] 1074 — Submatrices Sum to Target
- [ ] 1413 — Min Value for Positive Prefix
- [ ] 689 — 3 Non-Overlapping Subarrays
- [ ] 307 — Range Sum Query Mutable
- [ ] 327 — Count of Range Sum