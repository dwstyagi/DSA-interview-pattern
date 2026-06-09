# frozen_string_literal: true

# LeetCode 703: Kth Largest Element in a Stream
#
# Problem:
# Design a class that finds the kth largest element in a stream.
# KthLargest(k, nums) initializes with k and an initial list.
# add(val) appends val to the stream and returns the kth largest element.
#
# Examples:
#   Input:  k=3, nums=[4,5,8,2], add(3),add(5),add(10),add(9),add(4)
#   Output: 4,5,5,8,8
#   Why:    Min-heap of size k tracks the k largest; heap top is always kth largest.
#
#   Input:  k=1, nums=[1,2], add(3)
#   Output: 3
#   Why:    k=1 means largest element; after adding 3, heap top = 3.
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
# -----------------------------

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Keep every number in an array
# - On each add(val):
#   1. append val
#   2. sort the whole array in descending order
#   3. return the k-th largest element
#
# Time per add: O(n log n)
# Space: O(n)
class KthLargestBruteForce
  def initialize(k, nums)
    @k = k
    @numbers = nums.dup
  end

  def add(val)
    # Add the new value into the stream
    @numbers << val

    # Sort descending so largest elements come first
    sorted_numbers = @numbers.sort.reverse

    # k-th largest is at index k - 1
    sorted_numbers[@k - 1]
  end
end

# -----------------------------
# OPTIMIZED MIN-HEAP SOLUTION
# -----------------------------
# Idea:
# - Maintain a min heap containing only the largest k elements seen so far
# - If heap size grows beyond k, remove the smallest element
# - Then the heap root is the k-th largest element
#
# Why min heap?
# - among the top k elements, the smallest one is exactly the k-th largest
#
# Time per add: O(log k)
# Space: O(k)
require 'algorithms'
class KthLargest
  def initialize(k, nums)
    @size = k
    @min_heap = Containers::MinHeap.new

    # Build the heap using initial numbers
    nums.each do |num|
      @min_heap.push(num)
      @min_heap.pop if @min_heap.size > @size
    end
  end

  def add(val)
    # Add new value into heap
    @min_heap.push(val)

    # If heap has more than k elements,
    # remove the smallest one
    # so only the largest k elements remain
    @min_heap.pop if @min_heap.size > @size

    # Root of min heap is the k-th largest element
    @min_heap.next
  end
end

if __FILE__ == $PROGRAM_NAME
  brute = KthLargestBruteForce.new(3, [4, 5, 8, 2])
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
