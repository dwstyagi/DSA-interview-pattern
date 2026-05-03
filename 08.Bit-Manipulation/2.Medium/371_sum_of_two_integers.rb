# frozen_string_literal: true

# LeetCode 371: Sum of Two Integers
#
# Problem:
# Given two integers a and b, return the sum of the two integers without using
# the operators + and -.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use Ruby's built-in addition (defeats the purpose, but establishes result).
#    Time Complexity: O(1)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Must implement addition without + or -.
#
# 3. Optimized Accepted Approach
#    XOR gives sum without carry; AND << 1 gives the carry.
#    Repeat until carry = 0. Mask to 32 bits to simulate overflow.
#    Time Complexity: O(1) — at most 32 carry propagations
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# a=1 (01), b=3 (11)
# Step 1: sum = 01 ^ 11 = 10 (2); carry = (01 & 11) << 1 = 01 << 1 = 10 (2)
# Step 2: sum = 10 ^ 10 = 00 (0); carry = (10 & 10) << 1 = 10 << 1 = 100 (4)
# Step 3: sum = 00 ^ 100 = 100 (4); carry = 0
# Return 4 ✓
#
# Edge Cases:
# - a=0 → return b
# - Negative numbers handled by masking to 32-bit and sign extension

MASK = 0xFFFFFFFF
MAX  = 0x7FFFFFFF

def get_sum_brute(a, b)
  a + b   # reference answer
end

def get_sum(a, b)
  # mask to 32-bit to simulate fixed-width arithmetic
  a &= MASK
  b &= MASK

  while b != 0
    carry = (a & b) << 1   # carry bits
    a = (a ^ b) & MASK      # sum bits (no carry), mask to 32 bits
    b = carry & MASK         # next carry, masked
  end

  # sign-extend if highest bit set (negative result)
  a > MAX ? ~(a ^ MASK) : a
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{get_sum_brute(1, 2)}"    # 3
  puts "Opt:   #{get_sum(1, 2)}"          # 3
  puts "Brute: #{get_sum_brute(2, 3)}"    # 5
  puts "Opt:   #{get_sum(2, 3)}"          # 5
  puts "Brute: #{get_sum_brute(-1, 1)}"   # 0
  puts "Opt:   #{get_sum(-1, 1)}"         # 0
end
