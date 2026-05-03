# Pattern 03 — Fast & Slow Pointers (Floyd's Cycle Detection)

## Recognize It

Ask yourself:
- Is there a **linked list** or sequence that might contain a **cycle**?
- Do you need to find the **middle** of a linked list in one pass?
- Is the problem about a **sequence of transformations** that could loop (Happy Number)?
- Can you detect **duplicates in a bounded array** without extra space?

If yes → Fast & Slow Pointers.

---

## Core Template

### 1. Cycle Detection (Floyd's Tortoise & Hare)

```
slow moves 1 step, fast moves 2 steps
if they meet → cycle exists
if fast reaches null → no cycle
```

```ruby
def has_cycle(head)
  slow = fast = head

  while fast && fast.next
    slow = slow.next
    fast = fast.next.next
    return true if slow == fast
  end

  false
end
```

---

### 2. Finding the Cycle Start

```
after meeting inside cycle:
reset one pointer to head, advance both by 1
they meet at cycle entry
```

```ruby
def detect_cycle(head)
  slow = fast = head

  while fast && fast.next
    slow = slow.next
    fast = fast.next.next
    if slow == fast
      # phase 2: find start
      slow = head
      while slow != fast
        slow = slow.next
        fast = fast.next
      end
      return slow
    end
  end

  nil
end
```

---

### 3. Middle of Linked List

```ruby
def middle_node(head)
  slow = fast = head

  while fast && fast.next
    slow = slow.next
    fast = fast.next.next
  end

  slow   # when list is even-length, slow is the second middle
end
```

---

## Problem List

### Easy

| # | Problem | LC | Use | Track |
|---|---------|-----|-----|-------|
| 1 | Linked List Cycle | [141](https://leetcode.com/problems/linked-list-cycle/) | Cycle detect | slow/fast meet |
| 2 | Middle of the Linked List | [876](https://leetcode.com/problems/middle-of-the-linked-list/) | Midpoint | slow = mid |
| 3 | Happy Number | [202](https://leetcode.com/problems/happy-number/) | Cycle on number seq | digit-square chain |
| 4 | Remove Duplicates from Sorted List | [83](https://leetcode.com/problems/remove-duplicates-from-sorted-list/) | Same direction | skip equals |

### Medium

| # | Problem | LC | Use | Track |
|---|---------|-----|-----|-------|
| 5 | Linked List Cycle II | [142](https://leetcode.com/problems/linked-list-cycle-ii/) | Cycle start | reset phase |
| 6 | Palindrome Linked List | [234](https://leetcode.com/problems/palindrome-linked-list/) | Midpoint + reverse | two-half compare |
| 7 | Reorder List | [143](https://leetcode.com/problems/reorder-list/) | Midpoint + reverse + merge | multi-phase |
| 8 | Find the Duplicate Number | [287](https://leetcode.com/problems/find-the-duplicate-number/) | Cycle on index fn | Floyd on array |
| 9 | Linked List in Binary Tree | [1367](https://leetcode.com/problems/linked-list-in-binary-tree/) | Chain match | DFS + ptr walk |
| 10 | Split Linked List in Parts | [725](https://leetcode.com/problems/split-linked-list-in-parts/) | Length + split | count then cut |
| 11 | Odd Even Linked List | [328](https://leetcode.com/problems/odd-even-linked-list/) | Two chains | interleave |
| 12 | Swap Nodes in Pairs | [24](https://leetcode.com/problems/swap-nodes-in-pairs/) | Pointer pairs | dummy head |
| 13 | Remove Duplicates from Sorted List II | [82](https://leetcode.com/problems/remove-duplicates-from-sorted-list-ii/) | Same direction | skip all dupes |

### Hard

| # | Problem | LC | Use | Track |
|---|---------|-----|-----|-------|
| 14 | Reverse Nodes in k-Group | [25](https://leetcode.com/problems/reverse-nodes-in-k-group/) | Chunk reverse | count + reverse |
| 15 | Circular Array Loop | [457](https://leetcode.com/problems/circular-array-loop/) | Cycle on index | direction check |
| 16 | Merge k Sorted Lists | [23](https://leetcode.com/problems/merge-k-sorted-lists/) | Pairwise merge | divide & conquer |

---

## Key Tricks to Remember

**Why cycle-start works (math intuition)**
```
Let L = distance from head to cycle start
Let C = cycle length, x = distance from start to meeting point
Fast travels 2 * (L + x) = L + x + n*C  → L = n*C - x
So starting fresh pointer at head, both move L steps, meet at start.
```

**Duplicate number = cycle on function f(i) = arr[i]**
```ruby
# treat array indexes as linked-list nodes, arr[i] as "next pointer"
# duplicate guarantees a cycle; Floyd finds its entry = the duplicate
```

**Palindrome LL — do it in O(1) space**
```ruby
# 1. find middle with slow/fast
# 2. reverse second half
# 3. compare halves node by node
# 4. (optionally) restore the list
```

**Even vs Odd length midpoint**
```ruby
# `while fast && fast.next` → slow lands on 2nd middle for even length
# `while fast.next && fast.next.next` → slow lands on 1st middle
```

---

## Decision Checklist

```
linked list + "cycle"?            → Floyd's (slow/fast)
need cycle entry point?           → Floyd's + reset phase
middle of linked list (1 pass)?   → slow/fast, slow = answer
sequence that might loop (nums)?  → treat as implicit linked list
find duplicate in [1..n]?         → Floyd on f(i) = arr[i]
```

---

## Solved
- [ ] 141 — Linked List Cycle
- [ ] 876 — Middle of the Linked List
- [ ] 202 — Happy Number
- [ ] 83 — Remove Duplicates from Sorted List
- [ ] 142 — Linked List Cycle II
- [ ] 234 — Palindrome Linked List
- [ ] 143 — Reorder List
- [ ] 287 — Find the Duplicate Number
- [ ] 1367 — Linked List in Binary Tree
- [ ] 725 — Split Linked List in Parts
- [ ] 328 — Odd Even Linked List
- [ ] 24 — Swap Nodes in Pairs
- [ ] 82 — Remove Duplicates from Sorted List II
- [ ] 25 — Reverse Nodes in k-Group
- [ ] 457 — Circular Array Loop
- [ ] 23 — Merge k Sorted Lists