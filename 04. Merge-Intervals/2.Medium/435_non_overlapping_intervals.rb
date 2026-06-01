# frozen_string_literal: true

# LeetCode 435: Non-overlapping Intervals
#
# Problem:
# Given an array of intervals, return the minimum number of intervals you need to remove
# to make the rest of the intervals non-overlapping.
#
# Examples:
#   Input:  intervals = [[1,2],[2,3],[3,4],[1,3]]
#   Output: 1
#   Why:    Remove [1,3] to eliminate the overlap — minimum 1 removal.
#
#   Input:  intervals = [[1,2],[1,2],[1,2]]
#   Output: 2
#   Why:    All three overlap the same point — keep 1, remove 2.
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

def erase_overlap_intervals_true_brute_force(intervals)
  sorted_intervals = intervals.sort_by { |start_time, end_time| [start_time, end_time] }

  dfs = lambda do |index, last_end_time|
    return 0 if index == sorted_intervals.length

    start_time, end_time = sorted_intervals[index]

    remove_current = 1 + dfs.call(index + 1, last_end_time)

    keep_current = Float::INFINITY
    keep_current = dfs.call(index + 1, end_time) if last_end_time.nil? || start_time >= last_end_time

    [remove_current, keep_current].min
  end

  dfs.call(0, nil)
end

def erase_overlap_intervals(intervals)
  return 0 if intervals.empty?

  # Sort by end time — pick the interval ending earliest to leave most room
  sorted = intervals.sort_by { |i| i[1] }
  last_end = -Float::INFINITY
  res = 0

  sorted.each do |start, enden|
    if start >= last_end
      # Non-overlapping with last kept interval: keep it
      last_end = enden
    else
      # Else: overlapping → remove (don't update last_end)
      res += 1
    end
  end

  res
end

if __FILE__ == $PROGRAM_NAME
  puts "True Brute Force: #{erase_overlap_intervals_true_brute_force([[1, 2], [2, 3], [3, 4], [1, 3]])}" # 1
  puts "Optimized:         #{erase_overlap_intervals([[1, 2], [2, 3], [3, 4], [1, 3]])}"       # 1
  puts "True Brute Force: #{erase_overlap_intervals_true_brute_force([[1, 2], [1, 2], [1, 2]])}"         # 2
  puts "Optimized:         #{erase_overlap_intervals([[1, 2], [1, 2], [1, 2]])}"               # 2
end
