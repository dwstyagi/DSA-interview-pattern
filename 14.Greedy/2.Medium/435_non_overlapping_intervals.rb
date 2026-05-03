# frozen_string_literal: true

# LeetCode 435: Non-overlapping Intervals
#
# Problem:
# Given intervals, find the minimum number of intervals to remove to make
# the rest non-overlapping.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all subsets of intervals; check each subset for non-overlap.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Equivalent to: keep maximum number of non-overlapping intervals (activity selection).
#    Greedy: always keep the interval with the earliest end time.
#
# 3. Optimized Accepted Approach
#    Sort by end time. Greedily keep non-overlapping intervals.
#    Count intervals not kept = intervals to remove.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# intervals = [[1,2],[2,3],[3,4],[1,3]]
# sorted by end: [[1,2],[2,3],[1,3],[3,4]]
# keep [1,2]: prev_end=2
# [2,3]: start=2 >= prev_end=2 -> keep, prev_end=3
# [1,3]: start=1 < prev_end=2 -> remove, count=1
# [3,4]: start=3 >= prev_end=3 -> keep
# Result: 1
#
# Edge Cases:
# - No overlaps: return 0
# - All overlap same point: remove all but one

def erase_overlap_intervals_brute(intervals)
  sorted = intervals.sort_by(&:last)
  removed = 0
  prev_end = -Float::INFINITY
  sorted.each do |start, fin|
    if start < prev_end
      removed += 1
    else
      prev_end = fin
    end
  end
  removed
end

# optimized: same greedy, explicit variable names
def erase_overlap_intervals(intervals)
  return 0 if intervals.empty?
  intervals.sort_by!(&:last)
  count = 0
  prev_end = intervals[0][1]
  (1...intervals.length).each do |i|
    if intervals[i][0] < prev_end
      count += 1
    else
      prev_end = intervals[i][1]
    end
  end
  count
end

if __FILE__ == $PROGRAM_NAME
  puts erase_overlap_intervals_brute([[1, 2], [2, 3], [3, 4], [1, 3]])  # 1
  puts erase_overlap_intervals([[1, 2], [1, 2], [1, 2]])                 # 2
end
