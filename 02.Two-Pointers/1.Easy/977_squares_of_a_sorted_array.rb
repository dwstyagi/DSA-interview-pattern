# frozen_string_literal: true

# LeetCode 977: Squares of a Sorted Array
#
# Problem:
# Given an integer array nums sorted in non-decreasing order, return an array
# of the squares of each number also sorted in non-decreasing order.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Square every number, then sort the result.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    The input is already sorted, but brute force ignores that and performs a
#    full sort after squaring.
#    That extra sort is unnecessary.
#
# 3. Optimized Accepted Approach
#    Use two pointers from opposite ends.
#    The largest square must come from the value with the largest absolute
#    value, which will always be at either end of the sorted array.
#
#    Compare abs(nums[left]) and abs(nums[right]).
#    Place the larger square at the current write position in the result array,
#    starting from the back and moving leftward.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [-4, -1, 0, 3, 10]
#
# compare |-4| and |10|
# 10 is larger -> write 100 at the end
#
# compare |-4| and |3|
# 4 is larger -> write 16 before 100
#
# compare |-1| and |3|
# 3 is larger -> write 9
#
# compare |-1| and |0|
# 1 is larger -> write 1
#
# write 0 last
#
# Final answer = [0, 1, 9, 16, 100]
#
# Edge Cases:
# - all non-negative -> squares stay in order
# - all negative -> squares reverse order by size, but the algorithm handles it
# - zero in the middle still works naturally

def sorted_squares_true_brute_force(nums)
  nums.map { |num| num * num }.sort
end

def sorted_squares(nums)
  result = Array.new(nums.length)
  left = 0
  right = nums.length - 1
  (nums.length - 1).downto(0) do |write|
    left, right = fill_square(nums, result, write, left, right)
  end
  result
end

def fill_square(nums, result, write, left, right)
  if nums[left].abs > nums[right].abs
    result[write] = nums[left] * nums[left]
    [left + 1, right]
  else
    result[write] = nums[right] * nums[right]
    [left, right - 1]
  end
end

if __FILE__ == $PROGRAM_NAME
  nums = [-4, -1, 0, 3, 10]

  puts "True brute force: #{sorted_squares_true_brute_force(nums)}"
  puts "Optimized:        #{sorted_squares(nums)}"
end
