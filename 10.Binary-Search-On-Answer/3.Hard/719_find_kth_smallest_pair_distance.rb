# frozen_string_literal: true

# LeetCode 719: Find K-th Smallest Pair Distance
#
# Problem:
# Given an integer array nums, return the k-th smallest distance among all
# pairs nums[i] and nums[j] where 0 <= i < j < n.
# Distance = |nums[i] - nums[j]|.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Compute all pair distances, sort, return k-th (1-indexed).
#    Time Complexity: O(n^2 log n)
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    Storing all pairs uses O(n^2) space — binary search on distance value.
#
# 3. Optimized Accepted Approach
#    Sort nums. Binary search distance d in [0, max-min].
#    Count pairs with distance <= d using sliding window (two pointers).
#    Find the smallest d where count >= k.
#    Time Complexity: O(n log n + n log(max-min))
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[1,3,1], k=1
# sorted=[1,1,3], lo=0, hi=2
# mid=1 → pairs<=1: (1,1)=0✓,(1,3)=2✗,(1,3)=2✗ → count=1? use sliding window:
#   r=0,l=0→r=1 diff=0<=1 count+=1; r=2 diff=2>1 l=1; diff=2>1 l=2 → count=1+1=2 → hi=1
# mid=0 → pairs<=0: only (1,1)=0 → count=1 → hi=0
# lo=0, hi=0 → return 0 ✓
#
# Edge Cases:
# - All same elements -> 0
# - k equals total pairs -> max distance

def smallest_distance_pair_brute(nums, k)
  distances = []
  n = nums.length
  (0...n).each do |i|
    ((i + 1)...n).each do |j|
      distances << (nums[i] - nums[j]).abs
    end
  end
  distances.sort[k - 1]
end

def smallest_distance_pair(nums, k)
  nums.sort!
  n    = nums.length
  lo   = 0
  hi   = nums.last - nums.first

  count_pairs = lambda do |max_dist|
    # Count pairs with distance <= max_dist using sliding window
    count, left = 0, 0
    (1...n).each do |right|
      left += 1 while nums[right] - nums[left] > max_dist
      count += right - left
    end
    count
  end

  while lo < hi
    mid = (lo + hi) / 2
    count_pairs.call(mid) >= k ? hi = mid : lo = mid + 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{smallest_distance_pair_brute([1, 3, 1], 1)}"   # 0
  puts "Opt:   #{smallest_distance_pair([1, 3, 1], 1)}"          # 0
  puts "Brute: #{smallest_distance_pair_brute([1, 1, 1], 2)}"   # 0
  puts "Opt:   #{smallest_distance_pair([1, 1, 1], 2)}"          # 0
  puts "Brute: #{smallest_distance_pair_brute([1, 6, 1], 3)}"   # 5
  puts "Opt:   #{smallest_distance_pair([1, 6, 1], 3)}"          # 5
end
