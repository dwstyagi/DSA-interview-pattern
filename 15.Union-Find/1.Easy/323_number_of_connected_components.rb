# frozen_string_literal: true

# LeetCode 323: Number of Connected Components in an Undirected Graph
#
# Problem:
# Given n nodes (0 to n-1) and edges list, return the number of connected components.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS/DFS from each unvisited node, count traversals.
#    Time Complexity: O(V + E)
#    Space Complexity: O(V + E)
#
# 2. Bottleneck
#    DFS works well but Union-Find is more natural for connectivity.
#    Union-Find with path compression and union by rank is near O(1) per op.
#
# 3. Optimized Accepted Approach
#    Union-Find: initialize n components. For each edge, union the two nodes.
#    Count unique roots.
#
#    Time Complexity: O((V+E) * alpha(V)) ≈ O(V+E)
#    Space Complexity: O(V)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=5, edges=[[0,1],[1,2],[3,4]]
# union(0,1): root(0)=root(1), components=4
# union(1,2): root(1)=root(2), components=3
# union(3,4): root(3)=root(4), components=2
# Result: 2
#
# Edge Cases:
# - No edges: n components
# - All nodes connected: 1 component

def count_components_brute(n, edges)
  adj = Array.new(n) { [] }
  edges.each { |u, v| adj[u] << v; adj[v] << u }
  visited = Array.new(n, false)
  count = 0
  (0...n).each do |i|
    next if visited[i]
    count += 1
    stack = [i]
    while stack.any?
      node = stack.pop
      next if visited[node]
      visited[node] = true
      adj[node].each { |nb| stack << nb unless visited[nb] }
    end
  end
  count
end

class UnionFind
  def initialize(n)
    @parent = Array.new(n) { |i| i }
    @rank = Array.new(n, 0)
    @count = n
  end

  def find(x)
    @parent[x] = find(@parent[x]) unless @parent[x] == x
    @parent[x]
  end

  def union(x, y)
    px, py = find(x), find(y)
    return if px == py
    if @rank[px] < @rank[py]
      @parent[px] = py
    elsif @rank[px] > @rank[py]
      @parent[py] = px
    else
      @parent[py] = px
      @rank[px] += 1
    end
    @count -= 1
  end

  def count
    @count
  end
end

def count_components(n, edges)
  uf = UnionFind.new(n)
  edges.each { |u, v| uf.union(u, v) }
  uf.count
end

if __FILE__ == $PROGRAM_NAME
  puts count_components_brute(5, [[0, 1], [1, 2], [3, 4]])  # 2
  puts count_components(5, [[0, 1], [1, 2], [2, 3], [3, 4]])  # 1
end
