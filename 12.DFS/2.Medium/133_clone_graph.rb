# frozen_string_literal: true

# LeetCode 133: Clone Graph
#
# Problem:
# Given a reference to a node in a connected undirected graph, return a deep
# copy (clone) of the graph. Each node has a val and a list of neighbors.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS/DFS, store cloned nodes in a hash. This is already optimal.
#    Time Complexity: O(V+E)
#    Space Complexity: O(V)
#
# 2. Bottleneck
#    Must visit each node once. DFS with a visited/clone map is clean.
#
# 3. Optimized Accepted Approach
#    DFS with a hash {original_node => cloned_node}. If already cloned, return
#    clone. Otherwise create clone, then clone all neighbors recursively.
#    Time Complexity: O(V+E)
#    Space Complexity: O(V)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Graph: 1-2, 2-3, 3-4, 4-1 (cycle)
# dfs(1): create clone1, dfs(2)→clone2, dfs(3)→clone3, dfs(4)→clone4 → back to clone1
# All clones point to each other correctly ✓
#
# Edge Cases:
# - Nil node -> nil
# - Single node with no neighbors

# rubocop:disable Style/Documentation
class Node
  attr_accessor :val, :neighbors
  def initialize(val = 0, neighbors = [])
    @val = val
    @neighbors = neighbors
  end
end
# rubocop:enable Style/Documentation

def clone_graph_brute(node)
  return nil unless node
  cloned = {}
  queue  = [node]
  cloned[node] = Node.new(node.val)

  until queue.empty?
    curr = queue.shift
    curr.neighbors.each do |nei|
      unless cloned[nei]
        cloned[nei] = Node.new(nei.val)
        queue << nei
      end
      cloned[curr].neighbors << cloned[nei]
    end
  end

  cloned[node]
end

def clone_graph(node)
  return nil unless node
  cloned = {}

  dfs = lambda do |n|
    return cloned[n] if cloned[n]
    clone = Node.new(n.val)
    cloned[n] = clone                           # store before recursing (handles cycles)
    n.neighbors.each { |nei| clone.neighbors << dfs.call(nei) }
    clone
  end

  dfs.call(node)
end

if __FILE__ == $PROGRAM_NAME
  n1 = Node.new(1); n2 = Node.new(2); n3 = Node.new(3); n4 = Node.new(4)
  n1.neighbors = [n2, n4]; n2.neighbors = [n1, n3]
  n3.neighbors = [n2, n4]; n4.neighbors = [n1, n3]
  cloned = clone_graph(n1)
  puts "Opt: clone val=#{cloned.val}, neighbors=#{cloned.neighbors.map(&:val).inspect}"  # 1, [2,4]
  puts "Different objects: #{cloned.object_id != n1.object_id}"  # true
end
