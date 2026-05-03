# frozen_string_literal: true

# LeetCode 759: Employee Free Time
#
# Problem:
# We are given a list schedule of employees, which represents the working time for each employee.
# Each employee has a list of non-overlapping Intervals, and these intervals are in sorted order.
# Return the list of finite intervals representing common free time for all employees,
# sorted in order.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Flatten all intervals, sort them, merge all overlapping intervals.
#    The gaps between merged intervals are the free times.
#
#    Time Complexity: O(n log n) where n = total number of intervals
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Already optimal once we merge; the structure of the problem is just:
#    flatten → sort → merge → find gaps.
#
# 3. Optimized Accepted Approach
#    Same approach but implemented cleanly using merge intervals algorithm.
#    After merging, find gaps [merged[i].end, merged[i+1].start] for consecutive merged.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# schedule = [[[1,3],[6,7]],[[2,4]],[[2,5],[9,12]]]
# all intervals: [1,3],[6,7],[2,4],[2,5],[9,12]
# sorted: [1,3],[2,4],[2,5],[6,7],[9,12]
# merged: [1,5],[6,7],[9,12]
# gaps: [5,6],[7,9]
#
# Edge Cases:
# - Single employee, no gaps -> []
# - Continuous schedule      -> []

def employee_free_time_brute(schedule)
  # Flatten all intervals
  all = schedule.flatten(1).sort_by { |i| i[0] }

  # Merge overlapping intervals
  merged = [all[0].dup]
  all[1..].each do |curr|
    if curr[0] <= merged[-1][1]
      merged[-1][1] = [merged[-1][1], curr[1]].max
    else
      merged << curr.dup
    end
  end

  # Collect gaps between consecutive merged intervals
  gaps = []
  (0...merged.length - 1).each do |i|
    gaps << [merged[i][1], merged[i + 1][0]]
  end

  gaps
end

def employee_free_time(schedule)
  # Flatten all employees' intervals into one list
  all = schedule.flatten(1).sort_by { |i| i[0] }
  return [] if all.empty?

  # Merge all overlapping intervals
  merged = [all[0].dup]
  all[1..].each do |curr|
    last = merged[-1]
    if curr[0] <= last[1]
      # Extend the current merged interval
      last[1] = [last[1], curr[1]].max
    else
      merged << curr.dup
    end
  end

  # Find gaps (free time) between consecutive merged intervals
  free_time = []
  (0...merged.length - 1).each do |i|
    free_time << [merged[i][1], merged[i + 1][0]]
  end

  free_time
end

if __FILE__ == $PROGRAM_NAME
  schedule = [[[1, 3], [6, 7]], [[2, 4]], [[2, 5], [9, 12]]]
  puts "Brute force: #{employee_free_time_brute(schedule).inspect}"
  puts "Optimized:   #{employee_free_time(schedule).inspect}"
  # Both: [[5,6],[7,9]]
end
