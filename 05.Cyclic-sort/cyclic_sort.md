# Pattern 05 — Cyclic Sort

## Recognize It

Ask yourself:
- Is the input an **array of numbers in a fixed range** (1..N or 0..N-1)?
- Does the problem ask for **missing, duplicate, smallest missing positive**?
- Is **O(1) extra space** required (no hash set / no sorting)?
- Can each value be mapped to a **unique target index**?

If yes → Cyclic Sort.

---

## Core Template

### 1. Standard Cyclic Sort (values 1..N → index 0..N-1)

```
walk through array; if arr[i] is not at its correct index, swap it there
advance i only when arr[i] is correctly placed
```

```ruby
def cyclic_sort(nums)
  i = 0
  while i < nums.length
    correct = nums[i] - 1   # for 1..N values
    if nums[i] != nums[correct]
      nums[i], nums[correct] = nums[correct], nums[i]
    else
      i += 1
    end
  end
  nums
end
```

---

### 2. Find Missing / Duplicates After Sorting

```ruby
def find_missing(nums)
  # after cyclic sort, any index i where nums[i] != i + 1 is missing
  cyclic_sort(nums)
  nums.each_with_index { |v, i| return i + 1 if v != i + 1 }
  nums.length + 1
end
```

---

### 3. Handle Out-of-Range Values (First Missing Positive)

```ruby
def first_missing_positive(nums)
  n = nums.length
  i = 0

  while i < n
    correct = nums[i] - 1
    if nums[i] > 0 && nums[i] <= n && nums[i] != nums[correct]
      nums[i], nums[correct] = nums[correct], nums[i]
    else
      i += 1
    end
  end

  (0...n).each { |j| return j + 1 if nums[j] != j + 1 }
  n + 1
end
```

---

## Problem List

### Easy

| # | Problem | LC | Range | Track |
|---|---------|-----|-------|-------|
| 1 | Missing Number | [268](https://leetcode.com/problems/missing-number/) | 0..N | sort then scan |
| 2 | Find All Numbers Disappeared | [448](https://leetcode.com/problems/find-all-numbers-disappeared-in-an-array/) | 1..N | sort then collect |
| 3 | Sort an Array (in range) | GFG | 1..N | cyclic sort |

### Medium

| # | Problem | LC | Range | Track |
|---|---------|-----|-------|-------|
| 4 | Find the Duplicate Number | [287](https://leetcode.com/problems/find-the-duplicate-number/) | 1..N | index mismatch |
| 5 | Find All Duplicates in Array | [442](https://leetcode.com/problems/find-all-duplicates-in-an-array/) | 1..N | mismatch after sort |
| 6 | Set Mismatch | [645](https://leetcode.com/problems/set-mismatch/) | 1..N | duplicate + missing |
| 7 | Find the Corrupt Pair | GFG | 1..N | dup & missing |
| 8 | Find the Smallest Missing Positive Number (in N) | GFG | 1..N | sort then scan |
| 9 | Maximum Swap | [670](https://leetcode.com/problems/maximum-swap/) | 0..9 digits | index mapping |
| 10 | First Missing Integer in Range | GFG | 1..K | bounded sort |

### Hard

| # | Problem | LC | Range | Track |
|---|---------|-----|-------|-------|
| 11 | First Missing Positive | [41](https://leetcode.com/problems/first-missing-positive/) | 1..N | ignore OOR |
| 12 | Couples Holding Hands | [765](https://leetcode.com/problems/couples-holding-hands/) | pair indices | swap by pair |
| 13 | Find All Missing K Numbers | GFG | 1..N | sort then scan |
| 14 | Kth Missing Positive Number | [1539](https://leetcode.com/problems/kth-missing-positive-number/) | sparse | binary search variant |
| 15 | Find K Closest to Ideal Arrangement | GFG | 1..N | swap minimization |

---

## Key Tricks to Remember

**The index mapping**
```ruby
# values 1..N  → correct index is  val - 1
# values 0..N  → correct index is  val
# values a..b  → correct index is  val - a
```

**Swap until placed (don't advance on swap)**
```ruby
# don't do `i += 1` inside the swap branch
# you might have just swapped a new "wrong" value into position i
```

**Skip invalid values**
```ruby
# for First Missing Positive, ignore:
# - non-positive (val <= 0)
# - out of range (val > n)
# - already-correct (nums[i] == nums[correct])  ← prevents infinite loop on duplicates
```

**Why duplicates need the nums[i] != nums[correct] check**
```ruby
# if you check nums[i] != correct + 1 instead, two equal values
# in "correct" positions cause infinite swap. Comparing to nums[correct]
# stops as soon as the target slot already has that value.
```

---

## Decision Checklist

```
values in fixed range 1..N?      → Cyclic Sort
need missing / duplicate?        → Cyclic Sort + scan
first missing POSITIVE integer?  → Cyclic Sort + filter (> 0 and <= n)
O(1) extra space required?       → strong signal for this pattern
index ≠ value after sort?        → that index reveals the answer
```

---

## Solved
- [ ] 268 — Missing Number
- [ ] 448 — Find All Numbers Disappeared
- [ ] GFG — Sort an Array (in range)
- [ ] 287 — Find the Duplicate Number
- [ ] 442 — Find All Duplicates in Array
- [ ] 645 — Set Mismatch
- [ ] GFG — Find the Corrupt Pair
- [ ] GFG — Smallest Missing Positive (in N)
- [ ] 670 — Maximum Swap
- [ ] GFG — First Missing Integer in Range
- [ ] 41 — First Missing Positive
- [ ] 765 — Couples Holding Hands
- [ ] GFG — Find All Missing K Numbers
- [ ] 1539 — Kth Missing Positive Number
- [ ] GFG — Find K Closest to Ideal Arrangement