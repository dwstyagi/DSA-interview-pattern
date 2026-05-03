# frozen_string_literal: true

# LeetCode 26: Remove Duplicates from Sorted Array
#
# Problem:
# Given a sorted integer array nums, remove the duplicates in-place such that
# each unique element appears only once. Return the number of unique elements.
# Only the first k positions of nums need to contain the final unique values.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Build a separate array of unique values.
#    Then copy those values back into nums and return the unique count.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Time is already linear, but brute force allocates another array.
#    The problem asks for in-place modification, so that extra O(n) space is
#    unnecessary.
#
# 3. Optimized Accepted Approach
#    Use same-direction two pointers.
#    - fast scans the array
#    - slow tracks the next position to write a new unique value
#
#    Because the array is sorted, duplicates are adjacent.
#    So whenever nums[fast] != nums[fast - 1], we have found a new unique
#    value and should write it at nums[slow].
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [0, 0, 1, 1, 1, 2, 2, 3, 3, 4]
#
# slow = 1
#
# fast = 1
# nums[1] == nums[0], skip
#
# fast = 2
# nums[2] = 1, nums[1] = 0, new unique value
# write nums[1] = 1, slow = 2
#
# fast = 5
# nums[5] = 2, nums[4] = 1, new unique value
# write nums[2] = 2, slow = 3
#
# continue similarly to write 3 and 4
#
# Final useful portion = [0, 1, 2, 3, 4]
# Return 5
#
# Edge Cases:
# - empty array -> return 0
# - single element -> return 1
# - all values same -> return 1

def remove_duplicates_true_brute_force(nums)
  unique = []

  nums.each do |num|
    unique << num if unique.empty? || unique[-1] != num
  end

  unique.each_with_index do |num, index|
    nums[index] = num
  end

  unique.length
end

def remove_duplicates(nums)
  return nums.length if nums.length < 2

  slow = 1

  (1...nums.length).each do |fast|
    next if nums[fast] == nums[fast - 1]

    nums[slow] = nums[fast]
    slow += 1
  end

  slow
end

if __FILE__ == $PROGRAM_NAME
  brute_force_nums = [0, 0, 1, 1, 1, 2, 2, 3, 3, 4]
  optimized_nums = [0, 0, 1, 1, 1, 2, 2, 3, 3, 4]

  puts "True brute force: #{remove_duplicates_true_brute_force(brute_force_nums)}"
  puts "Optimized:        #{remove_duplicates(optimized_nums)}"
  puts "Optimized array:  #{optimized_nums}"
end
