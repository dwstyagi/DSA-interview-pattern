# frozen_string_literal: true

# LeetCode 283: Move Zeroes
#
# Problem:
# Given an integer array nums, move all 0's to the end while maintaining the
# relative order of the non-zero elements. The optimized solution should modify
# the array in-place.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Build a separate array containing all non-zero values in their original
#    order. Then append zeroes until the new array reaches the original length.
#    Finally, copy the values back into nums.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Time is already linear, but brute force allocates another full array.
#    The problem asks for in-place modification, so that extra O(n) space is
#    unnecessary.
#
# 3. Optimized Accepted Approach
#    Use same-direction two pointers.
#    - fast scans every value in nums
#    - slow tracks the next position where a non-zero value should be written
#
#    First pass:
#    - write each non-zero value at nums[slow]
#    - increment slow
#
#    Second pass:
#    - fill the remaining positions from slow to the end with 0
#
#    This preserves the relative order of non-zero elements.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [0, 1, 0, 3, 12]
#
# slow = 0
#
# read 0
# skip
#
# read 1
# write nums[0] = 1
# nums = [1, 1, 0, 3, 12]
# slow = 1
#
# read 0
# skip
#
# read 3
# write nums[1] = 3
# nums = [1, 3, 0, 3, 12]
# slow = 2
#
# read 12
# write nums[2] = 12
# nums = [1, 3, 12, 3, 12]
# slow = 3
#
# fill remaining positions with 0
# nums = [1, 3, 12, 0, 0]
#
# Final array = [1, 3, 12, 0, 0]
#
# Edge Cases:
# - all zeroes -> array stays the same
# - no zeroes -> array stays the same
# - single element -> works for both 0 and non-zero

def move_zeroes_true_brute_force(nums)
  result = []

  nums.each do |num|
    result << num unless num.zero?
  end

  result << 0 while result.length < nums.length
  nums.each_index { |index| nums[index] = result[index] }
end

def move_zeroes(nums)
  slow = 0

  nums.each do |num|
    next if num.zero?

    nums[slow] = num
    slow += 1
  end

  while slow < nums.length
    nums[slow] = 0
    slow += 1
  end
end

if __FILE__ == $PROGRAM_NAME
  brute_force_nums = [0, 1, 0, 3, 12]
  optimized_nums = [0, 1, 0, 3, 12]

  move_zeroes_true_brute_force(brute_force_nums)
  move_zeroes(optimized_nums)

  puts "True brute force: #{brute_force_nums}"
  puts "Optimized:        #{optimized_nums}"
end
