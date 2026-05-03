# frozen_string_literal: true

# LeetCode 304: Range Sum Query 2D - Immutable
#
# Problem:
# Given a 2D matrix, handle multiple sumRegion(r1,c1,r2,c2) queries that
# return the sum of elements inside the rectangle from (r1,c1) to (r2,c2).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each query, iterate all cells in the rectangle and sum.
#    Time Complexity: O(m*n) per query
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Each query scans potentially all cells.
#
# 3. Optimized Accepted Approach
#    2D prefix sum using inclusion-exclusion:
#    prefix[i+1][j+1] = mat[i][j] + prefix[i][j+1] + prefix[i+1][j] - prefix[i][j]
#    rect sum = prefix[r2+1][c2+1] - prefix[r1][c2+1] - prefix[r2+1][c1] + prefix[r1][c1]
#    Time Complexity: O(m*n) build, O(1) query
#    Space Complexity: O(m*n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# matrix = [[3,0,1,4,2],[5,6,3,2,1],[1,2,0,1,5],[4,1,0,1,7],[1,0,3,0,5]]
# sumRegion(2,1,4,3):
# = prefix[5][4] - prefix[2][4] - prefix[5][1] + prefix[2][1]
# = 58 - 24 - 8 + 8 = 8
#
# Edge Cases:
# - Single cell query → returns that cell value
# - Entire matrix query → total sum

class NumMatrix2DBrute
  def initialize(matrix)
    @matrix = matrix
  end

  def sum_region(row1, col1, row2, col2)
    total = 0
    (row1..row2).each { |r| (col1..col2).each { |c| total += @matrix[r][c] } }
    total
  end
end

class NumMatrix2D
  def initialize(matrix)
    m = matrix.length
    n = matrix[0].length
    @prefix = Array.new(m + 1) { Array.new(n + 1, 0) }

    (0...m).each do |i|
      (0...n).each do |j|
        @prefix[i + 1][j + 1] = matrix[i][j] +
                                 @prefix[i][j + 1] +
                                 @prefix[i + 1][j] -
                                 @prefix[i][j]   # inclusion-exclusion
      end
    end
  end

  def sum_region(row1, col1, row2, col2)
    @prefix[row2 + 1][col2 + 1] -
      @prefix[row1][col2 + 1] -
      @prefix[row2 + 1][col1] +
      @prefix[row1][col1]
  end
end

if __FILE__ == $PROGRAM_NAME
  mat = [[3, 0, 1, 4, 2], [5, 6, 3, 2, 1], [1, 2, 0, 1, 5], [4, 1, 0, 1, 7], [1, 0, 3, 0, 5]]
  brute = NumMatrix2DBrute.new(mat)
  opt   = NumMatrix2D.new(mat)
  puts "Brute: #{brute.sum_region(2, 1, 4, 3)}"  # 8
  puts "Opt:   #{opt.sum_region(2, 1, 4, 3)}"    # 8
  puts "Brute: #{brute.sum_region(1, 1, 2, 2)}"  # 11
  puts "Opt:   #{opt.sum_region(1, 1, 2, 2)}"    # 11
end
