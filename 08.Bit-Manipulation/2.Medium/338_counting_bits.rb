# frozen_string_literal: true

# LeetCode 338: Counting Bits
#
# Problem:
# Given an integer n, return an array ans of length n+1 such that for each i
# (0 <= i <= n), ans[i] is the number of 1's in the binary representation of i.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each number 0..n, count bits using Brian Kernighan's or built-in.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Counting bits for each number independently.
#
# 3. Optimized Accepted Approach
#    DP: dp[i] = dp[i >> 1] + (i & 1)
#    i >> 1 drops the last bit (counts set bits in i/2), + last bit of i.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n = 5
# dp[0] = 0
# dp[1] = dp[0] + 1 = 1
# dp[2] = dp[1] + 0 = 1  (10 → dp[1]=1, last bit=0)
# dp[3] = dp[1] + 1 = 2  (11 → dp[1]=1, last bit=1)
# dp[4] = dp[2] + 0 = 1  (100 → dp[2]=1, last bit=0)
# dp[5] = dp[2] + 1 = 2  (101 → dp[2]=1, last bit=1)
# Return [0,1,1,2,1,2]
#
# Edge Cases:
# - n=0 → [0]
# - n=1 → [0,1]

def count_bits_brute(n)
  (0..n).map do |i|
    k = i
    count = 0
    count += 1 and k &= k - 1 while k > 0
    count
  end
end

def count_bits(n)
  dp = Array.new(n + 1, 0)
  (1..n).each do |i|
    dp[i] = dp[i >> 1] + (i & 1)   # bits in half + last bit
  end
  dp
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{count_bits_brute(2).inspect}"  # [0,1,1]
  puts "Opt:   #{count_bits(2).inspect}"        # [0,1,1]
  puts "Brute: #{count_bits_brute(5).inspect}"  # [0,1,1,2,1,2]
  puts "Opt:   #{count_bits(5).inspect}"        # [0,1,1,2,1,2]
end
