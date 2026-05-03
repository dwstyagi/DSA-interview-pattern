# frozen_string_literal: true

# LeetCode 70: Climbing Stairs
#
# Problem:
# You're climbing a staircase with n steps. Each time you can climb 1 or 2 steps.
# In how many distinct ways can you climb to the top?
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursion: ways(n) = ways(n-1) + ways(n-2). Base: ways(0)=1, ways(1)=1.
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Overlapping subproblems. Memoize or use bottom-up DP.
#
# 3. Optimized Accepted Approach
#    DP: only need previous two values. O(n) time, O(1) space.
#    Same as Fibonacci: dp[i] = dp[i-1] + dp[i-2].
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=4: dp[0]=1, dp[1]=1, dp[2]=2, dp[3]=3, dp[4]=5
# ways: {1,1,1,1}, {1,1,2}, {1,2,1}, {2,1,1}, {2,2} -> 5 ways
#
# Edge Cases:
# - n=1: 1 way
# - n=2: 2 ways (1+1 or 2)

def climb_stairs_brute(n)
  memo = {}
  rec = lambda do |k|
    return 1 if k <= 1
    memo[k] ||= rec.call(k - 1) + rec.call(k - 2)
  end
  rec.call(n)
end

def climb_stairs(n)
  prev2 = 1
  prev1 = 1
  (2..n).each do
    prev2, prev1 = prev1, prev1 + prev2
  end
  prev1
end

if __FILE__ == $PROGRAM_NAME
  puts climb_stairs_brute(4)  # 5
  puts climb_stairs(10)       # 89
end
