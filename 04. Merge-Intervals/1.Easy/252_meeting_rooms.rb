# frozen_string_literal: true

# LeetCode 252: Meeting Rooms
#
# Problem:
# Given an array of meeting time intervals where intervals[i] = [start_i, end_i],
# determine if a person could attend all meetings (i.e., no two intervals overlap).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every pair of intervals for overlap.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Pairwise comparison. After sorting, only adjacent intervals can overlap.
#
# 3. Optimized Accepted Approach
#    Sort by start time. Check if any adjacent pair overlaps (next.start < curr.end).
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# intervals = [[0,30],[5,10],[15,20]]
# sorted: [[0,30],[5,10],[15,20]]
# pair(0,30) and (5,10): 5 < 30 → overlap! → false
#
# intervals = [[7,10],[2,4]]
# sorted: [[2,4],[7,10]]
# pair(2,4) and (7,10): 7 >= 4 → no overlap → true
#
# Edge Cases:
# - Empty or single interval -> true
# - Adjacent but not overlapping -> true (end == next.start is OK)

def can_attend_meetings_brute(intervals)
  (0...intervals.length).each do |i|
    ((i + 1)...intervals.length).each do |j|
      a = intervals[i]
      b = intervals[j]
      # Two intervals overlap if max(start) < min(end)
      return false if [a[0], b[0]].max < [a[1], b[1]].min
    end
  end
  true
end

def can_attend_meetings(intervals)
  return true if intervals.length <= 1

  # Sort by start time — only adjacent intervals can conflict
  sorted = intervals.sort_by { |i| i[0] }

  (1...sorted.length).each do |i|
    # If the next meeting starts before the current one ends, overlap
    return false if sorted[i][0] < sorted[i - 1][1]
  end

  true
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{can_attend_meetings_brute([[0, 30], [5, 10], [15, 20]])}" # false
  puts "Optimized:   #{can_attend_meetings([[0, 30], [5, 10], [15, 20]])}"       # false
  puts "Brute force: #{can_attend_meetings_brute([[7, 10], [2, 4]])}"            # true
  puts "Optimized:   #{can_attend_meetings([[7, 10], [2, 4]])}"                  # true
end
