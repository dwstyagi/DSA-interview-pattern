# frozen_string_literal: true

# LeetCode 863: All Nodes Distance K in Binary Tree
#
# Problem:
# Given the root of a binary tree, a target node, and an integer k, return an
# array of all node values exactly k distance from target.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Find all root-to-leaf paths, compute distances using path intersections.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Tree doesn't have parent pointers — build a parent map first, then BFS.
#
# 3. Optimized Accepted Approach
#    DFS to build parent map (child → parent). Then BFS from target node,
#    going to children and parent, tracking visited.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 3->[5,1] 5->[6,2] 2->[7,4] 1->[0,8], target=5, k=2
# parent: 5→3, 6→5, 2→5, 7→2, 4→2, 1→3, 0→1, 8→1
# BFS from 5: k=0:{5}; k=1:{6,2,3}; k=2:{7,4,1} → [7,4,1] ✓
#
# Edge Cases:
# - k=0 -> [target.val]
# - k > height of tree -> []

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def distance_k_brute(root, target, k)
  # Build adjacency list (undirected graph from tree)
  adj = Hash.new { |h, v| h[v] = [] }
  build = lambda do |node|
    return unless node
    adj[node.val] << node.left.val  if node.left
    adj[node.val] << node.right.val if node.right
    adj[node.left.val]  << node.val if node.left
    adj[node.right.val] << node.val if node.right
    build.call(node.left)
    build.call(node.right)
  end
  build.call(root)

  result  = []
  visited = {target.val => true}
  queue   = [target.val]
  dist    = 0

  until queue.empty?
    return queue if dist == k
    next_q = []
    queue.each do |v|
      adj[v].each do |nei|
        next if visited[nei]
        visited[nei] = true
        next_q << nei
      end
    end
    queue = next_q
    dist += 1
  end
  []
end

def distance_k(root, target, k)
  parent = {}

  # DFS to record parent of each node
  build_parents = lambda do |node, par|
    return unless node
    parent[node] = par
    build_parents.call(node.left,  node)
    build_parents.call(node.right, node)
  end
  build_parents.call(root, nil)

  # BFS from target node, traversing children and parent edges
  result  = []
  visited = {target => true}
  queue   = [target]

  k.times do
    break if queue.empty?
    next_q = []
    queue.each do |node|
      [node.left, node.right, parent[node]].each do |nei|
        next if nei.nil? || visited[nei]
        visited[nei] = true
        next_q << nei
      end
    end
    queue = next_q
  end

  queue.map(&:val)
end

if __FILE__ == $PROGRAM_NAME
  n7 = TreeNode.new(7); n4 = TreeNode.new(4)
  n6 = TreeNode.new(6); n2 = TreeNode.new(2, n7, n4)
  n5 = TreeNode.new(5, n6, n2)
  n0 = TreeNode.new(0); n8 = TreeNode.new(8)
  n1 = TreeNode.new(1, n0, n8)
  root = TreeNode.new(3, n5, n1)

  puts "Opt: #{distance_k(root, n5, 2).sort.inspect}"  # [1, 4, 7]
end
