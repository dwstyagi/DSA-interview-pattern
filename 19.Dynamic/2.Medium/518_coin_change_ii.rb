# frozen_string_literal: true

# LeetCode 518: Coin Change II
#
# Problem:
# Given coins array and amount, return the number of combinations to make the amount.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursion: try each coin, count all combinations.
#    Time Complexity: O(n^amount) with duplicates
#    Space Complexity: O(amount)
#
# 2. Bottleneck
#    Unbounded knapsack DP: dp[a] += dp[a - coin] for each coin (process coin-by-coin).
#
# 3. Optimized Accepted Approach
#    dp[0]=1 (one way to make 0). For each coin, update dp[coin..amount]:
#    dp[a] += dp[a-coin]. Coin-outer, amount-inner avoids counting permutations.
#
#    Time Complexity: O(n * amount)
#    Space Complexity: O(amount)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# coins=[1,2,5], amount=5
# After coin 1: dp=[1,1,1,1,1,1]
# After coin 2: dp=[1,1,2,2,3,3]
# After coin 5: dp=[1,1,2,2,3,4]
# dp[5] = 4
#
# Edge Cases:
# - amount=0: 1 combination (use no coins)
# - No valid combination: 0

def change_brute(amount, coins)
  memo = {}
  rec = lambda do |rem, idx|
    return 1 if rem == 0
    return 0 if rem < 0 || idx >= coins.length
    memo[[rem, idx]] ||= rec.call(rem - coins[idx], idx) + rec.call(rem, idx + 1)
  end
  rec.call(amount, 0)
end

def change(amount, coins)
  dp = Array.new(amount + 1, 0)
  dp[0] = 1
  coins.each do |coin|
    (coin..amount).each { |a| dp[a] += dp[a - coin] }
  end
  dp[amount]
end

if __FILE__ == $PROGRAM_NAME
  puts change_brute(5, [1, 2, 5])  # 4
  puts change(3, [2])              # 0
end
