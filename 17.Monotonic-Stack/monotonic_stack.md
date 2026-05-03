# Pattern 17 — Monotonic Stack

## Recognize It

Ask yourself:
- Do you need the **next / previous greater / smaller** element for each index?
- Is the problem about **"how long / how far until the next X"**?
- Does **trapping water** or **largest rectangle** come to mind?
- Are you looking for the **span** of values?

If yes → Monotonic Stack.

---

## The Mental Model

```
A monotonic stack keeps its elements in a strict order
(increasing or decreasing).
Whenever the new element VIOLATES the order, pop the stack —
each popped element has "found its answer" at that moment.
```

---

## Core Templates

### 1. Next Greater Element (right side)

```
maintain a DECREASING stack of values (or indices).
when current > stack top, pop — current is the "next greater" of the popped.
```

```ruby
def next_greater(nums)
  n = nums.length
  result = Array.new(n, -1)
  stack = []                                 # will hold indices

  nums.each_with_index do |v, i|
    while !stack.empty? && nums[stack[-1]] < v
      result[stack.pop] = v
    end
    stack << i
  end

  result                                     # leftovers in stack have no next greater
end
```

---

### 2. Next Smaller Element (right side)

```ruby
def next_smaller(nums)
  n = nums.length
  result = Array.new(n, -1)
  stack = []

  nums.each_with_index do |v, i|
    while !stack.empty? && nums[stack[-1]] > v
      result[stack.pop] = v
    end
    stack << i
  end

  result
end
```

---

### 3. Largest Rectangle in Histogram

```
for each bar, find the left and right boundaries
where bars are STRICTLY smaller.
monotonic increasing stack — popping gives you those boundaries.
```

```ruby
def largest_rectangle(heights)
  stack = []
  max_area = 0
  heights << 0                               # sentinel to drain stack

  heights.each_with_index do |h, i|
    while !stack.empty? && heights[stack[-1]] > h
      top = stack.pop
      left = stack.empty? ? -1 : stack[-1]
      width = i - left - 1
      max_area = [max_area, heights[top] * width].max
    end
    stack << i
  end

  heights.pop                                # restore input
  max_area
end
```

---

### 4. Trapping Rain Water (monotonic decreasing)

```ruby
def trap(height)
  stack = []
  water = 0

  height.each_with_index do |h, i|
    while !stack.empty? && height[stack[-1]] < h
      bottom = stack.pop
      break if stack.empty?
      left = stack[-1]
      width = i - left - 1
      bounded = [height[left], h].min - height[bottom]
      water += width * bounded
    end
    stack << i
  end

  water
end
```

---

## Problem List

### Easy

| # | Problem | LC | Stack Order | Track |
|---|---------|-----|-------------|-------|
| 1 | Next Greater Element I | [496](https://leetcode.com/problems/next-greater-element-i/) | Decreasing | map lookup |
| 2 | Final Prices With a Special Discount | [1475](https://leetcode.com/problems/final-prices-with-a-special-discount-in-a-shop/) | Increasing | next smaller-or-eq |
| 3 | Remove Outermost Parentheses | [1021](https://leetcode.com/problems/remove-outermost-parentheses/) | Depth counter | primitive groups |

### Medium

| # | Problem | LC | Stack Order | Track |
|---|---------|-----|-------------|-------|
| 4 | Daily Temperatures | [739](https://leetcode.com/problems/daily-temperatures/) | Decreasing | index diff |
| 5 | Next Greater Element II (circular) | [503](https://leetcode.com/problems/next-greater-element-ii/) | Decreasing | iterate 2n, mod n |
| 6 | Online Stock Span | [901](https://leetcode.com/problems/online-stock-span/) | Decreasing | span accumulator |
| 7 | Sum of Subarray Minimums | [907](https://leetcode.com/problems/sum-of-subarray-minimums/) | Increasing | left × right spans |
| 8 | Next Greater Node in Linked List | [1019](https://leetcode.com/problems/next-greater-node-in-linked-list/) | Decreasing | array first |
| 9 | Remove Duplicate Letters | [316](https://leetcode.com/problems/remove-duplicate-letters/) | Lexicographic | last-occurrence |
| 10 | 132 Pattern | [456](https://leetcode.com/problems/132-pattern/) | Decreasing + "k" | right-to-left |
| 11 | Asteroid Collision | [735](https://leetcode.com/problems/asteroid-collision/) | Direction check | sign + magnitude |
| 12 | Remove K Digits | [402](https://leetcode.com/problems/remove-k-digits/) | Increasing | pop while allowed |
| 13 | Car Fleet | [853](https://leetcode.com/problems/car-fleet/) | Sort + stack | times to dest |

### Hard

| # | Problem | LC | Stack Order | Track |
|---|---------|-----|-------------|-------|
| 14 | Largest Rectangle in Histogram | [84](https://leetcode.com/problems/largest-rectangle-in-histogram/) | Increasing | area on pop |
| 15 | Maximal Rectangle | [85](https://leetcode.com/problems/maximal-rectangle/) | Row-wise histogram | reduce to 84 |
| 16 | Trapping Rain Water | [42](https://leetcode.com/problems/trapping-rain-water/) | Decreasing | bounded fill |
| 17 | Sum of Subarray Ranges | [2104](https://leetcode.com/problems/sum-of-subarray-ranges/) | 2× monotonic | max - min contribs |

---

## Key Tricks to Remember

**Store indices, not values**
```ruby
# indices let you compute WIDTH (i - left - 1) on pop
# values alone lose positional info
```

**Pop = "found your answer"**
```ruby
# whenever an element gets popped, it's because the current element
# violated the monotonic order → current is its next-greater/smaller
# do the work at pop-time, not push-time
```

**Sentinel to drain the stack**
```ruby
# append a 0 (or -∞ / +∞) at the end so every element gets popped
# no special-case cleanup loop after the main loop
```

**Circular arrays: iterate twice, index mod n**
```ruby
(0...(2 * n)).each do |i|
  idx = i % n
  # standard mono-stack logic using idx
end
```

**Left × right contribution (subarray min/max sums)**
```ruby
# for each element, count subarrays where it's the minimum:
#   left = distance to previous smaller
#   right = distance to next smaller (strict on one side to avoid double-count)
# total contribution = value * left * right
```

**Strict vs non-strict for duplicates**
```ruby
# Sum of Subarray Minimums:
#   left  uses  "strictly smaller" (>)
#   right uses  "smaller or equal" (>=)
# asymmetric comparison prevents counting duplicates twice
```

---

## Decision Checklist

```
next / prev greater or smaller?     → monotonic stack
"how many days until warmer"?       → monotonic stack
histogram / rectangle area?         → monotonic increasing stack
trapping rain water?                → monotonic decreasing (bounded fill)
lex-smallest / largest with removal?→ monotonic with constraint count
subarray min/max contribution sum?  → mono stack + left-right counts
circular input?                     → iterate 2n, % n
```

---

## Solved
- [ ] 496 — Next Greater Element I
- [ ] 1475 — Final Prices With Special Discount
- [ ] 1021 — Remove Outermost Parentheses
- [ ] 739 — Daily Temperatures
- [ ] 503 — Next Greater Element II
- [ ] 901 — Online Stock Span
- [ ] 907 — Sum of Subarray Minimums
- [ ] 1019 — Next Greater Node in Linked List
- [ ] 316 — Remove Duplicate Letters
- [ ] 456 — 132 Pattern
- [ ] 735 — Asteroid Collision
- [ ] 402 — Remove K Digits
- [ ] 853 — Car Fleet
- [ ] 84 — Largest Rectangle in Histogram
- [ ] 85 — Maximal Rectangle
- [ ] 42 — Trapping Rain Water
- [ ] 2104 — Sum of Subarray Ranges