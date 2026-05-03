# frozen_string_literal: true

# LeetCode 703: Kth Largest Element in a Stream
#
# Problem:
# Design a class that finds the kth largest element in a stream.
# KthLargest(k, nums) initializes with k and an initial list.
# add(val) appends val to the stream and returns the kth largest element.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Store all elements; on each add(), sort and return element at index -k.
#    Time Complexity: O(n log n) per add call
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Full sort on every add is wasteful — we only need the kth largest.
#
# 3. Optimized Accepted Approach
#    Maintain a min-heap of size k. The root is always the kth largest.
#    On add: push the new value; if heap size > k, pop the minimum.
#    The root of the min-heap is the kth largest element.
#    Time Complexity: O(log k) per add
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# k=3, nums=[4,5,8,2]
# Init heap (size-3 min-heap): sorted asc [4,5,8] → heap root = 4
# add(3): [4,5,8] → push 3 → [3,4,5,8] → pop min → [4,5,8] → return 4
# add(5): push 5 → [4,5,5,8] → pop min → [5,5,8] → return 5
# add(10): push 10 → [5,5,8,10] → pop min → [5,8,10] → return 5
# add(9):  push 9 → [5,8,9,10] → pop min → [8,9,10] → return 8
#
# Edge Cases:
# - k=1 → return max element each time
# - nums empty at init → first k adds build the heap

class KthLargestBrute
  def initialize(k, nums)
    @k = k
    @data = nums.dup
  end

  def add(val)
    @data << val
    @data.sort[-@k]   # return kth largest via sort
  end
end

class KthLargest
  def initialize(k, nums)
    @k = k
    @heap = []              # min-heap simulated with sorted array

    nums.each { |n| add(n) }
  end

  def add(val)
    # Insert into sorted array maintaining ascending order
    idx = @heap.bsearch_index { |v| v >= val } || @heap.size
    @heap.insert(idx, val)
    @heap.shift if @heap.size > @k  # pop minimum (front of sorted array)
    @heap.first                      # root of min-heap = kth largest
  end
end

if __FILE__ == $PROGRAM_NAME
  brute = KthLargestBrute.new(3, [4, 5, 8, 2])
  puts "Brute: #{brute.add(3)}"   # 4
  puts "Brute: #{brute.add(5)}"   # 5
  puts "Brute: #{brute.add(10)}"  # 5
  puts "Brute: #{brute.add(9)}"   # 8
  puts "Brute: #{brute.add(4)}"   # 8

  opt = KthLargest.new(3, [4, 5, 8, 2])
  puts "Opt:   #{opt.add(3)}"   # 4
  puts "Opt:   #{opt.add(5)}"   # 5
  puts "Opt:   #{opt.add(10)}"  # 5
  puts "Opt:   #{opt.add(9)}"   # 8
  puts "Opt:   #{opt.add(4)}"   # 8
end
