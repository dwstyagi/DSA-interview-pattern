# frozen_string_literal: true

# LeetCode 435: Non-overlapping Intervals
#
# Problem:
# Given an array of intervals, return the minimum number of intervals you need to remove
# to make the rest of the intervals non-overlapping.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all subsets of intervals; for each subset check non-overlapping; maximize kept.
#    Answer = n - max_non_overlapping.
#
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Exponential. Greedy insight: always keep the interval with the earliest end time.
#
# 3. Optimized Accepted Approach
#    Sort by end time. Greedy: keep an interval if it starts at or after the last kept end.
#    Count removals = total - kept.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# intervals = [[1,2],[2,3],[3,4],[1,3]]
# sorted by end: [[1,2],[2,3],[1,3],[3,4]]
# last_end = -inf, kept = 0
# [1,2]: 1>=-inf → keep, last_end=2, kept=1
# [2,3]: 2>=2  → keep, last_end=3, kept=2
# [1,3]: 1<3   → remove
# [3,4]: 3>=3  → keep, last_end=4, kept=3
# removals = 4-3 = 1
#
# Edge Cases:
# - No overlaps  -> 0
# - All overlap  -> n-1

def erase_overlap_intervals_brute(intervals)
  n = intervals.length
  min_remove = n

  # Try each subset and check for non-overlapping
  (0...(1 << n)).each do |mask|
    subset = intervals.select.with_index { |_, i| (mask >> i) & 1 == 1 }
    sorted = subset.sort_by { |i| i[0] }
    valid = sorted.each_cons(2).all? { |a, b| a[1] <= b[0] }
    removals = n - subset.length
    min_remove = [min_remove, removals].min if valid
  end

  min_remove
end

def erase_overlap_intervals(intervals)
  return 0 if intervals.empty?

  # Sort by end time — pick the interval ending earliest to leave most room
  sorted = intervals.sort_by { |i| i[1] }
  last_end = -Float::INFINITY
  kept = 0

  sorted.each do |start, enden|
    if start >= last_end
      # Non-overlapping with last kept interval: keep it
      last_end = enden
      kept += 1
    end
    # Else: overlapping → remove (don't update last_end)
  end

  intervals.length - kept
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{erase_overlap_intervals_brute([[1, 2], [2, 3], [3, 4], [1, 3]])}" # 1
  puts "Optimized:   #{erase_overlap_intervals([[1, 2], [2, 3], [3, 4], [1, 3]])}"       # 1
  puts "Brute force: #{erase_overlap_intervals_brute([[1, 2], [1, 2], [1, 2]])}"         # 2
  puts "Optimized:   #{erase_overlap_intervals([[1, 2], [1, 2], [1, 2]])}"               # 2
end
