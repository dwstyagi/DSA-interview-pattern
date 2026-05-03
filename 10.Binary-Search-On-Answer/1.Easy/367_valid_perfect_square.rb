# frozen_string_literal: true

# LeetCode 367: Valid Perfect Square
#
# Problem:
# Given a positive integer num, return true if num is a perfect square,
# false otherwise. Do not use any built-in library function like sqrt.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try every integer from 1 upward; return true if i*i == num.
#    Time Complexity: O(sqrt(n))
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear search — binary search for exact match in O(log n).
#
# 3. Optimized Accepted Approach
#    Binary search in [1, num]. If mid*mid == num return true, if less go
#    right, if greater go left.
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# num = 16
# lo=1, hi=16 → mid=8 → 64>16 → hi=7
# lo=1, hi=7  → mid=4 → 16==16 → true ✓
#
# Edge Cases:
# - num=1 -> true
# - num=2 -> false
# - Large prime -> false

def is_perfect_square_brute(num)
  i = 1
  i += 1 while i * i < num
  i * i == num
end

def is_perfect_square(num)
  lo, hi = 1, num

  while lo <= hi
    mid = (lo + hi) / 2
    sq  = mid * mid
    return true  if sq == num
    sq < num ? lo = mid + 1 : hi = mid - 1
  end

  false
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{is_perfect_square_brute(16)}"  # true
  puts "Opt:   #{is_perfect_square(16)}"         # true
  puts "Brute: #{is_perfect_square_brute(14)}"  # false
  puts "Opt:   #{is_perfect_square(14)}"         # false
end
