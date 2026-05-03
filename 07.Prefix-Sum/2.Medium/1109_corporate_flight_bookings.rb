# frozen_string_literal: true

# LeetCode 1109: Corporate Flight Bookings
#
# Problem:
# There are n flights. Each booking [first, last, seats] reserves `seats` seats
# on flights first through last (1-indexed). Return the total seats booked for
# each flight as an array.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each booking, iterate from first to last and add seats.
#    Time Complexity: O(n * b) where b = number of bookings
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Updating every flight in range for each booking.
#
# 3. Optimized Accepted Approach
#    Difference array: diff[first-1] += seats, diff[last] -= seats.
#    Final answer is the prefix sum of the diff array.
#    Time Complexity: O(n + b)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=5, bookings=[[1,2,10],[2,3,20],[2,5,25]]
# diff = [0,0,0,0,0,0]
# [1,2,10]: diff[0]+=10, diff[2]-=10 → [10,0,-10,0,0,0]
# [2,3,20]: diff[1]+=20, diff[3]-=20 → [10,20,-10,-20,0,0]
# [2,5,25]: diff[1]+=25, diff[5]-=25 → [10,45,-10,-20,0,-25]
# prefix sum: [10,55,45,25,25] → answer
#
# Edge Cases:
# - Single booking covering all flights → uniform value
# - Bookings with first == last → single flight incremented

def corp_flight_bookings_brute(bookings, n)
  answer = Array.new(n, 0)
  bookings.each do |first, last, seats|
    ((first - 1)...last).each { |i| answer[i] += seats }
  end
  answer
end

def corp_flight_bookings(bookings, n)
  diff = Array.new(n + 1, 0)   # difference array, 1-indexed range updates

  bookings.each do |first, last, seats|
    diff[first - 1] += seats   # range start (0-indexed)
    diff[last] -= seats        # range end + 1 (cancel effect)
  end

  # prefix sum of diff gives the final seat counts
  total = 0
  (0...n).map { |i| total += diff[i]; total }
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{corp_flight_bookings_brute([[1, 2, 10], [2, 3, 20], [2, 5, 25]], 5).inspect}"
  puts "Opt:   #{corp_flight_bookings([[1, 2, 10], [2, 3, 20], [2, 5, 25]], 5).inspect}"
  # Both → [10, 55, 45, 25, 25]
end
