# frozen_string_literal: true

# LeetCode 309: Best Time to Buy and Sell Stock with Cooldown
#
# Problem:
# With prices array, maximize profit. After selling, must wait one day (cooldown).
# Can hold at most one share.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    State machine recursion: held, sold, cooldown, rest states.
#    Time Complexity: O(n) with memo
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    States: held (own stock), sold (just sold), rest (cooled down).
#    Transition: held -> hold or sell. sold -> rest. rest -> rest or buy.
#
# 3. Optimized Accepted Approach
#    Three variables: held, sold, rest (max profit in each state).
#    held[i] = max(held[i-1], rest[i-1] - price)
#    sold[i] = held[i-1] + price
#    rest[i] = max(rest[i-1], sold[i-1])
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# prices = [1, 2, 3, 0, 2]
# held=-inf, sold=0, rest=0
# price=1: held=max(-inf,0-1)=-1, sold=0+1? no, prev_held=-inf+1 ignore, rest=max(0,0)=0
# Actually: held=max(held, rest-price), sold=prev_held+price, rest=max(rest,sold)
# i=0(1): new_held=max(-inf,-1)=-1, new_sold=-inf+1(skip), rest=0
# i=1(2): new_held=max(-1,0-2)=-1, new_sold=-1+2=1, rest=max(0,0)=0
# i=2(3): held=-1, sold=-1+3=2, rest=max(0,1)=1
# i=3(0): held=max(-1,1-0)=1, sold=-1+0=-1, rest=max(1,2)=2
# i=4(2): held=max(1,2-2)=1, sold=1+2=3, rest=max(2,-1)=2
# Result: max(rest,sold) = max(2,3) = 3
#
# Edge Cases:
# - Single price: can't sell, profit=0
# - Monotonically decreasing: profit=0

def max_profit_with_cooldown_brute(prices)
  memo = {}
  rec = lambda do |i, holding|
    return 0 if i >= prices.length
    key = [i, holding]
    return memo[key] if memo.key?(key)
    memo[key] = if holding
                  sell = prices[i] + rec.call(i + 2, false)  # sell, then cooldown
                  hold = rec.call(i + 1, true)               # keep holding
                  [sell, hold].max
                else
                  buy = rec.call(i + 1, true) - prices[i]   # buy
                  skip = rec.call(i + 1, false)              # skip
                  [buy, skip].max
                end
  end
  rec.call(0, false)
end

def max_profit_with_cooldown(prices)
  held = -Float::INFINITY
  sold = 0
  rest = 0
  prices.each do |price|
    prev_sold = sold
    sold = held + price
    held = [held, rest - price].max
    rest = [rest, prev_sold].max
  end
  [sold, rest].max
end

if __FILE__ == $PROGRAM_NAME
  puts max_profit_with_cooldown_brute([1, 2, 3, 0, 2])  # 3
  puts max_profit_with_cooldown([1])                     # 0
end
