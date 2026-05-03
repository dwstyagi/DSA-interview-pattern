# frozen_string_literal: true

# LeetCode 261: Graph Valid Tree
#
# Problem:
# Given n nodes and edges, return true if the edges form a valid tree.
# A valid tree has exactly n-1 edges and is fully connected (no cycles).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS from node 0, check for cycles and that all nodes are visited.
#    Time Complexity: O(V + E)
#    Space Complexity: O(V)
#
# 2. Bottleneck
#    Already efficient. Union-Find provides a clean cycle detection mechanism.
#
# 3. Optimized Accepted Approach
#    Quick check: edges.length must equal n-1. Then Union-Find: if any edge
#    connects two nodes already in the same component, there's a cycle.
#
#    Time Complexity: O(E * alpha(V))
#    Space Complexity: O(V)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=5, edges=[[0,1],[0,2],[0,3],[1,4]]
# edges.length=4 == n-1=4 -> ok
# union(0,1), union(0,2), union(0,3), union(1,4) -> no conflicts -> true
#
# n=5, edges=[[0,1],[1,2],[2,3],[1,3],[1,4]]
# edges.length=5 != n-1=4 -> false
#
# Edge Cases:
# - n=1, no edges: true
# - Disconnected with n-1 edges (impossible, but guard with union-find count)

def valid_tree_brute?(n, edges)
  return false if edges.length != n - 1
  adj = Array.new(n) { [] }
  edges.each { |u, v| adj[u] << v; adj[v] << u }
  visited = Array.new(n, false)
  stack = [0]
  count = 0
  while stack.any?
    node = stack.pop
    next if visited[node]
    visited[node] = true
    count += 1
    adj[node].each { |nb| stack << nb }
  end
  count == n
end

def valid_tree?(n, edges)
  return false if edges.length != n - 1
  parent = Array.new(n) { |i| i }
  find = lambda do |x|
    parent[x] = find.call(parent[x]) unless parent[x] == x
    parent[x]
  end
  edges.each do |u, v|
    pu, pv = find.call(u), find.call(v)
    return false if pu == pv
    parent[pu] = pv
  end
  true
end

if __FILE__ == $PROGRAM_NAME
  puts valid_tree_brute?(5, [[0, 1], [0, 2], [0, 3], [1, 4]])         # true
  puts valid_tree?(5, [[0, 1], [1, 2], [2, 3], [1, 3], [1, 4]])       # false
end
