# frozen_string_literal: true

# =============================================================================
# LeetCode 100: Same Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the roots of two binary trees, p and q, return true if they are the same
# tree.
#
# Two trees are the same when:
# - Their structure is identical.
# - Every matching node has the same value.

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
# Serialize both trees into arrays, including nil markers for missing children.
# If the two serialized arrays are equal, the trees have the same values and the
# same structure.
#
# How the algorithm works:
# - Traverse each tree in preorder.
# - Add node values to the serialized result.
# - Add nil whenever a missing child is found.
# - Compare the two serialized arrays.
#
# Time Complexity:
#   O(n + m), where n and m are the number of nodes in the two trees.
#
# Space Complexity:
#   O(n + m), because both serialized arrays are stored.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def serialize_preorder(node, result = [])
  if node.nil?
    result << nil
    return result
  end

  result << node.val
  serialize_preorder(node.left, result)
  serialize_preorder(node.right, result)
  result
end

def same_tree_brute(p, q)
  serialize_preorder(p) == serialize_preorder(q)
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# Serialization does extra work:
# - It builds two full arrays before comparing.
# - Even if the roots are different, it still serializes both entire trees.
#
# We do not need to store the traversal. We can compare the trees directly while
# walking through them in parallel.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# At every position, there are only three meaningful cases:
# - Both nodes are nil: this part matches.
# - One node is nil and the other is not: structures differ.
# - Both nodes exist: values must match, and both children must match.
#
# This naturally gives a parallel recursive traversal:
#   same_tree?(p, q)
#     compare p and q
#     compare p.left with q.left
#     compare p.right with q.right
#
# The recursive call returns false as soon as any mismatch is found.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# p:
#     1
#    / \
#   2   3
#
# q:
#     1
#    / \
#   2   3
#
# same_tree?(1, 1):
#   values match
#   same_tree?(2, 2) => true
#   same_tree?(3, 3) => true
#   both sides true => true
#
# If q.right were 4:
#   same_tree?(3, 4) sees value mismatch and returns false.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - If both nodes are nil, return true.
# - If only one node is nil, return false.
# - If values differ, return false.
# - Recursively compare left subtrees and right subtrees.
#
# Time Complexity:
#   O(min(n, m)) in early mismatch cases, O(n) when trees have the same shape.
#
# Space Complexity:
#   O(h), where h is the recursion depth.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def same_tree?(p, q)
  return true if p.nil? && q.nil?
  return false if p.nil? || q.nil?
  return false if p.val != q.val

  same_tree?(p.left, q.left) && same_tree?(p.right, q.right)
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  p = TreeNode.new(1, TreeNode.new(2), TreeNode.new(3))
  q = TreeNode.new(1, TreeNode.new(2), TreeNode.new(3))

  puts same_tree_brute(p, q) # true
  puts same_tree?(p, q)      # true

  different = TreeNode.new(1, TreeNode.new(2), TreeNode.new(4))

  puts same_tree_brute(p, different) # false
  puts same_tree?(p, different)      # false

  puts same_tree?(nil, nil) # true
end
