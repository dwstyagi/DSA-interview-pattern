# frozen_string_literal: true

#
# 1. Problem Statement
#
# LeetCode 33 - Search in Rotated Sorted Array
#
# Given a rotated sorted array nums containing distinct integers and an integer
# target, return the index of target if it exists in the array. Otherwise,
# return -1.
#
# You must achieve O(log n) runtime complexity.
#
# Example:
# nums = [4,5,6,7,0,1,2], target = 0
# Output: 4
#

# ------------------------------------------------------------------
# 2. Brute Force Approach
# ------------------------------------------------------------------

#
# Intuition
# ---------
# The simplest approach is to scan the array from left to right and compare
# every element with target.
#
# Since the target can appear at any position, we may need to examine every
# element before finding it (or determining it doesn't exist).
#
# Algorithm
# ---------
# 1. Iterate through the array.
# 2. If nums[i] == target, return i.
# 3. If the loop finishes without finding target, return -1.
#
# Time Complexity
# --------------
# O(n)
#
# Space Complexity
# ---------------
# O(1)
#

# ------------------------------------------------------------------
# 3. Brute Force Code
# ------------------------------------------------------------------

def search_brute_force(nums, target)
  nums.each_with_index do |num, index|
    return index if num == target
  end

  -1
end

# ------------------------------------------------------------------
# 4. Bottleneck Analysis
# ------------------------------------------------------------------

#
# Why is the brute force solution inefficient?
# --------------------------------------------
#
# Even though the array was originally sorted, the brute force approach ignores
# that information completely.
#
# For every search:
#
# Worst Case:
# nums = [4,5,6,7,0,1,2]
# target = 2
#
# We check:
# 4 -> 5 -> 6 -> 7 -> 0 -> 1 -> 2
#
# Almost every element is visited.
#
# Repeated Work
# -------------
# For each search operation:
#
# - We repeatedly inspect elements that can be ruled out using ordering.
# - We fail to exploit the fact that the array is mostly sorted.
# - We eliminate only one element per comparison.
#
# As a result:
#
# n elements
# → n comparisons
#
# Time Complexity = O(n)
#
# But the problem explicitly asks for O(log n).
#
# We need a way to eliminate half of the search space at every step.
#

# ------------------------------------------------------------------
# 5. Optimization Journey
# ------------------------------------------------------------------

#
# Observation 1
# -------------
#
# The original array was sorted.
#
# Example:
#
# [0,1,2,4,5,6,7]
#
# After rotation:
#
# [4,5,6,7,0,1,2]
#
# The array is no longer globally sorted,
# but parts of it remain sorted.
#
# Observation 2
# -------------
#
# For any midpoint, at least one half is always sorted.
#
# Example:
#
# [4,5,6,7,0,1,2]
#  L     M     R
#
# mid = 7
#
# Left half:
# [4,5,6,7]
#
# Right half:
# [0,1,2]
#
# The left half is sorted.
#
# Similarly, in every iteration:
#
# Either
#
# nums[left] <= nums[mid]
#
# or
#
# nums[mid] <= nums[right]
#
# One of the halves must be sorted.
#
# Observation 3
# -------------
#
# Once we identify the sorted half, we can determine whether the target
# belongs inside that half.
#
# Case 1:
# Left half sorted
#
# nums[left] <= target < nums[mid]
#
# If true:
# Search left half.
#
# Otherwise:
# Search right half.
#
# Case 2:
# Right half sorted
#
# nums[mid] < target <= nums[right]
#
# If true:
# Search right half.
#
# Otherwise:
# Search left half.
#
# Key Insight
# -----------
#
# Instead of removing one element at a time, we remove half the search space
# during every iteration.
#
# This is exactly what Binary Search does.
#
# Therefore:
#
# O(n)
# → O(log n)
#
# No extra data structure is needed.
#
# We simply modify Binary Search to account for rotation.
#

# ------------------------------------------------------------------
# 6. Dry Run
# ------------------------------------------------------------------

#
# Example
#
# nums = [4,5,6,7,0,1,2]
# target = 0
#
# Initial State
#
# left = 0
# right = 6
#
# --------------------------------------------------
#
# Iteration 1
#
# mid = (0 + 6) / 2 = 3
#
# nums[mid] = 7
#
# Array:
#
# [4,5,6,7,0,1,2]
#        M
#
# Check sorted side:
#
# nums[left] <= nums[mid]
#
# 4 <= 7
#
# True
#
# Left half is sorted:
# [4,5,6,7]
#
# Does target belong here?
#
# 4 <= 0 < 7
#
# False
#
# Discard left half.
#
# left = mid + 1 = 4
#
# --------------------------------------------------
#
# Iteration 2
#
# left = 4
# right = 6
#
# mid = (4 + 6) / 2 = 5
#
# nums[mid] = 1
#
# Array:
#
# [4,5,6,7,0,1,2]
#          L M R
#
# Check sorted side:
#
# nums[left] <= nums[mid]
#
# 0 <= 1
#
# True
#
# Left half is sorted:
# [0,1]
#
# Does target belong here?
#
# 0 <= 0 < 1
#
# True
#
# Search left half.
#
# right = mid - 1 = 4
#
# --------------------------------------------------
#
# Iteration 3
#
# left = 4
# right = 4
#
# mid = 4
#
# nums[mid] = 0
#
# Target found.
#
# Return 4.
#

# ------------------------------------------------------------------
# 7. Optimal Solution
# ------------------------------------------------------------------

#
# Algorithm
# ---------
#
# While left <= right:
#
# 1. Find middle element.
#
# 2. If nums[mid] == target
#    return mid.
#
# 3. Determine which half is sorted.
#
#    If nums[left] <= nums[mid]
#       Left half is sorted.
#
#       If target lies inside left half:
#          move right pointer.
#       Else:
#          move left pointer.
#
#    Else
#       Right half is sorted.
#
#       If target lies inside right half:
#          move left pointer.
#       Else:
#          move right pointer.
#
# 4. If loop ends, return -1.
#
# Why It Works
# ------------
#
# At every step:
#
# - One side is guaranteed to be sorted.
# - We can determine whether target lies in that side.
# - Half of the remaining search space is discarded.
#
# Thus the search space shrinks exponentially.
#
# Time Complexity
# --------------
# O(log n)
#
# Space Complexity
# ---------------
# O(1)
#

# ------------------------------------------------------------------
# 8. Optimal Code
# ------------------------------------------------------------------

def search(nums, target)
  left = 0
  right = nums.length - 1

  while left <= right
    mid = left + ((right - left) / 2)

    return mid if nums[mid] == target

    # Left half is sorted.
    if nums[left] <= nums[mid]
      if nums[left] <= target && target < nums[mid]
        right = mid - 1
      else
        left = mid + 1
      end

    # Right half is sorted.
    elsif nums[mid] < target && target <= nums[right]
      left = mid + 1
    else
      right = mid - 1
    end
  end

  -1
end

# ------------------------------------------------------------------
# Example Test Cases
# ------------------------------------------------------------------

puts search([4, 5, 6, 7, 0, 1, 2], 0)
# 4

puts search([4, 5, 6, 7, 0, 1, 2], 3)
# -1

puts search([1], 0)
# -1

puts search([1], 1)
# 0

puts search([5, 1, 3], 5)
# 0

puts search([6, 7, 1, 2, 3, 4, 5], 3)
# 4
