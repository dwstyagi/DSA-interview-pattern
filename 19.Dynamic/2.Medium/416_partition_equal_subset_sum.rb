# frozen_string_literal: true

# LeetCode 416: Partition Equal Subset Sum
#
# Problem:
# Given nums array, return true if it can be partitioned into two subsets with equal sum.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all subsets, check if any has sum = total/2.
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    0/1 knapsack: can we achieve sum = total/2?
#
# 3. Optimized Accepted Approach
#    Target = total / 2. If odd total, impossible.
#    DP bit array: dp[s] = can we achieve sum s. Iterate nums in reverse to avoid reuse.
#
#    Time Complexity: O(n * target)
#    Space Complexity: O(target)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[1,5,11,5], total=22, target=11
# dp[0]=true
# After 1: dp[1]=true
# After 5: dp[5]=true, dp[6]=true
# After 11: dp[11]=true -> found! return true
#
# Edge Cases:
# - Odd total: false
# - Single element: only true if element * 2 = 0 (impossible with positive nums)

def can_partition_brute?(nums)
  total = nums.sum
  return false if total.odd?
  target = total / 2
  memo = {}
  rec = lambda do |idx, rem|
    return true if rem == 0
    return false if rem < 0 || idx >= nums.length
    memo[[idx, rem]] ||= rec.call(idx + 1, rem - nums[idx]) || rec.call(idx + 1, rem)
  end
  rec.call(0, target)
end

def can_partition?(nums)
  total = nums.sum
  return false if total.odd?
  target = total / 2
  dp = Array.new(target + 1, false)
  dp[0] = true
  nums.each do |n|
    target.downto(n) { |s| dp[s] = true if dp[s - n] }
  end
  dp[target]
end

if __FILE__ == $PROGRAM_NAME
  puts can_partition_brute?([1, 5, 11, 5])  # true
  puts can_partition?([1, 2, 3, 5])         # false
end
