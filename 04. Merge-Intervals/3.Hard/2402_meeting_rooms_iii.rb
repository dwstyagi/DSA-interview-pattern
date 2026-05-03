# frozen_string_literal: true

# LeetCode 2402: Meeting Rooms III
#
# Problem:
# You have n rooms numbered 0 to n-1. You are given a 2D integer array meetings
# where meetings[i] = [start_i, end_i].
# All meetings must be held. If a room is free, assign the meeting to the lowest-numbered room.
# If not, the meeting is delayed to the next free room's available time.
# Return the room number that held the most meetings.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate by sorting meetings by start. For each meeting, find the first free room.
#    If no room free, find the room that frees up earliest and delay the meeting.
#
#    Time Complexity: O(m * n) where m = meetings, n = rooms
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Finding the earliest-free room is O(n) per meeting → O(m*n) total.
#
# 3. Optimized Accepted Approach
#    Use two min-heaps:
#    - available: free rooms sorted by room number
#    - occupied: [end_time, room_number] for currently busy rooms
#    For each meeting (sorted by start): free up all rooms whose end <= start,
#    then assign to lowest-numbered free room, or to earliest-ending busy room.
#
#    Time Complexity: O(m log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=2, meetings=[[0,10],[1,5],[2,7],[3,4]]
# sorted: [[0,10],[1,5],[2,7],[3,4]]
# [0,10]: room 0 free → assign room 0, occupied=[[10,0]], count[0]++
# [1,5]:  room 1 free → assign room 1, occupied=[[5,1],[10,0]], count[1]++
# [2,7]:  no room free, earliest=5 (room 1) → delay to [5,5+5=7] → room 1 at 7, count[1]++
# [3,4]:  no room free at 3, earliest=7 (room 0 or 1 tie→ room 0)... room 0 at 10
#         actually earliest at 3 is room 1 (frees at 7) → assign room 1, count[1]++
# count = [1,3] → room 1
#
# Edge Cases:
# - Single meeting, multiple rooms -> room 0
# - All concurrent, n rooms -> spread evenly

def most_booked_brute(n, meetings)
  count = Array.new(n, 0)
  # free_until[i] = time room i becomes available
  free_until = Array.new(n, 0)

  meetings.sort_by { |m| m[0] }.each do |start, duration|
    dur = duration - start

    # Find free room with lowest index
    free_room = (0...n).find { |r| free_until[r] <= start }

    if free_room
      free_until[free_room] = start + dur
      count[free_room] += 1
    else
      # All busy: find room that frees earliest (tie: lowest index)
      earliest_room = (0...n).min_by { |r| [free_until[r], r] }
      free_until[earliest_room] += dur
      count[earliest_room] += 1
    end
  end

  count.index(count.max)
end

def most_booked(n, meetings)
  count = Array.new(n, 0)
  # available: sorted array of free room indices (min-heap behavior via sort)
  available = (0...n).to_a
  # occupied: [end_time, room_number]
  occupied = []

  meetings.sort_by { |m| m[0] }.each do |start, finish|
    dur = finish - start

    # Move rooms that have become free to available list
    while occupied.any? && occupied.min[0] <= start
      _, room = occupied.min
      occupied.delete(occupied.min)
      # Insert in sorted order
      idx = available.bsearch_index { |r| r >= room } || available.length
      available.insert(idx, room)
    end

    if available.any?
      # Assign to the lowest-numbered free room
      room = available.shift
      occupied << [start + dur, room]
      count[room] += 1
    else
      # All rooms busy: assign to the one ending earliest (tie: lowest room number)
      min_entry = occupied.min_by { |e, r| [e, r] }
      occupied.delete(min_entry)
      end_time, room = min_entry
      occupied << [end_time + dur, room]
      count[room] += 1
    end
  end

  count.index(count.max)
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{most_booked_brute(2, [[0, 10], [1, 5], [2, 7], [3, 4]])}" # 1
  puts "Optimized:   #{most_booked(2, [[0, 10], [1, 5], [2, 7], [3, 4]])}"       # 1
  puts "Brute force: #{most_booked_brute(3, [[1, 20], [2, 10], [3, 5], [4, 9], [6, 8]])}" # 1
  puts "Optimized:   #{most_booked(3, [[1, 20], [2, 10], [3, 5], [4, 9], [6, 8]])}"       # 1
end
