# frozen_string_literal: true

# LeetCode 215: Kth Largest Element in an Array
#
# Problem:
# Given an integer array nums and an integer k, return the kth largest element
# in the array. Note: it is the kth largest in sorted order, not the kth
# distinct element.
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

def find_kth_largest_brute(nums, k)
  nums.sort.reverse[k - 1]   # sort descending, take index k-1
end

def find_kth_largest(nums, k)
  heap = []   # simulate min-heap with sorted ascending array

  nums.each do |n|
    # binary-search insert to maintain sorted order
    idx = heap.bsearch_index { |v| v >= n } || heap.size
    heap.insert(idx, n)
    heap.shift if heap.size > k   # evict minimum when over capacity
  end

  heap.first   # root of min-heap = kth largest
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{find_kth_largest_brute([3, 2, 1, 5, 6, 4], 2)}"  # 5
  puts "Opt:   #{find_kth_largest([3, 2, 1, 5, 6, 4], 2)}"        # 5
  puts "Brute: #{find_kth_largest_brute([3, 2, 3, 1, 2, 4, 5, 5, 6], 4)}"  # 4
  puts "Opt:   #{find_kth_largest([3, 2, 3, 1, 2, 4, 5, 5, 6], 4)}"        # 4
end
