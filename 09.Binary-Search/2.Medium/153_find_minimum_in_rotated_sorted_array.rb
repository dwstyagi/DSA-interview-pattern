# frozen_string_literal: true

#
# 1. Problem Statement
# --------------------
# LeetCode 153 - Find Minimum in Rotated Sorted Array
#
# Suppose an array of unique integers was originally sorted in ascending order,
# but then rotated between 1 and n times.
#
# Examples:
# [0,1,2,4,5,6,7] -> rotated 4 times -> [4,5,6,7,0,1,2]
#
# Given the rotated sorted array, return the minimum element.
#
# You must design an algorithm that runs in O(log n) time.
#
# ------------------------------------------------------------
#
# 2. Brute Force Approach
# -----------------------
#
# Intuition
# ---------
# The minimum element is simply the smallest value in the array.
#
# Since every element is available, we can scan the entire array and keep
# track of the smallest value encountered.
#
# Algorithm
# ---------
# 1. Initialize min_value as the first element.
# 2. Traverse the array.
# 3. Update min_value whenever a smaller element is found.
# 4. Return min_value.
#
# Example
# -------
# nums = [4,5,6,7,0,1,2]
#
# min = 4
# 5 > 4 -> ignore
# 6 > 4 -> ignore
# 7 > 4 -> ignore
# 0 < 4 -> min = 0
# 1 > 0 -> ignore
# 2 > 0 -> ignore
#
# Answer = 0
#
# Complexity
# ----------
# Time Complexity: O(n)
# Space Complexity: O(1)
#
# ------------------------------------------------------------
#
# 3. Brute Force Code
# -------------------

def find_min_brute_force(nums)
  min_value = nums[0]

  nums.each do |num|
    min_value = [min_value, num].min
  end

  min_value
end

# ------------------------------------------------------------
#
# 4. Bottleneck Analysis
# ----------------------
#
# Why is the brute force solution inefficient?
#
# The array was originally sorted.
#
# A sorted array contains additional structure that we are completely
# ignoring by scanning every element.
#
# Even though the minimum can often be identified without examining
# all values, the brute force solution still checks every element.
#
# Repeated Work
# -------------
# For an array of size n:
#
# - Every element is visited.
# - No information from sorting order is used.
# - We spend O(n) operations even though the problem asks for O(log n).
#
# We need a strategy that eliminates half of the search space at every step.
#
# That naturally suggests Binary Search.
#
# ------------------------------------------------------------
#
# 5. Optimization Journey
# -----------------------
#
# Observation 1
# -------------
# A rotated sorted array consists of two sorted portions.
#
# Example:
#
# nums = [4,5,6,7,0,1,2]
#
# Left Part:
# [4,5,6,7]
#
# Right Part:
# [0,1,2]
#
# The minimum element is exactly where the rotation occurs.
#
# ------------------------------------------------------------
#
# Observation 2
# -------------
# Consider the last element.
#
# nums = [4,5,6,7,0,1,2]
#
# last = 2
#
# Let's examine mid.
#
# mid = 3
# nums[mid] = 7
#
# 7 > 2
#
# This tells us mid lies in the left sorted portion.
#
# Since the minimum is after the rotation point,
# it must be somewhere to the right.
#
# Therefore:
#
# left = mid + 1
#
# ------------------------------------------------------------
#
# Observation 3
# -------------
# Now suppose:
#
# nums = [4,5,6,7,0,1,2]
#
# mid = 5
# nums[mid] = 1
#
# 1 < 2
#
# Now mid belongs to the right sorted portion.
#
# The minimum could be:
#
# - mid itself
# - somewhere to the left of mid
#
# Therefore:
#
# right = mid
#
# Notice we do NOT discard mid because it might be the answer.
#
# ------------------------------------------------------------
#
# Observation 4
# -------------
# Each comparison removes half of the remaining search space.
#
# If:
#
# nums[mid] > nums[right]
#
# then minimum is in:
#
# (mid + 1 ... right)
#
# Else:
#
# (left ... mid)
#
# This is exactly Binary Search.
#
# ------------------------------------------------------------
#
# Why Compare With nums[right]?
# -----------------------------
#
# The rightmost value tells us which sorted region mid belongs to.
#
# Case 1:
# --------
# nums[mid] > nums[right]
#
# Example:
#
# [4,5,6,7,0,1,2]
#        ^
#        mid
#
# 7 > 2
#
# mid is in left region.
#
# Minimum must be on the right.
#
# Case 2:
# --------
# nums[mid] <= nums[right]
#
# Example:
#
# [4,5,6,7,0,1,2]
#            ^
#           mid
#
# 1 <= 2
#
# mid is in right region.
#
# Minimum is at mid or further left.
#
# ------------------------------------------------------------
#
# 6. Dry Run
# ----------
#
# Example:
# nums = [4,5,6,7,0,1,2]
#
# Initial:
# left = 0
# right = 6
#
# ------------------------------------------------
#
# Iteration 1
#
# mid = (0 + 6) / 2 = 3
#
# nums[mid] = 7
# nums[right] = 2
#
# 7 > 2
#
# Minimum is on right side.
#
# left = mid + 1 = 4
#
# Now:
#
# left = 4
# right = 6
#
# ------------------------------------------------
#
# Iteration 2
#
# mid = (4 + 6) / 2 = 5
#
# nums[mid] = 1
# nums[right] = 2
#
# 1 <= 2
#
# Minimum is at mid or left side.
#
# right = mid = 5
#
# Now:
#
# left = 4
# right = 5
#
# ------------------------------------------------
#
# Iteration 3
#
# mid = (4 + 5) / 2 = 4
#
# nums[mid] = 0
# nums[right] = 1
#
# 0 <= 1
#
# right = mid = 4
#
# Now:
#
# left = 4
# right = 4
#
# Loop stops.
#
# Return nums[left]
#
# Answer = 0
#
# ------------------------------------------------------------
#
# 7. Optimal Solution
# -------------------
#
# Algorithm
# ---------
# 1. Maintain two pointers:
#    - left
#    - right
#
# 2. While left < right:
#    - Compute mid.
#    - Compare nums[mid] with nums[right].
#
# 3. If nums[mid] > nums[right]:
#    - Minimum lies to the right.
#    - left = mid + 1
#
# 4. Otherwise:
#    - Minimum lies at mid or left side.
#    - right = mid
#
# 5. When left == right:
#    - That index contains the minimum element.
#
# Why It Works
# ------------
# Every comparison determines which half contains the rotation point.
#
# Since one half can be discarded each iteration,
# the search space shrinks by 50% every step.
#
# Complexity
# ----------
# Time Complexity: O(log n)
# Space Complexity: O(1)
#
# ------------------------------------------------------------
#
# 8. Optimal Code
# ---------------
#

def find_min(nums)
  left = 0
  right = nums.length - 1

  while left < right
    mid = left + ((right - left) / 2)

    if nums[mid] > nums[right]
      # Minimum lies in the right half
      left = mid + 1
    else
      # Minimum is at mid or in the left half
      right = mid
    end
  end

  nums[left]
end

#
# Example Tests
# -------------
#
puts find_min([3, 4, 5, 1, 2])
# Output: 1
#
puts find_min([4, 5, 6, 7, 0, 1, 2])
# Output: 0
#
puts find_min([11, 13, 15, 17])
# Output: 11
#
puts find_min([2, 1])
# Output: 1
#
