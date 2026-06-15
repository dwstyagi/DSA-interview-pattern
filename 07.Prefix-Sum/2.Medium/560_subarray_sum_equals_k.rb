# frozen_string_literal: true

# LeetCode 560: Subarray Sum Equals K
#
# Problem
# -------
# Given an integer array nums and an integer k,
# return the total number of continuous subarrays
# whose sum equals k.
#
# Example:
# nums = [1, 1, 1]
# k = 2
#
# Valid subarrays:
# [1,1] (index 0..1)
# [1,1] (index 1..2)
#
# Answer = 2
#
# -----------------------------------------------------------------------------
# Key Observation
# -----------------------------------------------------------------------------
#
# Let:
#
# prefix[i] = sum of nums[0..i]
#
# Then:
#
# subarray_sum(left..right)
# = prefix[right] - prefix[left - 1]
#
# We want:
#
# prefix[right] - prefix[left - 1] = k
#
# Rearranging:
#
# prefix[left - 1] = prefix[right] - k
#
# So while processing the current prefix sum:
#
# running = prefix[right]
#
# we only need to know:
#
# "How many times have we previously seen
#  running - k ?"
#
# Every occurrence forms a valid subarray ending here.
#
# -----------------------------------------------------------------------------
# Why freq = { 0 => 1 } ?
# -----------------------------------------------------------------------------
#
# Before processing any element, we've already seen
# one prefix sum equal to 0.
#
# Think of it as a virtual prefix at index -1.
#
# Example:
#
# nums = [1, 2]
# k = 3
#
# running = 3
# running - k = 0
#
# We need one occurrence of prefix sum 0 so that
# the subarray [1,2] starting at index 0 gets counted.
#
# -----------------------------------------------------------------------------
# Brute Force
# -----------------------------------------------------------------------------
#
# Check every possible subarray.
#
# Time:  O(n²)
# Space: O(1)
#

def subarray_sum_brute(nums, k)
  count = 0

  (0...nums.length).each do |start|
    sum = 0

    (start...nums.length).each do |ending|
      sum += nums[ending]

      count += 1 if sum == k
    end
  end

  count
end

# -----------------------------------------------------------------------------
# Optimal: Prefix Sum + Frequency Hash
# -----------------------------------------------------------------------------
#
# Hash stores:
#
# prefix_sum => number of times seen
#
# Example:
#
# freq = {
#   0 => 1,
#   1 => 2,
#   3 => 1
# }
#
# means:
#
# prefix sum 0 has appeared once
# prefix sum 1 has appeared twice
# prefix sum 3 has appeared once
#
# Time:  O(n)
# Space: O(n)
#

def subarray_sum(nums, k)
  count = 0

  # Running prefix sum
  running = 0

  # Prefix sum frequency map
  #
  # 0 => 1 represents the empty prefix
  freq = { 0 => 1 }

  nums.each do |num|
    # Current prefix sum
    running += num

    # We need:
    #
    # previous_prefix = running - k
    #
    # Every previous occurrence creates
    # one valid subarray ending here.
    count += freq[running - k] || 0

    # Record current prefix sum for future elements
    freq[running] = (freq[running] || 0) + 1
  end

  count
end

# -----------------------------------------------------------------------------
# Dry Run
# -----------------------------------------------------------------------------
#
# nums = [1, 1, 1]
# k = 2
#
# Start:
#
# running = 0
# count = 0
# freq = { 0 => 1 }
#
# --------------------------------------------------
# num = 1
#
# running = 1
#
# need running - k = -1
#
# freq[-1] = nil
#
# count = 0
#
# freq becomes:
# {
#   0 => 1,
#   1 => 1
# }
#
# --------------------------------------------------
# num = 1
#
# running = 2
#
# need running - k = 0
#
# freq[0] = 1
#
# count += 1
#
# count = 1
#
# freq becomes:
# {
#   0 => 1,
#   1 => 1,
#   2 => 1
# }
#
# --------------------------------------------------
# num = 1
#
# running = 3
#
# need running - k = 1
#
# freq[1] = 1
#
# count += 1
#
# count = 2
#
# Answer = 2
#
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  puts subarray_sum([1, 1, 1], 2)     # 2
  puts subarray_sum([1, 2, 3], 3)     # 2
  puts subarray_sum([1, -1, 0], 0)    # 3
end
