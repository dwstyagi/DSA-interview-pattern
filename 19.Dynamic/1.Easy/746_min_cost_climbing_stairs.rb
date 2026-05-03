# frozen_string_literal: true

# LeetCode 746: Min Cost Climbing Stairs
#
# Problem:
# Array cost where cost[i] is the cost of step i. You can start from step 0 or 1.
# From step i, you can climb 1 or 2 steps. Return minimum cost to reach the top.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursion: min_cost(i) = cost[i] + min(min_cost(i+1), min_cost(i+2)).
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Overlapping subproblems. DP: dp[i] = min(dp[i-1], dp[i-2]) + cost[i].
#
# 3. Optimized Accepted Approach
#    Bottom-up DP with O(1) space. Track last two steps.
#    Answer is min(prev1, prev2) (can step from either of last two positions to top).
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# cost = [10, 15, 20]
# dp[0]=10, dp[1]=15, dp[2]=20+min(10,15)=30
# answer = min(15, 30) = 15
# Path: start at 1, pay 15, jump 2 steps to top
#
# Edge Cases:
# - 2 steps: min of two costs
# - All zeros: 0

def min_cost_climbing_stairs_brute(cost)
  n = cost.length
  memo = {}
  rec = lambda do |i|
    return 0 if i >= n
    memo[i] ||= cost[i] + [rec.call(i + 1), rec.call(i + 2)].min
  end
  [rec.call(0), rec.call(1)].min
end

def min_cost_climbing_stairs(cost)
  prev2 = cost[0]
  prev1 = cost[1]
  (2...cost.length).each do |i|
    prev2, prev1 = prev1, cost[i] + [prev1, prev2].min
  end
  [prev1, prev2].min
end

if __FILE__ == $PROGRAM_NAME
  puts min_cost_climbing_stairs_brute([10, 15, 20])  # 15
  puts min_cost_climbing_stairs([1, 100, 1, 1, 1, 100, 1, 1, 100, 1])  # 6
end
