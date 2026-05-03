# frozen_string_literal: true

# LeetCode 1009: Complement of Base 10 Integer
#
# Problem:
# The complement of an integer is the integer you get when you flip all the
# 0s and 1s in its binary representation. Return the complement of num.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Convert to binary string, flip each bit, convert back.
#    Time Complexity: O(log n)
#    Space Complexity: O(log n) for string
#
# 2. Bottleneck
#    String conversion overhead.
#
# 3. Optimized Accepted Approach
#    Build an all-ones mask with the same number of bits as num.
#    XOR num with mask to flip all bits.
#    mask = (1 << bit_length) - 1
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# num = 5 (101)
# bit_length = 3, mask = (1<<3) - 1 = 7 (111)
# complement = 5 ^ 7 = 101 ^ 111 = 010 = 2 ✓
#
# Edge Cases:
# - num=0 → complement is 1 (edge case: bit_length would be 0; handle specially)
# - num=1 → complement is 0

def bitwise_complement_brute(num)
  return 1 if num == 0
  num.to_s(2).chars.map { |b| b == "0" ? "1" : "0" }.join.to_i(2)
end

def bitwise_complement(num)
  return 1 if num == 0

  # find bit length: position of highest set bit + 1
  bit_len = num.bit_length
  mask = (1 << bit_len) - 1   # all-ones mask of the same length

  num ^ mask   # flip all bits within the bit length
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{bitwise_complement_brute(5)}"   # 2 (101 → 010)
  puts "Opt:   #{bitwise_complement(5)}"         # 2
  puts "Brute: #{bitwise_complement_brute(7)}"   # 0 (111 → 000)
  puts "Opt:   #{bitwise_complement(7)}"         # 0
  puts "Brute: #{bitwise_complement_brute(10)}"  # 5 (1010 → 0101)
  puts "Opt:   #{bitwise_complement(10)}"        # 5
end
