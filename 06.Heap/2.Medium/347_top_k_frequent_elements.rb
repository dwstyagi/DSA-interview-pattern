# frozen_string_literal: true

# LeetCode 347: Top K Frequent Elements
#
# Problem:
# Given an integer array nums and an integer k, return the k most frequent
# elements. The answer can be returned in any order.
#
# Examples:
#   Input:  nums = [1,1,1,2,2,3], k = 2
#   Output: [1,2]
#   Why:    1 appears 3 times, 2 appears 2 times, 3 appears 1 time.
#
#   Input:  nums = [1], k = 1
#   Output: [1]
#   Why:    Only one number exists.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. Brute Force
#    Count frequency of each number, sort all numbers by frequency descending,
#    and return the first k numbers.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Sorting all unique numbers is expensive when we only need top k frequent
#    elements.
#
# 3. Optimized Min-Heap Approach
#    Maintain a min-heap of size k.
#    Heap stores [frequency, number].
#    If heap size becomes greater than k, remove the smallest frequency.
#    At the end, heap contains the k most frequent numbers.
#    Time Complexity: O(n log k)
#    Space Complexity: O(n + k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 1, 1, 2, 2, 3], k = 2
#
# Frequency map:
# 1 => 3
# 2 => 2
# 3 => 1
#
# Process [3, 1]:
# heap = [[3, 1]]
#
# Process [2, 2]:
# heap = [[2, 2], [3, 1]]
#
# Process [1, 3]:
# heap size becomes 3 > k
# pop smallest frequency [1, 3]
# heap = [[2, 2], [3, 1]]
#
# Final heap contains:
# [2, 2] means number 2 appears 2 times
# [3, 1] means number 1 appears 3 times
#
# Answer = [2, 1]
# Order does not matter, so [1, 2] is also correct.
#
# Edge Cases:
# - nums has one element
# - k = 1
# - k equals number of unique elements
# - multiple numbers have same frequency
# - negative numbers are allowed

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Count frequency of every number
# - Sort numbers by frequency in descending order
# - Return the first k numbers
#
# Time: O(n log n)
# Space: O(n)
def top_k_frequent_brute_force(nums, k)
  frequency = Hash.new(0)

  nums.each do |num|
    frequency[num] += 1
  end

  sorted_by_frequency = frequency.sort_by do |_num, count|
    -count
  end

  top_k_pairs = sorted_by_frequency.first(k)

  top_k_pairs.map do |num, _count|
    num
  end
end

# -----------------------------
# OPTIMIZED MIN-HEAP SOLUTION
# -----------------------------
# Idea:
# - Count frequency of every number
# - Keep a min-heap of size k
# - Heap stores [count, num]
# - Smallest count stays at the top of the heap
# - If heap size becomes greater than k, remove smallest count
# - Remaining k numbers are the top k frequent numbers
#
# Time: O(n log k)
# Space: O(n + k)
require 'algorithms'
def top_k_frequent(nums, k)
  frequency = Hash.new(0)

  nums.each do |num|
    frequency[num] += 1
  end

  min_heap = Containers::MinHeap.new

  frequency.each do |num, count|
    min_heap.push([count, num])
    min_heap.pop if min_heap.size > k
  end

  result = []

  until min_heap.empty?
    _count, num = min_heap.pop
    result << num
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  nums = [1, 1, 1, 2, 2, 3]
  k = 2

  puts "Brute: #{top_k_frequent_brute_force(nums, k)}"
  puts "Opt:   #{top_k_frequent(nums, k)}"

  nums = [1]
  k = 1

  puts "Brute: #{top_k_frequent_brute_force(nums, k)}"
  puts "Opt:   #{top_k_frequent(nums, k)}"
end
