# frozen_string_literal: true

# LeetCode 179: Largest Number
#
# Problem:
# Given a list of non-negative integers, arrange them to form the largest number.
# Return the result as a string.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all permutations, concatenate, pick the maximum string.
#    Time Complexity: O(n! * n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Custom comparator: for two numbers a, b compare "ab" vs "ba" as strings.
#    Sort by this comparator in descending order.
#
# 3. Optimized Accepted Approach
#    Convert to strings, sort with custom comparator (b+a vs a+b),
#    join. Handle edge case of all zeros.
#
#    Time Complexity: O(n log n * k) where k = average digit length
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [10, 2]
# strings: ["10", "2"]
# compare "2"+"10"="210" vs "10"+"2"="102" -> "210" > "102" -> "2" comes first
# Result: "210"
#
# Edge Cases:
# - All zeros: return "0"
# - Single element: return it as string

def largest_number_brute(nums)
  strs = nums.map(&:to_s)
  sorted = strs.sort { |a, b| (b + a) <=> (a + b) }
  result = sorted.join
  result[0] == '0' ? '0' : result
end

# optimized: same custom sort (already optimal)
def largest_number(nums)
  strs = nums.map(&:to_s)
  strs.sort! { |a, b| (b + a) <=> (a + b) }
  result = strs.join
  result[0] == '0' ? '0' : result
end

if __FILE__ == $PROGRAM_NAME
  puts largest_number_brute([10, 2])           # "210"
  puts largest_number([3, 30, 34, 5, 9])       # "9534330"
end
