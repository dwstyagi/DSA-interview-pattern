# frozen_string_literal: true

# LeetCode 1094: Car Pooling
#
# Problem:
# There is a car with capacity empty seats. The vehicle only drives east.
# Given trips[i] = [numPassengers, from, to], return true if it's possible to pick up
# and drop off all passengers for all given trips.
#
# Examples:
#   Input:  trips = [[2,1,5],[3,3,7]], capacity = 4
#   Output: false
#   Why:    At stop 3, 2+3=5 passengers on board, exceeds capacity 4.
#
#   Input:  trips = [[2,1,5],[3,5,7]], capacity = 3
#   Output: true
#   Why:    Passengers never overlap — max 3 on board at any time.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate at each position from 0 to max_stop.
#
#    Time Complexity: O(n * max_stop)
#    Space Complexity: O(max_stop)
#
# 2. Bottleneck
#    Max stop can be large. Use events (sweep line) instead.
#
# 3. Optimized Accepted Approach
#    Difference array (sweep line): at each pick-up point add passengers,
#    at each drop-off point subtract. Compute prefix sum and check if max <= capacity.
#
#    Time Complexity: O(n + max_stop)
#    Space Complexity: O(max_stop)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# trips = [[2,1,5],[3,3,7]], capacity = 4
# diff[1]+=2, diff[5]-=2
# diff[3]+=3, diff[7]-=3
# prefix: 0,2,2,5,5,3,3,0 → max=5 > 4 → false
#
# trips = [[2,1,5],[3,5,7]], capacity = 3
# diff[1]+=2, diff[5]-=2, diff[5]+=3, diff[7]-=3
# prefix: 0,2,2,2,2,3,3,0 → max=3 <= 3 → true
#
# Edge Cases:
# - Single trip <= capacity -> true
# - All at same stop        -> check sum

def car_pooling_brute(trips, capacity)
  # Find the maximum stop
  max_stop = trips.map { |_, _, to| to }.max

  # Simulate each position
  (0..max_stop).each do |pos|
    passengers = 0
    trips.each do |num, from, to|
      passengers += num if from <= pos && pos < to
    end
    return false if passengers > capacity
  end

  true
end

def car_pooling(trips, capacity)
  events = []

  # Convert each trip into:
  # pickup event  -> +passengers
  # drop-off event -> -passengers
  trips.each do |passengers, from_location, to_location|
    events << [from_location, passengers]
    events << [to_location, -passengers]
  end

  # Sort by location.
  # At the same location, drop-offs (-x) happen before pickups (+x).
  events.sort_by! { |location, change| [location, change] }

  current_passengers = 0

  events.each do |_, change|
    current_passengers += change
    return false if current_passengers > capacity
  end

  true
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{car_pooling_brute([[2, 1, 5], [3, 3, 7]], 4)}" # false
  puts "Optimized:   #{car_pooling([[2, 1, 5], [3, 3, 7]], 4)}"       # false
  puts "Brute force: #{car_pooling_brute([[2, 1, 5], [3, 5, 7]], 3)}" # true
  puts "Optimized:   #{car_pooling([[2, 1, 5], [3, 5, 7]], 3)}"       # true
end
