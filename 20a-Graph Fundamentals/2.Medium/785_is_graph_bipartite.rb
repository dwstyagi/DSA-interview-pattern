# frozen_string_literal: true

# 785. Is Graph Bipartite?
#
# 1. Problem Statement
#
# Return true if an undirected graph can be split into two groups such that no
# edge connects two nodes in the same group.
#
# 2. Brute Force Approach
#
# Intuition:
# Try every assignment of nodes to one of two groups, then validate all edges.
#
# Algorithm:
# Enumerate all 2^n bitmasks and reject an assignment if adjacent nodes have
# the same bit.
#
# Time Complexity: O(2^V * (V + E))
# Space Complexity: O(V)

# 3. Brute Force Code
def is_bipartite_brute(graph)
  (0...(1 << graph.length)).any? do |mask|
    graph.each_with_index.all? do |neighbors, node|
      neighbors.all? { |neighbor| ((mask >> node) & 1) != ((mask >> neighbor) & 1) }
    end
  end
end

# 4. Bottleneck Analysis
#
# The brute force tries assignments that differ only in far-away nodes. An edge
# constrains only two endpoints, so propagate group choices through the graph
# instead of guessing every combination.
#
# 5. Optimization Journey
#
# Color an uncolored node 0. Every neighbor must be color 1, every neighbor of
# those nodes must be color 0, and so on. If an edge ever joins equal colors,
# no valid two-group split exists. Restart from uncolored nodes for disconnected
# graphs.
#
# 6. Dry Run
#
# graph = [[1,3],[0,2],[1,3],[0,2]]:
# - Color 0 as 0, then color 1 and 3 as 1.
# - From 1, color 2 as 0.
# - Every edge connects opposite colors, so it is bipartite.
#
# 7. Optimal Solution
#
# BFS each component while assigning alternating colors.
#
# Time Complexity: O(V + E)
# Space Complexity: O(V)

# 8. Optimal Code
def is_bipartite(graph)
  colors = Array.new(graph.length)

  graph.each_index do |start|
    next unless colors[start].nil?

    colors[start] = 0
    queue = [start]
    head = 0

    while head < queue.length
      node = queue[head]
      head += 1
      graph[node].each do |neighbor|
        if colors[neighbor].nil?
          colors[neighbor] = 1 - colors[node]
          queue << neighbor
        elsif colors[neighbor] == colors[node]
          return false
        end
      end
    end
  end

  true
end

# Examples
if __FILE__ == $PROGRAM_NAME
  graph = [[1, 3], [0, 2], [1, 3], [0, 2]]
  p is_bipartite_brute(graph) # true
  p is_bipartite(graph) # true
end
