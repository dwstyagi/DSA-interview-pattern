# Pattern 01 — Sliding Window

## Recognize It

Ask yourself:
- Does the problem involve a **contiguous subarray or substring**?
- Are you looking for **max / min / longest / shortest** satisfying some condition?
- Is there a **fixed size K** or a constraint you must maintain?

If yes → Sliding Window.

---

## Two Variants

### 1. Fixed Window (size K is given)

```
init window with first K elements
slide: add arr[right], remove arr[left], update answer
```

```ruby
def fixed_window(arr, k)
  # build initial window
  window_state = arr[0...k].sum   # or whatever you're tracking

  result = window_state

  (k...arr.length).each do |right|
    left = right - k
    window_state += arr[right]
    window_state -= arr[left]
    result = [result, window_state].max   # or min, etc.
  end

  result
end
```

---

### 2. Variable Window (expand right, shrink left)

```
right pointer grows freely
shrink left when the window violates the constraint
```

```ruby
def variable_window(arr)
  left = 0
  result = 0
  window_state = {}   # hash / counter / sum — depends on problem

  (0...arr.length).each do |right|
    # --- EXPAND: add arr[right] to window ---
    window_state[arr[right]] = (window_state[arr[right]] || 0) + 1

    # --- SHRINK: while window is invalid ---
    while window_invalid?(window_state)
      window_state[arr[left]] -= 1
      window_state.delete(arr[left]) if window_state[arr[left]] == 0
      left += 1
    end

    # --- UPDATE answer ---
    result = [result, right - left + 1].max
  end

  result
end
```

---

## Problem List

### Easy

| # | Problem | LC | Window Type | Track |
|---|---------|-----|-------------|-------|
| 1 | Maximum Average Subarray I | [643](https://leetcode.com/problems/maximum-average-subarray-i/) | Fixed (K) | sum |
| 2 | Contains Duplicate II | [219](https://leetcode.com/problems/contains-duplicate-ii/) | Fixed (K) | hash set |
| 3 | Find the K-Beauty of a Number | [2269](https://leetcode.com/problems/find-the-k-beauty-of-a-number/) | Fixed (K) | string slice |

### Medium

| # | Problem | LC | Window Type | Track |
|---|---------|-----|-------------|-------|
| 4 | Longest Substring Without Repeating Chars | [3](https://leetcode.com/problems/longest-substring-without-repeating-characters/) | Variable | char frequency |
| 5 | Longest Substring with At Most K Distinct Chars | [340](https://leetcode.com/problems/longest-substring-with-at-most-k-distinct-characters/) | Variable | char count hash |
| 6 | Minimum Size Subarray Sum | [209](https://leetcode.com/problems/minimum-size-subarray-sum/) | Variable | running sum |
| 7 | Permutation in String | [567](https://leetcode.com/problems/permutation-in-string/) | Fixed (len s1) | frequency match |
| 8 | Find All Anagrams in a String | [438](https://leetcode.com/problems/find-all-anagrams-in-a-string/) | Fixed (len p) | frequency match |
| 9 | Max Consecutive Ones III | [1004](https://leetcode.com/problems/max-consecutive-ones-iii/) | Variable | zero count |
| 10 | Longest Repeating Character Replacement | [424](https://leetcode.com/problems/longest-repeating-character-replacement/) | Variable | max_freq trick |
| 11 | Subarray Product Less Than K | [713](https://leetcode.com/problems/subarray-product-less-than-k/) | Variable | running product |
| 12 | Number of Subarrays of Size K and Avg ≥ Threshold | [1343](https://leetcode.com/problems/number-of-sub-arrays-of-size-k-and-average-greater-than-or-equal-to-threshold/) | Fixed (K) | sum |
| 13 | Fruit Into Baskets | [904](https://leetcode.com/problems/fruit-into-baskets/) | Variable | at most 2 distinct |

### Hard

| # | Problem | LC | Window Type | Track |
|---|---------|-----|-------------|-------|
| 14 | Minimum Window Substring | [76](https://leetcode.com/problems/minimum-window-substring/) | Variable | need/have counts |
| 15 | Sliding Window Maximum | [239](https://leetcode.com/problems/sliding-window-maximum/) | Fixed (K) | monotonic deque |
| 16 | Substring with Concatenation of All Words | [30](https://leetcode.com/problems/substring-with-concatenation-of-all-words/) | Fixed (word * count) | word frequency |
| 17 | Minimum Number of K Consecutive Bit Flips | [995](https://leetcode.com/problems/minimum-number-of-k-consecutive-bit-flips/) | Fixed (K) | flip queue |

---

## Key Tricks to Remember

**Frequency match (anagram/permutation problems)**
```ruby
# Instead of sorting, compare two frequency hashes
# Slide: add right char, remove left char, check if hashes match
have == need   # O(1) check if you track a "matches" counter
```

**Longest Repeating Character Replacement trick**
```ruby
# window is valid if: (window_size - max_freq) <= k
# you never need to shrink max_freq — only grow it
```

**Monotonic Deque (sliding window max)**
```ruby
# deque stores indices, front = max of current window
# pop from back while arr[back] < arr[right]  (maintain decreasing order)
# pop from front when index is outside window
```

**Counting subarrays**
```ruby
# "number of subarrays satisfying X" often uses:
result += (right - left + 1)   # adds all subarrays ending at right
```

---

## Decision Checklist

```
fixed size K given?          → Fixed window
longest/shortest window?     → Variable window (expand/shrink)
exactly K → hard             → reframe as atMost(K) - atMost(K-1)
max in every window?         → Fixed window + monotonic deque
```

---

## Solved
- [x] 643 — Maximum Average Subarray I
- [x] 219 — Contains Duplicate II
- [x] 3 — Longest Substring Without Repeating Chars
- [x] 209 — Minimum Size Subarray Sum
- [x] 567 — Permutation in String
- [x] 438 — Find All Anagrams
- [x] 1004 — Max Consecutive Ones III
- [x] 424 — Longest Repeating Character Replacement
- [x] 713 — Subarray Product Less Than K
- [x] 904 — Fruit Into Baskets
- [x] 76 — Minimum Window Substring
- [x] 239 — Sliding Window Maximum
