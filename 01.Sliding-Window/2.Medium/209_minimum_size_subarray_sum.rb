# frozen_string_literal: true

# LeetCode 209: Minimum Size Subarray Sum
#
# Problem:
# Given an array of positive integers nums and a positive integer target,
# return the length of the smallest contiguous subarray whose sum is greater
# than or equal to target. If no such subarray exists, return 0.
#
# Examples:
#   Input:  target = 7, nums = [2,3,1,2,4,3]
#   Output: 2
#   Why:    Subarray [4,3] has sum=7 >= target with length 2 — smallest such window.
#
#   Input:  target = 4, nums = [1,4,4]
#   Output: 1
#   Why:    Single element [4] already meets target=4 -> minimum length is 1.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every possible subarray (left, right).
#    Maintain a running sum as right expands.
#    Once sum >= target, record the length and break the inner loop because
#    any longer window from the same left will not be smaller.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    We restart the sum from every left index, which repeats work.
#    Since all numbers are positive, the sum only grows as we expand right and
#    only shrinks as we move left forward.
#
# 3. Optimized Accepted Approach
#    Use a variable-size sliding window with a running sum.
#    Expand right one step at a time.
#    When sum >= target, update the best answer and shrink from the left until
#    the window becomes invalid again.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, 3, 1, 2, 4, 3]
# target = 7
#
# right = 0, sum = 2
# right = 1, sum = 5
# right = 2, sum = 6
# right = 3, sum = 8
# window [2, 3, 1, 2] is valid, best = 4
# shrink from left -> sum = 6
#
# right = 4, sum = 10
# window [3, 1, 2, 4] is valid, best = 4
# shrink -> [1, 2, 4], best = 3
# shrink -> sum = 6
#
# right = 5, sum = 9
# window [2, 4, 3] is valid, best = 3
# shrink -> [4, 3], best = 2
# shrink -> sum = 3
#
# Final answer = 2
#
# Edge Cases:
# - empty array -> return 0
# - total sum < target -> return 0
# - single element >= target -> return 1

def min_sub_array_len_true_brute_force(target, nums)
  min_length = Float::INFINITY

  (0...nums.length).each do |left|
    sum = 0

    (left...nums.length).each do |right|
      sum += nums[right]

      if sum >= target
        min_length = [min_length, right - left + 1].min
        break
      end
    end
  end
  min_length.finite? ? min_length : 0
end

def min_sub_array_len(target, nums)
  left = 0
  sum = 0
  min_length = Float::INFINITY

  nums.each_index do |right|
    sum += nums[right]

    while sum >= target
      min_length = [min_length, right - left + 1].min
      sum -= nums[left]
      left += 1
    end
  end

  min_length.finite? ? min_length : 0
end

if __FILE__ == $PROGRAM_NAME
  nums = [2, 3, 1, 2, 4, 3]
  target = 7

  puts "True brute force: #{min_sub_array_len_true_brute_force(target, nums)}"
  puts "Optimized:        #{min_sub_array_len(target, nums)}"
end
