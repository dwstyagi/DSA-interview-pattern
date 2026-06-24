# frozen_string_literal: true

#
# 1. Problem Statement
#
# LeetCode 658 - Find K Closest Elements
#
# Given a sorted integer array arr, two integers k and x, return the k closest
# integers to x in the array.
#
# Rules:
# - The result must be sorted in ascending order.
# - If there is a tie, the smaller element is preferred.
#
# Example:
# arr = [1,2,3,4,5], k = 4, x = 3
#
# Output:
# [1,2,3,4]
#

# -----------------------------------------------------------------------------
# 2. Brute Force Approach
# -----------------------------------------------------------------------------
#
# Intuition
# ---------
# Calculate the distance of every element from x.
#
# Since the problem asks for the k closest elements:
#   1. Compute distance = |num - x|
#   2. Sort elements by:
#        - Smaller distance first
#        - Smaller value first when distances are equal
#   3. Take first k elements
#   4. Sort them again because answer must be ascending
#
# How it works
# ------------
# For every element:
#   store [distance, value]
#
# Sort by:
#   distance ascending
#   value ascending
#
# Pick first k values.
#
# Sort selected values before returning.
#
# Time Complexity:
#   O(n log n)
#
# Space Complexity:
#   O(n)
#

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def find_closest_elements_brute_force(arr, k, x)
  candidates = []

  arr.each do |num|
    candidates << [(num - x).abs, num]
  end

  candidates.sort_by! { |distance, value| [distance, value] }

  result = candidates.first(k).map(&:last)

  result.sort
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# Why is the brute force solution inefficient?
#
# We sort the entire array based on distance from x.
#
# Even though we only need k elements, we still:
#
#   - Calculate distance for all n elements
#   - Sort all n elements
#
# Sorting costs:
#
#   O(n log n)
#
# This becomes expensive for large inputs.
#
# More importantly:
#
# The array is already sorted.
#
# The brute force solution completely ignores this useful property.
#
# We should exploit the sorted nature of the array instead of rebuilding
# a new ordering from scratch.
#

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Observation 1
# -------------
# Since arr is already sorted,
# the answer will always form a contiguous window.
#
# Example:
#
# arr = [1,2,3,4,5]
# k = 4
#
# Possible windows:
#
# [1,2,3,4]
# [2,3,4,5]
#
# Notice:
# We never skip elements.
#
# Therefore the answer must be some window of length k.
#
#
# Observation 2
# -------------
# Instead of selecting k elements individually,
# find the best window of size k.
#
# Number of possible windows:
#
# n - k + 1
#
#
# Observation 3
# -------------
# Use Binary Search on the window starting position.
#
# Search range:
#
# left  = 0
# right = n - k
#
#
# Suppose:
#
# mid = candidate window start
#
# Window A:
#
# [mid ... mid+k-1]
#
# Next window:
#
# [mid+1 ... mid+k]
#
#
# What changes?
#
# Window A loses:
#
# arr[mid]
#
# Window B gains:
#
# arr[mid+k]
#
# Everything else overlaps.
#
#
# Observation 4
# -------------
# Therefore we only compare:
#
# arr[mid]
# arr[mid+k]
#
#
# If:
#
# x - arr[mid] > arr[mid+k] - x
#
# then arr[mid+k] is closer to x.
#
# Shifting right improves the window.
#
# Move:
#
# left = mid + 1
#
#
# Otherwise:
#
# Current window is at least as good.
#
# Move:
#
# right = mid
#
#
# Tie Case
# --------
#
# If:
#
# x - arr[mid] == arr[mid+k] - x
#
# Problem prefers smaller values.
#
# arr[mid] is smaller than arr[mid+k].
#
# Therefore:
#
# Keep the left window.
#
# Move:
#
# right = mid
#
#
# Result
# ------
#
# Binary search finds the optimal starting index.
#
# Return:
#
# arr[start, k]
#

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Example:
#
# arr = [1,2,3,4,5]
# k   = 4
# x   = 3
#
#
# Initial:
#
# left  = 0
# right = 1
#
#
# Iteration 1
# -----------
#
# mid = 0
#
# Compare:
#
# x - arr[mid]
# = 3 - 1
# = 2
#
# arr[mid+k] - x
# = arr[4] - 3
# = 5 - 3
# = 2
#
# Since:
#
# 2 > 2 ? No
#
# Move:
#
# right = mid
# right = 0
#
#
# Loop Ends
# ---------
#
# left = 0
# right = 0
#
#
# Answer:
#
# arr[0, 4]
#
# => [1,2,3,4]
#

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm
# ---------
#
# 1. Binary search the window start index.
#
# 2. For each midpoint:
#      Compare:
#
#      x - arr[mid]
#
#      and
#
#      arr[mid+k] - x
#
# 3. If right boundary is closer:
#      move right
#
# 4. Otherwise:
#      keep current/left window
#
# 5. Return the window starting at the final position.
#
#
# Time Complexity
# ---------------
#
# Binary Search:
#   O(log(n - k))
#
# Building answer:
#   O(k)
#
# Total:
#   O(log(n - k) + k)
#
#
# Space Complexity
# ----------------
#
# O(1)
#
# Ignoring the returned array.
#

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def find_closest_elements(arr, k, x)
  left = 0
  right = arr.length - k

  while left < right
    mid = left + ((right - left) / 2)

    # Compare the element leaving the window
    # with the element entering the window.
    if x - arr[mid] > arr[mid + k] - x
      left = mid + 1
    else
      right = mid
    end
  end

  arr[left, k]
end

# -----------------------------------------------------------------------------
# Function Calls / Test Cases
# -----------------------------------------------------------------------------

puts 'Brute Force Solution'
p find_closest_elements_brute_force([1, 2, 3, 4, 5], 4, 3)
# Expected: [1, 2, 3, 4]

p find_closest_elements_brute_force([1, 2, 3, 4, 5], 4, -1)
# Expected: [1, 2, 3, 4]

puts

puts 'Optimal Solution'
p find_closest_elements([1, 2, 3, 4, 5], 4, 3)
# Expected: [1, 2, 3, 4]

p find_closest_elements([1, 2, 3, 4, 5], 4, -1)
# Expected: [1, 2, 3, 4]

p find_closest_elements([1, 1, 2, 3, 4, 5], 4, -1)
# Expected: [1, 1, 2, 3]

p find_closest_elements([0, 0, 1, 2, 3, 3, 4, 7, 7, 8], 3, 5)
# Expected: [3, 3, 4]
