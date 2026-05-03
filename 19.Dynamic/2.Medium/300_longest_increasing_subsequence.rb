# frozen_string_literal: true

# LeetCode 300: Longest Increasing Subsequence
#
# Problem:
# Given nums array, return the length of the longest strictly increasing subsequence.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all subsequences, check each for strictly increasing, track max length.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    DP: dp[i] = length of LIS ending at index i. O(n^2).
#    Patience sorting with binary search achieves O(n log n).
#
# 3. Optimized Accepted Approach
#    Maintain tails array (smallest tail element for each length).
#    Binary search to find position; replace or extend.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [10, 9, 2, 5, 3, 7, 101, 18]
# tails: []
# 10: [10]; 9: [9]; 2: [2]; 5: [2,5]; 3: [2,3]; 7: [2,3,7]; 101: [2,3,7,101]; 18: [2,3,7,18]
# Length: 4
#
# Edge Cases:
# - Single element: 1
# - All equal: 1
# - All increasing: n

def length_of_lis_brute(nums)
  n = nums.length
  dp = Array.new(n, 1)
  n.times do |i|
    i.times { |j| dp[i] = [dp[i], dp[j] + 1].max if nums[j] < nums[i] }
  end
  dp.max || 0
end

def length_of_lis(nums)
  tails = []
  nums.each do |n|
    lo = tails.bsearch_index { |t| t >= n } || tails.length
    tails[lo] = n
  end
  tails.length
end

if __FILE__ == $PROGRAM_NAME
  puts length_of_lis_brute([10, 9, 2, 5, 3, 7, 101, 18])  # 4
  puts length_of_lis([0, 1, 0, 3, 2, 3])                   # 4
end
