# frozen_string_literal: true

# LeetCode 215: Kth Largest Element in an Array
#
# Problem:
# Given an integer array nums and an integer k, return the kth largest element
# in the array. Note: it is the kth largest in sorted order, not the kth
# distinct element.
#
# Examples:
#   Input:  nums = [3,2,1,5,6,4], k = 2
#   Output: 5
#   Why:    Sorted descending: [6,5,4,3,2,1]; 2nd largest is 5.
#
#   Input:  nums = [3,2,3,1,2,4,5,5,6], k = 4
#   Output: 4
#   Why:    4th largest is 4 — min-heap of size k; top after all inserts = 4.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Sort the array descending and return the element at index k-1.
#    Time Complexity: O(n log n)
#    Space Complexity: O(1) (in-place sort)
#
# 2. Bottleneck
#    Full sort processes all elements when we only need the kth position.
#
# 3. Optimized Accepted Approach
#    Maintain a min-heap of size k. After processing all elements, the heap's
#    minimum (root) is the kth largest.
#    Each element: push → if size > k, pop minimum → root = kth largest.
#    Time Complexity: O(n log k)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [3, 2, 1, 5, 6, 4], k = 2
# Process 3: heap = [3]
# Process 2: heap = [2, 3]
# Process 1: heap size = 3 > 2 → pop min(1) → heap = [2, 3]
# Process 5: heap = [2, 3, 5] → pop 2 → heap = [3, 5]
# Process 6: heap = [3, 5, 6] → pop 3 → heap = [5, 6]
# Process 4: heap = [4, 5, 6] → pop 4 → heap = [5, 6]
# Root of min-heap = 5 → kth largest = 5
#
# Edge Cases:
# - k = 1 → return max
# - k = n → return min
# - All elements same → return that value

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Sort the numbers in descending order
# - The k-th largest element will be at index k - 1
#
# Time: O(n log n)
# Space: depends on sort implementation
def find_kth_largest_true_brute_force(nums, k)
  nums.sort.reverse[k - 1]
end

# -----------------------------
# OPTIMIZED MIN-HEAP SOLUTION
# -----------------------------
# Idea:
# - Keep a min heap of size k
# - It stores the largest k elements seen so far
# - If heap grows beyond k, remove the smallest
# - Then heap top is the k-th largest element
#
# Time: O(n log k)
# Space: O(k)
require 'algorithms'
def find_kth_largest(nums, k)
  min_heap = Containers::MinHeap.new

  nums.each do |num|
    min_heap.push(num)
    min_heap.pop if min_heap.size > k
  end

  min_heap.next
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{find_kth_largest_brute([3, 2, 1, 5, 6, 4], 2)}"  # 5
  puts "Opt:   #{find_kth_largest([3, 2, 1, 5, 6, 4], 2)}"        # 5
  puts "Brute: #{find_kth_largest_brute([3, 2, 3, 1, 2, 4, 5, 5, 6], 4)}"  # 4
  puts "Opt:   #{find_kth_largest([3, 2, 3, 1, 2, 4, 5, 5, 6], 4)}"        # 4
end
