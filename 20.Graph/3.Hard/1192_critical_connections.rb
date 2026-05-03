# frozen_string_literal: true

# LeetCode 1192: Critical Connections in a Network
#
# Problem:
# There are n servers connected by undirected edges. A critical connection is
# an edge that, if removed, will make some servers unable to reach others.
# Return all critical connections (bridges) in any order.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each edge, remove it and check if the graph remains connected (DFS/BFS).
#    If not, it's a critical connection.
#
#    Time Complexity: O(E * (V + E))
#    Space Complexity: O(V + E)
#
# 2. Bottleneck
#    Checking each edge separately is redundant. Tarjan's bridge-finding algorithm
#    finds all bridges in a single DFS pass.
#
# 3. Optimized Accepted Approach
#    Tarjan's bridge algorithm:
#    - Assign each node a discovery time (disc) and low value
#    - low[v] = min disc reachable from v's subtree (excluding parent edge)
#    - Edge (u, v) is a bridge if low[v] > disc[u]
#      (v cannot reach u or earlier without going through this edge)
#
#    Time Complexity: O(V + E)
#    Space Complexity: O(V + E)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=4, connections=[[0,1],[1,2],[2,0],[1,3]]
# Graph: 0-1-2 form a cycle; 1-3 is a pendant edge
#
# DFS from 0:
#   disc[0]=low[0]=0, visit 1
#   disc[1]=low[1]=1, visit 2
#   disc[2]=low[2]=2, visit 0 (parent's parent) -> low[2]=min(2,disc[0])=0
#   back to 1: low[1]=min(1,low[2])=0
#   visit 3: disc[3]=low[3]=3, no unvisited neighbors
#   back to 1: low[3]=3 > disc[1]=1 -> [1,3] is a bridge ✓
#
# Edge Cases:
# - All nodes in one big cycle -> no bridges
# - Tree (no cycles) -> every edge is a bridge
# - n=2 -> single edge is always a bridge

def critical_connections_brute(n, connections)
  adj = Array.new(n) { [] }
  connections.each do |u, v|
    adj[u] << v
    adj[v] << u
  end

  bridges = []

  connections.each do |u, v|
    # temporarily remove edge u-v
    adj[u].delete(v)
    adj[v].delete(u)

    # check connectivity with BFS
    visited = Array.new(n, false)
    queue = [0]
    visited[0] = true
    count = 1
    until queue.empty?
      node = queue.shift
      adj[node].each do |nb|
        next if visited[nb]

        visited[nb] = true
        count += 1
        queue << nb
      end
    end

    bridges << [u, v] if count < n

    # restore edge
    adj[u] << v
    adj[v] << u
  end

  bridges
end

def critical_connections(n, connections)
  adj = Array.new(n) { [] }
  connections.each do |u, v|
    adj[u] << v
    adj[v] << u
  end

  disc = Array.new(n, -1)
  low = Array.new(n, 0)
  bridges = []
  timer = [0]

  dfs = lambda do |node, parent|
    disc[node] = low[node] = timer[0]
    timer[0] += 1

    adj[node].each do |neighbor|
      next if neighbor == parent

      if disc[neighbor] == -1
        dfs.call(neighbor, node)
        low[node] = [low[node], low[neighbor]].min
        bridges << [node, neighbor] if low[neighbor] > disc[node]
      else
        low[node] = [low[node], disc[neighbor]].min
      end
    end
  end

  n.times { |i| dfs.call(i, -1) if disc[i] == -1 }

  bridges
end

if __FILE__ == $PROGRAM_NAME
  n = 4
  connections = [[0, 1], [1, 2], [2, 0], [1, 3]]

  puts "Brute:     #{critical_connections_brute(n, connections)}"
  puts "Optimized: #{critical_connections(n, connections)}"
end
