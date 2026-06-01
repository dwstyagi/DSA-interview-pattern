# frozen_string_literal: true

# LeetCode 729: My Calendar I
#
# Problem:
# Implement a MyCalendar class to store events.
# book(startTime, endTime): returns true if the event can be added (no double booking),
# false otherwise. An event is [start, end) — half-open interval.
#
# Examples:
#   Input:  book(10,20), book(15,25), book(20,30)
#   Output: true, false, true
#   Why:    [15,25) overlaps [10,20) -> rejected. [20,30) starts at 20 = end of first, no overlap.
#
#   Input:  book(0,10), book(5,15)
#   Output: true, false
#   Why:    [5,15) overlaps [0,10) at [5,10) -> rejected.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Store all events. On each new booking, check against all existing for overlap.
#
#    Time Complexity: O(n) per booking, O(n^2) total
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Linear scan per booking. Can use sorted structure + binary search.
#
# 3. Optimized Accepted Approach
#    Keep sorted list of events. Binary search for the insertion point.
#    Check only neighbors for overlap. In Ruby, simulate with sorted array.
#
#    Time Complexity: O(n log n) total (O(log n) search, O(n) insert)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# book(10,20): events=[], no conflict → add, return true
# book(15,25): events=[[10,20]], overlap: 15<20 → false
# book(20,30): events=[[10,20]], 20>=20 → no conflict → add, return true
#
# Edge Cases:
# - Adjacent events [10,20] and [20,30] -> no conflict (half-open)
# - Same event twice -> conflict

class MyCalendarBrute # rubocop:disable Style/Documentation
  def initialize
    @events = []
  end

  def book?(start_time, end_time)
    @events.each do |existing_start, existing_end|
      return false if start_time < existing_end && existing_start < end_time
    end

    @events << [start_time, end_time]
    true
  end
end

class MyCalendar # rubocop:disable Style/Documentation
  def initialize
    @events = [] # sorted by start time
  end

  def book?(start_time, end_time)
    left = 0
    right = @events.length

    # Binary search:
    # Find the first event whose start time is >= start_time.
    # That index is where the new event should be inserted.
    while left < right
      middle = (left + right) / 2

      if @events[middle][0] < start_time
        left = middle + 1
      else
        right = middle
      end
    end

    # Check the event on the right side of insertion.
    # Overlap exists if the next event starts before the new event ends.
    return false if left < @events.length && @events[left][0] < end_time

    # Check the event on the left side of insertion.
    # Overlap exists if the previous event ends after the new event starts.
    return false if left.positive? && @events[left - 1][1] > start_time

    # No overlap with neighbors, so insert at the correct sorted position.
    @events.insert(left, [start_time, end_time])
    true
  end
end

if __FILE__ == $PROGRAM_NAME
  cal = MyCalendarBrute.new
  puts "Brute: #{cal.book?(10, 20)}" # true
  puts "Brute: #{cal.book?(15, 25)}" # false
  puts "Brute: #{cal.book?(20, 30)}" # true

  cal2 = MyCalendar.new
  puts "Opt: #{cal2.book?(10, 20)}" # true
  puts "Opt: #{cal2.book?(15, 25)}" # false
  puts "Opt: #{cal2.book?(20, 30)}" # true
end
