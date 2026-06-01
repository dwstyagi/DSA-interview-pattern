# frozen_string_literal: true

# LeetCode 731: My Calendar II
#
# Problem:
# Implement a MyCalendarTwo class. A double booking happens when two events overlap.
# book(startTime, endTime) returns true if the event can be added without causing a
# triple booking (three overlapping events), false otherwise.
#
# Examples:
#   Input:  book(10,20), book(50,60), book(10,40), book(5,15), book(5,10), book(25,55)
#   Output: true, true, true, false, true, true
#   Why:    book(5,15) causes triple-booking at [10,15) with [10,20) and [10,40) -> rejected.
#
#   Input:  book(0,10), book(5,15), book(0,5)
#   Output: true, true, true
#   Why:    [0,5) is only double-booked max -> accepted.
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

class MyCalendarTwoBruteForce # rubocop:disable Style/Documentation
  def initialize
    @bookings = []
  end

  def book?(start_time, end_time)
    # Try adding the new booking temporarily.
    candidate_bookings = @bookings + [[start_time, end_time]]

    # Collect all unique boundary points from all bookings.
    # These boundaries split the timeline into small segments.
    boundaries = candidate_bookings
                 .flat_map { |booking_start, booking_end| [booking_start, booking_end] }
                 .uniq
                 .sort

    # Check each segment between consecutive boundary points.
    # If any segment is covered by 3 or more bookings, reject.
    (0...(boundaries.length - 1)).each do |index|
      segment_start = boundaries[index]
      segment_end = boundaries[index + 1]
      active_count = 0

      candidate_bookings.each do |booking_start, booking_end|
        # Overlap with current segment exists if:
        # booking_start < segment_end && segment_start < booking_end
        active_count += 1 if booking_start < segment_end && segment_start < booking_end
      end

      return false if active_count >= 3
    end

    # No segment reached triple booking, so accept it.
    @bookings << [start_time, end_time]
    true
  end
end

class MyCalendarTwo
  def initialize
    # All accepted bookings
    @bookings = []

    # Time segments that are already booked twice
    @double_booked = []
  end

  def book?(start_time, end_time)
    # If the new booking overlaps any already double-booked segment,
    # that would create a triple booking, so reject it.
    @double_booked.each do |overlap_start, overlap_end|
      return false if start_time < overlap_end && overlap_start < end_time
    end

    # Compare the new booking with every existing booking.
    # Any overlap between them becomes a new double-booked segment.
    @bookings.each do |existing_start, existing_end|
      overlap_start = [start_time, existing_start].max
      overlap_end = [end_time, existing_end].min

      @double_booked << [overlap_start, overlap_end] if overlap_start < overlap_end
    end

    # No triple booking found, so accept this booking.
    @bookings << [start_time, end_time]
    true
  end
end

if __FILE__ == $PROGRAM_NAME
  cal = MyCalendarTwoBrute.new
  puts "Brute: #{cal.book?(10, 20)}" # true
  puts "Brute: #{cal.book?(50, 60)}" # true
  puts "Brute: #{cal.book?(10, 40)}" # true
  puts "Brute: #{cal.book?(5, 15)}"  # false
  puts "Brute: #{cal.book?(5, 10)}"  # true
  puts "Brute: #{cal.book?(25, 55)}" # true

  cal2 = MyCalendarTwo.new
  puts "Opt: #{cal2.book?(10, 20)}" # true
  puts "Opt: #{cal2.book?(50, 60)}" # true
  puts "Opt: #{cal2.book?(10, 40)}" # true
  puts "Opt: #{cal2.book?(5, 15)}"  # false
end
