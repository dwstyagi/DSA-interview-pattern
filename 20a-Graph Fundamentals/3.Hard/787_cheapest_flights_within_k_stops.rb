# frozen_string_literal: true

# 787. Cheapest Flights Within K Stops
#
# 1. Problem Statement
#
# Given flights [from, to, price], return the cheapest price from src to dst
# using at most k stops. Return -1 if no such route exists.
#
# 2. Brute Force Approach
#
# Intuition:
# Try every route from src while keeping the number of used flights within
# k + 1. Track the cheapest route that reaches dst.
#
# Algorithm:
# Backtrack through outgoing flights and stop when the path is too long.
#
# Time Complexity: O(V^(K + 1)) in the worst case.
# Space Complexity: O(K)

# 3. Brute Force Code
def find_cheapest_price_brute(n, flights, src, dst, k)
  graph = flight_graph(n, flights)
  best = Float::INFINITY

  search = lambda do |city, flights_used, cost|
    return if flights_used > k + 1 || cost >= best
    return best = cost if city == dst

    graph[city].each do |neighbor, price|
      search.call(neighbor, flights_used + 1, cost + price)
    end
  end

  search.call(src, 0, 0)
  best.infinite? ? -1 : best
end

# 4. Bottleneck Analysis
#
# Backtracking explores many paths that end at the same city with the same
# number of flights. Only the cheapest cost for that state matters.
#
# 5. Optimization Journey
#
# A route with at most k stops uses at most k + 1 flights. Bellman-Ford can be
# limited to exactly that many rounds. Each round uses a copy of the previous
# distances so one round represents adding only one more flight.
#
# 6. Dry Run
#
# flights = [[0,1,100],[1,2,100],[0,2,500]], k = 1:
# - Round 1: distance to 1 is 100, to 2 is 500.
# - Round 2: from 1, distance to 2 becomes 200.
# - Answer is 200.
#
# 7. Optimal Solution
#
# Relax every flight k + 1 times using a snapshot from the previous round.
#
# Time Complexity: O(K * E)
# Space Complexity: O(V)

# 8. Optimal Code
def find_cheapest_price(n, flights, src, dst, k)
  distance = Array.new(n, Float::INFINITY)
  distance[src] = 0

  (k + 1).times do
    next_distance = distance.dup
    flights.each do |from, to, price|
      next if distance[from].infinite?

      next_distance[to] = [next_distance[to], distance[from] + price].min
    end
    distance = next_distance
  end

  distance[dst].infinite? ? -1 : distance[dst]
end

def flight_graph(n, flights)
  graph = Array.new(n) { [] }
  flights.each { |from, to, price| graph[from] << [to, price] }
  graph
end

# Examples
if __FILE__ == $PROGRAM_NAME
  flights = [[0, 1, 100], [1, 2, 100], [0, 2, 500]]
  p find_cheapest_price_brute(3, flights, 0, 2, 1) # 200
  p find_cheapest_price(3, flights, 0, 2, 1) # 200
end
