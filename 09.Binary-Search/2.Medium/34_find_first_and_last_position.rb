# frozen_string_literal: true

# LeetCode 34: Find First and Last Position of Element in Sorted Array
#
# Problem:
# Given a sorted array of integers and a target, find the starting and ending
# position of target. Return [-1, -1] if not found.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Linear scan for first and last occurrence.
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear scan on sorted array.
#
# 3. Optimized Accepted Approach
#    Two lower-bound binary searches:
#    first = lower_bound(target) — first index with nums[i] >= target
#    last  = lower_bound(target+1) - 1 — last index of target
#    Guard: if first >= n or nums[first] != target, return [-1, -1].
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[5,7,7,8,8,10], target=8
# lower_bound(8): l=0,r=6; converges to index 3
# lower_bound(9): l=0,r=6; converges to index 5
# first=3, last=5-1=4 → [3,4] ✓
#
# Edge Cases:
# - Target not in array → [-1,-1]
# - All elements are target → [0, n-1]

def search_range_brute(nums, target)
  first = nums.index(target)
  return [-1, -1] unless first

  last = nums.rindex(target)
  [first, last]
end

def lower_bound(nums, target)
  l = 0
  r = nums.length
  while l < r
    mid = (l + r) / 2
    nums[mid] < target ? l = mid + 1 : r = mid
  end
  l
end

def search_range(nums, target)
  first = lower_bound(nums, target)
  return [-1, -1] if first >= nums.length || nums[first] != target

  last = lower_bound(nums, target + 1) - 1
  [first, last]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{search_range_brute([5, 7, 7, 8, 8, 10], 8).inspect}"   # [3,4]
  puts "Opt:   #{search_range([5, 7, 7, 8, 8, 10], 8).inspect}"         # [3,4]
  puts "Brute: #{search_range_brute([5, 7, 7, 8, 8, 10], 6).inspect}"   # [-1,-1]
  puts "Opt:   #{search_range([5, 7, 7, 8, 8, 10], 6).inspect}"         # [-1,-1]
end
