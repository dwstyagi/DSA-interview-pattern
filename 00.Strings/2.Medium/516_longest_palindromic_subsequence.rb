# frozen_string_literal: true

# LeetCode 516: Longest Palindromic Subsequence
#
# Problem:
# Given a string s, find the longest palindromic subsequence's length in s.
# A subsequence is a sequence derived from another sequence by deleting some elements
# without changing the order of the remaining elements.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all subsequences, check each if palindrome, track the max length.
#
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Exponential generation is wasteful; overlapping subproblems exist.
#
# 3. Optimized Accepted Approach
#    The LPS of s equals the LCS of s and reverse(s).
#    Use 2D DP: dp[i][j] = longest palindromic subsequence in s[i..j].
#    Transition: if s[i]==s[j] → dp[i][j] = dp[i+1][j-1] + 2
#               else           → dp[i][j] = max(dp[i+1][j], dp[i][j-1])
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n^2)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "bbbab"
# dp table (bottom-up by length):
# len=1: dp[i][i]=1 for all i
# len=2: dp[0][1]: s[0]='b'==s[1]='b' → 2
#         dp[1][2]: s[1]='b'==s[2]='b' → 2
#         dp[2][3]: s[2]='b'!=s[3]='a' → max(dp[3][3],dp[2][2])=1
#         dp[3][4]: s[3]='a'!=s[4]='b' → 1
# ...
# dp[0][4] = 4
#
# Edge Cases:
# - Single char   -> 1
# - All same      -> n
# - No palindrome -> 1

def longest_palindromic_subsequence_brute(s)
  # LPS = LCS of s and its reverse (top-down memoized)
  t = s.reverse
  n = s.length
  memo = {}

  lcs = ->(i, j) {
    return 0 if i >= n || j >= n
    return memo[[i, j]] if memo.key?([i, j])

    memo[[i, j]] = if s[i] == t[j]
                     1 + lcs.call(i + 1, j + 1)
                   else
                     [lcs.call(i + 1, j), lcs.call(i, j + 1)].max
                   end
  }

  lcs.call(0, 0)
end

def longest_palindromic_subsequence(s)
  n = s.length
  # dp[i][j] = LPS length in s[i..j]
  dp = Array.new(n) { Array.new(n, 0) }

  # Base case: single characters are palindromes of length 1
  (0...n).each { |i| dp[i][i] = 1 }

  # Fill by increasing substring length
  (2..n).each do |len|
    (0..n - len).each do |i|
      j = i + len - 1
      if s[i] == s[j]
        # Matching ends: add 2 to the inner palindrome length
        dp[i][j] = (len == 2 ? 0 : dp[i + 1][j - 1]) + 2
      else
        # Take the best by excluding either end
        dp[i][j] = [dp[i + 1][j], dp[i][j - 1]].max
      end
    end
  end

  dp[0][n - 1]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{longest_palindromic_subsequence_brute('bbbab')}" # 4
  puts "Optimized:   #{longest_palindromic_subsequence('bbbab')}"       # 4
  puts "Brute force: #{longest_palindromic_subsequence_brute('cbbd')}"  # 2
  puts "Optimized:   #{longest_palindromic_subsequence('cbbd')}"        # 2
end
