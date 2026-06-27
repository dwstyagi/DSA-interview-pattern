# frozen_string_literal: true

# 797. All Paths From Source to Target
#
# 1. Problem Statement
#
# Given a directed acyclic graph, return every path from node 0 to node n - 1.
#
# 2. Brute Force Approach
#
# Intuition:
# Recursively follow every outgoing edge, carrying a new copied path for each
# branch. When target is reached, save that path.
#
# Algorithm:
# DFS from 0. For every neighbor, call DFS with path + [neighbor].
#
# Time Complexity: O(P * L), where P is the number of paths and L their length.
# Space Complexity: O(P * L) for output plus copied partial paths.

# 3. Brute Force Code
def all_paths_source_target_brute(graph)
  result = []

  explore = lambda do |node, path|
    if node == graph.length - 1
      result << path
      next
    end

    graph[node].each { |neighbor| explore.call(neighbor, path + [neighbor]) }
  end

  explore.call(0, [0])
  result
end

# 4. Bottleneck Analysis
#
# Enumerating all output paths is unavoidable, but repeatedly allocating copied
# arrays for prefixes adds overhead. A single mutable path can represent the
# current recursion branch.
#
# 5. Optimization Journey
#
# Append a neighbor before exploring it, then remove it when returning. This
# backtracking keeps only one active path. The graph is a DAG, so recursion
# cannot cycle indefinitely.
#
# 6. Dry Run
#
# graph = [[1,2],[3],[3],[]]:
# - Path starts [0].
# - Explore 1: path [0,1,3], save it, then backtrack.
# - Explore 2: path [0,2,3], save it.
#
# 7. Optimal Solution
#
# Backtrack through the DAG, adding copies only when a complete answer path is
# found.
#
# Time Complexity: O(P * L)
# Space Complexity: O(L) auxiliary, excluding output.

# 8. Optimal Code
def all_paths_source_target(graph)
  result = []
  path = [0]

  explore = lambda do |node|
    if node == graph.length - 1
      result << path.dup
      next
    end

    graph[node].each do |neighbor|
      path << neighbor
      explore.call(neighbor)
      path.pop
    end
  end

  explore.call(0)
  result
end

# Examples
if __FILE__ == $PROGRAM_NAME
  graph = [[1, 2], [3], [3], []]
  p all_paths_source_target_brute(graph) # [[0, 1, 3], [0, 2, 3]]
  p all_paths_source_target(graph) # [[0, 1, 3], [0, 2, 3]]
end
