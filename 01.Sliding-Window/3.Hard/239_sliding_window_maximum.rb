# frozen_string_literal: true

# LeetCode 239: Sliding Window Maximum
#
# Problem:
# Given an integer array nums and an integer window_size, return an array of
# the maximum value in every contiguous subarray of size window_size.
#
# Examples:
#   Input:  nums = [1,3,-1,-3,5,3,6,7], k = 3
#   Output: [3,3,5,5,6,7]
#   Why:    Windows: [1,3,-1]->3, [3,-1,-3]->3, [-1,-3,5]->5, [-3,5,3]->5, [5,3,6]->6, [3,6,7]->7.
#
#   Input:  nums = [1], k = 1
#   Output: [1]
#   Why:    Single element, single window -> maximum is 1.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate every window of size window_size.
#    For each window, scan all its elements to find the maximum.
#    Append that maximum to the result array.
#
#    Time Complexity: O(n * k)
#    Space Complexity: O(1) extra, ignoring the output
#
#    Why O(n * k)?
#    - O(n - k + 1) windows
#    - O(k) scan to find the maximum in each window
#
# 2. Bottleneck
#    Consecutive windows overlap heavily, but brute force recomputes the
#    maximum from scratch every time.
#    Unlike sum, maximum cannot be updated by a simple subtract/add rule,
#    because if the outgoing element was the maximum, we do not immediately
#    know the next best value.
#
# 3. Optimized Accepted Approach
#    Use a monotonic deque.
#    The deque stores indices in decreasing order of their values:
#      nums[deque[0]] >= nums[deque[1]] >= ...
#
#    For each index right:
#    - remove indices from the front if they are outside the window
#    - remove indices from the back while their values are <= nums[right]
#    - push right into the deque
#    - once the first full window is formed, nums[deque[0]] is the maximum
#
#    The front of the deque always holds the maximum for the current window.
#
#    Time Complexity: O(n)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 3, -1, -3, 5, 3, 6, 7]
# window_size = 3
#
# right = 0, value = 1
# deque = [0]
#
# right = 1, value = 3
# remove index 0 from back because 1 <= 3
# deque = [1]
#
# right = 2, value = -1
# deque = [1, 2]
# first full window formed -> max = nums[1] = 3
#
# right = 3, value = -3
# deque = [1, 2, 3]
# max = nums[1] = 3
#
# right = 4, value = 5
# index 1 is out of window, remove it from front
# remove indices 3 and 2 from back because their values are smaller than 5
# deque = [4]
# max = nums[4] = 5
#
# Final answer = [3, 3, 5, 5, 6, 7]
#
# Edge Cases:
# - window_size = 1 -> answer is nums
# - window_size = nums.length -> one window, one maximum
# - duplicate maximums are handled correctly by the deque logic

def max_sliding_window_true_brute_force(nums, window_size)
  (0..(nums.length - window_size)).map do |left|
    nums[left, window_size].max
  end
end

def max_sliding_window(nums, window_size)
  deque = []
  result = []

  nums.each_with_index do |num, right|
    deque.shift if !deque.empty? && deque[0] <= right - window_size
    deque.pop while !deque.empty? && nums[deque[-1]] <= num
    deque << right
    result << nums[deque[0]] if right >= window_size - 1
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  nums = [1, 3, -1, -3, 5, 3, 6, 7]
  window_size = 3

  puts "True brute force: #{max_sliding_window_true_brute_force(nums, window_size)}"
  puts "Optimized:        #{max_sliding_window(nums, window_size)}"
end
