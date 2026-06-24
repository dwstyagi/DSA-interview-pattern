# frozen_string_literal: true

=begin

1. Problem Statement
--------------------
Given a sorted (ascending order) integer array nums and an integer target,
return the index of target if it exists in the array.

If target does not exist, return -1.

You must write an algorithm with O(log n) runtime complexity.

Example:
nums = [-1, 0, 3, 5, 9, 12], target = 9
Output: 4

=end

# ============================================================
# 2. Brute Force Approach
# ============================================================

=begin

Intuition
---------
The most straightforward approach is to scan the array from left to right
and compare every element with the target.

As soon as we find the target, we return its index.
If we reach the end without finding it, we return -1.

How the Algorithm Works
-----------------------
1. Iterate through the array.
2. For each element:
   - If it equals target, return the current index.
3. If the loop finishes, return -1.

Time Complexity
---------------
O(n)

In the worst case we may need to examine every element.

Space Complexity
----------------
O(1)

No extra data structures are used.

=end

# ============================================================
# 3. Brute Force Code
# ============================================================

def search_brute_force(nums, target)
  nums.each_with_index do |num, index|
    return index if num == target
  end

  -1
end

# ============================================================
# 4. Bottleneck Analysis
# ============================================================

=begin

Why is the Brute Force Solution Inefficient?
--------------------------------------------
The array is already sorted, but the brute force solution completely ignores
this valuable information.

For example:

nums = [-1, 0, 3, 5, 9, 12]
target = 12

We still check:

-1
0
3
5
9
12

Even though the array ordering can help us eliminate large portions
of the search space immediately.

Main Bottleneck
---------------
The algorithm performs a linear scan.

Repeated Work
-------------
Every element is checked individually.

Even after examining the middle of the array, we still continue checking
many elements that can be ruled out using the sorted property.

This results in O(n) time complexity.

Can we do better?
-----------------
Since the array is sorted, we should be able to discard half of the
remaining elements after every comparison.

This leads us naturally to Binary Search.

=end

# ============================================================
# 5. Optimization Journey
# ============================================================

=begin

Observation 1
-------------
The array is sorted.

This means:

If nums[mid] < target,
then every element to the left of mid is also smaller than target.

Therefore, we can safely discard the entire left half.

--------------------------------------------------

Observation 2
-------------
If nums[mid] > target,

then every element to the right of mid is also greater than target.

Therefore, we can safely discard the entire right half.

--------------------------------------------------

Observation 3
-------------
Each comparison cuts the search space in half.

Example:

Size = 16
After one comparison -> 8
After two comparisons -> 4
After three comparisons -> 2
After four comparisons -> 1

This halving process produces logarithmic complexity.

--------------------------------------------------

Binary Search Strategy
----------------------

Maintain two pointers:

left  = beginning of search space
right = end of search space

While left <= right:

1. Find middle element.
2. Compare nums[mid] with target.
3. If equal:
      return mid
4. If nums[mid] < target:
      search right half
5. Otherwise:
      search left half

By repeatedly eliminating half of the remaining search space,
we achieve O(log n) time complexity.

Why This Solves the Bottleneck
------------------------------
Instead of checking every element one-by-one,
we eliminate half of the remaining candidates after every comparison.

This reduces:

O(n) -> O(log n)

which is exactly what the problem requires.

=end

# ============================================================
# 6. Dry Run
# ============================================================

=begin

Example:

nums   = [-1, 0, 3, 5, 9, 12]
target = 9

Initial State

left  = 0
right = 5

--------------------------------------------------

Iteration 1

mid = 0 + (5 - 0) / 2
mid = 2

nums[mid] = 3

3 < 9

Discard left half including mid.

left = mid + 1 = 3
right = 5

--------------------------------------------------

Iteration 2

left = 3
right = 5

mid = 3 + (5 - 3) / 2
mid = 4

nums[mid] = 9

Target found.

Return 4

--------------------------------------------------

Result = 4

=end

# ============================================================
# 7. Optimal Solution
# ============================================================

=begin

Algorithm
---------

1. Initialize:
      left = 0
      right = nums.length - 1

2. While left <= right:
      mid = left + (right - left) / 2

3. Compare nums[mid] with target:

      If equal:
          return mid

      If nums[mid] < target:
          left = mid + 1

      Else:
          right = mid - 1

4. If loop finishes:
      return -1

Time Complexity
---------------
O(log n)

Search space is halved every iteration.

Space Complexity
----------------
O(1)

Only a few variables are used.

=end

# ============================================================
# 8. Optimal Code
# ============================================================

def search(nums, target)
  left = 0
  right = nums.length - 1

  while left <= right
    # Avoids overflow and finds middle index
    mid = left + ((right - left) / 2)

    return mid if nums[mid] == target

    if nums[mid] < target
      left = mid + 1
    else
      right = mid - 1
    end
  end

  -1
end

# ============================================================
# Examples
# ============================================================

puts "Example 1"
nums = [-1, 0, 3, 5, 9, 12]
target = 9
puts search(nums, target)
# Output: 4

puts "\nExample 2"
nums = [-1, 0, 3, 5, 9, 12]
target = 2
puts search(nums, target)
# Output: -1

puts "\nExample 3"
nums = [1]
target = 1
puts search(nums, target)
# Output: 0

puts "\nExample 4"
nums = [1]
target = 0
puts search(nums, target)
# Output: -1