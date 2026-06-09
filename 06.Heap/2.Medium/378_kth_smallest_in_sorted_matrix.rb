# frozen_string_literal: true

# LeetCode 378: Kth Smallest Element in a Sorted Matrix
#
# Problem:
# Given an n x n matrix where each row and each column is sorted in ascending
# order, return the kth smallest element in the matrix.
#
# Important:
# - Duplicates count separately.
# - It is not asking for kth distinct value.
#
# Example:
#   Input:
#   matrix = [
#     [1,  5,  9],
#     [10, 11, 13],
#     [12, 13, 15]
#   ]
#   k = 8
#
#   Output: 13
#
#   Why:
#   Sorted values:
#   [1, 5, 9, 10, 11, 12, 13, 13, 15]
#   The 8th smallest value is 13.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. Brute Force
#    Flatten matrix into one array, sort it, return nums[k - 1].
#    Time Complexity: O(n^2 log(n^2))
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    We sort every value, but we only need the kth smallest value.
#
# 3. Optimized Min-Heap Approach
#    Treat every matrix row as a sorted list.
#    Push the first value of each useful row into MinHeap.
#    Pop the smallest value k times.
#    Whenever we pop from a row, push the next value from the same row.
#    Time Complexity: O(k log min(n, k))
#    Space Complexity: O(min(n, k))
#
# -----------------------------------------------------------------------------
# Dry Run
#
# matrix = [
#   [1,  5,  9],
#   [10, 11, 13],
#   [12, 13, 15]
# ]
# k = 8
#
# Treat rows as sorted lists:
#
# Row 0: 1  -> 5  -> 9
# Row 1: 10 -> 11 -> 13
# Row 2: 12 -> 13 -> 15
#
# Initial heap:
# [1,  0, 0]
# [10, 1, 0]
# [12, 2, 0]
#
# Pop 1  -> push 5
# Pop 5  -> push 9
# Pop 9  -> row 0 finished
# Pop 10 -> push 11
# Pop 11 -> push 13
# Pop 12 -> push 13
# Pop 13 -> row 1 finished
# Pop 13 -> kth pop, answer = 13
#
# Edge Cases:
# - matrix has one element
# - k = 1
# - k = n * n
# - duplicate values
# - negative values

require 'algorithms'

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Put every matrix value into one array
# - Sort that array
# - Return value at index k - 1
#
# Time: O(n^2 log(n^2))
# Space: O(n^2)
def kth_smallest_brute_force(matrix, k)
  nums = []

  matrix.each do |row|
    row.each do |num|
      nums << num
    end
  end

  nums.sort[k - 1]
end

# -----------------------------
# OPTIMIZED MIN-HEAP SOLUTION
# -----------------------------
# Idea:
# - Treat each row as a sorted list
# - Push first value of each row into MinHeap
# - Pop smallest value
# - After popping from a row, push next value from same row
# - The kth popped value is the answer
#
# Time: O(k log min(n, k))
# Space: O(min(n, k))
def kth_smallest(matrix, k)
  min_heap = Containers::MinHeap.new

  row_count = matrix.length
  col_count = matrix[0].length

  # Add first value from each useful row.
  #
  # We only need at most k rows because we only pop k values.
  [row_count, k].min.times do |row|
    value = matrix[row][0]

    # Store:
    # [value, row, col]
    #
    # col is 0 because every row starts from first column.
    min_heap.push([value, row, 0])
  end

  answer = nil

  # Pop exactly k times.
  #
  # Each pop gives the next smallest value.
  k.times do
    value, row, col = min_heap.pop
    answer = value

    # Move to next column in the same row.
    next_col = col + 1

    # If row has no more columns, do not push anything.
    next unless next_col < col_count

    next_value = matrix[row][next_col]
    min_heap.push([next_value, row, next_col])
  end

  answer
end

if __FILE__ == $PROGRAM_NAME
  matrix = [
    [1,  5,  9],
    [10, 11, 13],
    [12, 13, 15]
  ]
  k = 8

  puts "Brute: #{kth_smallest_brute_force(matrix, k)}"
  puts "Opt:   #{kth_smallest(matrix, k)}"

  matrix = [[-5]]
  k = 1

  puts "Brute: #{kth_smallest_brute_force(matrix, k)}"
  puts "Opt:   #{kth_smallest(matrix, k)}"
end
