# frozen_string_literal: true

# LeetCode 1109: Corporate Flight Bookings
#
# Problem
# -------
# There are n flights numbered from 1 to n.
#
# Each booking:
#
#   [first, last, seats]
#
# means every flight in the range [first, last] gets `seats` passengers.
#
# Return an array where answer[i] is the total seats booked for flight i + 1.
#
# -----------------------------------------------------------------------------
# Example
#
# bookings = [
#   [1, 2, 10],
#   [2, 3, 20],
#   [2, 5, 25]
# ]
#
# n = 5
#
# Final answer:
#
#   [10, 55, 45, 25, 25]
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. Brute Force
#
# For every booking:
#
#   [first, last, seats]
#
# add seats to every flight from first to last.
#
# Time:  O(bookings * range_length)
# Worst: O(n * bookings)
#
# -----------------------------------------------------------------------------
# Bottleneck
#
# A booking like:
#
#   [1, 20_000, 10]
#
# forces us to touch 20,000 flights.
#
# We repeatedly update the same ranges.
#
# -----------------------------------------------------------------------------
# Key Insight (Difference Array)
#
# Instead of updating every flight in the range,
# only record:
#
#   where the effect starts
#   where the effect stops
#
# Example:
#
#   [2, 5, 25]
#
# We want:
#
#   0 25 25 25 25
#
# Record:
#
#   +25 at flight 2
#   -25 after flight 5
#
# diff:
#
#   [0, 25, 0, 0, 0, -25]
#
# Taking a prefix sum reconstructs:
#
#   [0, 25, 25, 25, 25, 0]
#
# -----------------------------------------------------------------------------
# Difference Array Rule
#
# For range update:
#
#   add value to [left, right]
#
# Do:
#
#   diff[left]     += value
#   diff[right+1] -= value
#
# Then run a prefix sum once at the end.
#
# -----------------------------------------------------------------------------
# Dry Run
#
# bookings = [
#   [1, 2, 10],
#   [2, 3, 20],
#   [2, 5, 25]
# ]
#
# diff = [0,0,0,0,0,0]
#
# [1,2,10]
# diff[0] += 10
# diff[2] -= 10
#
# => [10,0,-10,0,0,0]
#
# [2,3,20]
# diff[1] += 20
# diff[3] -= 20
#
# => [10,20,-10,-20,0,0]
#
# [2,5,25]
# diff[1] += 25
# diff[5] -= 25
#
# => [10,45,-10,-20,0,-25]
#
# Prefix Sum:
#
# 10
# 10 + 45  = 55
# 55 - 10  = 45
# 45 - 20  = 25
# 25 + 0   = 25
#
# Answer:
#
# [10, 55, 45, 25, 25]
#
# -----------------------------------------------------------------------------
# Complexity
#
# Time:  O(bookings + n)
# Space: O(n)
#

def corp_flight_bookings_brute(bookings, n)
  result = Array.new(n, 0)

  bookings.each do |first, last, seats|
    (first..last).each do |flight|
      result[flight - 1] += seats
    end
  end

  result
end

def corp_flight_bookings(bookings, n)
  diff = Array.new(n + 1, 0)

  bookings.each do |first, last, seats|
    diff[first - 1] += seats # start effect
    diff[last] -= seats      # stop effect after last flight
  end

  running = 0

  (0...n).map do |i|
    running += diff[i]
    running
  end
end

if __FILE__ == $PROGRAM_NAME
  bookings = [
    [1, 2, 10],
    [2, 3, 20],
    [2, 5, 25]
  ]

  p corp_flight_bookings(bookings, 5)
  # => [10, 55, 45, 25, 25]
end
