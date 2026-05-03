# frozen_string_literal: true

# LeetCode 190: Reverse Bits
#
# Problem:
# Reverse bits of a given 32-bit unsigned integer.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Convert to 32-bit binary string, reverse, convert back.
#    Time Complexity: O(32) = O(1)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    String conversion overhead.
#
# 3. Optimized Accepted Approach
#    Bit-by-bit: each iteration, shift result left by 1, add LSB of n,
#    shift n right by 1. Do this 32 times.
#    Time Complexity: O(32) = O(1)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n = 43261596 (00000010100101000001111010011100)
# Reverse → 964176192 (00111001011110000010100101000000)
# Each step: result = (result << 1) | (n & 1); n >>= 1
#
# Edge Cases:
# - n = 0 → 0 reversed is 0
# - n = 1 → 2^31 (highest bit set)
# - n = 2^32 - 1 → same (all ones)

def reverse_bits_brute(n)
  # Convert to 32-bit string, reverse, parse back
  n.to_s(2).rjust(32, "0").reverse.to_i(2)
end

def reverse_bits(n)
  result = 0
  32.times do
    result = (result << 1) | (n & 1)   # add LSB of n to result
    n >>= 1                             # shift n right
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{reverse_bits_brute(43261596)}"    # 964176192
  puts "Opt:   #{reverse_bits(43261596)}"          # 964176192
  puts "Brute: #{reverse_bits_brute(4294967293)}"  # 3221225471
  puts "Opt:   #{reverse_bits(4294967293)}"        # 3221225471
end
