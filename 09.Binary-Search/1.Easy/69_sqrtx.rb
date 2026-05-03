# frozen_string_literal: true

# LeetCode 69: Sqrt(x)
#
# Problem:
# Given a non-negative integer x, return the square root of x rounded down to
# the nearest integer. The returned integer should be non-negative.
# Do not use any built-in exponent function or operator.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Increment from 0 until i² > x; return i-1.
#    Time Complexity: O(sqrt(x))
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(sqrt(x)) is slow for large x.
#
# 3. Optimized Accepted Approach
#    Binary search on [0, x]: find largest m where m² <= x.
#    Upper-bound variant: when m² <= x, record answer and move l up.
#    Time Complexity: O(log x)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# x=8: search [0,8]
# mid=4: 16>8 → r=3
# mid=1: 1<=8 → ans=1, l=2
# mid=2: 4<=8 → ans=2, l=3
# mid=3: 9>8 → r=2
# l>r → return 2 ✓
#
# Edge Cases:
# - x=0 → return 0
# - x=1 → return 1
# - Perfect square → return exact sqrt

def my_sqrt_brute(x)
  i = 0
  i += 1 while (i + 1) * (i + 1) <= x
  i
end

def my_sqrt(x)
  return x if x < 2

  l = 1
  r = x / 2   # sqrt(x) <= x/2 for x >= 4
  result = 0

  while l <= r
    mid = (l + r) / 2
    if mid * mid <= x
      result = mid    # mid is a valid candidate
      l = mid + 1     # try larger
    else
      r = mid - 1     # mid² too big, go smaller
    end
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{my_sqrt_brute(4)}"   # 2
  puts "Opt:   #{my_sqrt(4)}"         # 2
  puts "Brute: #{my_sqrt_brute(8)}"   # 2
  puts "Opt:   #{my_sqrt(8)}"         # 2
  puts "Brute: #{my_sqrt_brute(0)}"   # 0
  puts "Opt:   #{my_sqrt(0)}"         # 0
end
