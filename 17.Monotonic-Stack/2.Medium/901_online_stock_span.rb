# frozen_string_literal: true

# LeetCode 901: Online Stock Span
#
# Problem:
# Design a class that collects stock prices day by day and returns the span:
# number of consecutive days (including today) with price <= today's price.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Store all prices. On each call, scan backwards to count span.
#    Time Complexity: O(n) per call, O(n^2) total
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Repeated backward scans. Monotonic decreasing stack stores (price, span) pairs.
#    When today >= stack top, accumulate span and pop.
#
# 3. Optimized Accepted Approach
#    Monotonic stack of [price, span]. On next(price): pop all with price <= current,
#    accumulate their spans. Push [price, total_span]. Return total_span.
#
#    Time Complexity: O(1) amortized per call
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# next(100): stack=[[100,1]], return 1
# next(80):  80<100, stack=[[100,1],[80,1]], return 1
# next(60):  stack=[[100,1],[80,1],[60,1]], return 1
# next(70):  70>60 -> pop [60,1], span=1+1=2; 70<80, push [70,2], return 2
# next(60):  60<70, push, return 1
# next(75):  75>60 -> pop, span=2; 75>70 -> pop, span=2+2=4; 75<80, push [75,4], return 4
# next(85):  85>75 -> pop(4); 85>80 -> pop(1); 85<100, push [85,6], return 6
#
# Edge Cases:
# - Strictly decreasing prices: each span = 1
# - Strictly increasing: spans = 1, 2, 3, ...

class StockSpannerBrute
  def initialize
    @prices = []
  end

  def next(price)
    @prices << price
    span = 1
    i = @prices.length - 2
    while i >= 0 && @prices[i] <= price
      span += 1
      i -= 1
    end
    span
  end
end

class StockSpanner
  def initialize
    @stack = []  # [price, span]
  end

  def next(price)
    span = 1
    span += @stack.pop[1] while !@stack.empty? && @stack.last[0] <= price
    @stack << [price, span]
    span
  end
end

if __FILE__ == $PROGRAM_NAME
  ss = StockSpanner.new
  [100, 80, 60, 70, 60, 75, 85].each { |p| print "#{ss.next(p)} " }
  puts  # 1 1 1 2 1 4 6
end
