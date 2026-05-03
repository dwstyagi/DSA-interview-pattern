# Pattern 02 — Two Pointers

## Recognize It

Ask yourself:

- Is the input **sorted** (or can be sorted)?
- Are you looking for a **pair / triplet / quadruplet** satisfying some condition?
- Do you need to **partition, reverse, or compare** from both ends?
- Can you avoid an O(n²) brute force by moving two pointers in coordinated fashion?

If yes → Two Pointers.

---

## Three Variants

### 1. Opposite Ends (converging)

```
left = 0, right = n - 1
move based on comparison until they meet
```

```ruby
def opposite_ends(arr, target)
  left, right = 0, arr.length - 1

  while left < right
    sum = arr[left] + arr[right]
    return [left, right] if sum == target
    sum < target ? left += 1 : right -= 1
  end

  nil
end
```

---

### 2. Same Direction (fast/slow — not cycle detection)

```
slow tracks the "write" position, fast scans the array
used for in-place array modifications
```

```ruby
def remove_duplicates(arr)
  return arr.length if arr.length < 2

  slow = 1
  (1...arr.length).each do |fast|
    if arr[fast] != arr[fast - 1]
      arr[slow] = arr[fast]
      slow += 1
    end
  end

  slow   # new length
end
```

---

### 3. Two Arrays (parallel traversal)

```
i tracks arr1, j tracks arr2
advance whichever is smaller/based on condition
```

```ruby
def merge_sorted(a, b)
  i, j, result = 0, 0, []

  while i < a.length && j < b.length
    if a[i] <= b[j]
      result << a[i]; i += 1
    else
      result << b[j]; j += 1
    end
  end

  result + a[i..] + b[j..]
end
```

---

## Problem List

### Easy

| #   | Problem                             | LC                                                                       | Variant        | Track          |
| --- | ----------------------------------- | ------------------------------------------------------------------------ | -------------- | -------------- |
| 1   | Two Sum II — Input Array Is Sorted  | [167](https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/)   | Opposite ends  | sum comparison |
| 2   | Valid Palindrome                    | [125](https://leetcode.com/problems/valid-palindrome/)                   | Opposite ends  | char equality  |
| 3   | Reverse String                      | [344](https://leetcode.com/problems/reverse-string/)                     | Opposite ends  | swap           |
| 4   | Remove Duplicates from Sorted Array | [26](https://leetcode.com/problems/remove-duplicates-from-sorted-array/) | Same direction | write pointer  |
| 5   | Move Zeroes                         | [283](https://leetcode.com/problems/move-zeroes/)                        | Same direction | non-zero write |
| 6   | Squares of a Sorted Array           | [977](https://leetcode.com/problems/squares-of-a-sorted-array/)          | Opposite ends  | fill from back |

### Medium

| #   | Problem                   | LC                                                                    | Variant                 | Track           |
| --- | ------------------------- | --------------------------------------------------------------------- | ----------------------- | --------------- |
| 7   | 3Sum                      | [15](https://leetcode.com/problems/3sum/)                             | Fixed + opposite        | skip duplicates |
| 8   | 3Sum Closest              | [16](https://leetcode.com/problems/3sum-closest/)                     | Fixed + opposite        | min diff        |
| 9   | Container With Most Water | [11](https://leetcode.com/problems/container-with-most-water/)        | Opposite ends           | area            |
| 10  | Sort Colors               | [75](https://leetcode.com/problems/sort-colors/)                      | Three pointers          | Dutch flag      |
| 11  | Remove Nth Node From End  | [19](https://leetcode.com/problems/remove-nth-node-from-end-of-list/) | Gap pointers            | linked list     |
| 12  | Valid Palindrome II       | [680](https://leetcode.com/problems/valid-palindrome-ii/)             | Opposite ends           | 1-skip allowed  |
| 13  | Boats to Save People      | [881](https://leetcode.com/problems/boats-to-save-people/)            | Opposite ends           | greedy pairing  |
| 14  | 4Sum                      | [18](https://leetcode.com/problems/4sum/)                             | Double fixed + opposite | skip dupes      |
| 15  | Rotate List               | [61](https://leetcode.com/problems/rotate-list/)                      | Gap pointers            | find new tail   |

### Hard

| #   | Problem                                               | LC                                                                                                 | Variant       | Track         |
| --- | ----------------------------------------------------- | -------------------------------------------------------------------------------------------------- | ------------- | ------------- |
| 15  | Trapping Rain Water                                   | [42](https://leetcode.com/problems/trapping-rain-water/)                                           | Opposite ends | max_l / max_r |
| 16  | Minimum Number of Operations to Make Array Palindrome | [1872 var](https://leetcode.com/problems/minimum-number-of-operations-to-make-array-a-palindrome/) | Opposite ends | merge counts  |

---

## Key Tricks to Remember

**Skipping duplicates in 3Sum / 4Sum**

```ruby
# after finding a valid pair, advance past duplicates
left += 1 while left < right && arr[left] == arr[left + 1]
right -= 1 while left < right && arr[right] == arr[right - 1]
```

**Fill from the back (Squares of Sorted Array)**

```ruby
# negative squares can be larger than positive ones
# pick the larger of |arr[left]| vs |arr[right]| and place at result[write_idx]
```

**Dutch National Flag (Sort Colors)**

```ruby
# low, mid, high = 0, 0, n - 1
# 0 → swap(low, mid), low++, mid++
# 1 → mid++
# 2 → swap(mid, high), high--   (don't advance mid, need to re-check)
```

**Trapping Rain Water**

```ruby
# the side with smaller max determines the water trapped at that position
# move pointer on the smaller side inward
```

---

## Decision Checklist

```
sorted array + pair sum?          → Opposite ends
need triplets/quadruplets?        → Fix one/two, then opposite ends on rest
in-place array mutation?          → Same direction (slow/fast)
max area / min width between ends?→ Opposite ends (greedy shrink)
merging two sorted inputs?        → Parallel two pointers
```

---

## Solved

- [ ] 167 — Two Sum II
- [ ] 125 — Valid Palindrome
- [ ] 344 — Reverse String
- [ ] 26 — Remove Duplicates from Sorted Array
- [ ] 283 — Move Zeroes
- [ ] 977 — Squares of a Sorted Array
- [ ] 15 — 3Sum
- [ ] 16 — 3Sum Closest
- [ ] 11 — Container With Most Water
- [ ] 75 — Sort Colors
- [ ] 19 — Remove Nth Node From End
- [ ] 680 — Valid Palindrome II
- [ ] 881 — Boats to Save People
- [ ] 18 — 4Sum
- [ ] 61 — Rotate List
- [ ] 42 — Trapping Rain Water
- [ ] 1872 — Min Ops to Make Array Palindrome
