# frozen_string_literal: true

# LeetCode 56: Merge Intervals
#
# Problem:
# Given an array of intervals where intervals[i] = [start_i, end_i],
# merge all overlapping intervals and return an array of the non-overlapping intervals.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each interval, compare with all others and merge if overlapping. Repeat.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Without sorting, we can't guarantee that we find all overlaps in one pass.
#
# 3. Optimized Accepted Approach
#    Sort by start time. Sweep: if current interval overlaps the last merged one
#    (curr.start <= last.end), extend last.end = max(last.end, curr.end).
#    Otherwise, push the current interval as a new entry.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# intervals = [[1,3],[2,6],[8,10],[15,18]]
# sorted: same
# result = [[1,3]]
# [2,6]: 2<=3 → merge → [[1,6]]
# [8,10]: 8>6 → new → [[1,6],[8,10]]
# [15,18]: 15>10 → new → [[1,6],[8,10],[15,18]]
#
# Edge Cases:
# - Single interval    -> return as-is
# - All overlapping    -> one merged interval
# - No overlapping     -> all returned unchanged

def merge_brute(intervals)
  return intervals if intervals.length <= 1

  changed = true
  result = intervals.map(&:dup)

  while changed
    changed = false
    new_result = []
    used = Array.new(result.length, false)

    result.each_with_index do |a, i|
      next if used[i]

      merged = a.dup
      result.each_with_index do |b, j|
        next if i == j || used[j]

        # Overlap check: max(start) <= min(end)
        if [merged[0], b[0]].max <= [merged[1], b[1]].min
          merged[0] = [merged[0], b[0]].min
          merged[1] = [merged[1], b[1]].max
          used[j] = true
          changed = true
        end
      end
      new_result << merged
    end
    result = new_result
  end

  result.sort_by { |i| i[0] }
end

def merge(intervals)
  return intervals if intervals.empty?

  # Sort by start time
  sorted = intervals.sort_by { |i| i[0] }
  result = [sorted[0].dup]

  sorted[1..].each do |curr|
    last = result[-1]
    if curr[0] <= last[1]
      # Overlapping: extend the end of the last merged interval
      last[1] = [last[1], curr[1]].max
    else
      # Non-overlapping: start a new merged interval
      result << curr.dup
    end
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{merge_brute([[1, 3], [2, 6], [8, 10], [15, 18]]).inspect}"
  puts "Optimized:   #{merge([[1, 3], [2, 6], [8, 10], [15, 18]]).inspect}"
  # Both: [[1,6],[8,10],[15,18]]
end
