# frozen_string_literal: true

# LeetCode 137: Single Number II
#
# Problem:
# Given an integer array where every element appears three times except for
# one which appears exactly once. Find that single element.
# Must use O(1) extra space.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use a hash map to count; return element with count 1.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    O(n) space.
#
# 3. Optimized Accepted Approach
#    For each bit position (0-31), sum all values' bits mod 3.
#    The remainder is the bit of the unique element.
#    Equivalently use ones/twos state machine with XOR.
#    Time Complexity: O(32n) = O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, 2, 3, 2]
# Bit position 0: 0+0+1+0 = 1 → 1%3 = 1 → unique has bit 0 set
# Bit position 1: 1+1+1+1 = 4 → 4%3 = 1 → unique has bit 1 set
# Unique = 0b11 = 3 ✓
#
# Edge Cases:
# - Array length = 1 → return that element (appears once trivially)
# - Negative numbers handled by checking 32 bits and sign bit

def single_number_ii_brute(nums)
  nums.tally.find { |_, count| count == 1 }[0]
end

def single_number_ii(nums)
  result = 0
  32.times do |bit|
    # sum the bit-th bit across all numbers
    bit_sum = nums.sum { |n| (n >> bit) & 1 }
    # if sum mod 3 != 0, the unique number has this bit set
    result |= (bit_sum % 3) << bit
  end

  # handle sign extension for Ruby's arbitrary precision integers
  result >= 2**31 ? result - 2**32 : result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{single_number_ii_brute([2, 2, 3, 2])}"           # 3
  puts "Opt:   #{single_number_ii([2, 2, 3, 2])}"                 # 3
  puts "Brute: #{single_number_ii_brute([0, 1, 0, 1, 0, 1, 99])}" # 99
  puts "Opt:   #{single_number_ii([0, 1, 0, 1, 0, 1, 99])}"       # 99
end
