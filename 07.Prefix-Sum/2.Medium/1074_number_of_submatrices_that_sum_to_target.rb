# frozen_string_literal: true

# LeetCode 1074: Number of Submatrices That Sum to Target
#
# Problem:
# Given a matrix and a target, return the number of non-empty submatrices
# that sum to target.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Enumerate all O(m²*n²) submatrices, compute their sums.
#    Time Complexity: O(m²*n²)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Too many submatrices to enumerate.
#
# 3. Optimized Accepted Approach
#    Fix top and bottom row boundaries (r1, r2). Compress columns into
#    a 1D array (column sums). Apply 1D subarray-sum-equals-target with
#    hash map on this compressed array.
#    Time Complexity: O(m² * n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# matrix = [[0,1,0],[1,1,1],[0,1,0]], target = 0
# Fix r1=0: col_sums=[0,1,0]
#   Apply 1D sum: count subarrays = 0 with sum=0... find 2
# ... (multiple row pair combinations)
# Total = 4
#
# Edge Cases:
# - Single cell → check if cell == target
# - Entire matrix sums to target → counts as 1

def num_submatrix_sum_target_brute(matrix, target)
  m = matrix.length
  n = matrix[0].length
  count = 0

  (0...m).each do |r1|
    (0...n).each do |c1|
      (r1...m).each do |r2|
        (c1...n).each do |c2|
          sum = 0
          (r1..r2).each { |r| (c1..c2).each { |c| sum += matrix[r][c] } }
          count += 1 if sum == target
        end
      end
    end
  end

  count
end

def num_submatrix_sum_target(matrix, target)
  m = matrix.length
  n = matrix[0].length
  count = 0

  (0...m).each do |r1|
    col_sums = Array.new(n, 0)

    (r1...m).each do |r2|
      # accumulate column sums for rows r1..r2
      (0...n).each { |c| col_sums[c] += matrix[r2][c] }

      # now apply 1D subarray sum equals target on col_sums
      freq = { 0 => 1 }
      running = 0

      col_sums.each do |v|
        running += v
        count += (freq[running - target] || 0)
        freq[running] = (freq[running] || 0) + 1
      end
    end
  end

  count
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{num_submatrix_sum_target_brute([[0, 1, 0], [1, 1, 1], [0, 1, 0]], 0)}"  # 4
  puts "Opt:   #{num_submatrix_sum_target([[0, 1, 0], [1, 1, 1], [0, 1, 0]], 0)}"        # 4
  puts "Brute: #{num_submatrix_sum_target_brute([[1, -1], [-1, 1]], 0)}"  # 5
  puts "Opt:   #{num_submatrix_sum_target([[1, -1], [-1, 1]], 0)}"        # 5
end
