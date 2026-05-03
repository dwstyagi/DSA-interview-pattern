# frozen_string_literal: true

# LeetCode 136: Single Number
#
# Problem:
# Given a non-empty array of integers where every element appears twice except
# for one. Find that single one. Must run in O(n) time with O(1) extra space.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use a hash map to count frequencies; return the element with count 1.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    O(n) space for the hash map.
#
# 3. Optimized Accepted Approach
#    XOR all elements. Since a ^ a = 0 and a ^ 0 = a, all pairs cancel,
#    leaving only the unique element.
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [4, 1, 2, 1, 2]
# XOR: 0 ^ 4 = 4 ^ 1 = 5 ^ 2 = 7 ^ 1 = 6 ^ 2 = 4
# Result: 4 ✓
#
# Edge Cases:
# - Single element array → return it
# - Large values → XOR handles all integer sizes

def single_number_brute(nums)
  nums.tally.find { |_, count| count == 1 }[0]
end

def single_number(nums)
  nums.reduce(0, :^)   # XOR all; pairs cancel to 0, lone element remains
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{single_number_brute([2, 2, 1])}"            # 1
  puts "Opt:   #{single_number([2, 2, 1])}"                  # 1
  puts "Brute: #{single_number_brute([4, 1, 2, 1, 2])}"     # 4
  puts "Opt:   #{single_number([4, 1, 2, 1, 2])}"           # 4
end
