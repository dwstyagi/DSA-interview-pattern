# frozen_string_literal: true

# LeetCode 441: Arranging Coins
#
# Problem:
# You have n coins and you want to build a staircase. The i-th row has exactly
# i coins. Given n, return the number of complete rows of the staircase.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate row by row, subtracting coins until not enough remain.
#    Time Complexity: O(sqrt(n))
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear simulation — binary search on the answer (row count) in O(log n).
#
# 3. Optimized Accepted Approach
#    Binary search for the max k where k*(k+1)/2 <= n.
#    Feasibility: k*(k+1)/2 <= n → max feasible pattern.
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n = 8
# lo=1, hi=8 → mid=5 → 15>8 → hi=4
# lo=1, hi=4 → mid=3 → 6<=8 → lo=3
# lo=3, hi=4 → mid=4 → 10>8 → hi=3
# lo=3, hi=3 → return 3 ✓ (rows: 1+2+3=6, row 4 needs 4 > 2 remaining)
#
# Edge Cases:
# - n=1 -> 1
# - n=2 -> 1 (row 1 complete, row 2 needs 2 but only 1 left)
# - Perfect triangle number n=6 -> 3

def arrange_coins_brute(n)
  row = 0
  while n >= row + 1
    row += 1
    n -= row
  end
  row
end

def arrange_coins(n)
  lo, hi = 1, n

  while lo < hi
    mid = (lo + hi + 1) / 2             # bias up for max-feasible
    mid * (mid + 1) / 2 <= n ? lo = mid : hi = mid - 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{arrange_coins_brute(5)}"   # 2
  puts "Opt:   #{arrange_coins(5)}"          # 2
  puts "Brute: #{arrange_coins_brute(8)}"   # 3
  puts "Opt:   #{arrange_coins(8)}"          # 3
end
