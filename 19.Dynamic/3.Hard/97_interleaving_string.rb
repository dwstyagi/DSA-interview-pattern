# frozen_string_literal: true

# LeetCode 97: Interleaving String
#
# Problem:
# Given s1, s2, s3, return true if s3 is formed by interleaving s1 and s2
# while maintaining relative order of characters from each.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursion: try taking next char from s1 or s2.
#    Time Complexity: O(2^(m+n))
#    Space Complexity: O(m+n)
#
# 2. Bottleneck
#    DP: dp[i][j] = can s3[0..i+j-1] be formed from s1[0..i-1] and s2[0..j-1].
#
# 3. Optimized Accepted Approach
#    1D DP: dp[j] = can s3[0..i+j-1] be formed from s1[0..i-1] and s2[0..j-1].
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s1="aab", s2="axy", s3="aaxaby"
# dp[0][0]=T
# dp[i][j]: if s1[i-1]==s3[i+j-1] && dp[i-1][j] -> T
#           if s2[j-1]==s3[i+j-1] && dp[i][j-1] -> T
# Result: true
#
# Edge Cases:
# - s1 or s2 empty: s3 must equal the other
# - Lengths don't match: false

def is_interleave_brute?(s1, s2, s3)
  return s3.empty? if s1.empty? && s2.empty?
  return false if s1.length + s2.length != s3.length
  memo = {}
  rec = lambda do |i, j|
    return true if i == s1.length && j == s2.length
    key = [i, j]
    return memo[key] if memo.key?(key)
    k = i + j
    memo[key] = (i < s1.length && s1[i] == s3[k] && rec.call(i + 1, j)) ||
                (j < s2.length && s2[j] == s3[k] && rec.call(i, j + 1))
  end
  rec.call(0, 0)
end

def is_interleave?(s1, s2, s3)
  m = s1.length
  n = s2.length
  return false if m + n != s3.length
  dp = Array.new(n + 1, false)
  dp[0] = true
  (1..n).each { |j| dp[j] = dp[j - 1] && s2[j - 1] == s3[j - 1] }
  (1..m).each do |i|
    dp[0] = dp[0] && s1[i - 1] == s3[i - 1]
    (1..n).each do |j|
      dp[j] = (dp[j] && s1[i - 1] == s3[i + j - 1]) ||
              (dp[j - 1] && s2[j - 1] == s3[i + j - 1])
    end
  end
  dp[n]
end

if __FILE__ == $PROGRAM_NAME
  puts is_interleave_brute?('aabcc', 'dbbca', 'aadbbcbcac')  # true
  puts is_interleave?('aabcc', 'dbbca', 'aadbbbaccc')         # false
end
