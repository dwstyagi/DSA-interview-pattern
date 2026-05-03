# frozen_string_literal: true

# LeetCode 1552: Magnetic Force Between Two Balls
#
# Problem:
# Place m balls in n baskets (given positions[]). Maximize the minimum magnetic
# force (minimum distance between any two balls).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try every possible minimum distance, check feasibility greedily.
#    Time Complexity: O(max_gap * n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Checking all gap values linearly — binary search on the gap.
#
# 3. Optimized Accepted Approach
#    Sort positions. Binary search minimum distance in [1, (max-min)/(m-1)].
#    Feasibility: greedily place balls, count >= m.
#    Direction: max feasible → bias mid UP.
#    Time Complexity: O(n log n + n log(max_gap))
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# position=[1,2,3,4,7], m=3
# sorted=[1,2,3,4,7], lo=1, hi=3
# mid=2 → place: 1, skip 2(diff=1<2), 3(diff=2>=2 ✓), skip 4(diff=1<2), 7(diff=4>=2 ✓) → 3 balls → lo=2
# lo=2, hi=3 → mid=3 → place: 1, skip 2,3(diff=2<3), 4(diff=3>=3 ✓), 7(diff=3>=3 ✓) → 3 balls → lo=3
# lo=3, hi=3 → return 3 ✓
#
# Edge Cases:
# - m=2 -> max gap between any two positions
# - All positions consecutive -> limited by spacing

def max_distance_brute(position, m)
  pos = position.sort
  lo, hi = 1, (pos.last - pos.first) / (m - 1)
  result = 0

  (lo..hi).each do |gap|
    count, prev = 1, pos[0]
    pos[1..].each do |p|
      if p - prev >= gap
        count += 1
        prev = p
      end
    end
    count >= m ? result = gap : break
  end

  result
end

def max_distance(position, m)
  pos     = position.sort
  lo, hi  = 1, (pos.last - pos.first) / (m - 1)

  feasible = lambda do |gap|
    count, prev = 1, pos[0]
    pos[1..].each do |p|
      if p - prev >= gap
        count += 1
        prev = p
      end
    end
    count >= m
  end

  while lo < hi
    mid = (lo + hi + 1) / 2    # bias up for max-feasible
    feasible.call(mid) ? lo = mid : hi = mid - 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{max_distance_brute([1, 2, 3, 4, 7], 3)}"  # 3
  puts "Opt:   #{max_distance([1, 2, 3, 4, 7], 3)}"         # 3
  puts "Brute: #{max_distance_brute([5, 4, 3, 2, 1, 1000000000], 2)}" # 999999999
  puts "Opt:   #{max_distance([5, 4, 3, 2, 1, 1000000000], 2)}"        # 999999999
end
