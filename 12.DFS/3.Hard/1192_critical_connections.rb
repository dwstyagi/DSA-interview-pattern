# frozen_string_literal: true

# LeetCode 1192: Critical Connections in a Network
#
# Problem:
# There are n servers numbered 0 to n-1. Given an undirected graph of connections,
# a critical connection is one whose removal disconnects servers. Return all
# critical connections.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Remove each edge, check connectivity. O(E * (V+E)).
#    Time Complexity: O(E * (V+E))
#    Space Complexity: O(V+E)
#
# 2. Bottleneck
#    Per-edge connectivity check — Tarjan's bridge-finding algorithm.
#
# 3. Optimized Accepted Approach
#    Tarjan's algorithm: DFS with discovery time (disc) and low-link value (low).
#    low[u] = min discovery time reachable from subtree rooted at u.
#    Edge u-v is a bridge if low[v] > disc[u] (v can't reach back to u or earlier).
#    Time Complexity: O(V+E)
#    Space Complexity: O(V+E)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=4, connections=[[0,1],[1,2],[2,0],[1,3]]
# DFS from 0: disc[0]=0,low[0]=0 → go to 1: disc[1]=1,low[1]=1 → go to 2:
#   disc[2]=2,low[2]=2 → back to 0 (disc=0) → low[2]=0
#   back at 1: low[1]=min(1,0)=0 → go to 3: disc[3]=3,low[3]=3, no back edges
#   back at 1: low[3]=3 > disc[1]=1 → [1,3] is bridge
# result=[[1,3]] ✓
#
# Edge Cases:
# - Linear chain -> all edges are bridges
# - Complete graph -> no bridges

def critical_connections(n, connections)
  adj  = Array.new(n) { [] }
  connections.each do |u, v|
    adj[u] << v
    adj[v] << u
  end

  disc   = Array.new(n, -1)  # discovery time
  low    = Array.new(n, 0)   # lowest disc reachable
  timer  = [0]
  result = []

  dfs = lambda do |u, parent|
    disc[u] = low[u] = timer[0]
    timer[0] += 1

    adj[u].each do |v|
      next if v == parent    # skip the edge we came from

      if disc[v] == -1       # unvisited
        dfs.call(v, u)
        low[u] = [low[u], low[v]].min
        result << [u, v] if low[v] > disc[u]  # bridge condition
      else
        low[u] = [low[u], disc[v]].min        # back edge: update low
      end
    end
  end

  n.times { |i| dfs.call(i, -1) if disc[i] == -1 }
  result
end

def critical_connections_brute(n, connections)
  require 'set'
  adj = Array.new(n) { [] }
  connections.each { |u, v| adj[u] << v; adj[v] << u }

  connected = lambda do |skip_u, skip_v|
    visited = Array.new(n, false)
    visited[0] = true
    stack = [0]
    count = 1
    until stack.empty?
      u = stack.pop
      adj[u].each do |v|
        next if visited[v]
        next if (u == skip_u && v == skip_v) || (u == skip_v && v == skip_u)
        visited[v] = true
        count += 1
        stack << v
      end
    end
    count == n
  end

  connections.reject { |u, v| connected.call(u, v) }
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{critical_connections_brute(4, [[0,1],[1,2],[2,0],[1,3]]).inspect}" # [[1,3]]
  puts "Opt:   #{critical_connections(4, [[0,1],[1,2],[2,0],[1,3]]).inspect}"        # [[1,3]]
end
