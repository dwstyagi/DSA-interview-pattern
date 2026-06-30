# frozen_string_literal: true

# 323. Number of Connected Components in an Undirected Graph
#
# 1. Problem Statement
#
# Given n nodes and undirected edges, return the number of connected components.
#
# 2. Brute Force Approach
#
# Intuition:
# For every node, find every node reachable from it and save that group. Equal
# reachable groups represent the same component.
#
# Algorithm:
# Run DFS from every node, convert the reached nodes to a sorted array, and
# count unique arrays.
#
# Time Complexity: O(V * (V + E))
# Space Complexity: O(V^2)

# 3. Brute Force Code
def count_components_brute(n, edges)
  graph = component_graph(n, edges)
  groups = {}

  n.times do |start|
    visited = component_reach(graph, start)
    groups[visited.keys.sort] = true
  end

  groups.length
end

# 4. Bottleneck Analysis
#
# Every node within one component reconstructs the same reachable set. A global
# visited array lets one DFS claim the entire component, avoiding all repeats.
#
# 5. Optimization Journey
#
# Scan nodes from 0 to n - 1. An unvisited node cannot belong to a previously
# counted component, so it begins exactly one new DFS. Marking all reached
# nodes ensures they will be skipped later.
#
# 6. Dry Run
#
# n = 5, edges = [[0,1],[1,2],[3,4]]:
# - Start at 0: DFS marks 0, 1, 2. components = 1.
# - Skip 1 and 2.
# - Start at 3: DFS marks 3, 4. components = 2.
#
# 7. Optimal Solution
#
# Count the number of DFS starts among unvisited nodes.
#
# Time Complexity: O(V + E)
# Space Complexity: O(V + E)

# 8. Optimal Code
def count_components(n, edges)
  graph = component_graph(n, edges)
  visited = Array.new(n, false)
  components = 0

  n.times do |start|
    next if visited[start]

    components += 1
    stack = [start]
    visited[start] = true

    until stack.empty?
      node = stack.pop
      graph[node].each do |neighbor|
        next if visited[neighbor]

        visited[neighbor] = true
        stack << neighbor
      end
    end
  end

  components
end

def component_graph(n, edges)
  graph = Array.new(n) { [] }
  edges.each do |from, to|
    graph[from] << to
    graph[to] << from
  end
  graph
end

def component_reach(graph, start)
  visited = { start => true }
  stack = [start]

  until stack.empty?
    node = stack.pop
    graph[node].each do |neighbor|
      next if visited[neighbor]

      visited[neighbor] = true
      stack << neighbor
    end
  end

  visited
end

# Examples
if __FILE__ == $PROGRAM_NAME
  edges = [[0, 1], [1, 2], [3, 4]]
  p count_components_brute(5, edges) # 2
  p count_components(5, edges) # 2
end
