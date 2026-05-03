# frozen_string_literal: true

# LeetCode 871: Minimum Number of Refueling Stops
#
# Problem:
# A car starts at position 0 with startFuel. stations[i] = [position, fuel].
# Return the minimum number of refueling stops to reach target, or -1 if impossible.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS/DFS trying all subsets of stations to refuel at.
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Greedy with max-heap: as we pass each station, add its fuel to the heap.
#    When we run out of fuel, retroactively refuel at the best passed station.
#
# 3. Optimized Accepted Approach
#    Use a max-heap of available fuel (stations passed). When fuel runs out,
#    greedily take the largest available fuel stop.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# target=100, startFuel=10, stations=[[10,60],[20,30],[30,30],[60,40]]
# tank=10, stops=0, heap=[]
# pos=10: tank=10, pass station[10,60] -> heap=[60]; tank reaches 10
# run out before 20? no, tank=10 at pos 10; tank-=0 (distance 0), need more
# Actually simulate travel: tank decremented by travel. Greedy: refuel when needed.
#
# Edge Cases:
# - startFuel >= target: return 0
# - No stations and startFuel < target: return -1

def min_refuel_stops_brute(target, start_fuel, stations)
  n = stations.length
  (0..n).each do |stops|
    stations.combination(stops).each do |combo|
      fuel = start_fuel
      prev = 0
      valid = true
      (combo + [[target, 0]]).sort_by(&:first).each do |pos, f|
        fuel -= (pos - prev)
        if fuel < 0
          valid = false
          break
        end
        fuel += f
        prev = pos
      end
      return stops if valid
    end
  end
  -1
end

# optimized: greedy with max-heap (using sorted array as priority queue)
def min_refuel_stops(target, start_fuel, stations)
  heap = []
  fuel = start_fuel
  stops = 0
  prev = 0
  idx = 0

  loop do
    # collect all reachable stations
    while idx < stations.length && stations[idx][0] <= prev + fuel
      heap << stations[idx][1]
      idx += 1
    end
    fuel_needed = target - prev - fuel
    break if fuel_needed <= 0  # can reach target

    return -1 if heap.empty?
    best = heap.max
    heap.delete_at(heap.index(best))
    fuel += best
    stops += 1
  end

  stops
end

if __FILE__ == $PROGRAM_NAME
  puts min_refuel_stops_brute(100, 10, [[10, 60], [20, 30], [30, 30], [60, 40]])  # 2
  puts min_refuel_stops(100, 1, [[10, 100]])                                       # -1
end
