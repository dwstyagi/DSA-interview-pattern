# frozen_string_literal: true

# LeetCode 523: Continuous Subarray Sum
#
# Problem:
# Given an integer array nums and an integer k, return true if there is a
# good subarray: length at least 2, and the sum is a multiple of k.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check all subarrays of length >= 2, test if sum % k == 0.
#    Time Complexity: O(n²)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(n²) pairs.
#
# 3. Optimized Accepted Approach
#    Prefix sum mod k. If prefix[j] % k == prefix[i] % k, then the subarray
#    (i, j] is divisible by k. Store first occurrence of each remainder.
#    If same remainder appears >= 2 indices apart, return true.
#    Time Complexity: O(n)
#    Space Complexity: O(k) for remainder map
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [23, 2, 4, 6, 7], k = 6
# first_seen = {0 => -1}; running = 0
# i=0: running=23, rem=23%6=5; first_seen[5]=0
# i=1: running=25, rem=25%6=1; first_seen[1]=1
# i=2: running=29, rem=29%6=5; seen at 0 → i-0=2>=2 → true
#
# Edge Cases:
# - k=0 → can't mod by 0; treat as finding subarray summing to 0 (edge case in problem)
# - Subarray length must be >= 2

def check_subarray_sum_brute(nums, k)
  n = nums.length
  (0...n - 1).each do |i|
    sum = nums[i]
    (i + 1...n).each do |j|
      sum += nums[j]
      return true if k != 0 && sum % k == 0
      return true if k == 0 && sum == 0
    end
  end
  false
end

def check_subarray_sum(nums, k)
  first_seen = { 0 => -1 }   # remainder → earliest index
  running = 0

  nums.each_with_index do |n, i|
    running += n
    rem = k != 0 ? running % k : running

    if first_seen.key?(rem)
      return true if i - first_seen[rem] >= 2   # subarray length >= 2
    else
      first_seen[rem] = i
    end
  end

  false
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{check_subarray_sum_brute([23, 2, 4, 6, 7], 6)}"    # true
  puts "Opt:   #{check_subarray_sum([23, 2, 4, 6, 7], 6)}"          # true
  puts "Brute: #{check_subarray_sum_brute([23, 2, 6, 4, 7], 6)}"    # true
  puts "Opt:   #{check_subarray_sum([23, 2, 6, 4, 7], 6)}"          # true
  puts "Brute: #{check_subarray_sum_brute([23, 2, 6, 4, 7], 13)}"   # false
  puts "Opt:   #{check_subarray_sum([23, 2, 6, 4, 7], 13)}"         # false
end
