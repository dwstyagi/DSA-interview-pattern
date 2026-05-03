# frozen_string_literal: true

# LeetCode 421: Maximum XOR of Two Numbers in an Array
#
# Problem:
# Given an integer array nums, return the maximum result of nums[i] XOR nums[j]
# where 0 <= i <= j < n.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all pairs (i, j), compute XOR, track maximum.
#    Time Complexity: O(n²)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(n²) pairs.
#
# 3. Optimized Accepted Approach
#    Greedy + prefix set: process bit by bit from MSB to LSB.
#    For each bit position, try to set it in the result by checking if two
#    prefixes XOR to give that target prefix.
#    Time Complexity: O(32n) = O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [3, 10, 5, 25, 2, 8]
# MSB to LSB: try each bit. At bit 4, prefix 11 XOR 01 = 10000 → can set bit 4.
# Continue greedily setting bits → answer = 28
#
# Edge Cases:
# - All same elements → XOR = 0
# - Two elements → their XOR

def find_maximum_xor_brute(nums)
  max_xor = 0
  n = nums.length
  (0...n).each do |i|
    (i...n).each do |j|
      max_xor = [max_xor, nums[i] ^ nums[j]].max
    end
  end
  max_xor
end

def find_maximum_xor(nums)
  max_xor = 0
  mask = 0

  31.downto(0) do |i|
    mask |= (1 << i)   # build mask bit by bit from MSB

    # collect all prefixes up to current bit
    prefixes = nums.map { |n| n & mask }.to_set

    # try to set this bit in max_xor
    target = max_xor | (1 << i)

    # check if any two prefixes XOR to give target
    if prefixes.any? { |p| prefixes.include?(target ^ p) }
      max_xor = target
    end
  end

  max_xor
end

if __FILE__ == $PROGRAM_NAME
  require 'set'
  puts "Brute: #{find_maximum_xor_brute([3, 10, 5, 25, 2, 8])}"  # 28
  puts "Opt:   #{find_maximum_xor([3, 10, 5, 25, 2, 8])}"        # 28
  puts "Brute: #{find_maximum_xor_brute([14, 70, 53, 83, 49, 91, 36, 80, 92, 51, 66, 70])}"
  puts "Opt:   #{find_maximum_xor([14, 70, 53, 83, 49, 91, 36, 80, 92, 51, 66, 70])}"
end
