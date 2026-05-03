# frozen_string_literal: true

# LeetCode 209: Minimum Size Subarray Sum
#
# Problem:
# Given an array of positive integers nums and a positive integer target,
# return the length of the smallest contiguous subarray whose sum is greater
# than or equal to target. If no such subarray exists, return 0.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every possible subarray (left, right).
#    Maintain a running sum as right expands.
#    Once sum >= target, record the length and break inner loop.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    We restart the sum from every left — wasted work.
#    Since all numbers are positive, the sum only grows as we expand right
#    and shrinks as we shrink left.
#    Once sum >= target, shrink from left to find a smaller valid window
#    instead of restarting from scratch.
#
# 3. Optimized Accepted Approach
#    Use a sliding window with a running sum.
#    Expand right one step at a time, add nums[right] to sum.
#    When sum >= target, record window size then shrink from left
#    until sum < target. Track minimum window size throughout.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, 3, 1, 2, 4, 3], target = 7
#
# right=0, sum=2, result=INF
# right=1, sum=5, result=INF
# right=2, sum=6, result=INF
# right=3, sum=8 >= 7 -> result=4, sum=6 (remove 2), left=1
# right=4, sum=10 >= 7 -> result=3, sum=7 (remove 3), left=2
#           sum=7 >= 7  -> result=3, sum=6 (remove 1), left=3
# right=5, sum=9 >= 7  -> result=3, sum=7 (remove 2), left=4
#           sum=7 >= 7  -> result=2, sum=3 (remove 4), left=5
#
# Final answer = 2
#
# Edge Cases:
# - Empty array -> return 0
# - Total sum < target -> return 0
# - Single element >= target -> return 1

def min_sub_array_len_brute(target, nums)
  min_length = Float::INFINITY
  (0...nums.length).each do |left|
    sum = 0
    (left...nums.length).each do |right|
      sum += nums[right]
      break min_length = [min_length, right - left + 1].min if sum >= target
    end
  end
  finite_length_or_zero(min_length)
end

def min_sub_array_len(target, nums)
  left = 0
  sum = 0
  min_length = Float::INFINITY
  nums.each_index do |right|
    sum += nums[right]
    left, sum, candidate = shrink_min_window(nums, target, left, right, sum)
    min_length = [min_length, candidate].min
  end
  finite_length_or_zero(min_length)
end

def shrink_min_window(nums, target, left, right, sum)
  min_length = Float::INFINITY
  while sum >= target
    min_length = [min_length, right - left + 1].min
    sum -= nums[left]
    left += 1
  end
  [left, sum, min_length]
end

def finite_length_or_zero(length)
  length.finite? ? length : 0
end

if __FILE__ == $PROGRAM_NAME
  nums = [2, 3, 1, 2, 4, 3]
  target = 7

  puts "Brute force: #{min_sub_array_len_brute(target, nums)}"
  puts "Optimized:   #{min_sub_array_len(target, nums)}"
end
