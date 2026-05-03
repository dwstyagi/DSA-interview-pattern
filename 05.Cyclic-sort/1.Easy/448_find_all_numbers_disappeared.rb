# frozen_string_literal: true

# LeetCode 448: Find All Numbers Disappeared in an Array
#
# Problem:
# Given an array nums of n integers where nums[i] is in the range [1, n],
# return an array of all the integers in the range [1, n] that do not appear in nums.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use a set to store all numbers; iterate 1..n to find missing.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra O(n) space from the set. Can do it in-place with cyclic sort.
#
# 3. Optimized Accepted Approach
#    Cyclic sort: place each value v at index v-1.
#    After sorting, indices where nums[i] != i+1 are the missing numbers.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1) extra (output doesn't count)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [4, 3, 2, 7, 8, 2, 3, 1]
# cyclic sort places each value v at index v-1:
# After sort: [1,2,3,4,3,6,7,8] — but 2 appears twice (indices 4 and 2 conflict)
# Scan: index 4 has value 3 (not 5), index 5 has value 6 ≠ 6 OK...
# Actually: [1,2,3,4,_,6,7,8] with index 4 and 5 having duplicates
# Missing: 5 and 6? → actually result is [5,6]
#
# Edge Cases:
# - All numbers present -> []
# - Multiple missing    -> all returned

def find_disappeared_numbers_brute(nums)
  present = nums.to_set
  (1..nums.length).reject { |i| present.include?(i) }
end

def find_disappeared_numbers(nums)
  n = nums.length
  i = 0

  # Cyclic sort: place value v at index v-1
  while i < n
    correct = nums[i] - 1 # value v belongs at index v-1
    if nums[i] != nums[correct]
      nums[i], nums[correct] = nums[correct], nums[i]
    else
      i += 1
    end
  end

  # Collect all positions where the value doesn't match the index
  result = []
  nums.each_with_index { |v, idx| result << (idx + 1) if v != idx + 1 }
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{find_disappeared_numbers_brute([4, 3, 2, 7, 8, 2, 3, 1]).inspect}" # [5,6]
  puts "Optimized:   #{find_disappeared_numbers([4, 3, 2, 7, 8, 2, 3, 1]).inspect}"       # [5,6]
  puts "Brute force: #{find_disappeared_numbers_brute([1, 1]).inspect}"                   # [2]
  puts "Optimized:   #{find_disappeared_numbers([1, 1]).inspect}"                         # [2]
end
