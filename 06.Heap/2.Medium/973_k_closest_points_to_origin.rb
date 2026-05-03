# frozen_string_literal: true

# LeetCode 973: K Closest Points to Origin
#
# Problem:
# Given an array of points where points[i] = [xi, yi] and an integer k,
# return the k closest points to the origin (0, 0). Distance is Euclidean.
# The answer can be in any order.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Compute distance² for each point, sort by distance, return first k.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Full sort when we only need k closest is wasteful.
#
# 3. Optimized Accepted Approach
#    Maintain a max-heap of size k (by distance²). If a new point is closer
#    than the farthest point in the heap (heap root), replace it.
#    Final heap contains the k closest points.
#    Time Complexity: O(n log k)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# points = [[1,3],[-2,2]], k = 1
# dist²: [1,3] = 1+9 = 10, [-2,2] = 4+4 = 8
# heap (max-heap by dist²) of size 1:
# Push [10, [1,3]]: heap = [[10,[1,3]]]
# Push [-2,2]: dist=8 < heap root 10 → pop 10, push 8 → heap = [[8,[-2,2]]]
# Result: [[-2,2]]
#
# Edge Cases:
# - k = n → return all points
# - All same distance → any k can be returned

def k_closest_brute(points, k)
  points.sort_by { |x, y| x * x + y * y }.first(k)
end

def k_closest(points, k)
  # simulate max-heap of size k using sorted array descending by distance²
  heap = []   # [dist², point], sorted ascending → last element is max

  points.each do |point|
    x, y = point
    dist_sq = x * x + y * y

    idx = heap.bsearch_index { |d, _| d >= dist_sq } || heap.size
    heap.insert(idx, [dist_sq, point])

    heap.pop if heap.size > k   # remove the farthest (last element in asc sort)
  end

  heap.map { |_, p| p }
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{k_closest_brute([[1, 3], [-2, 2]], 1).inspect}"  # [[-2, 2]]
  puts "Opt:   #{k_closest([[1, 3], [-2, 2]], 1).inspect}"        # [[-2, 2]]
  puts "Brute: #{k_closest_brute([[3, 3], [5, -1], [-2, 4]], 2).inspect}"
  puts "Opt:   #{k_closest([[3, 3], [5, -1], [-2, 4]], 2).inspect}"
end
