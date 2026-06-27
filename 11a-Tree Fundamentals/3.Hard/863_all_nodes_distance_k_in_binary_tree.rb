# frozen_string_literal: true

# 863. All Nodes Distance K in Binary Tree
#
# 1. Problem Statement
#
# Given a binary tree root, a target node, and an integer k, return the values
# of all nodes exactly k edges away from target.

class TreeNode
  attr_accessor :val, :left, :right

  def initialize(val = 0, left = nil, right = nil)
    @val = val
    @left = left
    @right = right
  end
end

# 2. Brute Force Approach
#
# Intuition:
# Find the root-to-target path and then, for every node in the tree, find its
# root path too. Their last shared node is their lowest common ancestor, which
# gives the distance between the two nodes.
#
# Algorithm:
# 1. Find and save the path from root to target.
# 2. For every node, find its path from root.
# 3. Find the common prefix length of both paths.
# 4. Use both remaining suffix lengths to calculate distance.
#
# Time Complexity: O(n * h), where h is tree height; each candidate can require
# a root-to-node path search.
# Space Complexity: O(h) for paths, excluding the result.

# 3. Brute Force Code
def distance_k_brute(root, target, k)
  target_path = find_path(root, target)
  result = []

  visit = lambda do |node|
    next if node.nil?

    node_path = find_path(root, node)
    shared = 0
    while shared < target_path.length &&
          shared < node_path.length &&
          target_path[shared] == node_path[shared]
      shared += 1
    end

    distance = (target_path.length - shared) + (node_path.length - shared)
    result << node.val if distance == k

    visit.call(node.left)
    visit.call(node.right)
  end

  visit.call(root)
  result
end

def find_path(root, target)
  path = []

  search = lambda do |node|
    next false if node.nil?

    path << node
    return true if node == target

    return true if search.call(node.left) || search.call(node.right)

    path.pop
    false
  end

  search.call(root)
  path
end

# 4. Bottleneck Analysis
#
# The brute-force method repeatedly walks from root to locate paths. Most of
# those paths share long prefixes, so rediscovering them for every node causes
# the O(n * h) repeated work.
#
# 5. Optimization Journey
#
# Distance from target can move in three directions: left, right, and parent.
# Trees only store child pointers, so first build parent pointers in one DFS.
#
# The tree then behaves like an undirected graph. A breadth-first search
# starting at target explores nodes in increasing distance order:
# - BFS level 0 contains target.
# - BFS level 1 contains its neighbors.
# - BFS level k contains exactly the required nodes.
#
# A visited set prevents moving back and forth between parent and child.
#
# 6. Dry Run
#
# For target 5 and k = 2 in:
#
#         3
#        / \
#       5   1
#      / \ / \
#     6  2 0  8
#       / \
#      7   4
#
# Level 0: [5]
# Level 1: [6, 2, 3]
# Level 2: [7, 4, 1]
#
# Result: [7, 4, 1].
#
# 7. Optimal Solution
#
# Build parent references once, then use BFS from target for exactly k levels.
#
# Time Complexity: O(n)
# Space Complexity: O(n) for parent references, visited nodes, and BFS queue.

# 8. Optimal Code
def distance_k(root, target, k)
  parent = {}

  connect_parents = lambda do |node|
    next if node.nil?

    if node.left
      parent[node.left] = node
      connect_parents.call(node.left)
    end
    if node.right
      parent[node.right] = node
      connect_parents.call(node.right)
    end
  end
  connect_parents.call(root)

  visited = { target => true }
  level = [target]

  k.times do
    next_level = []

    level.each do |node|
      [node.left, node.right, parent[node]].compact.each do |neighbor|
        next if visited[neighbor]

        visited[neighbor] = true
        next_level << neighbor
      end
    end

    level = next_level
  end

  level.map(&:val)
end

# Examples
if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    3,
    TreeNode.new(5, TreeNode.new(6), TreeNode.new(2, TreeNode.new(7), TreeNode.new(4))),
    TreeNode.new(1, TreeNode.new(0), TreeNode.new(8))
  )
  target = root.left

  p distance_k_brute(root, target, 2).sort # [1, 4, 7]
  p distance_k(root, target, 2).sort # [1, 4, 7]
end
