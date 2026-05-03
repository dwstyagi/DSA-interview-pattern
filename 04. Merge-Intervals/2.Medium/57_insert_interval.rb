# frozen_string_literal: true

# LeetCode 57: Insert Interval
#
# Problem:
# Given a sorted array of non-overlapping intervals and a new interval,
# insert the new interval and merge as needed.
# Return the resulting array of non-overlapping intervals.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Append the new interval, then run the full merge algorithm.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Re-sorting is unnecessary since the input is already sorted.
#
# 3. Optimized Accepted Approach
#    3-phase scan:
#    Phase 1: Collect all intervals that end before the new interval starts.
#    Phase 2: Merge all intervals that overlap with the new interval.
#    Phase 3: Collect all intervals that start after the new interval ends.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# intervals=[[1,3],[6,9]], newInterval=[2,5]
# Phase 1: [1,3]: 3<2? No → stop. result=[]
# Phase 2: [1,3]: 1<=5 → merge: new=[1,5]; [6,9]: 6<=5? No → stop. result=[] + [1,5]
# Phase 3: [[6,9]] appended
# Final: [[1,5],[6,9]]
#
# Edge Cases:
# - New interval before all existing   -> prepend
# - New interval after all existing    -> append
# - New interval overlaps all          -> one big merged interval

def insert_brute(intervals, new_interval)
  # Append then merge using standard merge algorithm
  all = (intervals + [new_interval]).sort_by { |i| i[0] }
  result = [all[0].dup]
  all[1..].each do |curr|
    if curr[0] <= result[-1][1]
      result[-1][1] = [result[-1][1], curr[1]].max
    else
      result << curr.dup
    end
  end
  result
end

def insert(intervals, new_interval)
  result = []
  i = 0
  n = intervals.length

  # Phase 1: intervals entirely before new_interval (end < new_interval start)
  result << intervals[i] while i < n && intervals[i][1] < new_interval[0] && (i += 1)

  # Phase 2: intervals that overlap with new_interval (start <= new_interval end)
  while i < n && intervals[i][0] <= new_interval[1]
    new_interval[0] = [new_interval[0], intervals[i][0]].min
    new_interval[1] = [new_interval[1], intervals[i][1]].max
    i += 1
  end
  result << new_interval

  # Phase 3: intervals entirely after new_interval
  result.concat(intervals[i..])
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{insert_brute([[1, 3], [6, 9]], [2, 5]).inspect}"
  puts "Optimized:   #{insert([[1, 3], [6, 9]], [2, 5]).inspect}"
  # Both: [[1,5],[6,9]]
  puts "Brute force: #{insert_brute([[1, 2], [3, 5], [6, 7], [8, 10], [12, 16]], [4, 8]).inspect}"
  puts "Optimized:   #{insert([[1, 2], [3, 5], [6, 7], [8, 10], [12, 16]], [4, 8]).inspect}"
  # Both: [[1,2],[3,10],[12,16]]
end
