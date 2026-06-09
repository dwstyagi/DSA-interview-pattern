# frozen_string_literal: true

# LeetCode 373: Find K Pairs with Smallest Sums
#
# Problem:
# Given two sorted integer arrays nums1 and nums2, return k pairs with the
# smallest sums.
#
# A pair is:
# [nums1[i], nums2[j]]
#
# Examples:
#   Input:  nums1 = [1,7,11], nums2 = [2,4,6], k = 3
#   Output: [[1,2], [1,4], [1,6]]
#   Why:    These have sums 3, 5, and 7.
#
#   Input:  nums1 = [1,1,2], nums2 = [1,2,3], k = 2
#   Output: [[1,1], [1,1]]
#   Why:    The two smallest pairs both have sum 2.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. Brute Force
#    Generate every possible pair, sort all pairs by sum, return first k pairs.
#    Time Complexity: O((m * n) log(m * n))
#    Space Complexity: O(m * n)
#
# 2. Bottleneck
#    We generate and sort all pairs, but we only need k pairs.
#
# 3. Optimized Min-Heap Approach
#    Since both arrays are sorted, each row of pairs is also sorted.
#    Start with the first pair from each useful row.
#    Pop the smallest pair from heap.
#    Push the next pair from the same row.
#    Repeat until we collect k pairs.
#    Time Complexity: O(k log min(k, m))
#    Space Complexity: O(min(k, m))
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums1 = [1, 7, 11]
# nums2 = [2, 4, 6]
# k = 3
#
# Treat nums1 as rows:
#
# Row for 1:
# [1,2], [1,4], [1,6]
#
# Row for 7:
# [7,2], [7,4], [7,6]
#
# Row for 11:
# [11,2], [11,4], [11,6]
#
# Initial heap stores first pair from each row:
# [3, 0, 0]  -> [1,2]
# [9, 1, 0]  -> [7,2]
# [13, 2, 0] -> [11,2]
#
# Pop [1,2], then push next from same row: [1,4]
# Pop [1,4], then push next from same row: [1,6]
# Pop [1,6], then push nothing from that row
#
# Result:
# [[1,2], [1,4], [1,6]]
#
# Edge Cases:
# - nums1 is empty
# - nums2 is empty
# - k = 0
# - k is larger than total possible pairs
# - arrays can have different lengths
# - duplicate values are allowed

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Try every pair from nums1 and nums2
# - Sort all pairs by their sum
# - Return first k pairs
#
# Time: O((m * n) log(m * n))
# Space: O(m * n)
def k_smallest_pairs_brute_force(nums1, nums2, k)
  pairs = []

  nums1.each do |num1|
    nums2.each do |num2|
      pairs << [num1, num2]
    end
  end

  pairs.sort_by! do |num1, num2|
    num1 + num2
  end

  pairs.first(k)
end

# -----------------------------
# OPTIMIZED MIN-HEAP SOLUTION
# -----------------------------
# Idea:
# - Treat nums1 as rows
# - Every row starts with nums2[0]
# - Use min heap to always get the smallest available pair
# - After popping from a row, push the next pair from same row
#
# Time: O(k log min(k, nums1.length))
# Space: O(min(k, nums1.length))
require 'algorithms'
# We only need to store at most k pairs in the heap, so we only need to consider
# the first k rows of pairs. Each row corresponds to an element in nums1.
def k_smallest_pairs(nums1, nums2, k)
  return [] if nums1.empty? || nums2.empty? || k.zero?

  min_heap = Containers::MinHeap.new
  result = []

  # Add the first pair from each useful row.
  #
  # Each row is:
  # nums1[index1] paired with every value in nums2.
  #
  # Row example for nums1[index1] = 1:
  # [1, nums2[0]], [1, nums2[1]], [1, nums2[2]]
  #
  # The smallest pair in every row starts with nums2[0].
  #
  # We only need at most k rows because answer has only k pairs.
  [nums1.length, k].min.times do |index|
    sum = nums1[index] + nums2[0]

    # Store:
    # [sum, index, index2]
    #
    # index2 is 0 because each row starts from nums2[0].
    min_heap.push([sum, index, 0])
  end

  # Continue until we collect k pairs or there are no more pairs.
  while result.length < k && !min_heap.empty?
    _sum, index1, index2 = min_heap.pop

    # The heap gives the current smallest pair.
    result << [nums1[index1], nums2[index2]]

    # Move to the next pair in the same row.
    #
    # Example:
    # after [1,2], try [1,4]
    # after [1,4], try [1,6]
    next_index2 = index2 + 1

    # If index2 goes outside nums2, this row is finished.
    next unless next_index2 < nums2.length

    next_sum = nums1[index1] + nums2[next_index2]
    min_heap.push([next_sum, index1, next_index2])
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  nums1 = [1, 7, 11]
  nums2 = [2, 4, 6]
  k = 3

  puts "Brute: #{k_smallest_pairs_brute_force(nums1, nums2, k)}"
  puts "Opt:   #{k_smallest_pairs(nums1, nums2, k)}"

  nums1 = [1, 1, 2]
  nums2 = [1, 2, 3]
  k = 2

  puts "Brute: #{k_smallest_pairs_brute_force(nums1, nums2, k)}"
  puts "Opt:   #{k_smallest_pairs(nums1, nums2, k)}"
end
