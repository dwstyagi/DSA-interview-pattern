# frozen_string_literal: true

# LeetCode 16: 3Sum Closest
#
# Problem:
# Given an integer array nums and an integer target, return the sum of three
# integers in nums such that the sum is closest to target.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every triplet (i, j, k) with i < j < k.
#    Track the sum whose absolute distance from target is smallest.
#
#    Time Complexity: O(n^3)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Three nested loops check every possible triplet.
#    If we sort the array first, we can fix one number and use two pointers to
#    search the best remaining pair in linear time for that fixed index.
#
# 3. Optimized Accepted Approach
#    Sort the array.
#    For each fixed index, use left and right pointers for the remaining range.
#    Track the closest sum seen so far.
#
#    Pointer movement:
#    - current_sum < target -> move left rightward to increase the sum
#    - current_sum > target -> move right leftward to decrease the sum
#    - current_sum == target -> return target immediately
#
#    Returning immediately on exact match is valid because distance 0 is the
#    best possible distance.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1) extra, depending on sorting implementation
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [-1, 2, 1, -4]
# target = 1
# sorted nums = [-4, -1, 1, 2]
#
# closest_sum = -4 + -1 + 1 = -4
#
# fixed index 0, value -4
# left = 1, right = 3
# current_sum = -4 + -1 + 2 = -3
# -3 is closer than -4, update closest_sum
# current_sum < target, move left
#
# left = 2, right = 3
# current_sum = -4 + 1 + 2 = -1
# -1 is closer than -3, update closest_sum
# current_sum < target, move left
#
# fixed index 1, value -1
# left = 2, right = 3
# current_sum = -1 + 1 + 2 = 2
# 2 is closest to target 1, update closest_sum
#
# Final answer = 2
#
# Edge Cases:
# - exactly one closest sum is not required; returning any closest sum is valid
# - exact target match can return immediately
# - negative numbers work after sorting

def three_sum_closest_true_brute_force(nums, target)
  closest_sum = nums[0] + nums[1] + nums[2]

  (0...(nums.length - 2)).each do |first|
    ((first + 1)...(nums.length - 1)).each do |second|
      ((second + 1)...nums.length).each do |third|
        current_sum = nums[first] + nums[second] + nums[third]
        closest_sum = closer_sum(current_sum, closest_sum, target)
      end
    end
  end

  closest_sum
end

def three_sum_closest(nums, target)
  nums.sort!
  closest_sum = nums[0] + nums[1] + nums[2]

  (0...(nums.length - 2)).each do |fixed_index|
    closest_sum = scan_closest_pair(nums, fixed_index, target, closest_sum)
    return target if closest_sum == target
  end

  closest_sum
end

def scan_closest_pair(nums, fixed_index, target, closest_sum)
  left = fixed_index + 1
  right = nums.length - 1

  while left < right
    current_sum = nums[fixed_index] + nums[left] + nums[right]
    closest_sum = closer_sum(current_sum, closest_sum, target)
    left, right = move_closest_pointers(current_sum, target, left, right)
  end

  closest_sum
end

def closer_sum(current_sum, closest_sum, target)
  current_distance = (current_sum - target).abs
  closest_distance = (closest_sum - target).abs
  current_distance < closest_distance ? current_sum : closest_sum
end

def move_closest_pointers(current_sum, target, left, right)
  return [left + 1, right] if current_sum < target
  return [left, right - 1] if current_sum > target

  [left, left]
end

if __FILE__ == $PROGRAM_NAME
  nums = [-1, 2, 1, -4]
  target = 1

  puts "True brute force: #{three_sum_closest_true_brute_force(nums, target)}"
  puts "Optimized:        #{three_sum_closest(nums, target)}"
end
