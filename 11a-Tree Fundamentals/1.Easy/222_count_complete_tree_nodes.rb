# frozen_string_literal: true

# =============================================================================
# LeetCode 222: Count Complete Tree Nodes
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a complete binary tree, return the number of nodes.
#
# A complete binary tree has every level completely filled except possibly the
# last level, and all nodes in the last level are as far left as possible.

class TreeNode
  attr_accessor :val, :left, :right

  def initialize(val = 0, left = nil, right = nil)
    @val = val
    @left = left
    @right = right
  end
end

# -----------------------------------------------------------------------------
# 2. Brute Force Approach
# -----------------------------------------------------------------------------
#
# Intuition:
# Count every node with a normal tree traversal.
#
# How the algorithm works:
# - If the node is nil, it contributes 0.
# - Count the current node as 1.
# - Recursively count nodes in the left subtree.
# - Recursively count nodes in the right subtree.
#
# Time Complexity:
#   O(n), because every node is visited.
#
# Space Complexity:
#   O(h), where h is the tree height, due to recursion stack.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def count_nodes_brute(root)
  return 0 if root.nil?

  1 + count_nodes_brute(root.left) + count_nodes_brute(root.right)
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force traversal ignores the fact that the tree is complete.
#
# In a complete tree, many subtrees are perfect binary trees. A perfect binary
# tree has all levels full, so if its height is h, its node count is:
#   2^h - 1
#
# The repeated work is visiting every node inside a subtree whose count could be
# computed directly from its height.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# In a complete binary tree:
# - If the height following left pointers equals the height following right
#   pointers, the subtree is perfect.
# - A perfect subtree with height h has 2^h - 1 nodes.
#
# If the heights differ:
# - The subtree is not perfect.
# - But its children are still complete enough for the same logic to apply
#   recursively.
#
# This lets us skip entire perfect subtrees instead of visiting every node.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree:
#       1
#      / \
#     2   3
#    / \ /
#   4  5 6
#
# count_nodes(1):
#   left_height = 3  path 1 -> 2 -> 4
#   right_height = 2 path 1 -> 3
#   heights differ, so:
#     1 + count_nodes(2) + count_nodes(3)
#
# count_nodes(2):
#   left_height = 2, right_height = 2
#   perfect subtree => 2^2 - 1 = 3
#
# count_nodes(3):
#   left_height = 2, right_height = 1
#   not perfect => 1 + count_nodes(6) + count_nodes(nil) = 2
#
# Total = 1 + 3 + 2 = 6.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - For each subtree, compute leftmost height and rightmost height.
# - If they match, return 2^height - 1.
# - Otherwise recursively count left and right subtrees.
#
# Time Complexity:
#   O(log^2 n) for a complete tree.
#   Each level computes heights in O(log n), and there are O(log n) levels.
#
# Space Complexity:
#   O(log n), due to recursion stack in a complete tree.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def left_height(node)
  height = 0
  while node
    height += 1
    node = node.left
  end
  height
end

def right_height(node)
  height = 0
  while node
    height += 1
    node = node.right
  end
  height
end

def count_nodes(root)
  return 0 if root.nil?

  lh = left_height(root)
  rh = right_height(root)

  # Equal extreme heights mean this subtree is perfect.
  return (2**lh) - 1 if lh == rh

  1 + count_nodes(root.left) + count_nodes(root.right)
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    1,
    TreeNode.new(2, TreeNode.new(4), TreeNode.new(5)),
    TreeNode.new(3, TreeNode.new(6), nil)
  )

  puts count_nodes_brute(root) # 6
  puts count_nodes(root)       # 6

  perfect = TreeNode.new(
    1,
    TreeNode.new(2),
    TreeNode.new(3)
  )

  puts count_nodes_brute(perfect) # 3
  puts count_nodes(perfect)       # 3
end
