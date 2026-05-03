# frozen_string_literal: true

# LeetCode 73: Set Matrix Zeroes
#
# Problem:
# Given an m x n integer matrix, if an element is 0, set its entire row and
# column to 0's. Do it in place.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Collect all zero positions first, then zero out all their rows and cols.
#    Time Complexity: O(m*n*(m+n))
#    Space Complexity: O(k) — k zero cells
#
# 2. Bottleneck
#    Extra space for tracking zero positions — use first row/col as markers.
#
# 3. Optimized Accepted Approach
#    Use the first row and first column as flag arrays. Track separately whether
#    row0 and col0 themselves should be zeroed.
#    Time Complexity: O(m*n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# matrix = [[1,1,1],[1,0,1],[1,1,1]]
# row0_zero=false, col0_zero=false
# scan: matrix[1][1]=0 → mark matrix[1][0]=0, matrix[0][1]=0
# apply: row 1 → [0,0,0], col 1 → matrix[0][1]=0, matrix[2][1]=0
# result = [[1,0,1],[0,0,0],[1,0,1]] ✓
#
# Edge Cases:
# - Zero in first row -> entire first row becomes 0
# - Zero in first col -> entire first col becomes 0
# - All zeros -> all zeros

def set_zeroes_brute(matrix)
  zeros = []
  matrix.each_with_index do |row, r|
    row.each_with_index { |v, c| zeros << [r, c] if v.zero? }
  end
  zeros.each do |r, c|
    matrix[r].fill(0)                                        # zero out row
    matrix.each_with_index { |row, _| row[c] = 0 }          # zero out col
  end
end

def set_zeroes(matrix)
  m, n      = matrix.length, matrix[0].length
  row0_zero = matrix[0].any?(&:zero?)   # does row 0 need to be zeroed?
  col0_zero = matrix.any? { |row| row[0].zero? } # does col 0 need zeroing?

  # use row 0 and col 0 as markers for rows/cols 1..m-1 and 1..n-1
  (1...m).each do |r|
    (1...n).each do |c|
      if matrix[r][c].zero?
        matrix[r][0] = 0   # mark row r
        matrix[0][c] = 0   # mark col c
      end
    end
  end

  # apply markers from row 0 and col 0
  (1...m).each do |r|
    (1...n).each do |c|
      matrix[r][c] = 0 if matrix[r][0].zero? || matrix[0][c].zero?
    end
  end

  matrix[0].fill(0) if row0_zero      # zero first row if needed
  m.times { |r| matrix[r][0] = 0 } if col0_zero # zero first col if needed
end

if __FILE__ == $PROGRAM_NAME
  m1 = [[1, 1, 1], [1, 0, 1], [1, 1, 1]]
  set_zeroes(m1)
  puts "Opt: #{m1.inspect}"  # [[1,0,1],[0,0,0],[1,0,1]]

  m2 = [[0, 1, 2, 0], [3, 4, 5, 2], [1, 3, 1, 5]]
  set_zeroes(m2)
  puts "Opt: #{m2.inspect}"  # [[0,0,0,0],[0,4,5,0],[0,3,1,0]]
end
