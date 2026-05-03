# frozen_string_literal: true

# GFG: Minimum Number of Platforms
#
# Problem:
# Given arrival and departure times of trains, find the minimum number of platforms
# required so that no train waits. This is analogous to Meeting Rooms II.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each train, count how many other trains are present at the same time.
#    Take the maximum count.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Pairwise overlap counting is quadratic.
#
# 3. Optimized Accepted Approach
#    Sort arrivals and departures separately.
#    Two-pointer sweep: when a train arrives before the earliest departure,
#    need a new platform; otherwise reuse one.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(n) for sorted arrays
#
# -----------------------------------------------------------------------------
# Dry Run
#
# arr = [900,940,950,1100,1500,1800]
# dep = [910,1200,1120,1130,1900,2000]
# sorted arr: [900,940,950,1100,1500,1800]
# sorted dep: [910,1120,1130,1200,1900,2000]
# i=0(900),j=0(910): 900<=910 → plat=1, i++
# i=1(940),j=0(910): 940>910 → free, j=1; still 940<=1120 → plat=2, i++
# ... max = 3
#
# Edge Cases:
# - Single train     -> 1
# - All non-overlap  -> 1
# - All same times   -> n

def find_platforms_brute(arr, dep)
  n = arr.length
  max_plat = 0

  n.times do |i|
    plat = 1
    n.times do |j|
      next if i == j
      # Train j is present during train i's stay
      plat += 1 if arr[j] <= dep[i] && arr[i] <= dep[j]
    end
    max_plat = [max_plat, plat].max
  end

  max_plat
end

def find_platforms(arr, dep)
  sorted_arr = arr.sort
  sorted_dep = dep.sort

  platforms = 1
  max_platforms = 1
  i = 1
  j = 0

  while i < sorted_arr.length && j < sorted_dep.length
    if sorted_arr[i] <= sorted_dep[j]
      # A new train arrives before earliest departure → need one more platform
      platforms += 1
      max_platforms = [max_platforms, platforms].max
      i += 1
    else
      # A train departs → free up a platform
      platforms -= 1
      j += 1
    end
  end

  max_platforms
end

if __FILE__ == $PROGRAM_NAME
  arr = [900, 940, 950, 1100, 1500, 1800]
  dep = [910, 1200, 1120, 1130, 1900, 2000]
  puts "Brute force: #{find_platforms_brute(arr, dep)}" # 3
  puts "Optimized:   #{find_platforms(arr, dep)}"       # 3
end
