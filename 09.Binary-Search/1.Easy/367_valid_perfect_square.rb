# frozen_string_literal: true

# LeetCode 367: Valid Perfect Square
#
# Problem:
# Given a positive integer num, return true if num is a perfect square,
# otherwise return false. Do not use any built-in square root function.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check i*i == num for i from 1 to num.
#    Time Complexity: O(sqrt(n))
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear scan up to sqrt(n).
#
# 3. Optimized Accepted Approach
#    Binary search on [1, num]. Find if any m where m*m == num.
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# num=16: search [1,16]
# mid=8: 64>16 → r=7
# mid=4: 16==16 → return true ✓
# num=14: no mid satisfies m*m==14 → return false ✓
#
# Edge Cases:
# - num=1 → 1*1=1 → true
# - Large perfect squares → binary search handles efficiently

def is_perfect_square_brute(num)
  i = 1
  while i * i <= num
    return true if i * i == num
    i += 1
  end
  false
end

def is_perfect_square(num)
  l = 1
  r = num

  while l <= r
    mid = (l + r) / 2
    sq = mid * mid
    if sq == num
      return true      # exact match
    elsif sq < num
      l = mid + 1      # need larger mid
    else
      r = mid - 1      # mid too large
    end
  end

  false
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{is_perfect_square_brute(16)}"  # true
  puts "Opt:   #{is_perfect_square(16)}"        # true
  puts "Brute: #{is_perfect_square_brute(14)}"  # false
  puts "Opt:   #{is_perfect_square(14)}"        # false
  puts "Brute: #{is_perfect_square_brute(1)}"   # true
  puts "Opt:   #{is_perfect_square(1)}"         # true
end
