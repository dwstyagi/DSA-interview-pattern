# frozen_string_literal: true

# LeetCode 643: Maximum Average Subarray I
#
# Problem:
# Given an integer array nums consisting of n elements and an integer k,
# return the maximum average value of any contiguous subarray of length exactly k.
#
# Examples:
#   Input:  nums = [1,12,-5,-6,50,3], k = 4
#   Output: 12.75
#   Why:    Subarray [12,-5,-6,50] has sum=51, avg=51/4=12.75 — the highest of all windows.
#
#   Input:  nums = [5], k = 1
#   Output: 5.0
#   Why:    Only one element, only one window of size 1 -> average is 5.0.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate every contiguous subarray of size k.
#    For each window, rebuild the sum from scratch by visiting all k elements.
#    Track the maximum sum, then divide by k at the end.
#
#    Time Complexity: O(n * k)
#    Space Complexity: O(1)
#
#    Why O(n * k)?
#    - O(n - k + 1) possible windows
#    - O(k) work to sum each window from scratch
#
# 2. Bottleneck
#    Adjacent windows overlap heavily, so most of the summing work is repeated.
#    Example:
#    - [1, 12, -5, -6]
#    - [12, -5, -6, 50]
#    The second window keeps three elements from the first window.
#    Recomputing the whole sum each time is wasteful.
#
# 3. Optimized Accepted Approach
#    Use a fixed-size sliding window.
#    Build the sum of the first k elements once.
#    Then slide the window one step at a time:
#    - subtract the outgoing element
#    - add the incoming element
#    Update the best sum after each slide.
#
#    Since k is fixed, maximizing the average is the same as maximizing the sum.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 12, -5, -6, 50, 3]
# k = 4
#
# First window = [1, 12, -5, -6]
# window_sum = 2
# max_sum = 2
#
# right = 4
# outgoing = nums[0] = 1
# incoming = nums[4] = 50
# window_sum = 2 - 1 + 50 = 51
# max_sum = 51
#
# right = 5
# outgoing = nums[1] = 12
# incoming = nums[5] = 3
# window_sum = 51 - 12 + 3 = 42
# max_sum = 51
#
# Final answer = 51 / 4 = 12.75

def find_max_average_true_brute_force(nums, window_size)
  max_sum = -Float::INFINITY
  last_start = nums.length - window_size

  (0..last_start).each do |left|
    current_sum = 0

    (left...(left + window_size)).each do |right|
      current_sum += nums[right]
    end

    max_sum = current_sum if current_sum > max_sum
  end

  max_sum.to_f / window_size
end

def find_max_average(nums, window_size)
  window_sum = nums[0...window_size].sum
  max_sum = window_sum

  (window_size...nums.length).each do |right|
    window_sum = window_sum - nums[right - window_size] + nums[right]
    max_sum = window_sum if window_sum > max_sum
  end

  max_sum.to_f / window_size
end

if __FILE__ == $PROGRAM_NAME
  nums = [1, 12, -5, -6, 50, 3]
  k = 4

  puts "True brute force: #{find_max_average_true_brute_force(nums, k)}"
  puts "Optimized:        #{find_max_average(nums, k)}"
end
