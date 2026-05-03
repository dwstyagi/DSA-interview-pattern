# frozen_string_literal: true

# LeetCode 18: 4Sum
#
# Problem:
# Given an integer array nums and an integer target, return all unique
# quadruplets [a, b, c, d] such that a + b + c + d == target.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every group of four indices.
#    If the four values sum to target, sort that quadruplet and add it to a Set
#    to avoid duplicates.
#
#    Time Complexity: O(n^4)
#    Space Complexity: O(number of answers)
#
# 2. Bottleneck
#    Four nested loops check every possible quadruplet.
#    If we sort the array first, we can fix two numbers and use two pointers to
#    find the remaining pair in linear time.
#
# 3. Optimized Accepted Approach
#    Sort the array.
#    Fix the first value with index first.
#    Fix the second value with index second.
#    Then use left and right pointers to find pairs that complete target.
#
#    Duplicate handling:
#    - skip duplicate first values
#    - skip duplicate second values
#    - after recording a quadruplet, move both pointers and skip duplicate
#      left/right values
#
#    Time Complexity: O(n^3)
#    Space Complexity: O(1) extra, excluding output
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 0, -1, 0, -2, 2]
# target = 0
# sorted nums = [-2, -1, 0, 0, 1, 2]
#
# first = 0, nums[first] = -2
# second = 1, nums[second] = -1
# left = 2, right = 5
# sum = -2 + -1 + 0 + 2 = -1, too small, move left
#
# left = 3, right = 5
# sum = -2 + -1 + 0 + 2 = -1, too small, move left
#
# left = 4, right = 5
# sum = -2 + -1 + 1 + 2 = 0
# record [-2, -1, 1, 2]
#
# Continue scanning to find:
# [-2, 0, 0, 2]
# [-1, 0, 0, 1]
#
# Final answer = [[-2, -1, 1, 2], [-2, 0, 0, 2], [-1, 0, 0, 1]]
#
# Edge Cases:
# - fewer than 4 elements -> return []
# - duplicate values must not create duplicate quadruplets
# - negative numbers and positive numbers both work after sorting

def four_sum_true_brute_force(nums, target)
  result = Set.new
  length = nums.length

  (0...(length - 3)).each do |first|
    ((first + 1)...(length - 2)).each do |second|
      ((second + 1)...(length - 1)).each do |third|
        ((third + 1)...length).each do |fourth|
          quadruplet = [nums[first], nums[second], nums[third], nums[fourth]]
          result.add(quadruplet.sort) if quadruplet.sum == target
        end
      end
    end
  end

  result.to_a
end

def four_sum(nums, target)
  nums.sort!
  result = []
  length = nums.length

  (0...(length - 3)).each do |first|
    next if first.positive? && nums[first] == nums[first - 1]

    ((first + 1)...(length - 2)).each do |second|
      next if second > first + 1 && nums[second] == nums[second - 1]

      left = second + 1
      right = length - 1

      while left < right
        current_sum = nums[first] + nums[second] + nums[left] + nums[right]

        if current_sum == target
          result << [nums[first], nums[second], nums[left], nums[right]]
          left += 1
          right -= 1

          left += 1 while left < right && nums[left] == nums[left - 1]
          right -= 1 while left < right && nums[right] == nums[right + 1]
        elsif current_sum < target
          left += 1
        else
          right -= 1
        end
      end
    end
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  nums = [1, 0, -1, 0, -2, 2]
  target = 0

  puts "True brute force: #{four_sum_true_brute_force(nums, target)}"
  puts "Optimized:        #{four_sum(nums, target)}"
end
