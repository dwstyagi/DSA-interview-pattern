# frozen_string_literal: true

# LeetCode 231: Power of Two
#
# Problem:
# Given an integer n, return true if it is a power of two, false otherwise.
# An integer n is a power of two if there exists an integer x such that n == 2^x.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Divide n by 2 repeatedly; if we reach 1, it's a power of two.
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Division loop is O(log n).
#
# 3. Optimized Accepted Approach
#    Powers of two have exactly one set bit. So n > 0 && (n & (n-1)) == 0.
#    n & (n-1) clears the lowest set bit; if result is 0, only one bit was set.
#    Time Complexity: O(1)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=16 (10000): 16 & 15 = 10000 & 01111 = 0 → true ✓
# n=18 (10010): 18 & 17 = 10010 & 10001 = 10000 ≠ 0 → false ✓
# n=0: special case → false (not positive)
#
# Edge Cases:
# - n=1 → 2^0 = 1, return true
# - n=0 → false
# - Negative numbers → false

def is_power_of_two_brute(n)
  return false if n <= 0

  n = n / 2 while n % 2 == 0
  n == 1
end

def is_power_of_two(n)
  n > 0 && (n & (n - 1)) == 0   # positive and exactly one set bit
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{is_power_of_two_brute(1)}"   # true
  puts "Opt:   #{is_power_of_two(1)}"         # true
  puts "Brute: #{is_power_of_two_brute(16)}"  # true
  puts "Opt:   #{is_power_of_two(16)}"        # true
  puts "Brute: #{is_power_of_two_brute(3)}"   # false
  puts "Opt:   #{is_power_of_two(3)}"         # false
end
