# frozen_string_literal: true

# LeetCode 115: Distinct Subsequences
#
# Problem:
# Given strings s and t, return the number of distinct subsequences of s equal to t.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursion: for each char in s, decide to match with t[j] or skip.
#    Time Complexity: O(2^m)
#    Space Complexity: O(m)
#
# 2. Bottleneck
#    DP: dp[i][j] = number of ways s[0..i-1] contains t[0..j-1] as subsequence.
#
# 3. Optimized Accepted Approach
#    1D DP (iterate j in reverse to avoid overwriting).
#    dp[j] = ways to form t[0..j-1] from s processed so far.
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s="rabbbit", t="rabbit"
# dp starts as [1,0,0,0,0,0,0]
# For each char in s, update dp from right to left
# Result: 3 (three ways: each 'b' can be the "extra" one)
#
# Edge Cases:
# - t empty: 1 (empty subsequence always matches)
# - s shorter than t: 0

def num_distinct_brute(s, t)
  memo = {}
  rec = lambda do |i, j|
    return 1 if j == t.length
    return 0 if i == s.length
    memo[[i, j]] ||= rec.call(i + 1, j) + (s[i] == t[j] ? rec.call(i + 1, j + 1) : 0)
  end
  rec.call(0, 0)
end

def num_distinct(s, t)
  n = t.length
  dp = Array.new(n + 1, 0)
  dp[0] = 1
  s.each_char do |c|
    n.downto(1) do |j|
      dp[j] += dp[j - 1] if c == t[j - 1]
    end
  end
  dp[n]
end

if __FILE__ == $PROGRAM_NAME
  puts num_distinct_brute('rabbbit', 'rabbit')  # 3
  puts num_distinct('babgbag', 'bag')            # 5
end
