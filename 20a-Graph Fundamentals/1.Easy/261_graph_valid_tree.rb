# frozen_string_literal: true

# 261. Graph Valid Tree
#
# 1. Problem Statement
#
# Given n nodes and undirected edges, return true if they form one valid tree.
#
# 2. Brute Force Approach
#
# Intuition:
# A graph is a tree only when every node is connected and no route returns to a
# previously seen node.
#
# Algorithm:
# For each node, run a DFS to look for a cycle; then separately count connected
# components.
#
# Time Complexity: O(V * (V + E))
# Space Complexity: O(V + E)

# 3. Brute Force Code
def valid_tree_brute(n, edges)
  graph = adjacency(n, edges)

  n.times do |start|
    seen = {}
    cycle = false
    search = lambda do |node, parent|
      seen[node] = true
      graph[node].each do |neighbor|
        next if neighbor == parent

        if seen[neighbor]
          cycle = true
        else
          search.call(neighbor, node)
        end
      end
    end
    search.call(start, nil)
    return false if cycle
  end

  reachable = traverse(graph, 0)
  reachable.length == n
end

# 4. Bottleneck Analysis
#
# Repeating cycle detection from every start duplicates the same traversal.
# Also, a tree with n nodes must have exactly n - 1 edges, which lets us reject
# cycles or disconnected graphs before any DFS.
#
# 5. Optimization Journey
#
# An undirected graph is a tree if and only if:
# 1. It has n - 1 edges.
# 2. All n nodes are connected.
#
# With n - 1 edges, connectivity guarantees no cycle, and no cycle guarantees
# connectivity only if all nodes are reached. So count edges, then DFS once.
#
# 6. Dry Run
#
# n = 5, edges = [[0,1],[0,2],[0,3],[1,4]]:
# - Edge count is 4 = n - 1.
# - DFS from 0 reaches all five nodes.
# - The graph is a tree.
#
# 7. Optimal Solution
#
# Check the required edge count, then verify one traversal reaches every node.
#
# Time Complexity: O(V + E)
# Space Complexity: O(V + E)

# 8. Optimal Code
def valid_tree(n, edges)
  return false unless edges.length == n - 1

  traverse(adjacency(n, edges), 0).length == n
end

def adjacency(n, edges)
  graph = Array.new(n) { [] }
  edges.each do |from, to|
    graph[from] << to
    graph[to] << from
  end
  graph
end

def traverse(graph, start)
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
  edges = [[0, 1], [0, 2], [0, 3], [1, 4]]
  p valid_tree_brute(5, edges) # true
  p valid_tree(5, edges) # true
end
