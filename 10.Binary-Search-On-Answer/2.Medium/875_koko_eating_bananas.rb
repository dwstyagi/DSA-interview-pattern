# frozen_string_literal: true

# LeetCode 875: Koko Eating Bananas
#
# Problem:
# Koko loves bananas. There are n piles of bananas, piles[i] is the size of
# the i-th pile. Guards will return in h hours. Find the minimum eating speed k
# (bananas/hour) such that she can eat all piles within h hours.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try every speed from 1 to max(piles), return first that works.
#    Time Complexity: O(max(piles) * n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linearly scanning speeds — binary search on speed range [1, max(piles)].
#
# 3. Optimized Accepted Approach
#    Binary search for min speed k where sum(ceil(pile/k)) <= h.
#    Feasibility is monotonic: once k works, any higher k also works.
#    Time Complexity: O(n log(max(piles)))
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# piles=[3,6,7,11], h=8
# lo=1, hi=11 → mid=6 → hours=ceil(3/6)+ceil(6/6)+ceil(7/6)+ceil(11/6)=1+1+2+2=6<=8 → hi=6
# lo=1, hi=6  → mid=4 → hours=1+2+2+3=8<=8 → hi=4
# lo=1, hi=4  → mid=3 → hours=1+2+3+4=10>8 → lo=4
# lo=4, hi=4  → return 4 ✓
#
# Edge Cases:
# - h == piles.length -> k = max(piles)
# - h very large -> k = 1

def min_eating_speed_brute(piles, h)
  (1..piles.max).each do |k|
    hours = piles.sum { |p| (p + k - 1) / k }
    return k if hours <= h
  end
end

def min_eating_speed(piles, h)
  lo, hi = 1, piles.max

  while lo < hi
    mid   = (lo + hi) / 2
    hours = piles.sum { |p| (p + mid - 1) / mid } # ceil division
    hours <= h ? hi = mid : lo = mid + 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{min_eating_speed_brute([3, 6, 7, 11], 8)}"   # 4
  puts "Opt:   #{min_eating_speed([3, 6, 7, 11], 8)}"          # 4
  puts "Brute: #{min_eating_speed_brute([30, 11, 23, 4, 20], 5)}"  # 30
  puts "Opt:   #{min_eating_speed([30, 11, 23, 4, 20], 5)}"         # 30
end
