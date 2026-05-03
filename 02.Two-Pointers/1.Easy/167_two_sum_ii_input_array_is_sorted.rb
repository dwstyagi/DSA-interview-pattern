# frozen_string_literal: true

# LeetCode 167: Two Sum II - Input Array Is Sorted
#
# Problem:
# Given a 1-indexed array numbers sorted in non-decreasing order, find two
# numbers such that they add up to target_sum and return their 1-based indices.
# The problem guarantees exactly one solution, and the same element cannot be
# used twice.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every pair of indices.
#    If numbers[left] + numbers[right] equals target_sum, return their 1-based
#    indices.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Brute force ignores the fact that the array is already sorted.
#    It checks many impossible pairs even though sorted order tells us how the
#    sum changes when we move either pointer.
#
# 3. Optimized Accepted Approach
#    Use two pointers from opposite ends.
#    - left starts at the beginning
#    - right starts at the end
#
#    At each step:
#    - if the sum is too small, move left rightward to increase it
#    - if the sum is too large, move right leftward to decrease it
#    - if the sum matches target_sum, return the 1-based indices
#
#    Because the array is sorted, every pointer move discards impossible pairs.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# numbers = [2, 7, 11, 15]
# target_sum = 9
#
# left = 0, right = 3
# 2 + 15 = 17 > 9, move right left
#
# left = 0, right = 2
# 2 + 11 = 13 > 9, move right left
#
# left = 0, right = 1
# 2 + 7 = 9, match found
#
# Return [1, 2]
#
# Edge Cases:
# - smallest valid input has exactly two numbers
# - duplicate values are allowed, but indices must be different
# - negative numbers do not change the two-pointer logic

def two_sum_true_brute_force(numbers, target_sum)
  (0...numbers.length).each do |left|
    ((left + 1)...numbers.length).each do |right|
      return [left + 1, right + 1] if numbers[left] + numbers[right] == target_sum
    end
  end
end

def two_sum(numbers, target_sum)
  left = 0
  right = numbers.length - 1

  while left < right
    current_sum = numbers[left] + numbers[right]
    return [left + 1, right + 1] if current_sum == target_sum

    current_sum < target_sum ? left += 1 : right -= 1
  end
end

if __FILE__ == $PROGRAM_NAME
  numbers = [2, 7, 11, 15]
  target_sum = 9

  puts "True brute force: #{two_sum_true_brute_force(numbers, target_sum)}"
  puts "Optimized:        #{two_sum(numbers, target_sum)}"
end
