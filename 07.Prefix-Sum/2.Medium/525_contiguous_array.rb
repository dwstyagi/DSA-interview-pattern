# frozen_string_literal: true

# LeetCode 525: Contiguous Array
#
# Problem:
# Given a binary array nums, return the maximum length of a contiguous
# subarray with an equal number of 0s and 1s.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every pair (i, j), count 0s and 1s in nums[i..j], track max length.
#    Time Complexity: O(n²)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(n²) pairs to check.
#
# 3. Optimized Accepted Approach
#    Map 0 → -1, then problem becomes: find longest subarray with sum = 0.
#    Use prefix sum + hash map: store first occurrence of each running sum.
#    If running sum repeats, the subarray between those indices has sum 0.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [0, 1, 0]  → mapped to [-1, 1, -1]
# first_seen = {0 => -1}; running = 0; max_len = 0
# i=0: running=-1; not seen → first_seen[-1]=0
# i=1: running=0; seen at -1 → len=1-(-1)=2; max_len=2
# i=2: running=-1; seen at 0 → len=2-0=2; max_len=2
# Return 2
#
# Edge Cases:
# - All zeros → no valid subarray
# - All ones → no valid subarray
# - Alternating 0,1 → entire array

def find_max_length_brute(nums)
  n = nums.length
  max_len = 0
  (0...n).each do |i|
    zeros = ones = 0
    (i...n).each do |j|
      nums[j] == 0 ? zeros += 1 : ones += 1
      max_len = [max_len, j - i + 1].max if zeros == ones
    end
  end
  max_len
end

def find_max_length(nums)
  first_seen = { 0 => -1 }   # running_sum → earliest index
  running = 0
  max_len = 0

  nums.each_with_index do |bit, i|
    running += bit == 0 ? -1 : 1   # treat 0 as -1

    if first_seen.key?(running)
      max_len = [max_len, i - first_seen[running]].max
    else
      first_seen[running] = i       # only store first occurrence
    end
  end

  max_len
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{find_max_length_brute([0, 1])}"          # 2
  puts "Opt:   #{find_max_length([0, 1])}"                # 2
  puts "Brute: #{find_max_length_brute([0, 1, 0])}"       # 2
  puts "Opt:   #{find_max_length([0, 1, 0])}"             # 2
end
