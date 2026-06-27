# frozen_string_literal: true

# 662. Maximum Width of Binary Tree
#
# 1. Problem Statement
#
# Return the maximum width among all levels of a binary tree. Width includes
# the null positions between the leftmost and rightmost non-null nodes, as if
# the tree were placed in a complete binary tree.

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
# Give nodes the same positions they would have in a complete binary tree:
# left child = 2 * position and right child = 2 * position + 1.
# At each level, the width is last_position - first_position + 1.
#
# Algorithm:
# Run breadth-first search and carry an absolute complete-tree position with
# every node. Measure the first and last positions at each level.
#
# Time Complexity: O(n)
# Space Complexity: O(n) for the BFS levels.

# 3. Brute Force Code
def width_of_binary_tree_brute(root)
  return 0 if root.nil?

  maximum_width = 0
  level = [[root, 0]]

  until level.empty?
    maximum_width = [maximum_width, level[-1][1] - level[0][1] + 1].max
    next_level = []

    level.each do |node, position|
      next_level << [node.left, position * 2] if node.left
      next_level << [node.right, position * 2 + 1] if node.right
    end

    level = next_level
  end

  maximum_width
end

# 4. Bottleneck Analysis
#
# The brute-force positions are correct, but their values double at every
# depth. A sparse, deep tree can create extremely large integers even when a
# level contains only a few nodes. The repeated leading offset carries no
# information about that level's width.
#
# 5. Optimization Journey
#
# Width only depends on relative positions within one level. If the first
# position at a level is base, replace every position p with p - base:
#
#   (last - base) - (first - base) + 1 = last - first + 1
#
# So normalize every level before calculating child positions. The first node
# always becomes position 0, keeping all later indices as small as possible.
#
# 6. Dry Run
#
# For the level containing positions [4, 7]:
# - base = 4
# - Normalized positions become [0, 3].
# - Width = 3 - 0 + 1 = 4.
#
# The children are assigned from 0 and 3, not from 4 and 7, preserving their
# spacing while discarding an irrelevant prefix.
#
# 7. Optimal Solution
#
# Process one BFS level at a time. Normalize positions against that level's
# first position, calculate its width, and use normalized positions to label
# children.
#
# Time Complexity: O(n)
# Space Complexity: O(n) in the widest level.

# 8. Optimal Code
def width_of_binary_tree(root)
  return 0 if root.nil?

  maximum_width = 0
  level = [[root, 0]]

  until level.empty?
    base = level[0][1]
    maximum_width = [maximum_width, level[-1][1] - base + 1].max
    next_level = []

    level.each do |node, position|
      normalized = position - base
      next_level << [node.left, normalized * 2] if node.left
      next_level << [node.right, normalized * 2 + 1] if node.right
    end

    level = next_level
  end

  maximum_width
end

# Examples
if __FILE__ == $PROGRAM_NAME
  #       1
  #      / \
  #     3   2
  #    /     \
  #   5       9
  root = TreeNode.new(
    1,
    TreeNode.new(3, TreeNode.new(5)),
    TreeNode.new(2, nil, TreeNode.new(9))
  )

  p width_of_binary_tree_brute(root) # 4
  p width_of_binary_tree(root) # 4
end
