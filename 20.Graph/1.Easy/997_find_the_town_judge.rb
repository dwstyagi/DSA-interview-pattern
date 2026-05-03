# frozen_string_literal: true

# LeetCode 997: Find the Town Judge
#
# Problem:
# n people (1..n). trust[i]=[a,b] means a trusts b. Find person trusted by all others
# but trusts nobody. Return that person or -1.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each person, check if trusted by all others and trusts nobody.
#    Time Complexity: O(n^2 + e)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Use in-degree and out-degree. Judge has in-degree n-1 and out-degree 0.
#
# 3. Optimized Accepted Approach
#    Score array: +1 when trusted, -1 when trusting. Judge has score n-1.
#
#    Time Complexity: O(n + e)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=3, trust=[[1,3],[2,3]]
# score: 1=0, 2=0, 3=2
# After trust: 1-=1->-1, 3+=1->1; 2-=1->-1, 3+=1->2
# score[3]=n-1=2 -> return 3
#
# Edge Cases:
# - n=1, no trust edges: return 1 (alone is judge)
# - No judge: return -1

def find_judge_brute(n, trust)
  trusts = Array.new(n + 1, false)
  trusted_by = Array.new(n + 1, 0)
  trust.each do |a, b|
    trusts[a] = true
    trusted_by[b] += 1
  end
  (1..n).find { |i| !trusts[i] && trusted_by[i] == n - 1 } || -1
end

def find_judge(n, trust)
  score = Array.new(n + 1, 0)
  trust.each do |a, b|
    score[a] -= 1
    score[b] += 1
  end
  (1..n).find { |i| score[i] == n - 1 } || -1
end

if __FILE__ == $PROGRAM_NAME
  puts find_judge_brute(3, [[1, 3], [2, 3]])      # 3
  puts find_judge(3, [[1, 3], [2, 3], [3, 1]])    # -1
end
