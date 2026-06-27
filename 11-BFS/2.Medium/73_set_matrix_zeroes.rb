# frozen_string_literal: true

#
# LeetCode 73. Set Matrix Zeroes
#
# ------------------------------------------------------------
# 1. Problem Statement
# ------------------------------------------------------------
#
# Given an m x n integer matrix, if an element is 0, set its
# entire row and column to 0.
#
# The operation must be performed in-place.
#
# Example:
#
# Input:
# [
#   [1,1,1],
#   [1,0,1],
#   [1,1,1]
# ]
#
# Output:
# [
#   [1,0,1],
#   [0,0,0],
#   [1,0,1]
# ]
#
# ------------------------------------------------------------
# 2. Brute Force Approach
# ------------------------------------------------------------
#
# Intuition
# ---------
# Whenever we encounter a 0, every element in its row and
# column must become 0.
#
# The first idea is to immediately update its row and column.
#
# However, doing so introduces a problem.
#
# Newly created zeros will later be treated as original zeros,
# causing additional rows and columns to become zero
# incorrectly.
#
# To distinguish original zeros from newly generated ones,
# we temporarily mark cells using a special value that cannot
# appear in the matrix (Float::INFINITY).
#
# Algorithm
# ---------
# 1. Traverse every cell.
# 2. Whenever a zero is found:
#       - Mark every non-zero element in its row.
#       - Mark every non-zero element in its column.
# 3. After the traversal, convert every marker into 0.
#
# Time Complexity
# ---------------
# Worst case:
# Every cell is zero.
#
# For each zero we scan one entire row and one entire column.
#
# Time:
# O(m * n * (m + n))
#
# Space:
# O(1)
#
# ------------------------------------------------------------
# 3. Brute Force Code
# ------------------------------------------------------------

def mark_row(matrix, row, marker)
  cols = matrix[0].length

  (0...cols).each do |col|
    matrix[row][col] = marker unless matrix[row][col].zero?
  end
end

def mark_column(matrix, col, marker)
  rows = matrix.length

  (0...rows).each do |row|
    matrix[row][col] = marker unless matrix[row][col].zero?
  end
end

def set_zeroes_bruteforce(matrix)
  rows = matrix.length
  cols = matrix[0].length
  marker = Float::INFINITY

  (0...rows).each do |row|
    (0...cols).each do |col|
      next unless matrix[row][col].zero?

      mark_row(matrix, row, marker)
      mark_column(matrix, col, marker)
    end
  end

  (0...rows).each do |row|
    (0...cols).each do |col|
      matrix[row][col] = 0 if matrix[row][col] == marker
    end
  end
end

#
# Example
#
# matrix = [
#   [1,1,1],
#   [1,0,1],
#   [1,1,1]
# ]
#
# set_zeroes_bruteforce(matrix)
# p matrix
#
# Output
#
# [
#  [1,0,1],
#  [0,0,0],
#  [1,0,1]
# ]
#
# ------------------------------------------------------------
# 4. Bottleneck Analysis
# ------------------------------------------------------------
#
# Suppose there are K zeros.
#
# For every zero we again traverse
#
# - entire row
# - entire column
#
# Many rows and columns are visited repeatedly.
#
# Example
#
# 0 0 0
#
# The first row gets scanned three different times.
#
# Likewise the columns are scanned repeatedly.
#
# This repeated work causes
#
# O(m * n * (m + n))
#
# We need a way to remember which rows and columns must
# become zero without scanning them repeatedly.
#
# ------------------------------------------------------------
# 5. Optimization Journey
# ------------------------------------------------------------
#
# Observation 1
# -------------
#
# Instead of immediately modifying rows and columns,
# simply remember
#
# - which rows contain a zero
# - which columns contain a zero
#
# Then in a second traversal, make every cell zero whose
# row OR column has been marked.
#
# This removes repeated row/column scans.
#
# Time:
# O(mn)
#
# Space:
# O(m+n)
#
# Can we improve space?
#
# ------------------------------------------------------------
#
# Observation 2
# -------------
#
# The row markers and column markers themselves occupy
#
# O(m+n)
#
# But notice something interesting.
#
# The matrix already has
#
# - first row
# - first column
#
# These can store exactly the same information.
#
# Example
#
# Original
#
# 1 1 1
# 1 0 1
# 1 1 1
#
# After finding zero at (1,1)
#
# 1 0 1
# 0 0 1
# 1 1 1
#
# Now
#
# matrix[1][0] tells us
# Row 1 should become zero.
#
# matrix[0][1] tells us
# Column 1 should become zero.
#
# No extra arrays needed.
#
# ------------------------------------------------------------
#
# Observation 3
# -------------
#
# There is one problem.
#
# Cell (0,0) belongs to
#
# - first row
# - first column
#
# It cannot represent both.
#
# Therefore we use one extra boolean
#
# first_col_zero
#
# to remember whether the first column itself
# must become zero.
#
# ------------------------------------------------------------
#
# Observation 4
# -------------
#
# When applying the markers,
# we must traverse from
#
# bottom-right
#
# instead of
#
# top-left.
#
# Why?
#
# Because the first row and first column contain
# the marker information.
#
# If we overwrite them too early,
# later cells lose their markers.
#
# Traversing backwards guarantees markers remain
# available until every cell has been processed.
#
# ------------------------------------------------------------
# 6. Dry Run
# ------------------------------------------------------------
#
# Input
#
# [
#  [1,1,1],
#  [1,0,1],
#  [1,1,1]
# ]
#
# Initial
#
# first_col_zero = false
#
# -----------------------
# First Pass
# -----------------------
#
# At (1,1)
#
# Found zero.
#
# Store markers.
#
# matrix becomes
#
# [
#  [1,0,1],
#  [0,0,1],
#  [1,1,1]
# ]
#
# Meaning
#
# Row 1 -> zero
#
# Column 1 -> zero
#
# -----------------------
# Second Pass
# -----------------------
#
# Start from bottom-right.
#
# Cell (2,2)
#
# Row marker = 1
# Column marker = 1
#
# Keep 1.
#
# -----------------------
#
# Cell (2,1)
#
# Column marker is zero.
#
# Become zero.
#
# -----------------------
#
# Cell (1,2)
#
# Row marker is zero.
#
# Become zero.
#
# -----------------------
#
# Cell (1,1)
#
# Already zero.
#
# -----------------------
#
# Cell (1,0)
#
# First column handled later.
#
# -----------------------
#
# Finish.
#
# Result
#
# [
#  [1,0,1],
#  [0,0,0],
#  [1,0,1]
# ]
#
# ------------------------------------------------------------
# 7. Optimal Solution
# ------------------------------------------------------------
#
# Algorithm
#
# 1. Maintain one boolean
#
#       first_col_zero
#
# 2. Traverse matrix.
#
#       Whenever matrix[i][j] == 0
#
#       mark
#
#       matrix[i][0]
#       matrix[0][j]
#
# 3. Traverse matrix from bottom-right.
#
#       If row marker or column marker is zero,
#       set current cell to zero.
#
# 4. Finally update first column using
#    first_col_zero.
#
# Time Complexity
#
# O(mn)
#
# Every cell is visited twice.
#
# Space Complexity
#
# O(1)
#
# Only one boolean variable is used.
#
# ------------------------------------------------------------
# 8. Optimal Code
# ------------------------------------------------------------

def set_zeroes(matrix)
  rows = matrix.length
  cols = matrix[0].length

  first_col_zero = false

  # First pass: use first row and first column as markers.
  (0...rows).each do |row|
    first_col_zero = true if matrix[row][0].zero?

    (1...cols).each do |col|
      next unless matrix[row][col].zero?

      matrix[row][0] = 0
      matrix[0][col] = 0
    end
  end

  # Second pass: process from bottom-right to preserve markers.
  (rows - 1).downto(0) do |row|
    (cols - 1).downto(1) do |col|
      matrix[row][col] = 0 if matrix[row][0].zero? || matrix[0][col].zero?
    end

    matrix[row][0] = 0 if first_col_zero
  end
end

#
# ------------------------------------------------------------
# Example 1
# ------------------------------------------------------------
#
# matrix = [
#   [1,1,1],
#   [1,0,1],
#   [1,1,1]
# ]
#
# set_zeroes(matrix)
#
# p matrix
#
# Output
#
# [
#  [1,0,1],
#  [0,0,0],
#  [1,0,1]
# ]
#
# ------------------------------------------------------------
# Example 2
# ------------------------------------------------------------
#
# matrix = [
#   [0,1,2,0],
#   [3,4,5,2],
#   [1,3,1,5]
# ]
#
# set_zeroes(matrix)
#
# p matrix
#
# Output
#
# [
#  [0,0,0,0],
#  [0,4,5,0],
#  [0,3,1,0]
# ]
#
