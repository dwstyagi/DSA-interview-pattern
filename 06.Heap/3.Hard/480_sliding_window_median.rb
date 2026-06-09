# frozen_string_literal: true

# LeetCode 480: Sliding Window Median
#
# Problem:
# Given an integer array nums and an integer k, return the median for each
# sliding window of size k.
#
# The answer should be an array of floating-point values.
#
# Examples:
#   Input:  nums = [1,3,-1,-3,5,3,6,7], k = 3
#   Output: [1.0,-1.0,-1.0,3.0,5.0,6.0]
#   Why:    Each window of size 3 has a median of 1, -1, -1, 3, 5, 6.
#
#   Input:  nums = [1,2,3,4,2,3,1,4,2], k = 3
#   Output: [2.0,3.0,3.0,3.0,2.0,3.0,2.0]
#   Why:    For each window, sort the 3 elements and take the middle value.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. Brute Force
#    For every window of size k, copy the window, sort it, and compute median.
#    Time Complexity: O(n * k log k)
#    Space Complexity: O(k)
#
# 2. Bottleneck
#    Sorting every window from scratch is too expensive because adjacent
#    windows overlap heavily.
#
# 3. Optimized Two-Heap Approach
#    Use a MaxHeap for the lower half and a MinHeap for the upper half.
#    Keep heaps balanced so:
#    - lower_half.size == upper_half.size, or
#    - lower_half.size == upper_half.size + 1
#    Use lazy deletion for values that slide out of the window.
#    Time Complexity: O(n log k)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1,3,-1,-3,5,3,6,7], k = 3
#
# Window [1,3,-1] -> sorted [-1,1,3] -> median 1.0
# Window [3,-1,-3] -> sorted [-3,-1,3] -> median -1.0
# Window [-1,-3,5] -> sorted [-3,-1,5] -> median -1.0
# Window [-3,5,3] -> sorted [-3,3,5] -> median 3.0
# Window [5,3,6] -> sorted [3,5,6] -> median 5.0
# Window [3,6,7] -> sorted [3,6,7] -> median 6.0
#
# Final answer:
# [1.0,-1.0,-1.0,3.0,5.0,6.0]
#
# Edge Cases:
# - k = 1
# - k = nums.length
# - duplicate values
# - negative values

require 'algorithms'

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Take each sliding window
# - Sort the window
# - Pick the middle value or average of two middles
#
# Time: O(n * k log k)
# Space: O(k)
def median_sliding_window_brute_force(nums, k)
  result = []

  (0..(nums.length - k)).each do |start|
    window = nums[start, k].sort

    result << if k.odd?
                window[k / 2].to_f
              else
                ((window[(k / 2) - 1] + window[k / 2]) / 2.0)
              end
  end

  result
end

# -----------------------------
# OPTIMIZED TWO-HEAP SOLUTION
# -----------------------------
# Idea:
# - MaxHeap `lo` stores the lower half of the window
# - MinHeap `hi` stores the upper half
# - Lazy delete values that fall out of the window
# - Rebalance after every insert/remove
#
# Time: O(n log k)
# Space: O(k)
class SlidingWindowMedian
  def initialize
    @lower_half = Containers::MaxHeap.new
    @upper_half = Containers::MinHeap.new
    @delayed = Hash.new(0)
    @lower_half_size = 0
    @upper_half_size = 0
  end

  def add_num(num)
    prune_lower_half
    prune_upper_half

    if @lower_half_size.zero? || num <= @lower_half.max
      @lower_half.push(num)
      @lower_half_size += 1
    else
      @upper_half.push(num)
      @upper_half_size += 1
    end

    rebalance
  end

  def remove_num(num)
    prune_lower_half
    prune_upper_half

    @delayed[num] += 1

    if !@lower_half_size.zero? && num <= @lower_half.max
      @lower_half_size -= 1
      prune_lower_half
    else
      @upper_half_size -= 1
      prune_upper_half
    end

    rebalance
  end

  def median
    prune_lower_half
    prune_upper_half

    if @lower_half_size > @upper_half_size
      @lower_half.max.to_f
    else
      (@lower_half.max + @upper_half.min) / 2.0
    end
  end

  private

  def rebalance
    prune_lower_half
    prune_upper_half

    if @lower_half_size > @upper_half_size + 1
      @upper_half.push(@lower_half.max!)
      @lower_half_size -= 1
      @upper_half_size += 1
      prune_lower_half
    elsif @lower_half_size < @upper_half_size
      @lower_half.push(@upper_half.min!)
      @upper_half_size -= 1
      @lower_half_size += 1
      prune_upper_half
    end
  end

  def prune_lower_half
    while !@lower_half.empty? && @delayed[@lower_half.max].positive?
      value = @lower_half.max!
      @delayed[value] -= 1
      @delayed.delete(value) if @delayed[value].zero?
    end
  end

  def prune_upper_half
    while !@upper_half.empty? && @delayed[@upper_half.min].positive?
      value = @upper_half.min!
      @delayed[value] -= 1
      @delayed.delete(value) if @delayed[value].zero?
    end
  end
end

def median_sliding_window(nums, k)
  return [] if nums.empty? || k <= 0

  window = SlidingWindowMedian.new
  result = []

  nums[0, k].each { |num| window.add_num(num) }
  result << window.median

  (k...nums.length).each do |index|
    window.add_num(nums[index])
    window.remove_num(nums[index - k])
    result << window.median
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{median_sliding_window_brute_force([1, 3, -1, -3, 5, 3, 6, 7], 3).inspect}"
  puts "Opt:   #{median_sliding_window([1, 3, -1, -3, 5, 3, 6, 7], 3).inspect}"

  puts "Brute: #{median_sliding_window_brute_force([1, 2, 3, 4, 2, 3, 1, 4, 2], 3).inspect}"
  puts "Opt:   #{median_sliding_window([1, 2, 3, 4, 2, 3, 1, 4, 2], 3).inspect}"
end
