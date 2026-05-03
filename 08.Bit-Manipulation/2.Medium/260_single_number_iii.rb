# frozen_string_literal: true

# LeetCode 260: Single Number III
#
# Problem:
# Given an integer array where every element appears twice except for two
# elements which appear exactly once. Find those two elements.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use a hash map; return elements with count 1.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    O(n) space.
#
# 3. Optimized Accepted Approach
#    XOR all → a ^ b (the two unique elements).
#    Find any set bit (use a & -a to isolate lowest set bit) where a and b differ.
#    Partition all numbers into two groups by that bit; XOR within each group
#    yields a and b respectively.
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 2, 1, 3, 2, 5]
# XOR all = 1^2^1^3^2^5 = 3^5 = 6 (110)
# Isolate bit: 6 & -6 = 2 (010) → bit position 1 differs between 3 and 5
# Group by bit 1: {2,2,3} → XOR=3; {1,1,5} → XOR=5
# Return [3, 5]
#
# Edge Cases:
# - Two different large numbers → still works
# - Result order doesn't matter

def single_number_iii_brute(nums)
  nums.tally.select { |_, count| count == 1 }.keys
end

def single_number_iii(nums)
  xor = nums.reduce(0, :^)   # a ^ b where a, b are the two unique numbers

  # isolate the lowest set bit where a and b differ
  diff_bit = xor & -xor

  a = 0
  b = 0

  nums.each do |n|
    if (n & diff_bit) == 0
      a ^= n   # group where diff_bit is 0
    else
      b ^= n   # group where diff_bit is 1
    end
  end

  [a, b]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{single_number_iii_brute([1, 2, 1, 3, 2, 5]).sort.inspect}"  # [3, 5]
  puts "Opt:   #{single_number_iii([1, 2, 1, 3, 2, 5]).sort.inspect}"        # [3, 5]
  puts "Brute: #{single_number_iii_brute([-1, 0]).sort.inspect}"              # [-1, 0]
  puts "Opt:   #{single_number_iii([-1, 0]).sort.inspect}"                    # [-1, 0]
end
