# frozen_string_literal: true

# LeetCode 731: My Calendar II
#
# Problem:
# Implement a MyCalendarTwo class. A double booking happens when two events overlap.
# book(startTime, endTime) returns true if the event can be added without causing a
# triple booking (three overlapping events), false otherwise.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Track all bookings. On each new event, find the overlaps with existing events;
#    check if any overlap itself overlaps with another existing event.
#
#    Time Complexity: O(n^2) per booking
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Re-checking all pairs is expensive.
#
# 3. Optimized Accepted Approach
#    Maintain two lists: bookings (all events) and overlaps (double-booked regions).
#    For a new event to be added, it must not overlap with any region in overlaps.
#    If safe, add its intersections with all existing bookings into overlaps,
#    then add the new event to bookings.
#
#    Time Complexity: O(n^2) total (each booking checks all previous)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# book(10,20): bookings=[], overlaps=[] → safe, bookings=[[10,20]]
# book(50,60): overlaps=[] → safe, bookings=[[10,20],[50,60]]
# book(10,40): check overlaps: none → safe
#   intersect with [10,20]: [10,20] → overlaps=[[10,20]]
#   bookings=[[10,20],[50,60],[10,40]]
# book(5,15): check overlaps: [10,20] ∩ [5,15]=[10,15] ≠ ∅ → false
#
# Edge Cases:
# - Adjacent events      -> not overlapping (half-open)
# - Identical events x3  -> third returns false

class MyCalendarTwoBrute # rubocop:disable Style/Documentation
  def initialize
    @bookings = []
  end

  def book(start, enden)
    overlaps = []
    @bookings.each do |s, e|
      lo = [s, start].max
      hi = [e, enden].min
      overlaps << [lo, hi] if lo < hi
    end
    # Check if any overlap itself overlaps with another booking
    overlaps.each do |lo, hi|
      @bookings.each do |s, e|
        return false if [s, lo].max < [e, hi].min
      end
    end
    @bookings << [start, enden]
    true
  end
end

class MyCalendarTwo # rubocop:disable Style/Documentation
  def initialize
    @bookings = []  # all single-booked intervals
    @overlaps = []  # double-booked regions
  end

  def book(start, enden)
    # New event must not cause triple booking → must not overlap with any double-booked region
    @overlaps.each do |lo, hi|
      return false if [lo, start].max < [hi, enden].min
    end

    # Add intersections of new event with existing bookings into overlaps
    @bookings.each do |s, e|
      lo = [s, start].max
      hi = [e, enden].min
      @overlaps << [lo, hi] if lo < hi
    end

    @bookings << [start, enden]
    true
  end
end

if __FILE__ == $PROGRAM_NAME
  cal = MyCalendarTwoBrute.new
  puts "Brute: #{cal.book(10, 20)}" # true
  puts "Brute: #{cal.book(50, 60)}" # true
  puts "Brute: #{cal.book(10, 40)}" # true
  puts "Brute: #{cal.book(5, 15)}"  # false
  puts "Brute: #{cal.book(5, 10)}"  # true
  puts "Brute: #{cal.book(25, 55)}" # true

  cal2 = MyCalendarTwo.new
  puts "Opt: #{cal2.book(10, 20)}" # true
  puts "Opt: #{cal2.book(50, 60)}" # true
  puts "Opt: #{cal2.book(10, 40)}" # true
  puts "Opt: #{cal2.book(5, 15)}"  # false
end
