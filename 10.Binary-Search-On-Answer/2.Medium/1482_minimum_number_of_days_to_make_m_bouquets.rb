# frozen_string_literal: true

# LeetCode 1482: Minimum Number of Days to Make m Bouquets
#
# Problem:
# Given bloomDay[i] (day flower i blooms), k flowers per bouquet, m bouquets
# needed. Return the minimum day to make m bouquets, or -1 if impossible.
# Adjacent k flowers make one bouquet.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate each day, check if m bouquets are possible.
#    Time Complexity: O(max(bloomDay) * n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear day scan — binary search on day range [1, max(bloomDay)].
#
# 3. Optimized Accepted Approach
#    Binary search day d in [min(bloomDay), max(bloomDay)].
#    Feasibility: count consecutive bloomed flowers, divide by k, sum >= m.
#    Time Complexity: O(n log(max(bloomDay)))
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# bloomDay=[1,10,3,10,2], m=3, k=1
# lo=1, hi=10 → mid=5 → bloomed days<=5: [1,_,3,_,2] → 3 consecutive runs of 1
#   bouquets = 3/1 + 0 + 1/1 + 0 + 1/1 = 3 >= 3 → hi=5
# ... converges to day=3
#
# Edge Cases:
# - m*k > n -> impossible, return -1
# - All same bloom day -> that day is the answer

def min_days_brute(bloom_day, m, k)
  n = bloom_day.length
  return -1 if m * k > n

  (1..bloom_day.max).each do |day|
    bouquets, streak = 0, 0
    bloom_day.each do |bd|
      if bd <= day
        streak += 1
        bouquets += 1 and streak = 0 if streak == k
      else
        streak = 0
      end
    end
    return day if bouquets >= m
  end
  -1
end

def min_days(bloom_day, m, k)
  n = bloom_day.length
  return -1 if m * k > n

  feasible = lambda do |day|
    bouquets, streak = 0, 0
    bloom_day.each do |bd|
      if bd <= day
        streak += 1
        bouquets += 1 and streak = 0 if streak == k # completed a bouquet
      else
        streak = 0 # broken streak
      end
    end
    bouquets >= m
  end

  lo, hi = bloom_day.min, bloom_day.max
  while lo < hi
    mid = (lo + hi) / 2
    feasible.call(mid) ? hi = mid : lo = mid + 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{min_days_brute([1, 10, 3, 10, 2], 3, 1)}"   # 3
  puts "Opt:   #{min_days([1, 10, 3, 10, 2], 3, 1)}"          # 3
  puts "Brute: #{min_days_brute([1, 10, 3, 10, 2], 3, 2)}"   # -1
  puts "Opt:   #{min_days([1, 10, 3, 10, 2], 3, 2)}"          # -1
end
