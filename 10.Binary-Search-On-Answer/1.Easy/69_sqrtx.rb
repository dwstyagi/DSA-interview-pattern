# frozen_string_literal: true

# LeetCode 69: Sqrt(x)
#
# Problem:
# Given a non-negative integer x, return the square root of x rounded down to
# the nearest integer. The returned integer should be non-negative.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try every integer from 0 upward until i*i > x, return i-1.
#    Time Complexity: O(sqrt(x))
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear scan up to sqrt(x) — binary search cuts this to O(log x).
#
# 3. Optimized Accepted Approach
#    Binary search on answer range [0, x]. Find the largest m where m*m <= x.
#    Feasibility: m*m <= x. Direction: max feasible → bias mid UP.
#    Time Complexity: O(log x)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# x = 8
# lo=0, hi=8 → mid=4 → 16>8 → hi=3
# lo=0, hi=3 → mid=2 → 4<=8 → lo=2
# lo=2, hi=3 → mid=3 → 9>8 → hi=2
# lo=2, hi=2 → return 2 ✓
#
# Edge Cases:
# - x=0 -> 0
# - x=1 -> 1
# - Perfect square x=9 -> 3

def my_sqrt_brute(x)
  i = 0
  i += 1 while (i + 1) * (i + 1) <= x
  i
end

def my_sqrt(x)
  return x if x < 2

  lo, hi = 1, x / 2

  while lo < hi
    mid = (lo + hi + 1) / 2   # bias up for max-feasible
    mid * mid <= x ? lo = mid : hi = mid - 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{my_sqrt_brute(4)}"   # 2
  puts "Opt:   #{my_sqrt(4)}"          # 2
  puts "Brute: #{my_sqrt_brute(8)}"   # 2
  puts "Opt:   #{my_sqrt(8)}"          # 2
  puts "Brute: #{my_sqrt_brute(0)}"   # 0
  puts "Opt:   #{my_sqrt(0)}"          # 0
end
