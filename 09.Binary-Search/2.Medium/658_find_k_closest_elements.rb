# frozen_string_literal: true

# LeetCode 658: Find K Closest Elements
#
# Problem:
# Given a sorted integer array arr, two integers k and x, return the k closest
# integers to x in the array.
#
# The result must be sorted in ascending order.
#
# Tie Rule:
# If two numbers have the same distance from x, choose the smaller number.
#
# Examples:
#   Input:  arr = [1, 2, 3, 4, 5], k = 4, x = 3
#   Output: [1, 2, 3, 4]
#
#   Input:  arr = [1, 2, 3, 4, 5], k = 4, x = -1
#   Output: [1, 2, 3, 4]
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. Brute Force
#    Sort all elements by distance from x.
#    If distances tie, smaller value comes first.
#    Take first k elements and sort them ascending.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    The array is already sorted.
#    The answer must be a sorted window of length k inside arr.
#
# 3. Optimized Binary Search Approach
#    Binary search the left boundary of the answer window.
#    A valid answer is always arr[left...left + k].
#    Compare the element just outside the right side with the left element.
#    Time Complexity: O(log(n - k) + k)
#    Space Complexity: O(1), ignoring output
#
# -----------------------------------------------------------------------------
# Why Binary Search Works
#
# Every possible answer is a window of size k:
#
# arr = [1, 2, 3, 4, 5]
# k = 4
#
# Possible windows:
# left = 0 -> [1, 2, 3, 4]
# left = 1 -> [2, 3, 4, 5]
#
# We choose which window is closer to x.
#
# For a middle window starting at mid:
#
# left edge = arr[mid]
# right outside edge = arr[mid + k]
#
# If arr[mid] is farther from x than arr[mid + k],
# shift window right.
#
# Otherwise, keep window left.
#
# -----------------------------------------------------------------------------
# Dry Run
#
# arr = [1, 2, 3, 4, 5]
# k = 4
# x = 3
#
# left = 0
# right = arr.length - k = 1
#
# mid = 0
#
# Compare:
# x - arr[mid]       = 3 - 1 = 2
# arr[mid + k] - x   = 5 - 3 = 2
#
# Distances are equal.
# Tie rule prefers smaller elements, so keep left window.
#
# right = mid = 0
#
# left == right, stop.
#
# Answer window:
# arr[0, 4] = [1, 2, 3, 4]
#
# Edge Cases:
# - k = 1
# - k = arr.length
# - x smaller than all elements
# - x larger than all elements
# - duplicate values

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Sort every number by closeness to x
# - Tie-break by smaller number
# - Take first k
# - Sort result ascending
#
# Time: O(n log n)
# Space: O(n)
def find_closest_elements_brute_force(arr, k, x)
  arr
    .sort_by { |num| [(num - x).abs, num] }
    .first(k)
    .sort
end

# -----------------------------
# OPTIMIZED BINARY SEARCH SOLUTION
# -----------------------------
# Idea:
# - Answer is a continuous window of size k
# - Binary search the best left boundary
# - Return arr[left, k]
#
# Time: O(log(n - k) + k)
# Space: O(1), ignoring output
def find_closest_elements(arr, k, x)
  left = 0
  right = arr.length - k

  while left < right
    middle = (left + right) / 2

    left_distance = x - arr[middle]
    right_distance = arr[middle + k] - x

    # If left side is farther, shift window right.
    #
    # Use >, not >=.
    # When distances are equal, smaller elements are preferred,
    # so we keep the left window.
    if left_distance > right_distance
      left = middle + 1
    else
      right = middle
    end
  end

  arr[left, k]
end

if __FILE__ == $PROGRAM_NAME
  arr = [1, 2, 3, 4, 5]
  k = 4
  x = 3

  puts "Brute: #{find_closest_elements_brute_force(arr, k, x)}"
  puts "Opt:   #{find_closest_elements(arr, k, x)}"

  arr = [1, 2, 3, 4, 5]
  k = 4
  x = -1

  puts "Brute: #{find_closest_elements_brute_force(arr, k, x)}"
  puts "Opt:   #{find_closest_elements(arr, k, x)}"
end
