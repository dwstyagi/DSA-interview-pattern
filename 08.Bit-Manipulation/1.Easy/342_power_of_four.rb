# frozen_string_literal: true

# LeetCode 342: Power of Four
#
# Problem:
# Given an integer n, return true if it is a power of four. An integer n is a
# power of four if there exists an integer x such that n == 4^x.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Divide by 4 repeatedly; if we reach 1, it's a power of four.
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Division loop.
#
# 3. Optimized Accepted Approach
#    Must be a power of two (single set bit) AND that bit must be at an even
#    position (positions 0, 2, 4, ...). Check with mask 0x55555555 (even positions).
#    n > 0 && (n & (n-1)) == 0 && (n & 0x55555555) != 0
#    Time Complexity: O(1)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=16 (10000): power of 2 ✓; 16 & 0x55555555 = 10000 & 01010101...= 0 → false
# Wait: 16 = 4^2 → bit at position 4 (0-indexed). 0x55 = 01010101, position 4 is 1 ✓
# Actually 0x55555555 = 0101 0101 ... positions 0,2,4,6,... are set → 16's bit at pos 4 ✓
#
# Edge Cases:
# - n=1 → 4^0 = 1, return true
# - n=2 → power of 2 but not 4, return false
# - n=0 → false

def is_power_of_four_brute(n)
  return false if n <= 0

  n = n / 4 while n % 4 == 0
  n == 1
end

def is_power_of_four(n)
  # power of 2 (single set bit) AND bit is at an even position (0,2,4,...)
  n > 0 && (n & (n - 1)) == 0 && (n & 0x55555555) != 0
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{is_power_of_four_brute(16)}"  # true (4^2)
  puts "Opt:   #{is_power_of_four(16)}"        # true
  puts "Brute: #{is_power_of_four_brute(5)}"   # false
  puts "Opt:   #{is_power_of_four(5)}"         # false
  puts "Brute: #{is_power_of_four_brute(1)}"   # true (4^0)
  puts "Opt:   #{is_power_of_four(1)}"         # true
  puts "Brute: #{is_power_of_four_brute(2)}"   # false (2^1, not 4^x)
  puts "Opt:   #{is_power_of_four(2)}"         # false
end
