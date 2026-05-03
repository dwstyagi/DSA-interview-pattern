# frozen_string_literal: true

# LeetCode 310: Minimum Height Trees
#
# Problem:
# Given n nodes and edges, find all roots that produce minimum height trees.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS from each node as root to find height. Return roots with min height.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    The optimal roots are centroids of the tree. Iteratively remove leaf nodes
#    (like topological sort) until 1 or 2 nodes remain.
#
# 3. Optimized Accepted Approach
#    Find leaves (degree 1). Remove them, update degrees of neighbors.
#    Repeat until <= 2 nodes remain. Those are the answer.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=6, edges=[[3,0],[3,1],[3,2],[3,4],[5,4]]
# degrees: 0=1,1=1,2=1,3=4,4=2,5=1
# leaves=[0,1,2,5]; remove: update 3(deg=1), 4(deg=1)
# 2 nodes left: [3,4] -> return [3,4]
#
# Edge Cases:
# - n=1: return [0]
# - n=2: return [0,1]

def find_min_height_trees_brute(n, edges)
  return [0] if n == 1
  adj = Array.new(n) { [] }
  edges.each { |u, v| adj[u] << v; adj[v] << u }

  height = lambda do |root|
    visited = Array.new(n, false)
    visited[root] = true
    queue = [root]
    h = -1
    until queue.empty?
      h += 1
      next_q = []
      queue.each { |v| adj[v].each { |nb| next_q << nb unless visited[nb]; visited[nb] = true } }
      queue = next_q
    end
    h
  end

  min_h = n
  result = []
  n.times do |i|
    h = height.call(i)
    if h < min_h
      min_h = h; result = [i]
    elsif h == min_h
      result << i
    end
  end
  result
end

def find_min_height_trees(n, edges)
  return [0] if n == 1
  adj = Array.new(n) { [] }
  degree = Array.new(n, 0)
  edges.each { |u, v| adj[u] << v; adj[v] << u; degree[u] += 1; degree[v] += 1 }
  leaves = (0...n).select { |i| degree[i] == 1 }
  remaining = n
  while remaining > 2
    remaining -= leaves.length
    new_leaves = []
    leaves.each do |leaf|
      adj[leaf].each do |nb|
        degree[nb] -= 1
        new_leaves << nb if degree[nb] == 1
      end
    end
    leaves = new_leaves
  end
  leaves
end

if __FILE__ == $PROGRAM_NAME
  puts find_min_height_trees_brute(4, [[1, 0], [1, 2], [1, 3]]).inspect  # [1]
  puts find_min_height_trees(6, [[3, 0], [3, 1], [3, 2], [3, 4], [5, 4]]).inspect  # [3,4]
end
