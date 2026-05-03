# frozen_string_literal: true

# LeetCode 436: Find Right Interval
#
# Problem:
# Given an array of intervals where intervals[i] = [start_i, end_i], for each
# interval find the minimum start point of any interval whose start >= end_i.
# Return an array of indices. If no right interval exists return -1.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each interval, scan all others to find the one with the smallest
#    start >= current end.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Inner scan is O(n) per interval — use binary search on sorted starts.
#
# 3. Optimized Accepted Approach
#    Build a sorted array of [start, original_index]. For each interval's end,
#    binary search for the leftmost start >= end. Map back to original index.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# intervals = [[3,4],[2,3],[1,2]]
# starts sorted = [[1,2],[2,1],[3,0]]
# interval 0: end=4 → binary search for start>=4 → none → -1
# interval 1: end=3 → binary search for start>=3 → [3,0] → idx=0
# interval 2: end=2 → binary search for start>=2 → [2,1] → idx=1
# result = [-1, 0, 1] ✓
#
# Edge Cases:
# - Single interval [[1,4]] -> [-1]
# - end equals a start exactly -> that interval is the right interval

def find_right_interval_brute(intervals)
  n = intervals.length
  result = Array.new(n, -1)

  n.times do |i|
    end_i = intervals[i][1]
    best_start = Float::INFINITY
    best_idx   = -1

    n.times do |j|
      s = intervals[j][0]
      if s >= end_i && s < best_start
        best_start = s
        best_idx   = j
      end
    end

    result[i] = best_idx
  end

  result
end

def find_right_interval(intervals)
  # Build sorted list of [start, original_index]
  starts = intervals.each_with_index.map { |(s, _), idx| [s, idx] }.sort_by(&:first)

  intervals.map do |_, e|
    # Binary search: leftmost start >= e
    lo, hi = 0, starts.length
    while lo < hi
      mid = (lo + hi) / 2
      starts[mid][0] >= e ? hi = mid : lo = mid + 1
    end
    lo < starts.length ? starts[lo][1] : -1
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{find_right_interval_brute([[3, 4], [2, 3], [1, 2]]).inspect}" # [-1, 0, 1]
  puts "Opt:   #{find_right_interval([[3, 4], [2, 3], [1, 2]]).inspect}"        # [-1, 0, 1]
  puts "Brute: #{find_right_interval_brute([[1, 2]]).inspect}"                  # [-1]
  puts "Opt:   #{find_right_interval([[1, 2]]).inspect}"                        # [-1]
end
