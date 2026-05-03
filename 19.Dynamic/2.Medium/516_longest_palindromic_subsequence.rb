# frozen_string_literal: true

# LeetCode 516: Longest Palindromic Subsequence
#
# Problem:
# Given string s, return the length of the longest palindromic subsequence.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all subsequences of s, check if palindrome, track max length.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    LPS(s) = LCS(s, reverse(s)). Use the LCS DP.
#
# 3. Optimized Accepted Approach
#    LCS of s and its reverse gives LPS length.
#    Or: dp[i][j] = LPS of s[i..j]. If s[i]==s[j]: dp[i][j] = dp[i+1][j-1]+2.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n^2) or O(n) with optimization
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "bbbab"
# LCS("bbbab", "babbb") = 4 -> "bbbb"
#
# Edge Cases:
# - All same chars: n
# - Already palindrome: n

def longest_palindrome_subseq_brute(s)
  lcs = lambda do |s1, s2|
    m, n = s1.length, s2.length
    dp = Array.new(m + 1) { Array.new(n + 1, 0) }
    (1..m).each do |i|
      (1..n).each do |j|
        dp[i][j] = s1[i - 1] == s2[j - 1] ? dp[i - 1][j - 1] + 1 : [dp[i - 1][j], dp[i][j - 1]].max
      end
    end
    dp[m][n]
  end
  lcs.call(s, s.reverse)
end

def longest_palindrome_subseq(s)
  n = s.length
  dp = Array.new(n) { Array.new(n, 0) }
  n.times { |i| dp[i][i] = 1 }
  (2..n).each do |len|
    (0..n - len).each do |i|
      j = i + len - 1
      dp[i][j] = s[i] == s[j] ? dp[i + 1][j - 1] + 2 : [dp[i + 1][j], dp[i][j - 1]].max
    end
  end
  dp[0][n - 1]
end

if __FILE__ == $PROGRAM_NAME
  puts longest_palindrome_subseq_brute('bbbab')  # 4
  puts longest_palindrome_subseq('cbbd')          # 2
end
