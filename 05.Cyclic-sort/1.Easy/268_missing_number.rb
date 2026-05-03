# frozen_string_literal: true

# LeetCode 268: Missing Number
#
# Problem:
# Given an array nums containing n distinct numbers in the range [0, n],
# return the only number in the range that is missing from the array.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Sort the array and check for missing number.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Sorting is unnecessary. Can use XOR or sum formula in O(n).
#
# 3. Optimized Accepted Approach
#    Method A (cyclic sort): place each number at index nums[i], then scan for mismatch.
#    Method B (sum): missing = n*(n+1)/2 - sum(nums).
#    Method C (XOR): XOR all indices and values; pairs cancel, leaving the missing one.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run  (cyclic sort)
#
# nums = [3, 0, 1]
# i=0: nums[0]=3, correct index=3, swap(0,3) → [1,0,3] wait out of bounds (n=3)
# Actually 3 = n so skip, i++ → i=1: nums[1]=0, correct=0, swap(1,0) → [0,1,3]
# i=2: nums[2]=3, correct=3 (out of range), i++
# Scan: index 0→0✓, 1→1✓, 2→3✗ → missing = 2
#
# Edge Cases:
# - Missing 0      -> 0
# - Missing n      -> n
# - Single element -> 0 or 1

def missing_number_brute(nums)
  # Sum formula: expected sum - actual sum
  n = nums.length
  n * (n + 1) / 2 - nums.sum
end

def missing_number(nums)
  n = nums.length
  i = 0

  # Cyclic sort: place each value v at index v (skip if v == n, out of range)
  while i < n
    correct = nums[i]
    if nums[i] < n && nums[i] != nums[correct]
      nums[i], nums[correct] = nums[correct], nums[i]
    else
      i += 1
    end
  end

  # First index where nums[i] != i is the missing number
  nums.each_with_index { |v, idx| return idx if v != idx }
  n # missing number is n
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{missing_number_brute([3, 0, 1])}" # 2
  puts "Optimized:   #{missing_number([3, 0, 1])}"       # 2
  puts "Brute force: #{missing_number_brute([0, 1])}"    # 2
  puts "Optimized:   #{missing_number([0, 1])}"          # 2
end
