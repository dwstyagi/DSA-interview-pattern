# frozen_string_literal: true

# LeetCode 62: Unique Paths
#
# Problem:
# Robot on m×n grid, starts at (0,0), wants to reach (m-1,n-1).
# Can only move right or down. Return number of unique paths.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursion: paths(r,c) = paths(r+1,c) + paths(r,c+1).
#    Time Complexity: O(2^(m+n))
#    Space Complexity: O(m+n)
#
# 2. Bottleneck
#    Overlapping subproblems. DP table: dp[r][c] = dp[r-1][c] + dp[r][c-1].
#    Or math: C(m+n-2, m-1).
#
# 3. Optimized Accepted Approach
#    Single row DP: dp[c] = dp[c] + dp[c-1] (dp[c] from row above, dp[c-1] from left).
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# m=3, n=7
# dp = [1,1,1,1,1,1,1]
# row 1: dp = [1,2,3,4,5,6,7]... wait
# row 1: dp[c] += dp[c-1]: [1,2,3,4,5,6,7]
# row 2: [1,3,6,10,15,21,28]
# dp[6] = 28
#
# Edge Cases:
# - m=1 or n=1: only 1 path (straight line)

def unique_paths_brute(m, n)
  memo = {}
  rec = lambda do |r, c|
    return 1 if r == m - 1 || c == n - 1
    memo[[r, c]] ||= rec.call(r + 1, c) + rec.call(r, c + 1)
  end
  rec.call(0, 0)
end

def unique_paths(m, n)
  dp = Array.new(n, 1)
  (m - 1).times do
    (1...n).each { |c| dp[c] += dp[c - 1] }
  end
  dp[-1]
end

if __FILE__ == $PROGRAM_NAME
  puts unique_paths_brute(3, 7)  # 28
  puts unique_paths(3, 2)        # 3
end
