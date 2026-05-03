# frozen_string_literal: true

# LeetCode 853: Car Fleet
#
# Problem:
# n cars at different positions going to target. Cars form a fleet if one catches
# another (faster car slows to match slower). Return number of fleets.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Compute arrival time for each car. Sort by position descending.
#    Scan: if a car arrives before the car ahead, they merge into one fleet.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Already O(n log n) due to sort. Monotonic stack cleanly tracks fleet count.
#
# 3. Optimized Accepted Approach
#    Compute time = (target - pos) / speed. Sort by position descending.
#    Monotonic stack: push times. If new time > stack top, it's a new fleet.
#    Stack size at end = fleet count.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# target=12, position=[10,8,0,5,3], speed=[2,4,1,1,3]
# sorted by pos desc: (10,2),(8,4),(5,1),(3,3),(0,1)
# times: (12-10)/2=1, (12-8)/4=1, (12-5)/1=7, (12-3)/3=3, 12/1=12
# stack: [1] -> 1==1 skip -> 7>1 push [1,7] -> 3<7 skip -> 12>7 push [1,7,12]
# fleets = 3
#
# Edge Cases:
# - Single car: 1 fleet
# - All reach at same time: 1 fleet

def car_fleet_brute(target, position, speed)
  pairs = position.zip(speed).sort_by { |p, _| -p }
  times = pairs.map { |p, s| (target - p).to_f / s }
  fleets = 0
  max_time = 0
  times.each do |t|
    if t > max_time
      fleets += 1
      max_time = t
    end
  end
  fleets
end

# optimized: same approach with explicit stack
def car_fleet(target, position, speed)
  stack = []
  position.zip(speed).sort_by { |p, _| -p }.each do |p, s|
    t = (target - p).to_f / s
    stack << t if stack.empty? || t > stack.last
  end
  stack.size
end

if __FILE__ == $PROGRAM_NAME
  puts car_fleet_brute(12, [10, 8, 0, 5, 3], [2, 4, 1, 1, 3])  # 3
  puts car_fleet(10, [3], [3])                                    # 1
end
