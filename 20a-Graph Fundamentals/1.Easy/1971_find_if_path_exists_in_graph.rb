# frozen_string_literal: true

# 1971. Find if Path Exists in Graph
#
# 1. Problem Statement
#
# Given an undirected graph with n nodes, return whether any path connects
# source to destination.
#
# 2. Brute Force Approach
#
# Intuition:
# Try every possible route from source until destination is found.
#
# Algorithm:
# Build an adjacency list and recursively explore each neighbor. A path-local
# visited set prevents a cycle from repeating forever.
#
# Time Complexity: O(V + E)
# Space Complexity: O(V + E)

# 3. Brute Force Code
def valid_path_brute(n, edges, source, destination)
  graph = build_undirected_graph(n, edges)

  search = lambda do |node, path|
    return true if node == destination

    graph[node].any? do |neighbor|
      !path.include?(neighbor) && search.call(neighbor, path + [neighbor])
    end
  end

  search.call(source, [source])
end

# 4. Bottleneck Analysis
#
# Copying and searching a path array at each recursive branch wastes work.
# Once a node has been fully reached in an undirected graph, every route from
# that node is independent of how we arrived there.
#
# 5. Optimization Journey
#
# Replace per-path tracking with one global visited set. Each node needs to be
# processed once: the first time it is discovered, it is reachable from source.
# BFS is a convenient iterative traversal for this reachability question.
#
# 6. Dry Run
#
# n = 3, edges = [[0, 1], [1, 2]], source = 0, destination = 2:
# - Queue starts [0], visited = {0}.
# - Visit 0, add 1.
# - Visit 1, add 2.
# - Visit 2, so a path exists.
#
# 7. Optimal Solution
#
# Use BFS over the adjacency list. Return as soon as destination is removed
# from the queue.
#
# Time Complexity: O(V + E)
# Space Complexity: O(V + E)

# 8. Optimal Code
def valid_path(n, edges, source, destination)
  graph = build_undirected_graph(n, edges)
  visited = { source => true }
  queue = [source]
  head = 0

  while head < queue.length
    node = queue[head]
    head += 1
    return true if node == destination

    graph[node].each do |neighbor|
      next if visited[neighbor]

      visited[neighbor] = true
      queue << neighbor
    end
  end

  false
end

def build_undirected_graph(n, edges)
  graph = Array.new(n) { [] }
  edges.each do |from, to|
    graph[from] << to
    graph[to] << from
  end
  graph
end

# Examples
if __FILE__ == $PROGRAM_NAME
  edges = [[0, 1], [1, 2], [2, 0]]
  p valid_path_brute(3, edges, 0, 2) # true
  p valid_path(3, edges, 0, 2) # true
end
