# Pattern 06 — Top K Elements (Heap / Priority Queue)

## Recognize It

Ask yourself:
- Does the problem ask for the **top K / bottom K / Kth** element?
- Do you need the **K most frequent / closest / largest** items?
- Is it a **streaming** problem (running median, moving window)?
- Is full sort (O(n log n)) wasteful because you only need K items?

If yes → Heap. A size-K heap gives you O(n log K).

---

## Core Template

### 1. Top K Largest → MIN-HEAP of size K

```
push every element; if heap size > K, pop (kicks out the smallest)
heap ends up holding the K largest, root is the Kth largest
```

```ruby
require 'algorithms'   # or roll your own heap
include Containers

def k_largest(nums, k)
  heap = MinHeap.new
  nums.each do |n|
    heap.push(n)
    heap.pop if heap.size > k
  end
  heap.to_a   # the K largest
end

def kth_largest(nums, k)
  heap = MinHeap.new
  nums.each do |n|
    heap.push(n)
    heap.pop if heap.size > k
  end
  heap.min   # root of min-heap = Kth largest
end
```

**Rule of thumb:** top K largest → min-heap; top K smallest → max-heap. The heap's root is what gets kicked out, so it stores "the worst of the best."

---

### 2. K Most Frequent (frequency + heap)

```ruby
def top_k_frequent(nums, k)
  freq = nums.tally
  heap = MinHeap.new { |a, b| a[1] <=> b[1] }   # compare by count
  freq.each do |num, count|
    heap.push([num, count])
    heap.pop if heap.size > k
  end
  heap.to_a.map(&:first)
end
```

---

### 3. Two-Heap Pattern (running median)

```
max-heap holds lower half
min-heap holds upper half
balance so |sizes| <= 1
median = top of bigger heap, or avg of the two tops
```

```ruby
class MedianFinder
  def initialize
    @lo = MaxHeap.new   # lower half
    @hi = MinHeap.new   # upper half
  end

  def add_num(n)
    @lo.push(n)
    @hi.push(@lo.pop)             # funnel largest-of-lower into upper
    @hi.size > @lo.size and @lo.push(@hi.pop)
  end

  def find_median
    @lo.size > @hi.size ? @lo.max.to_f : (@lo.max + @hi.min) / 2.0
  end
end
```

---

## Problem List

### Easy

| # | Problem | LC | Heap Type | Track |
|---|---------|-----|-----------|-------|
| 1 | Last Stone Weight | [1046](https://leetcode.com/problems/last-stone-weight/) | Max-heap | simulate collisions |
| 2 | Kth Largest Element in a Stream | [703](https://leetcode.com/problems/kth-largest-element-in-a-stream/) | Min-heap size K | streaming |
| 3 | Relative Ranks | [506](https://leetcode.com/problems/relative-ranks/) | Max-heap | sort via heap |

### Medium

| # | Problem | LC | Heap Type | Track |
|---|---------|-----|-----------|-------|
| 4 | Kth Largest Element in an Array | [215](https://leetcode.com/problems/kth-largest-element-in-an-array/) | Min-heap size K | root = answer |
| 5 | Top K Frequent Elements | [347](https://leetcode.com/problems/top-k-frequent-elements/) | Min-heap on freq | tally first |
| 6 | K Closest Points to Origin | [973](https://leetcode.com/problems/k-closest-points-to-origin/) | Max-heap size K | sort by dist² |
| 7 | Sort Characters By Frequency | [451](https://leetcode.com/problems/sort-characters-by-frequency/) | Max-heap | tally then drain |
| 8 | Reorganize String | [767](https://leetcode.com/problems/reorganize-string/) | Max-heap on count | alternate picks |
| 9 | Task Scheduler | [621](https://leetcode.com/problems/task-scheduler/) | Max-heap on count | cooldown queue |
| 10 | Find K Closest Elements | [658](https://leetcode.com/problems/find-k-closest-elements/) | Max-heap or binary search | distance ties |
| 11 | Top K Frequent Words | [692](https://leetcode.com/problems/top-k-frequent-words/) | Min-heap custom cmp | freq then lex |
| 12 | K Pairs with Smallest Sums | [373](https://leetcode.com/problems/find-k-pairs-with-smallest-sums/) | Min-heap | index frontier |
| 13 | Kth Smallest in Sorted Matrix | [378](https://leetcode.com/problems/kth-smallest-element-in-a-sorted-matrix/) | Min-heap | push neighbors |

### Hard

| # | Problem | LC | Heap Type | Track |
|---|---------|-----|-----------|-------|
| 14 | Find Median from Data Stream | [295](https://leetcode.com/problems/find-median-from-data-stream/) | Two heaps | balance halves |
| 15 | Sliding Window Median | [480](https://leetcode.com/problems/sliding-window-median/) | Two heaps + lazy delete | remove expired |
| 16 | Maximum Performance of a Team | [1383](https://leetcode.com/problems/maximum-performance-of-a-team/) | Min-heap size K | sort by eff, sum speeds |
| 17 | IPO | [502](https://leetcode.com/problems/ipo/) | Two heaps | capital vs profit |

---

## Key Tricks to Remember

**Size-K heap orientation**
```ruby
# "give me the K LARGEST" → maintain a MIN-heap of size K
#   - root is the smallest-of-the-best, which is the Kth largest
# "give me the K SMALLEST" → maintain a MAX-heap of size K
```

**Ruby doesn't ship with a heap**
```ruby
# options:
# 1. gem install algorithms  → Containers::MinHeap / MaxHeap
# 2. gem install pqueue      → PQueue.new { |a, b| ... }
# 3. roll your own heap with an array + heapify_up / heapify_down
```

**Two-heap balancing invariant**
```ruby
# keep  lo.size == hi.size  OR  lo.size == hi.size + 1
# always push to lo first, funnel top → hi, rebalance if hi got too big
```

**Custom comparator with ties**
```ruby
# Top K Frequent Words: higher freq wins, else lexicographically smaller
heap.push([freq, word]) { |a, b|
  a[0] != b[0] ? a[0] <=> b[0] : b[1] <=> a[1]
}
```

**Lazy deletion in sliding window median**
```ruby
# heaps don't support removal by value in O(log n)
# → keep a "to_delete" hashmap; clean tops only when they're the stale entry
```

---

## Decision Checklist

```
Kth largest / smallest?      → size-K heap (opposite orientation)
K most frequent?             → tally + size-K heap on count
K closest / farthest?        → size-K heap on distance
running / streaming median?  → two heaps, balanced
merge K sorted sources?      → min-heap of (value, source_id, idx)
scheduling with priority?    → max-heap, re-insert with decremented count
```

---

## Solved
- [ ] 1046 — Last Stone Weight
- [ ] 703 — Kth Largest in a Stream
- [ ] 506 — Relative Ranks
- [ ] 215 — Kth Largest in Array
- [ ] 347 — Top K Frequent Elements
- [ ] 973 — K Closest Points to Origin
- [ ] 451 — Sort Characters By Frequency
- [ ] 767 — Reorganize String
- [ ] 621 — Task Scheduler
- [ ] 658 — Find K Closest Elements
- [ ] 692 — Top K Frequent Words
- [ ] 373 — K Pairs with Smallest Sums
- [ ] 378 — Kth Smallest in Sorted Matrix
- [ ] 295 — Find Median from Data Stream
- [ ] 480 — Sliding Window Median
- [ ] 1383 — Maximum Performance of a Team
- [ ] 502 — IPO