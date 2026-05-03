# frozen_string_literal: true

# LeetCode 74: Search a 2D Matrix
#
# Problem:
# Given an m x n matrix where each row is sorted and the first integer of each
# row is greater than the last integer of the previous row, search for target.
# Return true if found.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Linear scan all cells.
#    Time Complexity: O(m*n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(m*n) ignores sorted structure.
#
# 3. Optimized Accepted Approach
#    Treat matrix as a flat sorted array of m*n elements.
#    Binary search with flat index i: row = i/n, col = i%n.
#    Time Complexity: O(log(m*n))
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# matrix=[[1,3,5,7],[10,11,16,20],[23,30,34,60]], target=3
# m=3,n=4, total=12
# l=0,r=11: mid=5, flat[5]=11 > 3 → r=4
# l=0,r=4: mid=2, flat[2]=5 > 3 → r=1
# l=0,r=1: mid=0, flat[0]=1 < 3 → l=1
# l=r=1, flat[1]=3==3 → true ✓
#
# Edge Cases:
# - Target less than first element → false
# - Target greater than last element → false

def search_matrix_brute(matrix, target)
  matrix.any? { |row| row.include?(target) }
end

def search_matrix(matrix, target)
  m = matrix.length
  n = matrix[0].length
  l = 0
  r = m * n - 1

  while l <= r
    mid = (l + r) / 2
    val = matrix[mid / n][mid % n]   # convert flat index to 2D

    if val == target
      return true
    elsif val < target
      l = mid + 1
    else
      r = mid - 1
    end
  end

  false
end

if __FILE__ == $PROGRAM_NAME
  mat = [[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]]
  puts "Brute: #{search_matrix_brute(mat, 3)}"    # true
  puts "Opt:   #{search_matrix(mat, 3)}"          # true
  puts "Brute: #{search_matrix_brute(mat, 13)}"   # false
  puts "Opt:   #{search_matrix(mat, 13)}"         # false
end
