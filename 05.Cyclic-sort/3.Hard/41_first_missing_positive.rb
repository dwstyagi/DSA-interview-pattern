# frozen_string_literal: true

# LeetCode 41: First Missing Positive
#
# Problem:
# Given an unsorted integer array nums, return the smallest missing positive integer.
# Must run in O(n) time and use O(1) extra space.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Filter positives, put in a set, scan 1..n+1 for missing.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra O(n) space. We can use the array itself as a hash via cyclic sort.
#
# 3. Optimized Accepted Approach
#    Cyclic sort ignoring values <= 0 and > n.
#    After sorting: first index where nums[i] != i+1 gives the answer.
#    If all positions correct, answer is n+1.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [3, 4, -1, 1]
# n=4, ignore -1 and values >4
# i=0: nums[0]=3, correct=2, nums[2]=-1≠3 → swap → [-1,4,3,1]
# i=0: nums[0]=-1, not in (0,4] → i=1
# i=1: nums[1]=4, correct=3, nums[3]=1≠4 → swap → [-1,1,3,4]
# i=1: nums[1]=1, correct=0, nums[0]=-1≠1 → swap → [1,-1,3,4]
# i=1: nums[1]=-1 → i=2
# i=2: nums[2]=3, correct=2, nums[2]=3 → i=3
# i=3: nums[3]=4, correct=3, nums[3]=4 → i=4
# Scan: idx0=1✓, idx1=-1≠2 → return 2
#
# Edge Cases:
# - [1]          -> 2
# - [1,2,3]     -> 4
# - All negative -> 1

def first_missing_positive_brute(nums)
  present = nums.select { |n| n > 0 }.to_set
  1.upto(nums.length + 1) { |i| return i unless present.include?(i) }
end

def first_missing_positive(nums)
  n = nums.length
  i = 0

  # Cyclic sort: place value v at index v-1, ignoring out-of-range values
  while i < n
    correct = nums[i] - 1
    # Only sort values in valid range [1, n] and avoid infinite loop on duplicates
    if nums[i] > 0 && nums[i] <= n && nums[i] != nums[correct]
      nums[i], nums[correct] = nums[correct], nums[i]
    else
      i += 1
    end
  end

  # First index where value doesn't match = first missing positive
  nums.each_with_index { |v, idx| return idx + 1 if v != idx + 1 }
  n + 1
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{first_missing_positive_brute([3, 4, -1, 1])}" # 2
  puts "Optimized:   #{first_missing_positive([3, 4, -1, 1])}"       # 2
  puts "Brute force: #{first_missing_positive_brute([1, 2, 0])}"     # 3
  puts "Optimized:   #{first_missing_positive([1, 2, 0])}"           # 3
  puts "Brute force: #{first_missing_positive_brute([7, 8, 9, 11])}" # 1
  puts "Optimized:   #{first_missing_positive([7, 8, 9, 11])}"       # 1
end
