# frozen_string_literal: true

# LeetCode 930: Binary Subarrays With Sum
#
# Problem:
# Given a binary array nums and an integer goal,
# return the number of non-empty subarrays whose sum equals goal.
#
# -----------------------------------------------------------------------------
# Pattern Recognition
#
# We need:
#
#   subarray_sum = goal
#
# Using prefix sums:
#
#   current_prefix - previous_prefix = goal
#
# Rearrange:
#
#   previous_prefix = current_prefix - goal
#
# Therefore:
# For every current prefix sum, count how many times
# (current_prefix - goal) has appeared before.
#
# This is the EXACT same pattern as:
#
#   LC 560 - Subarray Sum Equals K
#
# Difference:
# - LC 560 works for any integers
# - LC 930 happens to use a binary array
#
# -----------------------------------------------------------------------------
# Interview Progression
#
# 1. Brute Force
#    Generate every subarray and calculate its sum.
#
#    Time:  O(n²)
#    Space: O(1)
#
# 2. Observation
#
#    If:
#
#      prefix[j] - prefix[i] = goal
#
#    then:
#
#      prefix[i] = prefix[j] - goal
#
#    We only need to know how many times a prefix sum
#    has already appeared.
#
# 3. Optimized
#
#    Use:
#
#      Hash:
#      prefix_sum => frequency
#
#    Time:  O(n)
#    Space: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1,0,1,0,1]
# goal = 2
#
# freq    = {0=>1}
# running = 0
# count   = 0
#
# -------------------------------------------------------------------
# num=1
#
# running = 1
# need    = 1 - 2 = -1
#
# freq[-1] = 0
# count = 0
#
# freq = {0=>1, 1=>1}
#
# -------------------------------------------------------------------
# num=0
#
# running = 1
# need    = -1
#
# freq[-1] = 0
# count = 0
#
# freq = {0=>1, 1=>2}
#
# -------------------------------------------------------------------
# num=1
#
# running = 2
# need    = 0
#
# freq[0] = 1
# count += 1
#
# count = 1
#
# freq = {0=>1, 1=>2, 2=>1}
#
# -------------------------------------------------------------------
# num=0
#
# running = 2
# need    = 0
#
# freq[0] = 1
# count += 1
#
# count = 2
#
# freq[2] = 2
#
# -------------------------------------------------------------------
# num=1
#
# running = 3
# need    = 1
#
# freq[1] = 2
# count += 2
#
# count = 4
#
# Return 4
#
# -----------------------------------------------------------------------------
# Edge Cases
#
# goal = 0
# nums = [0,0,0]
#
# Count all zero-sum subarrays.
#
# -----------------------------------------------------------------------------

def num_subarrays_with_sum_brute(nums, goal)
  count = 0

  nums.each_index do |start|
    sum = 0

    (start...nums.length).each do |ending|
      sum += nums[ending]
      count += 1 if sum == goal
    end
  end

  count
end

def num_subarrays_with_sum(nums, goal)
  # prefix_sum => frequency
  freq = { 0 => 1 }

  running_sum = 0
  count = 0

  nums.each do |num|
    running_sum += num

    # previous_prefix = current_prefix - goal
    count += freq[running_sum - goal] || 0

    # record current prefix sum
    freq[running_sum] = (freq[running_sum] || 0) + 1
  end

  count
end

if __FILE__ == $PROGRAM_NAME
  puts num_subarrays_with_sum([1, 0, 1, 0, 1], 2) # 4
  puts num_subarrays_with_sum([0, 0, 0, 0, 0], 0) # 15
end
