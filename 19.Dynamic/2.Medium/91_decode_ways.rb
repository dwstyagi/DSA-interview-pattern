# frozen_string_literal: true

# LeetCode 91: Decode Ways
#
# Problem:
# A message encoded as '1'->'A', '2'->'B', ..., '26'->'Z'.
# Given numeric string s, return the number of ways to decode it.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursion: try taking 1 or 2 digits, recurse on remainder.
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Overlapping subproblems. DP: dp[i] = ways to decode s[0..i-1].
#
# 3. Optimized Accepted Approach
#    dp[i] = dp[i-1] if s[i-1] valid (1-9) + dp[i-2] if s[i-2..i-1] valid (10-26).
#    Track only last two values.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "226"
# dp[0]=1, dp[1]=1 (s[0]='2' valid)
# i=2: s[1]='2' valid -> dp[2]+=dp[1]=1; s[0..1]='22' valid -> dp[2]+=dp[0]=1; dp[2]=2
# i=3: s[2]='6' valid -> dp[3]+=dp[2]=2; s[1..2]='26' valid -> dp[3]+=dp[1]=1; dp[3]=3
# Result: 3
#
# Edge Cases:
# - Leading '0': 0 ways
# - "10": 1 way (only "10"->'J', can't split)
# - "0" alone: 0

def num_decodings_brute(s)
  memo = {}
  rec = lambda do |i|
    return 1 if i == s.length
    return 0 if s[i] == '0'
    memo[i] ||= begin
      ways = rec.call(i + 1)
      ways += rec.call(i + 2) if i + 1 < s.length && s[i..i + 1].to_i <= 26
      ways
    end
  end
  rec.call(0)
end

def num_decodings(s)
  dp2 = 1  # dp[i-2]
  dp1 = s[0] == '0' ? 0 : 1  # dp[i-1]
  (1...s.length).each do |i|
    cur = 0
    cur += dp1 if s[i] != '0'
    two = s[i - 1..i].to_i
    cur += dp2 if two >= 10 && two <= 26
    dp2, dp1 = dp1, cur
  end
  dp1
end

if __FILE__ == $PROGRAM_NAME
  puts num_decodings_brute('226')  # 3
  puts num_decodings('06')         # 0
end
