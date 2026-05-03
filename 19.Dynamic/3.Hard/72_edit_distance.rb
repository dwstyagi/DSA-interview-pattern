# frozen_string_literal: true

# LeetCode 72: Edit Distance
#
# Problem:
# Given words word1 and word2, return minimum operations (insert, delete, replace)
# to convert word1 to word2.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursion: ed(i,j) = min of insert, delete, replace at each position.
#    Time Complexity: O(3^(m+n))
#    Space Complexity: O(m+n)
#
# 2. Bottleneck
#    DP: dp[i][j] = edit distance of word1[0..i-1] to word2[0..j-1].
#
# 3. Optimized Accepted Approach
#    dp[i][j]: if chars match = dp[i-1][j-1]. Else min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])+1.
#    Space optimize to single row.
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(min(m, n))
#
# -----------------------------------------------------------------------------
# Dry Run
#
# word1="horse", word2="ros"
# dp row 0: [0,1,2,3]
# 'h': [1,1,2,3] (h!=r: min(0,1,1)+1=1; h!=o: ...; h!=s: ...)
# ... ends with dp[5][3]=3
# Result: 3
#
# Edge Cases:
# - One empty string: length of other
# - Same strings: 0

def min_distance_brute(word1, word2)
  memo = {}
  rec = lambda do |i, j|
    return j if i == 0
    return i if j == 0
    memo[[i, j]] ||= if word1[i - 1] == word2[j - 1]
                       rec.call(i - 1, j - 1)
                     else
                       [rec.call(i - 1, j), rec.call(i, j - 1), rec.call(i - 1, j - 1)].min + 1
                     end
  end
  rec.call(word1.length, word2.length)
end

def min_distance(word1, word2)
  m = word1.length
  n = word2.length
  dp = Array.new(n + 1) { |j| j }
  (1..m).each do |i|
    prev = dp[0]
    dp[0] = i
    (1..n).each do |j|
      temp = dp[j]
      dp[j] = if word1[i - 1] == word2[j - 1]
                prev
              else
                [dp[j], dp[j - 1], prev].min + 1
              end
      prev = temp
    end
  end
  dp[n]
end

if __FILE__ == $PROGRAM_NAME
  puts min_distance_brute('horse', 'ros')  # 3
  puts min_distance('intention', 'execution')  # 5
end
