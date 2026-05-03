# frozen_string_literal: true

# LeetCode 201: Bitwise AND of Numbers Range
#
# Problem:
# Given two integers left and right representing a range [left, right],
# return the bitwise AND of all numbers in that range (inclusive).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    AND all numbers from left to right.
#    Time Complexity: O(right - left) which can be huge
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Range can be up to 2^31, so O(n) brute force TLEs.
#
# 3. Optimized Accepted Approach
#    Find the common prefix of left and right in binary. Right-shift both until
#    they are equal (tracking shift count). The common prefix shifted back is
#    the answer. Any bit that differs will be ANDed to 0.
#    Time Complexity: O(32) = O(1)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# left=5 (101), right=7 (111)
# 101 ≠ 111: shift both → 10, 11; shift=1
# 10 ≠ 11: shift both → 1, 1; shift=2
# 1 == 1: common prefix = 1 << 2 = 4 (100) ✓
#
# Edge Cases:
# - left == right → return left
# - left = 0 → return 0 (all numbers from 0 to right include 0)

def range_bitwise_and_brute(left, right)
  result = left
  (left + 1..right).each { |n| result &= n }
  result
end

def range_bitwise_and(left, right)
  shifts = 0

  while left != right
    left >>= 1    # remove least significant bit
    right >>= 1   # remove least significant bit
    shifts += 1
  end

  left << shifts   # restore common prefix to original position
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{range_bitwise_and_brute(5, 7)}"   # 4
  puts "Opt:   #{range_bitwise_and(5, 7)}"         # 4
  puts "Brute: #{range_bitwise_and_brute(0, 0)}"   # 0
  puts "Opt:   #{range_bitwise_and(0, 0)}"         # 0
  puts "Brute: #{range_bitwise_and_brute(1, 2_147_483_647)}"  # 0
  puts "Opt:   #{range_bitwise_and(1, 2_147_483_647)}"        # 0
end
