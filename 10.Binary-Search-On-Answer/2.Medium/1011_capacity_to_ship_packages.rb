# frozen_string_literal: true

# LeetCode 1011: Capacity to Ship Packages Within D Days
#
# Problem:
# A conveyor belt has packages with weights[i]. Ship all packages in d days.
# Packages must be shipped in order. Find the minimum weight capacity of the
# ship such that all packages are shipped within d days.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try every capacity from max(weights) to sum(weights), return first valid.
#    Time Complexity: O(n * sum(weights))
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear scan over huge capacity range — binary search cuts to O(n log(sum)).
#
# 3. Optimized Accepted Approach
#    Binary search capacity in [max(weights), sum(weights)].
#    Feasibility: greedily pack days, count <= d.
#    Time Complexity: O(n log(sum(weights)))
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# weights=[1,2,3,4,5,6,7,8,9,10], d=5
# lo=10, hi=55 → mid=32 → days=2 (way under) → hi=32
# ... eventually converges to 15
# capacity=15: [1..5]=15, [6,7]=13, [8]=8, [9]=9, [10]=10 → 5 days ✓
#
# Edge Cases:
# - d == weights.length -> each package gets its own day, cap = max(weights)
# - d == 1 -> must ship all at once, cap = sum(weights)

def ship_within_days_brute(weights, days)
  lo = weights.max
  hi = weights.sum
  (lo..hi).each do |cap|
    d, cur = 1, 0
    weights.each do |w|
      if cur + w > cap
        d += 1
        cur = 0
      end
      cur += w
    end
    return cap if d <= days
  end
end

def ship_within_days(weights, days)
  lo, hi = weights.max, weights.sum

  feasible = lambda do |cap|
    d, cur = 1, 0
    weights.each do |w|
      if cur + w > cap
        d += 1   # start new day
        cur = 0
      end
      cur += w
    end
    d <= days
  end

  while lo < hi
    mid = (lo + hi) / 2
    feasible.call(mid) ? hi = mid : lo = mid + 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{ship_within_days_brute([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 5)}" # 15
  puts "Opt:   #{ship_within_days([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 5)}"        # 15
  puts "Brute: #{ship_within_days_brute([3, 2, 2, 4, 1, 4], 3)}"               # 6
  puts "Opt:   #{ship_within_days([3, 2, 2, 4, 1, 4], 3)}"                      # 6
end
