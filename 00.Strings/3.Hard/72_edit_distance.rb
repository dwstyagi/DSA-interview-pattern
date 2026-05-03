# frozen_string_literal: true

# LeetCode 72: Edit Distance
#
# Problem:
# Given two strings word1 and word2, return the minimum number of operations
# (insert, delete, replace) to convert word1 to word2.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursive: at each position, try all three operations + no-op, take minimum.
#
#    Time Complexity: O(3^(m+n))
#    Space Complexity: O(m+n)
#
# 2. Bottleneck
#    Massive overlapping subproblems — same (i,j) computed repeatedly.
#
# 3. Optimized Accepted Approach
#    2D DP: dp[i][j] = min edits to convert word1[0..i-1] to word2[0..j-1].
#    If chars match: dp[i][j] = dp[i-1][j-1]
#    Else: dp[i][j] = 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])
#                       (delete,          insert,       replace)
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n) → reducible to O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# word1 = "horse", word2 = "ros"
# dp[0][j] = j (delete all of word2's chars)
# dp[i][0] = i (insert all of word1's chars)
# i=1('h'): j=1('r'): no match → 1+min(dp[0][1],dp[1][0],dp[0][0])=1+1=2
#   ...
# dp[5][3] = 3
#
# Edge Cases:
# - Either string empty -> length of the other
# - Identical strings   -> 0

def min_distance_brute(word1, word2)
  memo = {}

  recurse = ->(i, j) {
    return j if i == 0 # insert j chars
    return i if j == 0 # delete i chars
    return memo[[i, j]] if memo.key?([i, j])

    memo[[i, j]] = if word1[i - 1] == word2[j - 1]
                     recurse.call(i - 1, j - 1) # no operation needed
                   else
                     1 + [
                       recurse.call(i - 1, j),     # delete from word1
                       recurse.call(i, j - 1),     # insert into word1
                       recurse.call(i - 1, j - 1)  # replace
                     ].min
                   end
  }

  recurse.call(word1.length, word2.length)
end

def min_distance(word1, word2)
  m = word1.length
  n = word2.length

  # dp[i][j] = edit distance for word1[0..i-1] vs word2[0..j-1]
  dp = Array.new(m + 1) { Array.new(n + 1, 0) }

  # Base cases: converting to/from empty string
  (0..m).each { |i| dp[i][0] = i }
  (0..n).each { |j| dp[0][j] = j }

  (1..m).each do |i|
    (1..n).each do |j|
      if word1[i - 1] == word2[j - 1]
        dp[i][j] = dp[i - 1][j - 1] # characters match, no operation needed
      else
        dp[i][j] = 1 + [
          dp[i - 1][j],     # delete char from word1
          dp[i][j - 1],     # insert char into word1
          dp[i - 1][j - 1]  # replace char
        ].min
      end
    end
  end

  dp[m][n]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{min_distance_brute('horse', 'ros')}" # 3
  puts "Optimized:   #{min_distance('horse', 'ros')}"       # 3
  puts "Brute force: #{min_distance_brute('intention', 'execution')}" # 5
  puts "Optimized:   #{min_distance('intention', 'execution')}"       # 5
end
