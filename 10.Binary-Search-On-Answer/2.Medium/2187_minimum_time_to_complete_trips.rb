# frozen_string_literal: true

# LeetCode 2187: Minimum Time to Complete Trips
#
# Problem:
# You are given an array time where time[i] is the time for bus i to complete
# one trip. Each bus can make multiple trips simultaneously. Return the minimum
# time required for all buses to complete at least totalTrips trips total.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate time 1, 2, 3... until total trips >= totalTrips.
#    Time Complexity: O(answer * n) — answer can be huge
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear time simulation — binary search on time.
#
# 3. Optimized Accepted Approach
#    Binary search t in [1, min(time) * totalTrips].
#    Feasibility: sum(t / time[i]) >= totalTrips.
#    Direction: min feasible → standard lower-bound.
#    Time Complexity: O(n log(min * totalTrips))
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# time=[1,2,3], totalTrips=5
# lo=1, hi=5 → mid=3 → trips=3+1+1=5>=5 → hi=3
# lo=1, hi=3 → mid=2 → trips=2+1+0=3<5 → lo=3
# lo=3, hi=3 → return 3 ✓
#
# Edge Cases:
# - Single bus -> totalTrips * time[0]
# - All buses same time -> ceil(totalTrips / n) * time[0]

def minimum_time_brute(time, total_trips)
  t = 0
  loop do
    t += 1
    trips = time.sum { |bus| t / bus }
    return t if trips >= total_trips
  end
end

def minimum_time(time, total_trips)
  lo = 1
  hi = time.min * total_trips  # worst case: slowest single bus

  while lo < hi
    mid   = (lo + hi) / 2
    trips = time.sum { |bus| mid / bus }
    trips >= total_trips ? hi = mid : lo = mid + 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{minimum_time_brute([1, 2, 3], 5)}"   # 3
  puts "Opt:   #{minimum_time([1, 2, 3], 5)}"          # 3
  puts "Brute: #{minimum_time_brute([2], 1)}"           # 2
  puts "Opt:   #{minimum_time([2], 1)}"                 # 2
end
