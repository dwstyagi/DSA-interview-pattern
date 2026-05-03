# frozen_string_literal: true

# LeetCode 787: Cheapest Flights Within K Stops
#
# Problem:
# Find cheapest price from src to dst with at most k stops.
# Return -1 if no such route exists.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS/BFS trying all paths with at most k+1 edges. Exponential.
#    Time Complexity: O(n^k)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Bellman-Ford limited to k+1 iterations gives minimum cost with at most k stops.
#
# 3. Optimized Accepted Approach
#    Bellman-Ford: run k+1 iterations. At each iteration, relax all edges using
#    prices from previous iteration (to limit to exactly i edges used).
#
#    Time Complexity: O(k * E)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=4, flights=[[0,1,100],[1,2,100],[2,0,100],[1,3,600],[2,3,200]], src=0, dst=3, k=1
# k+1=2 iterations
# iter 1: dist[1]=100, dist[3]=600 (via 0->1->3 but that's 2 edges... wait k=1 stop = 2 edges)
# iter 2: dist[2]=200, dist[3]=min(600, 100+200)=300
# Actually with k=1 stop: 0->1->3=700 (1 stop) or 0->2 doesn't exist in 1 edge
# dist[3] = 700
#
# Edge Cases:
# - k=0: must be direct flight
# - No path within k stops: -1

def find_cheapest_price_brute(n, flights, src, dst, k)
  adj = Hash.new { |h, key| h[key] = [] }
  flights.each { |u, v, w| adj[u] << [v, w] }
  min_cost = Float::INFINITY
  dfs = lambda do |node, cost, stops|
    return if stops < 0 || cost >= min_cost
    min_cost = cost if node == dst
    adj[node].each { |nb, w| dfs.call(nb, cost + w, stops - 1) }
  end
  dfs.call(src, 0, k)
  min_cost == Float::INFINITY ? -1 : min_cost
end

def find_cheapest_price(n, flights, src, dst, k)
  prices = Array.new(n, Float::INFINITY)
  prices[src] = 0
  (k + 1).times do
    tmp = prices.dup
    flights.each do |u, v, w|
      next if prices[u] == Float::INFINITY
      tmp[v] = [tmp[v], prices[u] + w].min
    end
    prices = tmp
  end
  prices[dst] == Float::INFINITY ? -1 : prices[dst]
end

if __FILE__ == $PROGRAM_NAME
  flights = [[0, 1, 100], [1, 2, 100], [2, 0, 100], [1, 3, 600], [2, 3, 200]]
  puts find_cheapest_price_brute(4, flights, 0, 3, 1)  # 700
  puts find_cheapest_price(4, flights, 0, 3, 1)        # 700
end
