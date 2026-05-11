# frozen_string_literal: true

# LeetCode 1004: Max Consecutive Ones III
#
# Problem:
# Given a binary array nums and an integer k, return the maximum number of
# consecutive 1's in the array if you can flip at most k 0's.
#
# Examples:
#   Input:  nums = [1,1,1,0,0,0,1,1,1,1,0], k = 2
#   Output: 6
#   Why:    Flip the two 0s at indices 9,10: window [1,1,1,1,0,0] -> flip -> 6 consecutive 1s.
#           Actually best window is indices 5..10 after flipping 2 zeros -> length 6.
#
#   Input:  nums = [0,0,1,1,0,0,1,1,1,0,1,1,0,0,0,1,1,1,1], k = 3
#   Output: 10
#   Why:    Flip 3 zeros in the right window to get 10 consecutive 1s.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate every subarray.
#    For each subarray, count how many zeroes it contains.
#    If the zero count is at most k, update the maximum length.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
#    Why O(n^2)?
#    - O(n^2) possible subarrays
#    - we maintain the zero count incrementally while expanding right
#
# 2. Bottleneck
#    Adjacent subarrays overlap heavily, so restarting from each left index
#    repeats work.
#    We do not need all valid subarrays. We only need the longest window
#    whose zero count stays at most k.
#
# 3. Optimized Accepted Approach
#    Use a variable-size sliding window.
#    Expand right one step at a time.
#    Track how many zeroes are inside the current window.
#    If zero_count becomes greater than k, move left forward until the
#    window becomes valid again.
#
#    Window invariant:
#    - zero_count <= k
#
#    After restoring validity, update the best window length.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0]
# k = 2
#
# right = 0..4
# window stays valid with at most 2 zeroes
# best length becomes 5
#
# right = 5, nums[5] = 0
# zero_count becomes 3, so the window is invalid
#
# Move left forward until one zero leaves the window:
# - skip 1 at index 0
# - skip 1 at index 1
# - skip 1 at index 2
# - remove 0 at index 3
#
# window is valid again, and we continue expanding
#
# The best valid window found has length 6
#
# Final answer = 6
#
# Edge Cases:
# - k = 0 -> longest existing streak of 1's
# - all 1's -> answer is nums.length
# - all 0's -> answer is at most k
# - k >= number of zeroes -> whole array is valid

def longest_ones_true_brute_force(nums, flip_limit)
  max_length = 0

  (0...nums.length).each do |left|
    zero_count = 0

    (left...nums.length).each do |right|
      zero_count += 1 if nums[right].zero?
      max_length = [max_length, right - left + 1].max if zero_count <= flip_limit
    end
  end

  max_length
end

def longest_ones(nums, flip_limit)
  left = zero_count = max_length = 0

  nums.each_with_index do |num, right|
    zero_count += 1 if num.zero?
    left, zero_count = shrink_zero_window(nums, left, zero_count, flip_limit) if zero_count > flip_limit
    max_length = [max_length, right - left + 1].max
  end

  max_length
end

def shrink_zero_window(nums, left, zero_count, flip_limit)
  while zero_count > flip_limit
    zero_count -= 1 if nums[left].zero?
    left += 1
  end

  [left, zero_count]
end

if __FILE__ == $PROGRAM_NAME
  nums = [1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0]
  k = 2

  puts "True brute force: #{longest_ones_true_brute_force(nums, k)}"
  puts "Optimized:        #{longest_ones(nums, k)}"
end
