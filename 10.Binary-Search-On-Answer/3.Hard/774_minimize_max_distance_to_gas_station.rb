# frozen_string_literal: true

# LeetCode 774: Minimize Max Distance to Gas Station
#
# Problem:
# You have a horizontal number line with gas stations at positions[i]. You can
# add k more gas stations anywhere. Return the minimized maximum distance
# between adjacent gas stations. Answers within 10^-6 of the actual answer
# are accepted.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each possible number of stations per gap, compute max gap — O(n*k).
#    Time Complexity: O(n*k)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Integer simulation doesn't work here (real-valued answer) — real-valued
#    binary search with fixed iterations.
#
# 3. Optimized Accepted Approach
#    Real-valued binary search on the max distance d in [0, max_gap].
#    Feasibility: for each gap, stations needed = ceil(gap/d) - 1. Sum <= k.
#    Run 100 iterations (float convergence).
#    Time Complexity: O(n log(1/epsilon)) ~ O(100n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# stations=[1,2,3,4,5,6,7,8,9,10], k=9
# gaps=[1,1,1,...,1] (9 gaps of 1)
# With 9 extra stations: add 1 per gap → each gap becomes 0.5
# answer = 0.5 ✓
#
# Edge Cases:
# - k=0 -> max existing gap
# - k very large -> gaps approach 0

def min_max_gas_dist_brute(stations, k)
  n    = stations.length
  gaps = (1...n).map { |i| stations[i] - stations[i - 1] }
  adds = Array.new(n - 1, 0)

  k.times do
    max_dist = 0.0
    best     = 0
    gaps.each_with_index do |g, i|
      d = g.to_f / (adds[i] + 1)
      best = i and max_dist = d if d > max_dist
    end
    adds[best] += 1
  end

  max_dist = 0.0
  gaps.each_with_index { |g, i| d = g.to_f / (adds[i] + 1); max_dist = d if d > max_dist }
  max_dist.round(6)
end

def min_max_gas_dist(stations, k)
  n    = stations.length
  gaps = (1...n).map { |i| stations[i] - stations[i - 1] }

  feasible = lambda do |max_d|
    # stations needed to break all gaps to <= max_d
    gaps.sum { |g| (g / max_d).ceil - 1 } <= k
  end

  lo, hi = 0.0, gaps.max.to_f
  100.times do
    mid = (lo + hi) / 2.0
    feasible.call(mid) ? hi = mid : lo = mid
  end

  hi.round(6)
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{min_max_gas_dist_brute([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 9)}"  # 0.5
  puts "Opt:   #{min_max_gas_dist([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 9)}"         # 0.5
  puts "Brute: #{min_max_gas_dist_brute([23, 24, 36, 39, 46, 56, 57, 65, 84, 98], 1)}" # 14.0
  puts "Opt:   #{min_max_gas_dist([23, 24, 36, 39, 46, 56, 57, 65, 84, 98], 1)}"        # 14.0
end
