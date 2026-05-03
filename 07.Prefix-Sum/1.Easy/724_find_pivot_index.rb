# frozen_string_literal: true

# LeetCode 724: Find Pivot Index
#
# Problem:
# Given an array nums, return the pivot index: the index where the sum of all
# elements to the left equals the sum of all elements to the right.
# Return -1 if no such index exists.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each index, compute left sum and right sum from scratch.
#    Time Complexity: O(n²)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Recomputing sums at each index is redundant.
#
# 3. Optimized Accepted Approach
#    Precompute total sum. For each index i:
#    left_sum = running_sum before i; right_sum = total - left_sum - nums[i].
#    If left_sum == right_sum, pivot found.
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 7, 3, 6, 5, 6], total = 28
# i=0: left=0, right=28-0-1=27 → no
# i=1: left=1, right=28-1-7=20 → no
# i=2: left=8, right=28-8-3=17 → no
# i=3: left=11, right=28-11-6=11 → MATCH → return 3
#
# Edge Cases:
# - All zeros → return 0 (leftmost index)
# - Single element → return 0 (left and right both 0)
# - No pivot → return -1

def pivot_index_brute(nums)
  nums.each_index do |i|
    return i if nums[0...i].sum == nums[i + 1..].sum
  end
  -1
end

def pivot_index(nums)
  total = nums.sum
  left_sum = 0

  nums.each_with_index do |n, i|
    right_sum = total - left_sum - n   # right = total minus left and self
    return i if left_sum == right_sum
    left_sum += n
  end

  -1
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{pivot_index_brute([1, 7, 3, 6, 5, 6])}"  # 3
  puts "Opt:   #{pivot_index([1, 7, 3, 6, 5, 6])}"        # 3
  puts "Brute: #{pivot_index_brute([1, 2, 3])}"            # -1
  puts "Opt:   #{pivot_index([1, 2, 3])}"                  # -1
  puts "Brute: #{pivot_index_brute([2, 1, -1])}"           # 0
  puts "Opt:   #{pivot_index([2, 1, -1])}"                 # 0
end
