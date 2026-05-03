# frozen_string_literal: true

# LeetCode 373: Find K Pairs with Smallest Sums
#
# Problem:
# Given two integer arrays nums1 and nums2 sorted in ascending order, and an
# integer k, return the k pairs (u, v) with the smallest sums, where u ∈ nums1
# and v ∈ nums2.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all pairs, sort by sum, return first k.
#    Time Complexity: O(m*n log(m*n))
#    Space Complexity: O(m*n)
#
# 2. Bottleneck
#    Generating all pairs is wasteful when m*n >> k.
#
# 3. Optimized Accepted Approach
#    Min-heap with index-frontier: start with (nums1[i], nums2[0]) for all i
#    (or just i=0 to avoid duplicates). Each pop yields the next smallest pair;
#    push (nums1[i], nums2[j+1]) to explore next column for that row.
#    Time Complexity: O(k log k)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums1=[1,7,11], nums2=[2,4,6], k=3
# Initial heap: [(1+2,0,0),(7+2,1,0),(11+2,2,0)] = [(3,0,0),(9,1,0),(13,2,0)]
# Pop (3,0,0) → pair [1,2]; push (1+4,0,1)=(5,0,1)
# heap: [(5,0,1),(9,1,0),(13,2,0)]
# Pop (5,0,1) → pair [1,4]; push (1+6,0,2)=(7,0,2)
# heap: [(7,0,2),(9,1,0),(13,2,0)]
# Pop (7,0,2) → pair [1,6]; done.
# Result: [[1,2],[1,4],[1,6]]
#
# Edge Cases:
# - k > m*n → return all pairs
# - Single element arrays → one pair

def k_smallest_pairs_brute(nums1, nums2, k)
  pairs = nums1.flat_map { |u| nums2.map { |v| [u, v] } }
  pairs.sort_by { |u, v| u + v }.first(k)
end

def k_smallest_pairs(nums1, nums2, k)
  return [] if nums1.empty? || nums2.empty?

  result = []
  # min-heap: [sum, i, j] — sorted ascending by sum
  heap = nums1.each_index.map { |i| [nums1[i] + nums2[0], i, 0] }.sort

  while result.size < k && !heap.empty?
    sum, i, j = heap.shift   # pop minimum
    result << [nums1[i], nums2[j]]

    if j + 1 < nums2.length
      # push next pair from same row (same i, next j)
      new_entry = [nums1[i] + nums2[j + 1], i, j + 1]
      idx = heap.bsearch_index { |v| v[0] >= new_entry[0] } || heap.size
      heap.insert(idx, new_entry)
    end
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{k_smallest_pairs_brute([1, 7, 11], [2, 4, 6], 3).inspect}"
  puts "Opt:   #{k_smallest_pairs([1, 7, 11], [2, 4, 6], 3).inspect}"
  puts "Brute: #{k_smallest_pairs_brute([1, 1, 2], [1, 2, 3], 2).inspect}"
  puts "Opt:   #{k_smallest_pairs([1, 1, 2], [1, 2, 3], 2).inspect}"
end
