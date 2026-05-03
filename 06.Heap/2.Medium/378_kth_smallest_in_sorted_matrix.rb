# frozen_string_literal: true

# LeetCode 378: Kth Smallest Element in a Sorted Matrix
#
# Problem:
# Given an n x n matrix where each row and column is sorted in ascending order,
# return the kth smallest element in the matrix.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Flatten the matrix, sort, return element at index k-1.
#    Time Complexity: O(n² log n²) = O(n² log n)
#    Space Complexity: O(n²)
#
# 2. Bottleneck
#    Ignores sorted structure; sorting all n² elements is wasteful.
#
# 3. Optimized Accepted Approach
#    Min-heap: push first element of each row with its row/col indices.
#    Pop k times: each pop yields the next smallest; push next element in
#    that row. The kth pop is the answer.
#    Time Complexity: O(k log n)
#    Space Complexity: O(n) for heap
#
# -----------------------------------------------------------------------------
# Dry Run
#
# matrix = [[1,5,9],[10,11,13],[12,13,15]], k=8
# Heap init: [(1,0,0),(10,1,0),(12,2,0)]
# Pop 1 → push (5,0,1); heap [(5,0,1),(10,1,0),(12,2,0)]
# Pop 5 → push (9,0,2); heap [(9,0,2),(10,1,0),(12,2,0)]
# Pop 9 → no more in row 0; heap [(10,1,0),(12,2,0)]
# Pop 10 → push (11,1,1); heap [(11,1,1),(12,2,0)]
# Pop 11 → push (13,1,2); heap [(12,2,0),(13,1,2)]
# Pop 12 → push (13,2,1); heap [(13,1,2),(13,2,1)]
# Pop 13 → 7th smallest; push (15,2,2); heap [(13,2,1),(15,2,2)]
# Pop 13 → 8th smallest = answer = 13
#
# Edge Cases:
# - 1x1 matrix → return matrix[0][0]
# - k=1 → return matrix[0][0] (top-left is always minimum)

def kth_smallest_brute(matrix, k)
  matrix.flatten.sort[k - 1]
end

def kth_smallest(matrix, k)
  n = matrix.length
  # min-heap: [value, row, col]
  heap = (0...n).map { |r| [matrix[r][0], r, 0] }.sort

  result = nil
  k.times do
    val, r, c = heap.shift   # pop minimum

    result = val

    if c + 1 < n
      new_entry = [matrix[r][c + 1], r, c + 1]
      idx = heap.bsearch_index { |v| v[0] >= new_entry[0] } || heap.size
      heap.insert(idx, new_entry)
    end
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  matrix = [[1, 5, 9], [10, 11, 13], [12, 13, 15]]
  puts "Brute: #{kth_smallest_brute(matrix, 8)}"  # 13
  puts "Opt:   #{kth_smallest(matrix, 8)}"        # 13
  puts "Brute: #{kth_smallest_brute([[-5]], 1)}"  # -5
  puts "Opt:   #{kth_smallest([[-5]], 1)}"        # -5
end
