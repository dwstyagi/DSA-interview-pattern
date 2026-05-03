# frozen_string_literal: true

# LeetCode 1092: Shortest Common Supersequence
#
# Problem:
# Return the shortest string that has both str1 and str2 as subsequences.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Find LCS of str1 and str2. Merge both strings around LCS.
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n)
#
# 2. Bottleneck
#    Need LCS to build SCS. Then reconstruct the merged string.
#
# 3. Optimized Accepted Approach
#    Build LCS DP table. Backtrack to reconstruct SCS:
#    - If chars match: include once, move diagonally.
#    - Else: include char from the side with larger dp value, move that pointer.
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# str1="abac", str2="cab"
# LCS="ab" (or "ab"), SCS="cabac"
# Backtrack: str1[3]='c', str2[2]='b' dp[4][3]=4,dp[3][3]=4? -> backtrack
# Result: "cabac"
#
# Edge Cases:
# - One empty string: return the other
# - Same strings: return either

def shortest_common_supersequence_brute(str1, str2)
  m = str1.length
  n = str2.length
  dp = Array.new(m + 1) { Array.new(n + 1, 0) }
  (1..m).each do |i|
    (1..n).each do |j|
      dp[i][j] = str1[i - 1] == str2[j - 1] ? dp[i - 1][j - 1] + 1 : [dp[i - 1][j], dp[i][j - 1]].max
    end
  end
  # Reconstruct
  i = m
  j = n
  result = []
  while i > 0 && j > 0
    if str1[i - 1] == str2[j - 1]
      result << str1[i - 1]
      i -= 1; j -= 1
    elsif dp[i - 1][j] > dp[i][j - 1]
      result << str1[i - 1]; i -= 1
    else
      result << str2[j - 1]; j -= 1
    end
  end
  result << str1[0...i] << str2[0...j]
  result.join.reverse
end

# optimized: same approach (LCS + backtrack is optimal)
def shortest_common_supersequence(str1, str2)
  shortest_common_supersequence_brute(str1, str2)
end

if __FILE__ == $PROGRAM_NAME
  puts shortest_common_supersequence_brute('abac', 'cab')  # "cabac"
  puts shortest_common_supersequence('aaaaaaaa', 'aaaaaaaa')  # "aaaaaaaa"
end
