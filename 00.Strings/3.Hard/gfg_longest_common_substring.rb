# frozen_string_literal: true

# GFG: Longest Common Substring
#
# Problem:
# Given two strings s1 and s2, find the length of the longest substring
# common to both strings. A substring must be contiguous (unlike subsequence).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every substring of s1 against s2 using contains check.
#
#    Time Complexity: O(n^3)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Redundant work comparing substrings. Use DP to avoid re-checking.
#
# 3. Optimized Accepted Approach
#    2D DP: dp[i][j] = length of longest common substring ending at s1[i-1] and s2[j-1].
#    If s1[i-1] == s2[j-1]: dp[i][j] = dp[i-1][j-1] + 1 → extend the match
#    Else:                   dp[i][j] = 0               → reset (must be contiguous)
#    Track the global maximum.
#
#    Key difference from LCS: we RESET to 0 on mismatch (contiguous requirement).
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n) → reducible to O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s1 = "abcde", s2 = "abfce"
# dp[1][1]: 'a'=='a' → dp[0][0]+1=1
# dp[2][2]: 'b'=='b' → dp[1][1]+1=2
# dp[3][3]: 'c'!='f' → 0
# dp[3][4]: 'c'!='c' (different indices) ...
# max = 2 ("ab")
#
# Edge Cases:
# - No common chars    -> 0
# - One string is other -> length of shorter
# - All same chars     -> min(m,n)

def longest_common_substring_brute(s1, s2)
  max_len = 0

  (0...s1.length).each do |i|
    (0...s2.length).each do |j|
      len = 0
      # Extend match as long as chars agree
      len += 1 while i + len < s1.length && j + len < s2.length && s1[i + len] == s2[j + len]
      max_len = [max_len, len].max
    end
  end

  max_len
end

def longest_common_substring(s1, s2)
  m = s1.length
  n = s2.length
  max_len = 0

  # dp[i][j] = length of common substring ending at s1[i-1] and s2[j-1]
  dp = Array.new(m + 1) { Array.new(n + 1, 0) }

  (1..m).each do |i|
    (1..n).each do |j|
      if s1[i - 1] == s2[j - 1]
        # Characters match: extend the previous common substring by 1
        dp[i][j] = dp[i - 1][j - 1] + 1
        max_len = [max_len, dp[i][j]].max
      else
        # No match: reset to 0 (substring must be contiguous)
        dp[i][j] = 0
      end
    end
  end

  max_len
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{longest_common_substring_brute('abcde', 'abfce')}" # 2
  puts "Optimized:   #{longest_common_substring('abcde', 'abfce')}"       # 2
  puts "Brute force: #{longest_common_substring_brute('GeeksforGeeks', 'GeeksQuiz')}" # 5
  puts "Optimized:   #{longest_common_substring('GeeksforGeeks', 'GeeksQuiz')}"       # 5
end
