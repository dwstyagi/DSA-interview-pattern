# frozen_string_literal: true

# LeetCode 1143: Longest Common Subsequence
#
# Problem:
# Given text1 and text2, return the length of their longest common subsequence.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all subsequences of text1, check if each is a subsequence of text2.
#    Time Complexity: O(2^m * n)
#    Space Complexity: O(m)
#
# 2. Bottleneck
#    DP: dp[i][j] = LCS of text1[0..i-1] and text2[0..j-1].
#    If chars match: dp[i][j] = dp[i-1][j-1] + 1. Else max of two predecessors.
#
# 3. Optimized Accepted Approach
#    Single row DP with prev variable for O(min(m,n)) space.
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(min(m, n))
#
# -----------------------------------------------------------------------------
# Dry Run
#
# text1="abcde", text2="ace"
# dp: 2D with [0..m][0..n]
# text1[0]='a', text2[0]='a' match -> dp[1][1]=1
# text2[1]='c': text1[2]='c' match -> dp[3][2]=2
# text2[2]='e': text1[4]='e' match -> dp[5][3]=3
# Result: 3
#
# Edge Cases:
# - No common characters: 0
# - One string is subsequence of other: length of shorter

def longest_common_subsequence_brute(text1, text2)
  memo = {}
  rec = lambda do |i, j|
    return 0 if i == text1.length || j == text2.length
    memo[[i, j]] ||= if text1[i] == text2[j]
                       1 + rec.call(i + 1, j + 1)
                     else
                       [rec.call(i + 1, j), rec.call(i, j + 1)].max
                     end
  end
  rec.call(0, 0)
end

def longest_common_subsequence(text1, text2)
  m = text1.length
  n = text2.length
  dp = Array.new(n + 1, 0)
  (1..m).each do |i|
    prev = 0
    (1..n).each do |j|
      temp = dp[j]
      dp[j] = if text1[i - 1] == text2[j - 1]
                prev + 1
              else
                [dp[j], dp[j - 1]].max
              end
      prev = temp
    end
  end
  dp[n]
end

if __FILE__ == $PROGRAM_NAME
  puts longest_common_subsequence_brute('abcde', 'ace')  # 3
  puts longest_common_subsequence('abc', 'abc')           # 3
end
