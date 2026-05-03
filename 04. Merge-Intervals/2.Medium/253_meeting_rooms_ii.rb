# frozen_string_literal: true

# LeetCode 253: Meeting Rooms II
#
# Problem:
# Given an array of meeting time intervals where intervals[i] = [start_i, end_i],
# return the minimum number of conference rooms required.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate by trying to assign each meeting to an existing room if possible.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Naive assignment is O(n^2). Key insight: only the minimum end time matters.
#
# 3. Optimized Accepted Approach
#    Two-pointer sweep: separate and sort start times and end times.
#    Pointer s scans starts, pointer e scans ends.
#    When a meeting starts before the earliest-ending meeting finishes → need a new room.
#    When a meeting starts after earliest end → reuse that room (e advances).
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# intervals = [[0,30],[5,10],[15,20]]
# starts = [0,5,15], ends = [10,20,30]
# s=0(0),e=0(10): 0<10 → rooms=1, s++
# s=1(5),e=0(10): 5<10 → rooms=2, s++
# s=2(15),e=0(10): 15>=10 → reuse, e=1, s++
# max rooms = 2
#
# Edge Cases:
# - Single meeting    -> 1
# - No overlaps       -> 1
# - All same time     -> n

def min_meeting_rooms_brute(intervals)
  return 0 if intervals.empty?

  # Greedy assignment: room holds end time of last meeting
  rooms = []
  intervals.sort_by { |i| i[0] }.each do |start, enden|
    # Find a room that is free (ended before this meeting starts)
    freed = rooms.index { |end_time| end_time <= start }
    if freed
      rooms[freed] = enden
    else
      rooms << enden
    end
  end

  rooms.length
end

def min_meeting_rooms(intervals)
  return 0 if intervals.empty?

  starts = intervals.map { |i| i[0] }.sort
  ends   = intervals.map { |i| i[1] }.sort

  rooms = 0
  max_rooms = 0
  s = 0
  e = 0

  while s < starts.length
    if starts[s] < ends[e]
      # New meeting starts before earliest-ending meeting; need a room
      rooms += 1
      max_rooms = [max_rooms, rooms].max
      s += 1
    else
      # A room is freed up
      rooms -= 1
      e += 1
    end
  end

  max_rooms
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{min_meeting_rooms_brute([[0, 30], [5, 10], [15, 20]])}" # 2
  puts "Optimized:   #{min_meeting_rooms([[0, 30], [5, 10], [15, 20]])}"       # 2
  puts "Brute force: #{min_meeting_rooms_brute([[7, 10], [2, 4]])}"            # 1
  puts "Optimized:   #{min_meeting_rooms([[7, 10], [2, 4]])}"                  # 1
end
