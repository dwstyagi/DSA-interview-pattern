# frozen_string_literal: true

# LeetCode 64: Minimum Path Sum
#
# Problem:
# Given m×n grid of non-negative integers, find path from top-left to bottom-right
# minimizing sum. Can only move right or down.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursion: min_sum(r,c) = grid[r][c] + min(down, right).
#    Time Complexity: O(2^(m+n))
#    Space Complexity: O(m+n)
#
# 2. Bottleneck
#    DP: dp[r][c] = grid[r][c] + min(dp[r-1][c], dp[r][c-1]).
#
# 3. Optimized Accepted Approach
#    In-place DP: modify grid. Or single row DP.
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(1) in-place
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[[1,3,1],[1,5,1],[4,2,1]]
# in-place: [1,4,5],[2,7,6],[6,8,7]
# Result: 7
#
# Edge Cases:
# - 1×1: return grid[0][0]
# - Single row: prefix sums

def min_path_sum_brute(grid)
  m = grid.length
  n = grid[0].length
  memo = {}
  rec = lambda do |r, c|
    return grid[r][c] if r == m - 1 && c == n - 1
    memo[[r, c]] ||= begin
      down  = r + 1 < m ? rec.call(r + 1, c) : Float::INFINITY
      right = c + 1 < n ? rec.call(r, c + 1) : Float::INFINITY
      grid[r][c] + [down, right].min
    end
  end
  rec.call(0, 0)
end

def min_path_sum(grid)
  m = grid.length
  n = grid[0].length
  grid = grid.map(&:dup)
  (1...m).each { |r| grid[r][0] += grid[r - 1][0] }
  (1...n).each { |c| grid[0][c] += grid[0][c - 1] }
  (1...m).each { |r| (1...n).each { |c| grid[r][c] += [grid[r - 1][c], grid[r][c - 1]].min } }
  grid[m - 1][n - 1]
end

if __FILE__ == $PROGRAM_NAME
  puts min_path_sum_brute([[1, 3, 1], [1, 5, 1], [4, 2, 1]])  # 7
  puts min_path_sum([[1, 2, 3], [4, 5, 6]])                    # 12
end
