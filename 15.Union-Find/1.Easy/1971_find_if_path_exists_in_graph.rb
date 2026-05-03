# frozen_string_literal: true

# LeetCode 1971: Find if Path Exists in Graph
#
# Problem:
# Given n nodes, edges, source, and destination, return true if a valid path
# exists from source to destination.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS/DFS from source, check if destination is reachable.
#    Time Complexity: O(V + E)
#    Space Complexity: O(V + E)
#
# 2. Bottleneck
#    BFS/DFS is already optimal. Union-Find is an equally valid alternative
#    that checks connectivity directly.
#
# 3. Optimized Accepted Approach
#    Union-Find: union all edges, then check if find(source) == find(destination).
#
#    Time Complexity: O((V+E) * alpha(V))
#    Space Complexity: O(V)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=6, edges=[[0,1],[0,2],[3,5],[5,4],[4,3]], src=0, dst=5
# After unions: {0,1,2} and {3,4,5} are components
# find(0) != find(5) -> false
#
# Edge Cases:
# - source == destination: always true
# - No edges: source == destination returns true, else false

def valid_path_brute?(n, edges, source, destination)
  return true if source == destination
  adj = Array.new(n) { [] }
  edges.each { |u, v| adj[u] << v; adj[v] << u }
  visited = Array.new(n, false)
  stack = [source]
  while stack.any?
    node = stack.pop
    return true if node == destination
    next if visited[node]
    visited[node] = true
    adj[node].each { |nb| stack << nb }
  end
  false
end

def valid_path?(n, edges, source, destination)
  parent = Array.new(n) { |i| i }
  find = lambda do |x|
    parent[x] = find.call(parent[x]) unless parent[x] == x
    parent[x]
  end
  edges.each do |u, v|
    pu, pv = find.call(u), find.call(v)
    parent[pu] = pv unless pu == pv
  end
  find.call(source) == find.call(destination)
end

if __FILE__ == $PROGRAM_NAME
  puts valid_path_brute?(3, [[0, 1], [1, 2], [2, 0]], 0, 2)  # true
  puts valid_path?(6, [[0, 1], [0, 2], [3, 5], [5, 4], [4, 3]], 0, 5)  # false
end
