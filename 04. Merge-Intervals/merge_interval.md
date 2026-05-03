# Pattern 04 — Merge Intervals

## Recognize It

Ask yourself:

- Does the input consist of **intervals / ranges** (start, end)?
- Do you need to **merge, insert, or detect overlaps** between intervals?
- Is it about **scheduling, meeting rooms, or resource allocation**?
- Does the answer depend on how intervals **overlap or don't**?

If yes → Merge Intervals.

---

## Core Template

### 1. Merge Overlapping Intervals

```
sort by start
iterate: if current.start <= last.end → merge (extend last.end)
         else → push current as new
```

```ruby
def merge(intervals)
  return intervals if intervals.empty?

  intervals.sort_by! { |i| i[0] }
  result = [intervals[0]]

  intervals[1..].each do |curr|
    last = result[-1]
    if curr[0] <= last[1]
      last[1] = [last[1], curr[1]].max
    else
      result << curr
    end
  end

  result
end
```

---

### 2. Insert Interval (input sorted, not overlapping)

```ruby
def insert(intervals, new_i)
  result = []
  i, n = 0, intervals.length

  # before overlap
  result << intervals[i] while i < n && intervals[i][1] < new_i[0] && (i += 1)

  # overlap — merge
  while i < n && intervals[i][0] <= new_i[1]
    new_i[0] = [new_i[0], intervals[i][0]].min
    new_i[1] = [new_i[1], intervals[i][1]].max
    i += 1
  end
  result << new_i

  # after overlap
  result.concat(intervals[i..])
  result
end
```

---

### 3. Meeting Rooms II (min rooms = max concurrent meetings)

```ruby
def min_meeting_rooms(intervals)
  starts = intervals.map { |i| i[0] }.sort
  ends   = intervals.map { |i| i[1] }.sort

  rooms = max_rooms = 0
  s = e = 0

  while s < starts.length
    if starts[s] < ends[e]
      rooms += 1
      max_rooms = [max_rooms, rooms].max
      s += 1
    else
      rooms -= 1
      e += 1
    end
  end

  max_rooms
end
```

---

## Problem List

### Easy

| #   | Problem        | LC                                                   | Variant       | Track              |
| --- | -------------- | ---------------------------------------------------- | ------------- | ------------------ |
| 1   | Meeting Rooms  | [252](https://leetcode.com/problems/meeting-rooms/)  | Overlap check | any overlap?       |
| 2   | Summary Ranges | [228](https://leetcode.com/problems/summary-ranges/) | Group consec  | start/end build    |
| 3   | Missing Ranges | [163](https://leetcode.com/problems/missing-ranges/) | Gap detection | lower/upper bounds |

### Medium

| #   | Problem                      | LC                                                                               | Variant        | Track                  |
| --- | ---------------------------- | -------------------------------------------------------------------------------- | -------------- | ---------------------- |
| 4   | Merge Intervals              | [56](https://leetcode.com/problems/merge-intervals/)                             | Merge          | sort + sweep           |
| 5   | Insert Interval              | [57](https://leetcode.com/problems/insert-interval/)                             | Insert         | 3-phase                |
| 6   | Non-overlapping Intervals    | [435](https://leetcode.com/problems/non-overlapping-intervals/)                  | Greedy remove  | sort by end            |
| 7   | Min Arrows to Burst Balloons | [452](https://leetcode.com/problems/minimum-number-of-arrows-to-burst-balloons/) | Greedy groups  | sort by end            |
| 8   | Meeting Rooms II             | [253](https://leetcode.com/problems/meeting-rooms-ii/)                           | Max concurrent | heap or 2ptr           |
| 9   | Car Pooling                  | [1094](https://leetcode.com/problems/car-pooling/)                               | Sweep line     | delta per stop         |
| 10  | Interval List Intersections  | [986](https://leetcode.com/problems/interval-list-intersections/)                | Two-list sweep | max(starts), min(ends) |
| 11  | My Calendar I                | [729](https://leetcode.com/problems/my-calendar-i/)                              | Dynamic insert | treeset/array          |
| 12  | My Calendar II               | [731](https://leetcode.com/problems/my-calendar-ii/)                             | Double-booking | overlap list           |
| 13  | Minimum Number of Platforms  | GFG                                                                              | Max concurrent | sweep line             |

### Hard

| #   | Problem                           | LC                                                                      | Variant       | Track          |
| --- | --------------------------------- | ----------------------------------------------------------------------- | ------------- | -------------- |
| 14  | Employee Free Time                | [759](https://leetcode.com/problems/employee-free-time/)                | Merge + gaps  | flatten + sort |
| 15  | Data Stream as Disjoint Intervals | [352](https://leetcode.com/problems/data-stream-as-disjoint-intervals/) | Dynamic merge | treemap        |
| 16  | Meeting Rooms III                 | [2402](https://leetcode.com/problems/meeting-rooms-iii/)                | Simulate      | two heaps      |

---

## Key Tricks to Remember

**Overlap condition**

```ruby
# two intervals [a, b] and [c, d] overlap iff:
a <= d && c <= b
# or equivalently: max(a, c) <= min(b, d)
```

**Sort-key matters**

```ruby
# merge problems         → sort by start
# greedy remove/arrows   → sort by END (pick fewest "ending soonest")
```

**Two-pointer intersection (sorted lists)**

```ruby
lo = [A[i][0], B[j][0]].max
hi = [A[i][1], B[j][1]].min
result << [lo, hi] if lo <= hi
A[i][1] < B[j][1] ? i += 1 : j += 1
```

**Sweep line / delta trick**

```ruby
# for "max concurrent X" problems:
# events[start] += 1, events[end] -= 1
# sort by time, running prefix sum → peak is the answer
```

---

## Decision Checklist

```
merge overlapping?           → sort by start, sweep
insert into sorted?          → 3-phase (before / overlap / after)
min arrows / max non-overlap → sort by END, greedy
max concurrent / min rooms   → sweep line OR min-heap on end times
two sorted interval lists?   → two pointers, max(starts)..min(ends)
dynamic stream?              → TreeMap / sorted container
```

---

## Solved

- [ ] 252 — Meeting Rooms
- [ ] 228 — Summary Ranges
- [ ] 163 — Missing Ranges
- [ ] 56 — Merge Intervals
- [ ] 57 — Insert Interval
- [ ] 435 — Non-overlapping Intervals
- [ ] 452 — Min Arrows to Burst Balloons
- [ ] 253 — Meeting Rooms II
- [ ] 1094 — Car Pooling
- [ ] 986 — Interval List Intersections
- [ ] 729 — My Calendar I
- [ ] 731 — My Calendar II
- [ ] GFG — Minimum Number of Platforms
- [ ] 759 — Employee Free Time
- [ ] 352 — Data Stream as Disjoint Intervals
- [ ] 2402 — Meeting Rooms III
