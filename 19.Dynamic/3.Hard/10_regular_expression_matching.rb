# frozen_string_literal: true

# LeetCode 10: Regular Expression Matching
#
# Problem:
# Implement regex matching with '.' (any single char) and '*' (zero or more of preceding).
# Return true if pattern matches entire string.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursion: handle '.' and '*' cases by branching.
#    Time Complexity: O(m * n) with memo
#    Space Complexity: O(m * n)
#
# 2. Bottleneck
#    Recursion with memoization is essentially DP. Convert to bottom-up.
#
# 3. Optimized Accepted Approach
#    dp[i][j] = does s[0..i-1] match p[0..j-1].
#    If p[j-1]!='*': dp[i][j] = dp[i-1][j-1] && (s[i-1]==p[j-1] || p[j-1]=='.').
#    If p[j-1]=='*': dp[i][j] = dp[i][j-2] (zero occurrences)
#                              || dp[i-1][j] if s[i-1] matches p[j-2].
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s="aab", p="c*a*b"
# dp[0][0]=T; dp[0][2]=T (c* = 0 c's); dp[0][4]=T (a* = 0 a's)
# dp[1][2]: s[0]='a', p[1]='*' -> dp[1][0]=F or dp[0][2]&&'a' matches 'c'=F -> F
# dp[1][3]: p[2]='a' matches s[0]='a', dp[0][2]=T -> T
# ... dp[3][5]=T -> true
#
# Edge Cases:
# - Empty pattern: only matches empty string
# - Pattern with only '*': invalid (must have char before *)

def is_match_brute?(s, p)
  return s.empty? if p.empty?
  first = !s.empty? && (p[0] == '.' || p[0] == s[0])
  if p.length >= 2 && p[1] == '*'
    is_match_brute?(s, p[2..]) || (first && is_match_brute?(s[1..], p))
  else
    first && is_match_brute?(s[1..], p[1..])
  end
end

def is_match?(s, p)
  m = s.length
  n = p.length
  dp = Array.new(m + 1) { Array.new(n + 1, false) }
  dp[0][0] = true
  (1..n).each { |j| dp[0][j] = j >= 2 && p[j - 1] == '*' && dp[0][j - 2] }
  (1..m).each do |i|
    (1..n).each do |j|
      dp[i][j] = if p[j - 1] == '*'
                   dp[i][j - 2] || (dp[i - 1][j] && (p[j - 2] == '.' || p[j - 2] == s[i - 1]))
                 else
                   dp[i - 1][j - 1] && (p[j - 1] == '.' || p[j - 1] == s[i - 1])
                 end
    end
  end
  dp[m][n]
end

if __FILE__ == $PROGRAM_NAME
  puts is_match_brute?('aa', 'a')      # false
  puts is_match_brute?('aa', 'a*')     # true
  puts is_match?('aab', 'c*a*b')       # true
  puts is_match?('mississippi', 'mis*is*p*.')  # false
end
