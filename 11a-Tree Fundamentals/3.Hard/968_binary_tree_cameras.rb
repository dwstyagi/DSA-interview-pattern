# frozen_string_literal: true

# 968. Binary Tree Cameras
#
# 1. Problem Statement
#
# Place the fewest cameras in a binary tree so that every node is monitored.
# A camera monitors its parent, itself, and its immediate children.

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
# For n nodes, try every subset of nodes as possible camera locations and keep
# the smallest subset that covers the whole tree.
#
# Algorithm:
# 1. Collect every node and its parent.
# 2. Enumerate all 2^n camera subsets.
# 3. For each subset, mark the selected node, its parent, and its children as
#    covered.
# 4. Keep the smallest subset that covers every node.
#
# Time Complexity: O(n * 2^n)
# Space Complexity: O(n)

# 3. Brute Force Code
def min_camera_cover_brute(root)
  return 0 if root.nil?

  nodes = []
  parent = {}

  collect = lambda do |node, previous|
    next if node.nil?

    nodes << node
    parent[node] = previous
    collect.call(node.left, node)
    collect.call(node.right, node)
  end
  collect.call(root, nil)

  best = nodes.length
  (0...(1 << nodes.length)).each do |mask|
    camera_count = mask.digits(2).sum
    next if camera_count >= best

    covered = {}
    nodes.each_with_index do |node, index|
      next if (mask & (1 << index)).zero?

      covered[node] = true
      covered[parent[node]] = true if parent[node]
      covered[node.left] = true if node.left
      covered[node.right] = true if node.right
    end

    best = camera_count if nodes.all? { |node| covered[node] }
  end

  best
end

# 4. Bottleneck Analysis
#
# The brute-force method treats camera choices as independent, even though
# coverage only crosses one edge. It examines exponentially many combinations
# that have the same local coverage relationship.
#
# 5. Optimization Journey
#
# After processing both children, a node only needs one of three states:
#
# - NEEDS_CAMERA: it is not covered by a child camera.
# - HAS_CAMERA: a camera is installed here.
# - COVERED: it has no camera but is covered by a child camera.
#
# Postorder lets children report their states first:
# - If any child needs a camera, put one at the current node.
# - Else if any child has a camera, the current node is covered.
# - Otherwise, the current node needs its parent to place a camera.
#
# Nil children are considered covered, and a root left needing a camera gets a
# final camera after DFS.
#
# 6. Dry Run
#
# For a chain 0 -> 0 -> 0:
# - Bottom leaf has no child camera, so it returns NEEDS_CAMERA.
# - Its parent sees that state, installs a camera, and returns HAS_CAMERA.
# - Root sees a child camera, so it returns COVERED.
#
# Only one camera is needed, placed at the middle node.
#
# 7. Optimal Solution
#
# Use postorder DFS and the three states above. Each node is visited once and
# the greedy camera placement is forced whenever a child would otherwise remain
# uncovered.
#
# Time Complexity: O(n)
# Space Complexity: O(h), where h is the tree height.

# 8. Optimal Code
def min_camera_cover(root)
  needs_camera = 0
  has_camera = 1
  covered = 2
  cameras = 0

  visit = lambda do |node|
    next covered if node.nil?

    left_state = visit.call(node.left)
    right_state = visit.call(node.right)

    if left_state == needs_camera || right_state == needs_camera
      cameras += 1
      has_camera
    elsif left_state == has_camera || right_state == has_camera
      covered
    else
      needs_camera
    end
  end

  cameras += 1 if visit.call(root) == needs_camera
  cameras
end

# Examples
if __FILE__ == $PROGRAM_NAME
  #     0
  #    /
  #   0
  #  / \
  # 0   0
  root = TreeNode.new(0, TreeNode.new(0, TreeNode.new(0), TreeNode.new(0)))

  p min_camera_cover_brute(root) # 1
  p min_camera_cover(root) # 1
end
