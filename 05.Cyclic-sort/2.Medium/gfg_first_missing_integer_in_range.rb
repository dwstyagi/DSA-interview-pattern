# frozen_string_literal: true

# GFG: First Missing Integer in Range
#
# Problem:
# Given an array of integers and a range [a, b], find the first integer in the range
# that is missing from the array. If all integers in the range are present, return b+1.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use a set of all numbers in the array; scan a..b for the first missing.
#
#    Time Complexity: O(n + range_size)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra O(n) space. Can use a bounded cyclic sort for values in [a, b].
#
# 3. Optimized Accepted Approach
#    Shift values so range [a, b] maps to [0, b-a].
#    Cyclic sort within bounds; then scan for first mismatch → return a + mismatch_index.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 3, 6, 4, 1, 2], a=1, b=6
# Shift: treat as range [1,6] → values 1..6 at indices 0..5
# After sort: [1,1,3,4,6,...] — 2 missing
# Scan: index 1 has 1 (should be 2) → first missing = 2
#
# Edge Cases:
# - All in range present -> b+1
# - a and b far apart    -> O(n) still

def first_missing_in_range_brute(nums, a, b)
  present = nums.to_set
  (a..b).each { |i| return i unless present.include?(i) }
  b + 1
end

def first_missing_in_range(nums, a, b)
  n = nums.length

  # Only sort values that fall within [a, b]
  # Each value v in [a, b] belongs at index v - a
  i = 0
  while i < n
    v = nums[i]
    correct = v - a
    if v >= a && v <= b && correct < n && nums[i] != nums[correct]
      nums[i], nums[correct] = nums[correct], nums[i]
    else
      i += 1
    end
  end

  # Scan for the first mismatch
  (0...n).each { |idx| return a + idx if nums[idx] != a + idx }

  # All positions covered up to n; the next missing is a+n or b+1
  [a + n, b + 1].min
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{first_missing_in_range_brute([1, 3, 6, 4, 1, 2], 1, 6)}" # 5
  puts "Optimized:   #{first_missing_in_range([1, 3, 6, 4, 1, 2], 1, 6)}"       # 5
  puts "Brute force: #{first_missing_in_range_brute([1, 2, 3, 4], 1, 5)}"       # 5
  puts "Optimized:   #{first_missing_in_range([1, 2, 3, 4], 1, 5)}"             # 5
end
