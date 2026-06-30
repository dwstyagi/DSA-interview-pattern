# frozen_string_literal: true

# 684. Redundant Connection
#
# 1. Problem Statement
#
# An undirected graph began as a tree and received one extra edge. Return the
# edge that creates the cycle.
#
# 2. Brute Force Approach
#
# Intuition:
# For each edge, temporarily remove it and check whether the remaining graph is
# still connected. The last removable edge is the redundant one.
#
# Algorithm:
# Rebuild and traverse the graph once for every candidate edge.
#
# Time Complexity: O(E * (V + E))
# Space Complexity: O(V + E)

# 3. Brute Force Code
def find_redundant_connection_brute(edges)
  (edges.length - 1).downto(0) do |skip|
    graph = Array.new(edges.length + 1) { [] }
    edges.each_with_index do |(from, to), index|
      next if index == skip

      graph[from] << to
      graph[to] << from
    end

    visited = { 1 => true }
    stack = [1]
    until stack.empty?
      node = stack.pop
      graph[node].each do |neighbor|
        next if visited[neighbor]

        visited[neighbor] = true
        stack << neighbor
      end
    end
    return edges[skip] if visited.length == edges.length
  end
end

# 4. Bottleneck Analysis
#
# Rebuilding and traversing nearly identical graphs for every edge is repeated
# work. We only need to know whether the endpoints of the current edge are
# already connected by earlier edges.
#
# 5. Optimization Journey
#
# Union-Find stores connected components:
# - Find returns a node's component representative.
# - Union joins two different components.
# - If both endpoints already have the same representative, adding their edge
#   closes a cycle, making that edge redundant.
#
# 6. Dry Run
#
# edges = [[1,2],[1,3],[2,3]]:
# - Union 1 and 2.
# - Union 1 and 3.
# - 2 and 3 now share a representative, so [2,3] is redundant.
#
# 7. Optimal Solution
#
# Process edges once with Union-Find and return the first failed union.
#
# Time Complexity: O(E * alpha(V)), effectively O(E)
# Space Complexity: O(V)

# 8. Optimal Code
def find_redundant_connection(edges)
  parent = Array.new(edges.length + 1) { |node| node }

  find = lambda do |node|
    parent[node] = find.call(parent[node]) if parent[node] != node
    parent[node]
  end

  edges.each do |from, to|
    root_from = find.call(from)
    root_to = find.call(to)
    return [from, to] if root_from == root_to

    parent[root_from] = root_to
  end
end

# Examples
if __FILE__ == $PROGRAM_NAME
  edges = [[1, 2], [1, 3], [2, 3]]
  p find_redundant_connection_brute(edges) # [2, 3]
  p find_redundant_connection(edges) # [2, 3]
end
