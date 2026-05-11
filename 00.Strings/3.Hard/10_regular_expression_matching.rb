# frozen_string_literal: true

# LeetCode 10: Regular Expression Matching
#
# Problem:
# Given an input string s and a pattern p, implement regular expression matching
# with support for '.' (matches any single character) and '*' (matches zero or
# more of the preceding element).
# The matching should cover the entire input string.
#
# Examples:
#   Input:  s = "aa", p = "a*"
#   Output: true
#   Why:    "a*" means zero or more 'a's. Matching two 'a's -> true.
#
#   Input:  s = "mississippi", p = "mis*is*p*."
#   Output: false
#   Why:    The pattern can't fully cover "mississippi" — the trailing 'i' is unmatched.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursive: handle each position in s and p, try all '*' possibilities.
#
#    Time Complexity: O((m+n) * 2^(m+n)) worst case
#    Space Complexity: O(m+n)
#
# 2. Bottleneck
#    Exponential blowup from re-exploring the same (i,j) states.
#
# 3. Optimized Accepted Approach
#    2D DP: dp[i][j] = true if s[0..i-1] matches p[0..j-1].
#    If p[j-1] == '*': match zero occurrences (dp[i][j-2])
#                   OR match one more (dp[i-1][j] if s[i-1] matches p[j-2])
#    If p[j-1] == '.' or p[j-1] == s[i-1]: dp[i][j] = dp[i-1][j-1]
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "aa", p = "a*"
# dp[0][0]=T, dp[0][2]: '*' matches zero 'a' → dp[0][0]=T
# dp[1][2]: 'a'=='a' → dp[0][2] or dp[0][0]=T → T
# dp[2][2]: 'a'=='a' → dp[1][2]=T → T
# Result: true
#
# Edge Cases:
# - p = ".*"      -> matches everything
# - p = "" s = "" -> true
# - consecutive * patterns like "a*b*" work via zero-match chains

def is_match_brute(s, p)
  memo = {}

  match = ->(i, j) {
    return memo[[i, j]] if memo.key?([i, j])
    return i == s.length if j == p.length

    first_match = i < s.length && (p[j] == s[i] || p[j] == '.')

    memo[[i, j]] = if j + 1 < p.length && p[j + 1] == '*'
                     # '*' can match zero or more of p[j]
                     match.call(i, j + 2) || (first_match && match.call(i + 1, j))
                   else
                     first_match && match.call(i + 1, j + 1)
                   end
  }

  match.call(0, 0)
end

def is_match(s, p)
  m = s.length
  n = p.length

  # dp[i][j] = does s[0..i-1] match p[0..j-1]?
  dp = Array.new(m + 1) { Array.new(n + 1, false) }
  dp[0][0] = true # empty matches empty

  # Patterns like a*, a*b*, a*b*c* can match empty string
  (2..n).each do |j|
    dp[0][j] = p[j - 1] == '*' && dp[0][j - 2]
  end

  (1..m).each do |i|
    (1..n).each do |j|
      if p[j - 1] == '*'
        # Zero occurrences of p[j-2]: skip the "x*" pattern entirely
        dp[i][j] = dp[i][j - 2]
        # One or more occurrences: if p[j-2] matches s[i-1]
        if p[j - 2] == '.' || p[j - 2] == s[i - 1]
          dp[i][j] ||= dp[i - 1][j]
        end
      elsif p[j - 1] == '.' || p[j - 1] == s[i - 1]
        # Direct character or dot match
        dp[i][j] = dp[i - 1][j - 1]
      end
    end
  end

  dp[m][n]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{is_match_brute('aa', 'a*')}"   # true
  puts "Optimized:   #{is_match('aa', 'a*')}"         # true
  puts "Brute force: #{is_match_brute('aab', 'c*a*b')}" # true
  puts "Optimized:   #{is_match('aab', 'c*a*b')}"       # true
  puts "Brute force: #{is_match_brute('mississippi', 'mis*is*p*.')}" # false
  puts "Optimized:   #{is_match('mississippi', 'mis*is*p*.')}"       # false
end
