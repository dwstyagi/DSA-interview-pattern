# frozen_string_literal: true

=begin

1. Problem Statement

LeetCode 34 - Find First and Last Position of Element in Sorted Array

Given a sorted array of integers nums and an integer target,
return the starting and ending position of target in the array.

If target is not present, return [-1, -1].

The solution must run in O(log n) time.

Example:
nums = [5,7,7,8,8,10], target = 8

Output:
[3, 4]

=end

# ============================================================
# 2. Brute Force Approach
# ============================================================

=begin

Intuition
---------
Since we need the first and last occurrence of target,
we can simply scan the entire array.

While traversing:

1. When target is found for the first time,
   store its index as first.

2. Keep updating last whenever target is found.

3. After traversal:
   - If target never appeared, return [-1, -1]
   - Otherwise return [first, last]

How It Works
------------
nums = [5,7,7,8,8,10]
target = 8

Traverse:

i = 0 -> 5
i = 1 -> 7
i = 2 -> 7
i = 3 -> 8
  first = 3
  last = 3

i = 4 -> 8
  last = 4

i = 5 -> 10

Return [3,4]

Time Complexity
---------------
O(n)

Space Complexity
----------------
O(1)

=end

# ============================================================
# 3. Brute Force Code
# ============================================================

def search_range_brute_force(nums, target)
  first = -1
  last = -1

  nums.each_with_index do |num, index|
    next unless num == target

    first = index if first == -1
    last = index
  end

  [first, last]
end

# ============================================================
# 4. Bottleneck Analysis
# ============================================================

=begin

Why is the brute force solution inefficient?

The array is already sorted.

However, the brute force solution completely ignores
this information and still examines every element.

Example:

nums = [1,2,3,4,5,6,7,8,9]

target = 8

Even though sorting allows us to eliminate half
the search space repeatedly, brute force still
checks almost every element.

Repeated Work
-------------
We repeatedly inspect elements that can be ruled out
using binary search.

Since the problem explicitly requires O(log n),
an O(n) solution is not acceptable.

We need to exploit the sorted nature of the array.

=end

# ============================================================
# 5. Optimization Journey
# ============================================================

=begin

Observation 1
-------------
The array is sorted.

Whenever we see "sorted array" and "O(log n)",
binary search should immediately come to mind.

Observation 2
-------------
A normal binary search is not enough.

Example:

nums = [1,2,2,2,2,3]

A standard binary search may return:

index = 2

But we need:

[1,4]

We need boundaries, not any occurrence.

Observation 3
-------------
Think of all target values as a continuous block.

Example:

nums = [1,2,2,2,2,3]

          |-----|
          target block

We need:

- Left boundary
- Right boundary

Observation 4
-------------
Let's define a reusable helper:

lower_bound(target)

Definition:
Returns the first index whose value is >= target.

Example:

nums = [1,2,2,2,4,5]

lower_bound(2) => 1
lower_bound(3) => 4

Observation 5
-------------
Finding the first occurrence

The first occurrence of target is simply:

first = lower_bound(target)

Example:

nums = [5,7,7,8,8,10]

lower_bound(8)

returns:

3

which is exactly the first occurrence.

Observation 6
-------------
Finding the last occurrence

Instead of searching for the last target directly,
search for the beginning of the next larger value.

For integers:

lower_bound(target + 1)

Example:

nums = [5,7,7,8,8,10]

lower_bound(9)

returns:

5

because index 5 contains 10,
which is the first value >= 9.

Therefore:

last = 5 - 1 = 4

This gives the last occurrence of 8.

Key Formula
------------

first = lower_bound(target)

last = lower_bound(target + 1) - 1

Why does this work?

Because in a sorted array:

smaller values | target values | larger values

lower_bound(target)
finds where target starts.

lower_bound(target + 1)
finds where target ends and larger values begin.

=end

# ============================================================
# 6. Dry Run
# ============================================================

=begin

nums = [5,7,7,8,8,10]
target = 8

------------------------------------------------
Step 1
------------------------------------------------

first = lower_bound(nums, 8)

l = 0
r = 6

mid = 3
nums[3] = 8

8 < 8 ? No

r = 3

--------------------------------

l = 0
r = 3

mid = 1
nums[1] = 7

7 < 8 ? Yes

l = 2

--------------------------------

l = 2
r = 3

mid = 2
nums[2] = 7

7 < 8 ? Yes

l = 3

--------------------------------

l = 3
r = 3

Stop

first = 3

------------------------------------------------
Step 2
------------------------------------------------

lower_bound(nums, 9)

l = 0
r = 6

mid = 3
nums[3] = 8

8 < 9 ? Yes

l = 4

--------------------------------

l = 4
r = 6

mid = 5
nums[5] = 10

10 < 9 ? No

r = 5

--------------------------------

l = 4
r = 5

mid = 4
nums[4] = 8

8 < 9 ? Yes

l = 5

--------------------------------

l = 5
r = 5

Stop

lower_bound(9) = 5

last = 5 - 1
     = 4

Answer:

[3,4]

=end

# ============================================================
# 7. Optimal Solution
# ============================================================

=begin

Algorithm
---------

1. Find first occurrence using:

   first = lower_bound(target)

2. Verify target actually exists.

   If:
   - first is outside array OR
   - nums[first] != target

   return [-1,-1]

3. Find:

   lower_bound(target + 1)

4. The last occurrence is one position before it.

5. Return [first, last]

Why It Works
------------

lower_bound(target)
gives the first position where target can appear.

lower_bound(target + 1)
gives the first position after the target block.

The element immediately before that position
must be the final occurrence of target.

Time Complexity
---------------

lower_bound -> O(log n)

Called twice:

O(log n) + O(log n)
= O(log n)

Space Complexity
----------------

O(1)

=end

# ============================================================
# 8. Optimal Code
# ============================================================

def lower_bound(nums, target)
  left = 0
  right = nums.length

  while left < right
    mid = left + ((right - left) / 2)

    if nums[mid] < target
      left = mid + 1
    else
      right = mid
    end
  end

  left
end

def search_range(nums, target)
  first = lower_bound(nums, target)

  return [-1, -1] if first >= nums.length || nums[first] != target

  last = lower_bound(nums, target + 1) - 1

  [first, last]
end

# ============================================================
# Example Test Cases
# ============================================================

p search_range([5, 7, 7, 8, 8, 10], 8)
# [3, 4]

p search_range([5, 7, 7, 8, 8, 10], 6)
# [-1, -1]

p search_range([], 0)
# [-1, -1]

p search_range([1], 1)
# [0, 0]

p search_range([2, 2], 2)
# [0, 1]