# frozen_string_literal: true

# LeetCode 729: My Calendar I
#
# Problem:
# Implement a MyCalendar class to store events.
# book(startTime, endTime): returns true if the event can be added (no double booking),
# false otherwise. An event is [start, end) — half-open interval.
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

  def book(start, enden)
    # Check against every stored event
    @events.each do |s, e|
      # Intervals [s,e) and [start,enden) overlap if max(s,start) < min(e,enden)
      return false if [s, start].max < [e, enden].min
    end
    @events << [start, enden]
    true
  end
end

class MyCalendar # rubocop:disable Style/Documentation
  def initialize
    @events = [] # sorted by start time
  end

  def book(start, enden)
    # Binary search for the insertion position
    lo = 0
    hi = @events.length

    while lo < hi
      mid = (lo + hi) / 2
      @events[mid][0] < start ? lo = mid + 1 : hi = mid
    end

    # Check the neighbor to the right (lo) for overlap
    if lo < @events.length && @events[lo][0] < enden
      return false
    end

    # Check the neighbor to the left (lo-1) for overlap
    if lo > 0 && @events[lo - 1][1] > start
      return false
    end

    # No conflict; insert at position lo
    @events.insert(lo, [start, enden])
    true
  end
end

if __FILE__ == $PROGRAM_NAME
  cal = MyCalendarBrute.new
  puts "Brute: #{cal.book(10, 20)}" # true
  puts "Brute: #{cal.book(15, 25)}" # false
  puts "Brute: #{cal.book(20, 30)}" # true

  cal2 = MyCalendar.new
  puts "Opt: #{cal2.book(10, 20)}" # true
  puts "Opt: #{cal2.book(15, 25)}" # false
  puts "Opt: #{cal2.book(20, 30)}" # true
end
