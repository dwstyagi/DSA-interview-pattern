# frozen_string_literal: true

# LeetCode 2594: Minimum Time to Repair Cars
#
# Problem:
# You are given an integer array ranks where ranks[i] is the rank of the i-th
# mechanic. A mechanic with rank r takes r * n^2 minutes to repair n cars.
# All mechanics work simultaneously. Return the minimum time to repair all cars.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate minute by minute — impractical for large inputs.
#    Time Complexity: O(answer * n) — answer can be huge
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear simulation — binary search on time in [1, min(ranks) * cars^2].
#
# 3. Optimized Accepted Approach
#    Binary search time t. Feasibility: each mechanic with rank r can repair
#    floor(sqrt(t/r)) cars in time t. Sum >= cars.
#    Direction: min feasible.
#    Time Complexity: O(n log(min_rank * cars^2))
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# ranks=[4,2,3,1], cars=10
# lo=1, hi=16 → mid=8 → cars: √(8/4)=√2≈1, √(8/2)=2, √(8/3)≈1, √(8/1)≈2 → 6<10 → lo=9
# ... eventually lo converges to 16
# t=16: √(16/4)=2, √(16/2)≈2, √(16/3)≈2, √(16/1)=4 → 2+2+2+4=10>=10 → answer=16 ✓
#
# Edge Cases:
# - Single mechanic -> rank * cars^2
# - All same rank -> ceil(cars/n) ^ 2 * rank

def repair_cars_brute(ranks, cars)
  lo = 1
  hi = ranks.min * cars * cars
  # Impractical to iterate linearly — just demonstrate the feasibility check
  while lo < hi
    mid  = (lo + hi) / 2
    total = ranks.sum { |r| Math.sqrt(mid.to_f / r).to_i }
    total >= cars ? hi = mid : lo = mid + 1
  end
  lo
end

def repair_cars(ranks, cars)
  lo = 1
  hi = ranks.min * cars * cars  # worst case: best mechanic repairs all

  while lo < hi
    mid   = (lo + hi) / 2
    total = ranks.sum { |r| Math.sqrt(mid.to_f / r).to_i } # each mechanic's cars in time mid
    total >= cars ? hi = mid : lo = mid + 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{repair_cars_brute([4, 2, 3, 1], 10)}"  # 16
  puts "Opt:   #{repair_cars([4, 2, 3, 1], 10)}"         # 16
  puts "Brute: #{repair_cars_brute([5, 1, 8], 6)}"       # 16
  puts "Opt:   #{repair_cars([5, 1, 8], 6)}"              # 16
end
