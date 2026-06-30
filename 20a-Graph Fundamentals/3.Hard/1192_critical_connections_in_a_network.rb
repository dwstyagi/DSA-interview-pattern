# frozen_string_literal: true

# 1192. Critical Connections in a Network
#
# 1. Problem Statement
#
# Given an undirected connected network, return every edge whose removal would
# disconnect the graph. Such edges are called bridges.
#
# 2. Brute Force Approach
#
# Intuition:
# Remove each edge one at a time and check whether the graph is still connected.
#
# Algorithm:
# For every edge, build a graph without that edge and run DFS from node 0.
#
# Time Complexity: O(E * (V + E))
# Space Complexity: O(V + E)

# 3. Brute Force Code
def critical_connections_brute(n, connections)
  result = []

  connections.each_with_index do |edge, skip|
    graph = Array.new(n) { [] }
    connections.each_with_index do |(from, to), index|
      next if index == skip

      graph[from] << to
      graph[to] << from
    end

    visited = bridge_reach(graph, 0)
    result << edge if visited.length < n
  end

  result
end

# 4. Bottleneck Analysis
#
# Removing every edge repeats almost the same connectivity test. A single DFS
# can learn whether each subtree has a back edge to an ancestor.
#
# 5. Optimization Journey
#
# During DFS, give each node a discovery time. Also compute low[node], the
# earliest discovery time reachable from node through its subtree and at most
# one back edge. For tree edge node -> neighbor:
#
#   if low[neighbor] > discovery[node], no back edge reaches node or above.
#
# That means removing node-neighbor disconnects the neighbor subtree.
#
# 6. Dry Run
#
# connections = [[0,1],[1,2],[2,0],[1,3]]:
# - Nodes 0,1,2 form a cycle, so their low values connect back.
# - Node 3 has no back edge.
# - low[3] > discovery[1], so [1,3] is critical.
#
# 7. Optimal Solution
#
# Run Tarjan bridge-finding DFS once and collect edges satisfying the low-link
# bridge condition.
#
# Time Complexity: O(V + E)
# Space Complexity: O(V + E)

# 8. Optimal Code
def critical_connections(n, connections)
  graph = Array.new(n) { [] }
  connections.each do |from, to|
    graph[from] << to
    graph[to] << from
  end

  discovery = Array.new(n)
  low = Array.new(n)
  time = 0
  bridges = []

  dfs = lambda do |node, parent|
    discovery[node] = time
    low[node] = time
    time += 1

    graph[node].each do |neighbor|
      next if neighbor == parent

      if discovery[neighbor].nil?
        dfs.call(neighbor, node)
        low[node] = [low[node], low[neighbor]].min
        bridges << [node, neighbor] if low[neighbor] > discovery[node]
      else
        low[node] = [low[node], discovery[neighbor]].min
      end
    end
  end

  dfs.call(0, -1)
  bridges
end

def bridge_reach(graph, start)
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
  connections = [[0, 1], [1, 2], [2, 0], [1, 3]]
  p critical_connections_brute(4, connections) # [[1, 3]]
  p critical_connections(4, connections) # [[1, 3]]
end
