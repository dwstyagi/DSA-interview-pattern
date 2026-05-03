# frozen_string_literal: true

# LeetCode 268: Missing Number
#
# Problem:
# Given an array nums containing n distinct numbers in range [0, n],
# return the only number in the range that is missing.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Sort and scan for the gap, or use a set and check 0..n.
#    Time Complexity: O(n log n) or O(n) with set
#    Space Complexity: O(1) or O(n)
#
# 2. Bottleneck
#    Extra space for set, or sorting.
#
# 3. Optimized Accepted Approach
#    XOR all indices (0..n) with all nums. Pairs cancel, leaving the missing.
#    Alternatively: expected_sum = n*(n+1)/2, actual_sum = sum(nums),
#    missing = expected - actual.
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [3, 0, 1], n = 3
# XOR: (0^1^2^3) ^ (3^0^1) = 0^1^2^3^3^0^1 = 2
# OR: expected=6, actual=4, missing=2 ✓
#
# Edge Cases:
# - Missing 0 → XOR with 0 works
# - Missing n → last value missing

def missing_number_brute(nums)
  n = nums.length
  (0..n).find { |i| !nums.include?(i) }
end

def missing_number(nums)
  n = nums.length
  # Gauss formula: expected sum of 0..n
  n * (n + 1) / 2 - nums.sum
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{missing_number_brute([3, 0, 1])}"    # 2
  puts "Opt:   #{missing_number([3, 0, 1])}"          # 2
  puts "Brute: #{missing_number_brute([0, 1])}"       # 2
  puts "Opt:   #{missing_number([0, 1])}"             # 2
  puts "Brute: #{missing_number_brute([9, 6, 4, 2, 3, 5, 7, 0, 1])}"  # 8
  puts "Opt:   #{missing_number([9, 6, 4, 2, 3, 5, 7, 0, 1])}"        # 8
end
