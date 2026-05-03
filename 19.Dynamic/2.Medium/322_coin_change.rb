# frozen_string_literal: true

# LeetCode 322: Coin Change
#
# Problem:
# Given coins array and amount, return the fewest number of coins to make amount.
# Return -1 if impossible.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursion: try every coin, recurse on remainder.
#    Time Complexity: O(S^n) where S = amount, n = coins
#    Space Complexity: O(S)
#
# 2. Bottleneck
#    Overlapping subproblems. DP: dp[a] = min coins to make amount a.
#
# 3. Optimized Accepted Approach
#    Bottom-up DP: dp[0]=0, dp[a] = min(dp[a], dp[a-coin]+1) for each coin.
#    Initialize dp with infinity.
#
#    Time Complexity: O(S * n)
#    Space Complexity: O(S)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# coins=[1,2,5], amount=11
# dp=[0,1,1,2,2,1,2,2,3,3,2,3]
# dp[11] = 3 (5+5+1)
#
# Edge Cases:
# - amount=0: 0 coins
# - No valid combination: -1

def coin_change_brute(coins, amount)
  memo = {}
  rec = lambda do |rem|
    return 0 if rem == 0
    return -1 if rem < 0
    return memo[rem] if memo.key?(rem)
    min_c = Float::INFINITY
    coins.each do |c|
      res = rec.call(rem - c)
      min_c = [min_c, res + 1].min if res != -1
    end
    memo[rem] = min_c == Float::INFINITY ? -1 : min_c
  end
  rec.call(amount)
end

def coin_change(coins, amount)
  dp = Array.new(amount + 1, Float::INFINITY)
  dp[0] = 0
  (1..amount).each do |a|
    coins.each { |c| dp[a] = [dp[a], dp[a - c] + 1].min if c <= a }
  end
  dp[amount] == Float::INFINITY ? -1 : dp[amount]
end

if __FILE__ == $PROGRAM_NAME
  puts coin_change_brute([1, 2, 5], 11)  # 3
  puts coin_change([2], 3)               # -1
end
