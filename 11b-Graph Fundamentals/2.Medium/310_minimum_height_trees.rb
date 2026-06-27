# frozen_string_literal: true

# 310. Minimum Height Trees
#
# 1. Problem Statement
#
# Given an undirected tree with n nodes, return every root that produces the
# minimum possible tree height.
#
# 2. Brute Force Approach
#
# Intuition:
# Try every node as the root, calculate the farthest distance from it, and keep
# the roots with the smallest height.
#
# Algorithm:
# Run BFS from each node and record the maximum BFS level reached.
#
# Time Complexity: O(n^2)
# Space Complexity: O(n)

# 3. Brute Force Code
def find_min_height_trees_brute(n, edges)
  graph = tree_graph(n, edges)
  heights = (0...n).map { |root| [root, bfs_height(graph, root)] }
  best_height = heights.map(&:last).min
  heights.filter_map { |root, height| root if height == best_height }
end

# 4. Bottleneck Analysis
#
# Neighboring roots have heavily overlapping BFS traversals. A tree's best
# roots are its center nodes, and we can expose them without measuring height
# from every possible root.
#
# 5. Optimization Journey
#
# Leaves can never be centers: moving one edge inward always reduces the
# maximum distance to all other nodes. Remove every current leaf simultaneously.
# This peels the tree like layers. The final one or two nodes left are centers,
# which are exactly the minimum-height roots.
#
# 6. Dry Run
#
# n = 4, edges = [[1,0],[1,2],[1,3]]:
# - Initial leaves: 0, 2, 3.
# - Remove all three leaves; node 1 remains.
# - 1 is the only center and the only answer.
#
# 7. Optimal Solution
#
# Repeatedly remove all nodes with degree 1 until at most two nodes remain.
#
# Time Complexity: O(n)
# Space Complexity: O(n)

# 8. Optimal Code
def find_min_height_trees(n, edges)
  return [0] if n == 1

  graph = tree_graph(n, edges)
  degree = graph.map(&:length)
  leaves = (0...n).select { |node| degree[node] == 1 }
  remaining = n

  while remaining > 2
    remaining -= leaves.length
    next_leaves = []

    leaves.each do |leaf|
      graph[leaf].each do |neighbor|
        degree[neighbor] -= 1
        next_leaves << neighbor if degree[neighbor] == 1
      end
    end

    leaves = next_leaves
  end

  leaves
end

def tree_graph(n, edges)
  graph = Array.new(n) { [] }
  edges.each do |from, to|
    graph[from] << to
    graph[to] << from
  end
  graph
end

def bfs_height(graph, root)
  visited = { root => true }
  queue = [[root, 0]]
  head = 0
  height = 0

  while head < queue.length
    node, distance = queue[head]
    head += 1
    height = [height, distance].max
    graph[node].each do |neighbor|
      next if visited[neighbor]

      visited[neighbor] = true
      queue << [neighbor, distance + 1]
    end
  end

  height
end

# Examples
if __FILE__ == $PROGRAM_NAME
  edges = [[1, 0], [1, 2], [1, 3]]
  p find_min_height_trees_brute(4, edges) # [1]
  p find_min_height_trees(4, edges) # [1]
end
