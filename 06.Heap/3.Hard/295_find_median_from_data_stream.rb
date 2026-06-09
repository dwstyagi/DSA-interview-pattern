# frozen_string_literal: true

# LeetCode 295: Find Median from Data Stream
#
# Problem:
# Design a data structure that supports two operations:
# - add_num(num): add a number to the data stream
# - find_median(): return the median of all numbers added so far
#
# Examples:
#   Input:  add(1), add(2), find_median(), add(3), find_median()
#   Output: 1.5, 2.0
#   Why:    After [1,2], the median is (1 + 2) / 2 = 1.5.
#           After [1,2,3], the median is 2.0.
#
#   Input:  add(5), add(15), add(1), add(3), find_median()
#   Output: 4.0
#   Why:    Sorted data = [1,3,5,15], median = (3 + 5) / 2 = 4.0.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. Brute Force
#    Keep all numbers in an array.
#    On add_num, append the number.
#    On find_median, sort the array and compute the middle value.
#    Time Complexity: O(1) add, O(n log n) find
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Sorting from scratch every time we ask for the median is expensive.
#
# 3. Optimized Two-Heap Approach
#    Use a MaxHeap for the lower half and a MinHeap for the upper half.
#    Keep the heaps balanced so:
#    - lo.size == hi.size, or
#    - lo.size == hi.size + 1
#    Then the median is:
#    - lo.max when total count is odd
#    - (lo.max + hi.min) / 2.0 when total count is even
#    Time Complexity: O(log n) add, O(1) find
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# add(1):
#   lo = [1], hi = []
#   median = 1.0
#
# add(2):
#   push 2 into lo, move max(2) to hi, rebalance
#   lo = [1], hi = [2]
#   median = (1 + 2) / 2 = 1.5
#
# add(3):
#   push 3 into lo, move max(3) to hi, rebalance back
#   lo = [2,1], hi = [3]
#   median = 2.0
#
# Edge Cases:
# - Single element
# - Even number of elements
# - Negative values
# - Duplicate values

require 'algorithms'

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Store all numbers in an array
# - On find_median, sort the full array
# - Return the middle value or the average of the two middle values
#
# Time:
# - add_num: O(1)
# - find_median: O(n log n)
# Space: O(n)
class MedianFinderBrute
  def initialize
    @nums = []
  end

  def add_num(num)
    @nums << num
  end

  def find_median
    sorted = @nums.sort
    n = sorted.length

    if n.odd?
      sorted[n / 2].to_f
    else
      (sorted[(n / 2) - 1] + sorted[n / 2]) / 2.0
    end
  end
end

# -----------------------------
# OPTIMIZED TWO-HEAP SOLUTION
# -----------------------------
# Idea:
# - MaxHeap `lo` stores the lower half
# - MinHeap `hi` stores the upper half
# - Rebalance after every insertion so `lo` has the same size as `hi`
#   or one extra element
#
# Time:
# - add_num: O(log n)
# - find_median: O(1)
# Space: O(n)
class MedianFinder
  def initialize
    @lower_half = Containers::MaxHeap.new
    @upper_half = Containers::MinHeap.new
  end

  def add_num(num)
    if @lower_half.empty? || num <= @lower_half.max
      @lower_half.push(num)
    else
      @upper_half.push(num)
    end

    rebalance_heaps
  end

  def find_median
    return nil if @lower_half.empty? && @upper_half.empty?

    if @lower_half.size > @upper_half.size
      @lower_half.max.to_f
    else
      (@lower_half.max + @upper_half.min) / 2.0
    end
  end

  private

  def rebalance_heaps
    if @lower_half.size > @upper_half.size + 1
      @upper_half.push(@lower_half.pop)
    elsif @upper_half.size > @lower_half.size
      @lower_half.push(@upper_half.pop)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  brute = MedianFinderBrute.new
  brute.add_num(1)
  brute.add_num(2)
  puts "Brute: #{brute.find_median}" # 1.5
  brute.add_num(3)
  puts "Brute: #{brute.find_median}" # 2.0

  opt = MedianFinder.new
  opt.add_num(1)
  opt.add_num(2)
  puts "Opt:   #{opt.find_median}" # 1.5
  opt.add_num(3)
  puts "Opt:   #{opt.find_median}" # 2.0
end
