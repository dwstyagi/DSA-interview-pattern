# frozen_string_literal: true

# LeetCode 1475: Final Prices With a Special Discount in a Shop
#
# Problem:
# prices[i] = price of item i. Discount for item i = prices[j] where j > i
# and prices[j] <= prices[i] (first such j). Return final prices after discounts.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each item, scan right for first item with price <= current.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Repeated right-scan. Monotonic stack finds next-smaller-or-equal efficiently.
#
# 3. Optimized Accepted Approach
#    Monotonic non-increasing stack of indices. When prices[i] <= prices[stack.top],
#    pop and apply discount.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# prices = [8, 4, 6, 2, 3]
# i=0(8): stack=[0]
# i=1(4): 4<=8 -> result[0]=8-4=4, pop; push 1 -> stack=[1]
# i=2(6): 6>4 -> push 2 -> stack=[1,2]
# i=3(2): 2<=6 -> result[2]=6-2=4, pop; 2<=4 -> result[1]=4-2=2, pop; push 3
# i=4(3): 3>2 -> push 4 -> stack=[3,4]
# No discount for remaining: result=[4,2,4,2,3]
#
# Edge Cases:
# - Strictly increasing: no discounts
# - Single item: no discount

def final_prices_brute(prices)
  n = prices.length
  result = prices.dup
  n.times do |i|
    (i + 1...n).each do |j|
      if prices[j] <= prices[i]
        result[i] -= prices[j]
        break
      end
    end
  end
  result
end

def final_prices(prices)
  result = prices.dup
  stack = []
  prices.each_with_index do |p, i|
    while !stack.empty? && prices[stack.last] >= p
      result[stack.pop] -= p
    end
    stack << i
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  puts final_prices_brute([8, 4, 6, 2, 3]).inspect  # [4,2,4,2,3]
  puts final_prices([1, 2, 3, 4, 5]).inspect         # [1,2,3,4,5]
end
