# frozen_string_literal: true

# LeetCode 191: Number of 1 Bits
#
# Problem:
# Given a positive integer n, return the number of set bits in its binary
# representation (also known as the Hamming weight).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check each of 32 bits using bit shift and AND.
#    Time Complexity: O(32) = O(1)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Checking all 32 bits even when most are 0.
#
# 3. Optimized Accepted Approach
#    Brian Kernighan's algorithm: n & (n-1) drops the lowest set bit.
#    Count how many times we can do this before n becomes 0.
#    Iterations = number of set bits (skips zero bits entirely).
#    Time Complexity: O(k) where k = number of set bits
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n = 11 (binary: 1011)
# n=11, 11 & 10 = 1010 (10), count=1
# n=10, 10 & 9  = 1000 (8),  count=2
# n=8,  8 & 7   = 0000 (0),  count=3
# Return 3
#
# Edge Cases:
# - n=0 → 0 set bits (though problem says positive)
# - n=2^31-1 → 31 set bits

def hamming_weight_brute(n)
  count = 0
  32.times { count += n & 1; n >>= 1 }   # check each bit position
  count
end

def hamming_weight(n)
  count = 0
  while n > 0
    n &= n - 1   # drop lowest set bit
    count += 1
  end
  count
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{hamming_weight_brute(11)}"          # 3 (1011)
  puts "Opt:   #{hamming_weight(11)}"                # 3
  puts "Brute: #{hamming_weight_brute(128)}"         # 1 (10000000)
  puts "Opt:   #{hamming_weight(128)}"               # 1
  puts "Brute: #{hamming_weight_brute(2_147_483_645)}"  # 30
  puts "Opt:   #{hamming_weight(2_147_483_645)}"        # 30
end
