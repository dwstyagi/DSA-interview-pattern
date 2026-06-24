# frozen_string_literal: true

# ============================================================
# LeetCode 74. Search a 2D Matrix
# ============================================================
#
# 1. Problem Statement
#
# Given an m x n integer matrix with the following properties:
#
# 1. Each row is sorted in non-decreasing order.
# 2. The first integer of each row is greater than the last
#    integer of the previous row.
#
# Determine whether a target value exists in the matrix.
#
# Return true if the target is found, otherwise false.
#
# ============================================================
# 2. Brute Force Approach
# ============================================================
#
# Intuition
# ---------
# The simplest approach is to check every element one by one.
#
# Since we are only asked whether the target exists, we can
# traverse the entire matrix and return true as soon as we
# find the target.
#
# Algorithm
# ---------
# 1. Iterate through every row.
# 2. Iterate through every element in the row.
# 3. If the current element equals target, return true.
# 4. If traversal completes, return false.
#
# Time Complexity:
# O(m * n)
#
# Space Complexity:
# O(1)
#
# ============================================================
# 3. Brute Force Code
# ============================================================
#
def search_matrix_brute_force?(matrix, target)
  matrix.each do |row|
    row.each do |num|
      return true if num == target
    end
  end

  false
end
#
# ============================================================
# 4. Bottleneck Analysis
# ============================================================
#
# Why is the brute force solution inefficient?
#
# Even though the matrix is sorted, the brute force solution
# completely ignores this information.
#
# Example:
#
# [
#   [1, 3, 5, 7],
#   [10, 11, 16, 20],
#   [23, 30, 34, 60]
# ]
#
# target = 60
#
# We may need to inspect nearly every element before finding
# the answer.
#
# Repeated Work
# -------------
# We are checking many values that can be eliminated using
# ordering information.
#
# Since the matrix is globally sorted, searching linearly
# wastes work.
#
# We need a faster searching technique.
#
# ============================================================
# 5. Optimization Journey
# ============================================================
#
# Observation 1
# -------------
# Every row is sorted.
#
# Observation 2
# -------------
# The first element of a row is greater than the last element
# of the previous row.
#
# Example:
#
# [
#   [1,  3,  5,  7],
#   [10, 11, 16, 20],
#   [23, 30, 34, 60]
# ]
#
# Notice:
#
# 7  < 10
# 20 < 23
#
# This means the entire matrix behaves like one sorted array:
#
# [1,3,5,7,10,11,16,20,23,30,34,60]
#
# Since the data is globally sorted,
# Binary Search becomes possible.
#
# ------------------------------------------------------------
# Converting 1D Index to 2D Coordinates
# ------------------------------------------------------------
#
# Suppose:
#
# rows = 3
# cols = 4
#
# Flattened indices:
#
# Index:
# 0 1 2 3 4 5 6 7 8 9 10 11
#
# Every row contains exactly 'cols' elements.
#
# Therefore:
#
# row = index / cols
# col = index % cols
#
# Example:
#
# index = 6
#
# row = 6 / 4 = 1
# col = 6 % 4 = 2
#
# matrix[1][2] = 16
#
# Now we can perform Binary Search on the virtual array
# without actually creating one.
#
# ============================================================
# 6. Dry Run
# ============================================================
#
# matrix =
#
# [
#   [1, 3, 5, 7],
#   [10, 11, 16, 20],
#   [23, 30, 34, 60]
# ]
#
# target = 16
#
# rows = 3
# cols = 4
#
# left  = 0
# right = 11
#
# ------------------------------------------------------------
# Iteration 1
# ------------------------------------------------------------
#
# mid = 5
#
# row = 5 / 4 = 1
# col = 5 % 4 = 1
#
# value = 11
#
# 11 < 16
#
# left = 6
#
# ------------------------------------------------------------
# Iteration 2
# ------------------------------------------------------------
#
# left = 6
# right = 11
#
# mid = 8
#
# row = 8 / 4 = 2
# col = 8 % 4 = 0
#
# value = 23
#
# 23 > 16
#
# right = 7
#
# ------------------------------------------------------------
# Iteration 3
# ------------------------------------------------------------
#
# left = 6
# right = 7
#
# mid = 6
#
# row = 6 / 4 = 1
# col = 6 % 4 = 2
#
# value = 16
#
# Found target.
#
# Return true.
#
# ============================================================
# 7. Optimal Solution
# ============================================================
#
# Treat the matrix as a virtual sorted array.
#
# Perform Binary Search over indices:
#
# 0...(rows * cols - 1)
#
# For every midpoint:
#
# row = mid / cols
# col = mid % cols
#
# Compare matrix[row][col] with target and shrink the search
# space exactly as in a normal Binary Search.
#
# Time Complexity:
# O(log(m * n))
#
# Space Complexity:
# O(1)
#
# ============================================================
# 8. Optimal Code
# ============================================================

# @param {Integer[][]} matrix
# @param {Integer} target
# @return {Boolean}
def search_matrix?(matrix, target)
  rows = matrix.length
  cols = matrix[0].length

  left = 0
  right = (rows * cols) - 1

  while left <= right
    mid = left + ((right - left) / 2)

    row = mid / cols
    col = mid % cols

    value = matrix[row][col]

    if value == target
      return true
    elsif value < target
      left = mid + 1
    else
      right = mid - 1
    end
  end

  false
end

# ============================================================
# Example
# ============================================================
#
matrix = [
  [1, 3, 5, 7],
  [10, 11, 16, 20],
  [23, 30, 34, 60]
]

puts search_matrix?(matrix, 3)
puts search_matrix?(matrix, 13)
