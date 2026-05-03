# frozen_string_literal: true

# LeetCode 325: Maximum Size Subarray Sum Equals K
#
# Problem:
# Given an integer array nums and an integer k, return the maximum length of a
# subarray that sums to k. If there isn't one, return 0.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check all subarrays, track max length where sum == k.
#    Time Complexity: O(n²)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(n²) pairs to check.
#
# 3. Optimized Accepted Approach
#    Prefix sum + hash map storing first occurrence of each running sum.
#    When running sum - k has been seen before, the subarray length is
#    current_index - first_seen_index.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, -1, 5, -2, 3], k = 3
# first_seen = {0 => -1}; running = 0; max_len = 0
# i=0: run=1, look for 1-3=-2 → not seen; first_seen[1]=0
# i=1: run=0, look for 0-3=-3 → not seen; seen[0]=-1 already
# i=2: run=5, look for 5-3=2 → not seen; first_seen[5]=2
# i=3: run=3, look for 3-3=0 → seen at -1 → len=3-(-1)=4; max_len=4
# i=4: run=6, look for 6-3=3 → not seen; first_seen[6]=4
# Return 4
#
# Edge Cases:
# - k=0 → longest subarray summing to 0
# - No valid subarray → return 0

def max_sub_array_len_brute(nums, k)
  n = nums.length
  max_len = 0
  (0...n).each do |i|
    sum = 0
    (i...n).each do |j|
      sum += nums[j]
      max_len = [max_len, j - i + 1].max if sum == k
    end
  end
  max_len
end

def max_sub_array_len(nums, k)
  first_seen = { 0 => -1 }   # running_sum → earliest index
  running = 0
  max_len = 0

  nums.each_with_index do |n, i|
    running += n

    if first_seen.key?(running - k)
      max_len = [max_len, i - first_seen[running - k]].max
    end

    first_seen[running] ||= i   # only store FIRST occurrence
  end

  max_len
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{max_sub_array_len_brute([1, -1, 5, -2, 3], 3)}"   # 4
  puts "Opt:   #{max_sub_array_len([1, -1, 5, -2, 3], 3)}"         # 4
  puts "Brute: #{max_sub_array_len_brute([-2, -1, 2, 1], 1)}"      # 2
  puts "Opt:   #{max_sub_array_len([-2, -1, 2, 1], 1)}"            # 2
end
