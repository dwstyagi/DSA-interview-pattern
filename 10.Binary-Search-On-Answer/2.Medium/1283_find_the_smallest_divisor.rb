# frozen_string_literal: true

# LeetCode 1283: Find the Smallest Divisor Given a Threshold
#
# Problem:
# Given an array of integers nums and an integer threshold, find the smallest
# divisor d such that the sum of ceil(nums[i]/d) <= threshold.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try every divisor from 1 upward, return first where sum <= threshold.
#    Time Complexity: O(max(nums) * n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear divisor scan — binary search on [1, max(nums)].
#
# 3. Optimized Accepted Approach
#    Binary search divisor in [1, max(nums)].
#    Feasibility: sum(ceil(n/d)) <= threshold → min feasible direction.
#    Time Complexity: O(n log(max(nums)))
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[1,2,5,9], threshold=6
# lo=1, hi=9 → mid=5 → ceil(1/5)+ceil(2/5)+ceil(5/5)+ceil(9/5)=1+1+1+2=5<=6 → hi=5
# lo=1, hi=5 → mid=3 → 1+1+2+3=7>6 → lo=4
# lo=4, hi=5 → mid=4 → 1+1+2+3=7>6... wait: ceil(1/4)=1,ceil(2/4)=1,ceil(5/4)=2,ceil(9/4)=3 → 7>6 → lo=5
# lo=5, hi=5 → return 5 ✓
#
# Edge Cases:
# - threshold >= n -> divisor=1 always works since each ceil >= 1
# - All nums=1 -> sum = n, need d such that n/d <= threshold

def smallest_divisor_brute(nums, threshold)
  (1..nums.max).each do |d|
    total = nums.sum { |n| (n + d - 1) / d }
    return d if total <= threshold
  end
end

def smallest_divisor(nums, threshold)
  lo, hi = 1, nums.max

  while lo < hi
    mid   = (lo + hi) / 2
    total = nums.sum { |n| (n + mid - 1) / mid } # ceil division
    total <= threshold ? hi = mid : lo = mid + 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{smallest_divisor_brute([1, 2, 5, 9], 6)}"    # 5
  puts "Opt:   #{smallest_divisor([1, 2, 5, 9], 6)}"           # 5
  puts "Brute: #{smallest_divisor_brute([44, 22, 33, 11, 1], 5)}" # 44
  puts "Opt:   #{smallest_divisor([44, 22, 33, 11, 1], 5)}"        # 44
end
