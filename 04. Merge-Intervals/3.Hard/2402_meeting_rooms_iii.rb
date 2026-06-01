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
# Examples:
#   Input:  n = 2, meetings = [[0,10],[1,5],[2,7],[3,4]]
#   Output: 0
#   Why:    Room 0 holds most meetings (3 total) -> return room index 0.
#
#   Input:  n = 3, meetings = [[1,20],[2,10],[3,5],[4,9],[6,8]]
#   Output: 1
#   Why:    After all meetings, room 1 has been used most times.
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

def most_booked_brute(room_count, meetings)
  # booking_count[room] = how many meetings were assigned to this room
  booking_count = Array.new(room_count, 0)

  # free_until[room] = time when this room becomes available again
  free_until = Array.new(room_count, 0)

  # Process meetings in sorted order of start time
  meetings.sort_by { |meeting| meeting[0] }.each do |start_time, end_time|
    duration = end_time - start_time

    # Try to find a room that is already free at start_time.
    # Since we scan from left to right, the first free room is the
    # smallest room number.
    free_room = (0...room_count).find do |room_number|
      free_until[room_number] <= start_time
    end

    if free_room
      # Assign the meeting immediately to that free room.
      free_until[free_room] = end_time
      booking_count[free_room] += 1
    else
      # All rooms are busy.
      # Pick the room that becomes free the earliest.
      # If multiple rooms free at the same time, choose smaller room number.
      earliest_room = (0...room_count).min_by do |room_number|
        [free_until[room_number], room_number]
      end

      # Delay the meeting to start when earliest_room becomes free.
      # The meeting keeps the same duration.
      free_until[earliest_room] += duration
      booking_count[earliest_room] += 1
    end
  end

  # Return the room with the highest booking count.
  # If tied, index returns the first one, which is the smaller room number.
  booking_count.index(booking_count.max)
end

require 'algorithms'

def most_booked(room_count, meetings)
  # Process meetings in increasing order of start time.
  sorted_meetings = meetings.sort_by { |start_time, _end_time| start_time }

  # Min-heap of currently free room numbers.
  # Always gives the smallest available room number.
  free_rooms = Containers::MinHeap.new

  # Min-heap of busy rooms stored as:
  # [end_time, room_number]
  # This gives the room that becomes free earliest.
  # If end times tie, smaller room number wins automatically.
  busy_rooms = Containers::MinHeap.new

  # booking_count[room] = how many meetings were assigned to this room
  booking_count = Array.new(room_count, 0)

  # Initially every room is free.
  (0...room_count).each do |room_number|
    free_rooms.push(room_number)
  end

  sorted_meetings.each do |start_time, end_time|
    duration = end_time - start_time

    # Release all rooms whose meetings have already ended
    # by the current meeting's start time.
    until busy_rooms.empty?
      earliest_end_time, room_number = busy_rooms.next
      break if earliest_end_time > start_time

      busy_rooms.pop
      free_rooms.push(room_number)
    end

    if free_rooms.empty?
      # No room is free.
      # Take the room that becomes available earliest,
      # delay the meeting there, and keep the same duration.
      available_time, room_number = busy_rooms.pop
      delayed_end_time = available_time + duration

      busy_rooms.push([delayed_end_time, room_number])
    else
      # At least one room is free.
      # Use the smallest room number.
      room_number = free_rooms.pop

      busy_rooms.push([end_time, room_number])
    end

    booking_count[room_number] += 1
  end

  # Return the room with the highest booking count.
  # If tied, choose the smaller room number.
  booking_count.each_with_index.max_by { |count, room_number| [count, -room_number] }[1]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{most_booked_brute(2, [[0, 10], [1, 5], [2, 7], [3, 4]])}" # 1
  puts "Optimized:   #{most_booked(2, [[0, 10], [1, 5], [2, 7], [3, 4]])}"       # 1
  puts "Brute force: #{most_booked_brute(3, [[1, 20], [2, 10], [3, 5], [4, 9], [6, 8]])}" # 1
  puts "Optimized:   #{most_booked(3, [[1, 20], [2, 10], [3, 5], [4, 9], [6, 8]])}"       # 1
end
