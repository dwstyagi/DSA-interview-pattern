# frozen_string_literal: true

# LeetCode 1480: Running Sum of 1d Array
#
# Problem:
# Given an array nums, return an array runningSum where runningSum[i] is the
# sum of nums[0] + nums[1] + ... + nums[i].
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each index i, compute sum of nums[0..i] from scratch.
#    Time Complexity: O(n²)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Recomputing the sum from index 0 for each element is redundant.
#
# 3. Optimized Accepted Approach
#    Single pass: carry a running sum, append to result at each step.
#    Time Complexity: O(n)
#    Space Complexity: O(n) for result array
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 2, 3, 4]
# i=0: sum=1, result=[1]
# i=1: sum=3, result=[1,3]
# i=2: sum=6, result=[1,3,6]
# i=3: sum=10, result=[1,3,6,10]
#
# Edge Cases:
# - Single element → return [element]
# - All zeros → return [0,0,...,0]

def running_sum_brute(nums)
  nums.each_index.map { |i| nums[0..i].sum }
end

def running_sum(nums)
  total = 0
  nums.map { |n| total += n }   # accumulate and map in one pass
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{running_sum_brute([1, 2, 3, 4]).inspect}"      # [1,3,6,10]
  puts "Opt:   #{running_sum([1, 2, 3, 4]).inspect}"            # [1,3,6,10]
  puts "Brute: #{running_sum_brute([1, 1, 1, 1, 1]).inspect}"   # [1,2,3,4,5]
  puts "Opt:   #{running_sum([1, 1, 1, 1, 1]).inspect}"         # [1,2,3,4,5]
end
