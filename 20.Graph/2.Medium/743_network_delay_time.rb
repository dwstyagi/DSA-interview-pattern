# frozen_string_literal: true

# LeetCode 743: Network Delay Time
#
# Problem:
# Directed weighted graph. Signal sent from node k. Return time for all n nodes
# to receive signal. Return -1 if not all nodes reachable.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS/DFS without priority, try all paths. Inefficient.
#    Time Complexity: O(V^2 + E)
#    Space Complexity: O(V)
#
# 2. Bottleneck
#    Dijkstra's algorithm with a priority queue gives optimal shortest paths.
#
# 3. Optimized Accepted Approach
#    Dijkstra from k. Answer = max of all dist values. Return -1 if any unreachable.
#
#    Time Complexity: O((V + E) log V)
#    Space Complexity: O(V + E)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# times=[[2,1,1],[2,3,1],[3,4,1]], n=4, k=2
# dist: {1:inf, 2:0, 3:inf, 4:inf}
# Process 2: update 1->1, 3->1
# Process 1(d=1): no outgoing
# Process 3(d=1): update 4->2
# Process 4(d=2): no outgoing
# max dist = 2
#
# Edge Cases:
# - k is isolated: -1 (unless n=1)
# - Already all connected with 0 cost: return 0

def network_delay_time_brute(times, n, k)
  dist = Array.new(n + 1, Float::INFINITY)
  dist[k] = 0
  adj = Hash.new { |h, key| h[key] = [] }
  times.each { |u, v, w| adj[u] << [v, w] }
  (n - 1).times do
    changed = false
    (1..n).each do |u|
      next if dist[u] == Float::INFINITY
      adj[u].each do |v, w|
        if dist[u] + w < dist[v]
          dist[v] = dist[u] + w
          changed = true
        end
      end
    end
    break unless changed
  end
  max_d = dist[1..].max
  max_d == Float::INFINITY ? -1 : max_d
end

def network_delay_time(times, n, k)
  adj = Hash.new { |h, key| h[key] = [] }
  times.each { |u, v, w| adj[u] << [v, w] }
  dist = Hash.new(Float::INFINITY)
  dist[k] = 0
  # min-heap: [distance, node]
  heap = [[0, k]]
  until heap.empty?
    d, u = heap.min
    heap.delete([d, u])
    next if d > dist[u]
    adj[u].each do |v, w|
      nd = d + w
      if nd < dist[v]
        dist[v] = nd
        heap << [nd, v]
      end
    end
  end
  max_d = (1..n).map { |v| dist[v] }.max
  max_d == Float::INFINITY ? -1 : max_d
end

if __FILE__ == $PROGRAM_NAME
  puts network_delay_time_brute([[2, 1, 1], [2, 3, 1], [3, 4, 1]], 4, 2)  # 2
  puts network_delay_time([[1, 2, 1]], 2, 1)                               # 1
end
