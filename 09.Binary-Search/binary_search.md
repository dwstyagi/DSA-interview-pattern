# Pattern 09 — Binary Search

## Recognize It

Ask yourself:
- Is the input **sorted** (or rotated-sorted, or has a "sorted property")?
- Can the problem be framed as finding a **boundary** (first/last satisfying)?
- Is there a **monotonic predicate** f(x) that flips from false → true?
- Would linear O(n) TLE, and the input suggests O(log n)?

If yes → Binary Search.

---

## Core Templates (memorize both)

### 1. Classic — Find Exact Target

```ruby
def search(nums, target)
  l, r = 0, nums.length - 1
  while l <= r
    m = (l + r) / 2
    if nums[m] == target
      return m
    elsif nums[m] < target
      l = m + 1
    else
      r = m - 1
    end
  end
  -1
end
```

---

### 2. Lower-Bound (first index where condition becomes true)

```
Half-open [l, r). This is the template to use for "first true" in a
monotonic false…false…true…true space.
```

```ruby
def lower_bound(nums, target)
  l, r = 0, nums.length
  while l < r
    m = (l + r) / 2
    if nums[m] < target
      l = m + 1
    else
      r = m
    end
  end
  l   # first index with nums[l] >= target  (may be nums.length)
end
```

---

### 3. Binary Search on Rotated Array

```ruby
def search_rotated(nums, target)
  l, r = 0, nums.length - 1
  while l <= r
    m = (l + r) / 2
    return m if nums[m] == target

    if nums[l] <= nums[m]                 # left half sorted
      (nums[l] <= target && target < nums[m]) ? r = m - 1 : l = m + 1
    else                                  # right half sorted
      (nums[m] < target && target <= nums[r]) ? l = m + 1 : r = m - 1
    end
  end
  -1
end
```

---

## Problem List

### Easy

| # | Problem | LC | Variant | Track |
|---|---------|-----|---------|-------|
| 1 | Binary Search | [704](https://leetcode.com/problems/binary-search/) | Classic | exact match |
| 2 | Search Insert Position | [35](https://leetcode.com/problems/search-insert-position/) | Lower-bound | insert index |
| 3 | First Bad Version | [278](https://leetcode.com/problems/first-bad-version/) | Lower-bound | API predicate |
| 4 | Sqrt(x) | [69](https://leetcode.com/problems/sqrtx/) | Upper-bound on x² | floor sqrt |
| 5 | Valid Perfect Square | [367](https://leetcode.com/problems/valid-perfect-square/) | Classic on m² | direct check |

### Medium

| # | Problem | LC | Variant | Track |
|---|---------|-----|---------|-------|
| 6 | Search in Rotated Sorted Array | [33](https://leetcode.com/problems/search-in-rotated-sorted-array/) | Rotated | half-sorted test |
| 7 | Find First and Last Position | [34](https://leetcode.com/problems/find-first-and-last-position-of-element-in-sorted-array/) | Two lower-bounds | lb(t), lb(t+1)-1 |
| 8 | Find Minimum in Rotated Sorted Array | [153](https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/) | Rotated | compare with right |
| 9 | Find Peak Element | [162](https://leetcode.com/problems/find-peak-element/) | Local max | m vs m+1 |
| 10 | Search a 2D Matrix | [74](https://leetcode.com/problems/search-a-2d-matrix/) | 1D view of matrix | flat index |
| 11 | Find Smallest Letter Greater Than Target | [744](https://leetcode.com/problems/find-smallest-letter-greater-than-target/) | Upper-bound | wrap on end |
| 12 | Single Element in Sorted Array | [540](https://leetcode.com/problems/single-element-in-a-sorted-array/) | Even-pair check | m ^ 1 pair |
| 13 | Find Right Interval | [436](https://leetcode.com/problems/find-right-interval/) | Sort + lower-bound | search on starts |

### Hard

| # | Problem | LC | Variant | Track |
|---|---------|-----|---------|-------|
| 14 | Median of Two Sorted Arrays | [4](https://leetcode.com/problems/median-of-two-sorted-arrays/) | Partition search | left vs right halves |
| 15 | Find in Mountain Array | [1095](https://leetcode.com/problems/find-in-mountain-array/) | Peak + 2x BS | ascending / descending |
| 16 | Count of Smaller Numbers After Self | [315](https://leetcode.com/problems/count-of-smaller-numbers-after-self/) | BIT / merge sort | order stat |

---

## Key Tricks to Remember

**Avoid overflow in midpoint**
```ruby
# in languages with fixed-size ints:
m = l + (r - l) / 2      # instead of (l + r) / 2
# Ruby's integers are arbitrary precision, but this is still a good habit
```

**Pick the right template**
```ruby
# exact match only          → [l, r] inclusive, while l <= r
# first-true / lower-bound  → [l, r) half-open, while l < r
# mixing templates is the #1 source of binary-search bugs
```

**"Left half sorted" test for rotated arrays**
```ruby
# in a rotated sorted array, at least one half around m is sorted
# nums[l] <= nums[m]  → left half is sorted; check if target in [nums[l], nums[m])
# else               → right half is sorted; check the mirror condition
```

**First and Last Position**
```ruby
first = lower_bound(nums, target)         # nums[first] >= target
last  = lower_bound(nums, target + 1) - 1 # last index of target
# guard with  first < n && nums[first] == target
```

**Peak finding (not sorted, still O(log n))**
```ruby
# nums[m] < nums[m+1] → peak lies to the right;  l = m + 1
# else                → peak lies at m or to the left;  r = m
```

---

## Decision Checklist

```
sorted array + target?        → classic binary search
first/last occurrence?        → two lower-bound calls
insertion point?              → lower-bound directly
rotated sorted array?         → half-sorted test variant
unsorted but monotonic pred?  → binary search on answer (pattern 10)
matrix with sorted rows/cols? → flat-index BS or row-then-col
```

---

## Solved
- [ ] 704 — Binary Search
- [ ] 35 — Search Insert Position
- [ ] 278 — First Bad Version
- [ ] 69 — Sqrt(x)
- [ ] 367 — Valid Perfect Square
- [ ] 33 — Search in Rotated Sorted Array
- [ ] 34 — Find First and Last Position
- [ ] 153 — Find Min in Rotated Sorted Array
- [ ] 162 — Find Peak Element
- [ ] 74 — Search a 2D Matrix
- [ ] 744 — Smallest Letter Greater Than Target
- [ ] 540 — Single Element in Sorted Array
- [ ] 436 — Find Right Interval
- [ ] 4 — Median of Two Sorted Arrays
- [ ] 1095 — Find in Mountain Array
- [ ] 315 — Count of Smaller Numbers After Self