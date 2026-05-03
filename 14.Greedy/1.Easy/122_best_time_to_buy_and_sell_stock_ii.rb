# frozen_string_literal: true

# LeetCode 122: Best Time to Buy and Sell Stock II
#
# Problem:
# Given prices array where prices[i] is the stock price on day i.
# You may buy and sell on multiple days (but hold at most one share).
# Return the maximum profit.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all possible buy/sell combinations recursively.
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Overlapping subproblems. Observation: the maximum profit equals the sum
#    of all positive daily differences — capture every upward move.
#
# 3. Optimized Accepted Approach
#    Greedy: accumulate every positive price increase (prices[i] - prices[i-1] > 0).
#    Equivalent to buying and selling every consecutive profitable pair.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# prices = [7, 1, 5, 3, 6, 4]
# Day 1->2: 1-7 = -6 (skip)
# Day 2->3: 5-1 = +4 -> profit += 4
# Day 3->4: 3-5 = -2 (skip)
# Day 4->5: 6-3 = +3 -> profit += 3
# Day 5->6: 4-6 = -2 (skip)
# Total profit = 7
#
# Edge Cases:
# - Monotonically decreasing: profit = 0
# - Single day: profit = 0

def max_profit_brute(prices)
  best = 0
  n = prices.length
  (0...n).each do |i|
    (i + 1...n).each do |j|
      # sum of consecutive positive diffs between i and j
      profit = 0
      (i + 1..j).each { |k| profit += [prices[k] - prices[k - 1], 0].max }
      best = [best, profit].max
    end
  end
  best
end

# optimized: greedy sum of all positive consecutive differences
def max_profit(prices)
  profit = 0
  (1...prices.length).each do |i|
    profit += prices[i] - prices[i - 1] if prices[i] > prices[i - 1]
  end
  profit
end

if __FILE__ == $PROGRAM_NAME
  puts max_profit_brute([7, 1, 5, 3, 6, 4])  # 7
  puts max_profit([1, 2, 3, 4, 5])            # 4
end
