# frozen_string_literal: true

# LeetCode 295: Find Median from Data Stream
#
# Problem:
# Implement a data structure that supports adding integers and finding the
# median of all elements added so far.
# MedianFinder: add_num(num), find_median() → Float
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Keep a sorted array. On add_num: binary insert O(n). On find_median: O(1).
#    Time Complexity: O(n) per add (insertion into sorted array), O(1) find
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Shifting elements for sorted insertion is O(n).
#
# 3. Optimized Accepted Approach
#    Two heaps: max-heap `lo` holds the lower half, min-heap `hi` holds upper half.
#    Invariant: lo.size == hi.size or lo.size == hi.size + 1.
#    Add: push to lo, funnel top of lo to hi, rebalance.
#    Median: lo.size > hi.size → lo.max; else (lo.max + hi.min) / 2.0
#    Time Complexity: O(log n) per add, O(1) find
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# add(1): lo=[1], hi=[]       → median=1.0
# add(2): push 1 to lo, move max(1) to hi=[1], lo=[] → rebalance lo=[] hi=[1,2]?
#         Actually: push 2 to lo=[2], move max(2) to hi=[2], lo=[1] → median=(1+2)/2=1.5
# add(3): push 3 to lo=[3,1], move max(3) to hi=[2,3], rebalance lo=[1] too small
#         → move hi.min(2) to lo=[2,1] → median=lo.max=2.0
#
# Edge Cases:
# - Single element → return it as float
# - Even number of elements → average of two middle elements

class MedianFinderBrute
  def initialize
    @data = []
  end

  def add_num(num)
    idx = @data.bsearch_index { |v| v >= num } || @data.size
    @data.insert(idx, num)
  end

  def find_median
    n = @data.size
    n.odd? ? @data[n / 2].to_f : (@data[n / 2 - 1] + @data[n / 2]) / 2.0
  end
end

class MedianFinder
  def initialize
    @lo = []   # max-heap (lower half) — simulated descending sorted array
    @hi = []   # min-heap (upper half) — simulated ascending sorted array
  end

  def add_num(num)
    # Always push to lo first
    lo_idx = @lo.bsearch_index { |v| v <= num } || @lo.size
    @lo.insert(lo_idx, num)

    # Funnel the largest of lo into hi
    hi_val = @lo.shift   # lo sorted descending, first = max
    hi_idx = @hi.bsearch_index { |v| v >= hi_val } || @hi.size
    @hi.insert(hi_idx, hi_val)

    # Rebalance: lo must not be smaller than hi
    if @hi.size > @lo.size
      lo_val = @hi.shift   # hi sorted ascending, first = min
      lo_idx2 = @lo.bsearch_index { |v| v <= lo_val } || @lo.size
      @lo.insert(lo_idx2, lo_val)
    end
  end

  def find_median
    if @lo.size > @hi.size
      @lo[0].to_f   # lo sorted desc, first = max = median
    else
      (@lo[0] + @hi[0]) / 2.0
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  brute = MedianFinderBrute.new
  brute.add_num(1)
  brute.add_num(2)
  puts "Brute: #{brute.find_median}"   # 1.5
  brute.add_num(3)
  puts "Brute: #{brute.find_median}"   # 2.0

  opt = MedianFinder.new
  opt.add_num(1)
  opt.add_num(2)
  puts "Opt:   #{opt.find_median}"     # 1.5
  opt.add_num(3)
  puts "Opt:   #{opt.find_median}"     # 2.0
end
