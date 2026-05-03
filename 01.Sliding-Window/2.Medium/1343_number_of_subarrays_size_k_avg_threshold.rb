# frozen_string_literal: true

# LeetCode 1343: Number of Sub-arrays of Size K and Average Greater than or
# Equal to Threshold
#
# Problem:
# Given an integer array arr and two integers k and threshold, return the
# number of contiguous subarrays of size exactly k whose average is greater
# than or equal to threshold.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate every window of size k.
#    For each window, rebuild its sum from scratch.
#    If the sum is at least k * threshold, count it.
#
#    Time Complexity: O(n * k)
#    Space Complexity: O(1)
#
#    Why O(n * k)?
#    - O(n - k + 1) possible windows
#    - O(k) work to sum each window from scratch
#
# 2. Bottleneck
#    Consecutive windows overlap heavily, but brute force recomputes the whole
#    sum every time.
#    When a fixed-size window moves by one step:
#    - one element leaves
#    - one element enters
#
#    Rebuilding the entire sum is wasted work.
#
# 3. Optimized Accepted Approach
#    Use a fixed-size sliding window.
#    Convert the average condition:
#      window_sum / k >= threshold
#    into:
#      window_sum >= k * threshold
#
#    Build the first window sum once.
#    Then slide one step at a time:
#    - subtract the outgoing value
#    - add the incoming value
#    - count the window if it meets the target sum
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# arr = [2, 2, 2, 2, 5, 5, 5, 8]
# k = 3
# threshold = 4
# target_sum = 12
#
# first window = [2, 2, 2]
# window_sum = 6
# not counted
#
# slide to [2, 2, 2]
# window_sum = 6
# not counted
#
# slide to [2, 2, 5]
# window_sum = 9
# not counted
#
# slide to [2, 5, 5]
# window_sum = 12
# counted
#
# slide to [5, 5, 5]
# window_sum = 15
# counted
#
# slide to [5, 5, 8]
# window_sum = 18
# counted
#
# Final answer = 3
#
# Edge Cases:
# - arr.length == k -> only one window exists
# - if no window reaches the target sum, answer is 0
# - use sum comparison instead of average division to avoid extra work

def num_of_subarrays_true_brute_force(array, window_size, threshold)
  target_sum = window_size * threshold
  count = 0

  (0..(array.length - window_size)).each do |left|
    count += 1 if array[left, window_size].sum >= target_sum
  end

  count
end

def num_of_subarrays(array, window_size, threshold)
  target_sum = window_size * threshold
  window_sum = array[0...window_size].sum
  count = count_window(window_sum, target_sum)

  (window_size...array.length).each do |right|
    window_sum = window_sum - array[right - window_size] + array[right]
    count += count_window(window_sum, target_sum)
  end

  count
end

def count_window(window_sum, target_sum)
  window_sum >= target_sum ? 1 : 0
end

if __FILE__ == $PROGRAM_NAME
  array = [2, 2, 2, 2, 5, 5, 5, 8]
  window_size = 3
  threshold = 4

  puts "True brute force: #{num_of_subarrays_true_brute_force(array, window_size, threshold)}"
  puts "Optimized:        #{num_of_subarrays(array, window_size, threshold)}"
end
