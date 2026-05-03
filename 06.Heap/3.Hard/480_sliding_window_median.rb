# frozen_string_literal: true

# LeetCode 480: Sliding Window Median
#
# Problem:
# Given an array nums and integer k, return an array of the medians of each
# sliding window of size k.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each window of size k, sort the window and find the median.
#    Time Complexity: O(n * k log k)
#    Space Complexity: O(k)
#
# 2. Bottleneck
#    Re-sorting the entire window on every slide is wasteful.
#
# 3. Optimized Accepted Approach
#    Two heaps (lo max-heap, hi min-heap) + lazy deletion hash.
#    On slide: add new element, remove outgoing element via lazy delete.
#    Lazy delete: track elements to delete in a hash; skip them when they
#    surface to the top of a heap.
#    Time Complexity: O(n log k)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[1,3,-1,-3,5,3,6,7], k=3
# Window [1,3,-1]: sorted=[-1,1,3] → median=1
# Window [3,-1,-3]: sorted=[-3,-1,3] → median=-1
# ...
#
# Edge Cases:
# - k=1 → each element is its own median
# - k=n → single median of all elements

def median_sliding_window_brute(nums, k)
  result = []
  (0..nums.length - k).each do |i|
    window = nums[i, k].sort
    result << (k.odd? ? window[k / 2].to_f : (window[k / 2 - 1] + window[k / 2]) / 2.0)
  end
  result
end

def median_sliding_window(nums, k)
  result = []
  # lo: descending sorted (max at front), hi: ascending sorted (min at front)
  lo = []
  hi = []
  to_delete = Hash.new(0)

  add = ->(num) {
    if lo.empty? || num <= lo[0]
      idx = lo.bsearch_index { |v| v <= num } || lo.size
      lo.insert(idx, num)
    else
      idx = hi.bsearch_index { |v| v >= num } || hi.size
      hi.insert(idx, num)
    end
  }

  rebalance = -> {
    # clean stale tops
    lo.shift while !lo.empty? && to_delete[lo[0]] > 0 && to_delete[lo[0]] > (to_delete[lo[0]] -= 1; 0)
    hi.shift while !hi.empty? && to_delete[hi[0]] > 0 && to_delete[hi[0]] > (to_delete[hi[0]] -= 1; 0)

    if lo.size > hi.size + 1
      val = lo.shift
      idx = hi.bsearch_index { |v| v >= val } || hi.size
      hi.insert(idx, val)
    elsif hi.size > lo.size
      val = hi.shift
      idx = lo.bsearch_index { |v| v <= val } || lo.size
      lo.insert(idx, val)
    end
  }

  get_median = -> {
    k.odd? ? lo[0].to_f : (lo[0] + hi[0]) / 2.0
  }

  # Build initial window
  nums[0, k].each { |n| add.call(n) }
  rebalance.call
  result << get_median.call

  (k...nums.length).each do |i|
    incoming = nums[i]
    outgoing = nums[i - k]

    add.call(incoming)
    to_delete[outgoing] += 1

    # clean stale tops
    lo.shift while !lo.empty? && to_delete[lo[0]] > 0 && (to_delete[lo[0]] -= 1; true)
    hi.shift while !hi.empty? && to_delete[hi[0]] > 0 && (to_delete[hi[0]] -= 1; true)

    rebalance.call
    result << get_median.call
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{median_sliding_window_brute([1, 3, -1, -3, 5, 3, 6, 7], 3).inspect}"
  # [1.0, -1.0, -1.0, 3.0, 5.0, 6.0]
  puts "Opt:   #{median_sliding_window([1, 3, -1, -3, 5, 3, 6, 7], 3).inspect}"
end
