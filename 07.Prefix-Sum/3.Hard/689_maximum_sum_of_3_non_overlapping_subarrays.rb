# frozen_string_literal: true

# LeetCode 689: Maximum Sum of 3 Non-Overlapping Subarrays
#
# Problem:
# Given an integer array nums and an integer k, find three non-overlapping
# subarrays of length k with maximum sum. Return the starting indices in
# ascending order (leftmost on tie).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all combinations of three non-overlapping windows of size k.
#    Time Complexity: O(n³)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Cubic enumeration.
#
# 3. Optimized Accepted Approach
#    Precompute window sums. Build left[] (best window index ending at or
#    before i) and right[] (best window index starting at or after i).
#    Sweep middle window; combine left + middle + right.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[1,2,1,2,6,7,5,1], k=2
# window_sums=[3,3,3,8,13,12,6] (sums of each window starting at i)
# left[i] = index of max sum window in [0..i]
# right[i] = index of max sum window in [i..end]
# sweep i=k to n-2k: combine left[i-1], i, right[i+k]
#
# Edge Cases:
# - Exactly 3 non-overlapping windows fit → single answer
# - All same values → return [0, k, 2k]

def max_sum_of_three_subarrays_brute(nums, k)
  n = nums.length
  best = -1
  result = []

  (0..n - 3 * k).each do |i|
    (i + k..n - 2 * k).each do |j|
      (j + k..n - k).each do |l|
        sum = nums[i, k].sum + nums[j, k].sum + nums[l, k].sum
        if sum > best
          best = sum
          result = [i, j, l]
        end
      end
    end
  end

  result
end

def max_sum_of_three_subarrays(nums, k)
  n = nums.length
  # precompute sums of each window of size k
  win_sums = Array.new(n - k + 1)
  cur_sum = nums[0, k].sum
  win_sums[0] = cur_sum
  (1..n - k).each do |i|
    cur_sum += nums[i + k - 1] - nums[i - 1]
    win_sums[i] = cur_sum
  end

  m = win_sums.length

  # left[i] = index of max window sum in [0..i] (leftmost on tie)
  left = Array.new(m)
  best_idx = 0
  (0...m).each do |i|
    best_idx = i if win_sums[i] > win_sums[best_idx]
    left[i] = best_idx
  end

  # right[i] = index of max window sum in [i..m-1] (leftmost on tie)
  right = Array.new(m)
  best_idx = m - 1
  (m - 1).downto(0) do |i|
    best_idx = i if win_sums[i] >= win_sums[best_idx]
    right[i] = best_idx
  end

  result = nil
  best = -1

  # sweep middle window
  (k..m - 2 * k).each do |j|
    l = left[j - k]
    r = right[j + k]
    total = win_sums[l] + win_sums[j] + win_sums[r]
    if total > best
      best = total
      result = [l, j, r]
    end
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{max_sum_of_three_subarrays_brute([1, 2, 1, 2, 6, 7, 5, 1], 2).inspect}"  # [0,3,5]
  puts "Opt:   #{max_sum_of_three_subarrays([1, 2, 1, 2, 6, 7, 5, 1], 2).inspect}"        # [0,3,5]
  puts "Brute: #{max_sum_of_three_subarrays_brute([1, 2, 1, 2, 1, 2, 1, 2, 1], 2).inspect}"
  puts "Opt:   #{max_sum_of_three_subarrays([1, 2, 1, 2, 1, 2, 1, 2, 1], 2).inspect}"
end
