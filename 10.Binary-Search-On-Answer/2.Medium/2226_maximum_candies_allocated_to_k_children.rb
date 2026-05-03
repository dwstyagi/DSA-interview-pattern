# frozen_string_literal: true

# LeetCode 2226: Maximum Candies Allocated to K Children
#
# Problem:
# You have n piles of candies. Allocate candies to k children such that each
# child gets the same number of candies from at most one pile sub-divided.
# Return the maximum number of candies each child can get.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try every possible allocation from max down to 1, return first feasible.
#    Time Complexity: O(max(candies) * n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Scanning from max down is O(max) — binary search on allocation size.
#
# 3. Optimized Accepted Approach
#    Binary search piece size in [0, max(candies)].
#    Feasibility: sum(pile/piece) >= k.
#    Direction: max feasible → bias mid UP.
#    Time Complexity: O(n log(max(candies)))
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# candies=[5,8,6], k=3
# lo=0, hi=8 → mid=4 → kids=1+2+1=4>=3 → lo=4
# lo=4, hi=8 → mid=6 → kids=0+1+1=2<3 → hi=5
# lo=4, hi=5 → mid=5 → kids=1+1+1=3>=3 → lo=5
# lo=5, hi=5 → return 5 ✓
#
# Edge Cases:
# - k > sum(candies) -> 0 (impossible to give each child at least 1)
# - k=1 -> max(candies)

def maximum_candies_brute(candies, k)
  (candies.max).downto(1) do |piece|
    return piece if candies.sum { |c| c / piece } >= k
  end
  0
end

def maximum_candies(candies, k)
  lo, hi = 0, candies.max

  while lo < hi
    mid  = (lo + hi + 1) / 2       # bias up for max-feasible
    kids = candies.sum { |c| c / mid }
    kids >= k ? lo = mid : hi = mid - 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{maximum_candies_brute([5, 8, 6], 3)}"    # 5
  puts "Opt:   #{maximum_candies([5, 8, 6], 3)}"           # 5
  puts "Brute: #{maximum_candies_brute([2, 5], 11)}"       # 0
  puts "Opt:   #{maximum_candies([2, 5], 11)}"              # 0
end
