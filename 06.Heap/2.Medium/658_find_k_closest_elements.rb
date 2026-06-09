# frozen_string_literal: true

# LeetCode 658: Find K Closest Elements
#
# Problem:
# Given a sorted integer array arr, two integers k and x, return the k closest
# integers to x in the array.
#
# The result must be sorted in ascending order.
#
# Tie Rule:
# If two numbers have the same distance from x, choose the smaller number.
#
# Examples:
#   Input:  arr = [1, 2, 3, 4, 5], k = 4, x = 3
#   Output: [1, 2, 3, 4]
#   Why:    1 and 5 both have distance 2 from 3, but 1 is smaller.
#
#   Input:  arr = [1, 2, 3, 4, 5], k = 4, x = -1
#   Output: [1, 2, 3, 4]
#   Why:    x is smaller than all elements, so the first 4 are closest.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. Brute Force
#    Sort all elements by distance from x.
#    If distances tie, smaller value comes first.
#    Take first k elements and sort them ascending for final answer.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Sorting all n elements is unnecessary when we only need k elements.
#
# 3. Optimized Max-Heap Approach
#    Keep a MaxHeap of size k.
#    Heap stores [distance, value].
#    If heap grows beyond k, pop the farthest value.
#    If distance ties, larger value is worse and gets removed first.
#    Time Complexity: O(n log k + k log k)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# arr = [1, 2, 3, 4, 5]
# k = 4
# x = 3
#
# Push [distance, value]:
#
# 1 -> [2, 1]
# 2 -> [1, 2]
# 3 -> [0, 3]
# 4 -> [1, 4]
# 5 -> [2, 5]
#
# Heap size becomes 5, so pop the largest pair.
#
# [2, 5] is popped.
#
# Why not [2, 1]?
# Both 1 and 5 have distance 2.
# Larger value 5 is worse because tie rule prefers smaller value.
#
# Remaining values:
# [1, 2, 3, 4]
#
# Final answer:
# [1, 2, 3, 4]
#
# Edge Cases:
# - k = 1
# - k = arr.length
# - x smaller than all elements
# - x larger than all elements
# - duplicate values

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Sort every number by closeness to x
# - Tie-break by smaller number
# - Take first k
# - Sort result ascending
#
# Time: O(n log n)
# Space: O(n)
def find_closest_elements_brute_force(arr, k, x)
  arr
    .sort_by { |num| [(num - x).abs, num] }
    .first(k)
    .sort
end

# -----------------------------
# OPTIMIZED MAX-HEAP SOLUTION
# -----------------------------
# Idea:
# - Keep only k closest elements in a MaxHeap
# - Heap stores [distance, num]
# - The top of MaxHeap is the worst among current k elements
# - If heap size becomes greater than k, remove that worst element
#
# Time: O(n log k + k log k)
# Space: O(k)
require 'algorithms'
def find_closest_elements(arr, k, x)
  max_heap = Containers::MaxHeap.new

  arr.each do |num|
    distance = (num - x).abs

    # Store distance first because closeness is the main comparison.
    #
    # For ties:
    # [2, 5] is greater than [2, 1],
    # so 5 gets removed before 1.
    max_heap.push([distance, num])

    max_heap.pop if max_heap.size > k
  end

  result = []

  until max_heap.empty?
    _distance, num = max_heap.pop
    result << num
  end

  # LeetCode requires answer in ascending order.
  result.sort
end

if __FILE__ == $PROGRAM_NAME
  arr = [1, 2, 3, 4, 5]
  k = 4
  x = 3

  puts "Brute: #{find_closest_elements_brute_force(arr, k, x)}"
  puts "Opt:   #{find_closest_elements(arr, k, x)}"

  arr = [1, 2, 3, 4, 5]
  k = 4
  x = -1

  puts "Brute: #{find_closest_elements_brute_force(arr, k, x)}"
  puts "Opt:   #{find_closest_elements(arr, k, x)}"
end
