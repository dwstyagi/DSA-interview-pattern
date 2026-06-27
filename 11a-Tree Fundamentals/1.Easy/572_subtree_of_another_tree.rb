# frozen_string_literal: true

# =============================================================================
# LeetCode 572: Subtree of Another Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the roots of two binary trees, root and sub_root, return true if sub_root
# is a subtree of root.
#
# A subtree must match both structure and node values.

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
# Serialize both trees with nil markers. Then check whether the serialized
# sub_root appears inside the serialized root.
#
# How the algorithm works:
# - Preorder serialize root and sub_root.
# - Include nil markers so different shapes do not look identical.
# - Convert both serializations into strings with separators.
# - Check whether the larger string contains the smaller string.
#
# Time Complexity:
#   O(n + m) average for serialization plus substring search, depending on Ruby's
#   internal string search.
#
# Space Complexity:
#   O(n + m), because the serialized strings are stored.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def serialize(node, result = [])
  if node.nil?
    result << '#'
    return result
  end

  result << "^#{node.val}"
  serialize(node.left, result)
  serialize(node.right, result)
  result
end

def subtree_brute?(root, sub_root)
  serialize(root).join(',').include?(serialize(sub_root).join(','))
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# Serialization solves the problem, but it hides the tree logic inside string
# matching and stores extra data.
#
# The direct repeated work is:
# - Every possible root in the main tree may need to be compared with sub_root.
# - If many nodes have the same value as sub_root's root, we may repeat large
#   same-tree comparisons.
#
# Even so, the direct tree approach is usually the clearest interview solution.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# sub_root is a subtree of root if there exists some node in root where:
#   same_tree?(that_node, sub_root) == true
#
# So the problem splits into two smaller problems:
# - same_tree?: compare two trees in parallel.
# - subtree?: DFS through root and try same_tree? at each node.
#
# This is a common pattern: use one fundamental tree helper as the subproblem
# inside another traversal.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# root:
#       3
#      / \
#     4   5
#    / \
#   1   2
#
# sub_root:
#     4
#    / \
#   1   2
#
# subtree?(3, sub_root):
#   same_tree?(3, 4) => false
#   subtree?(4, sub_root):
#     same_tree?(4, 4) checks children 1 and 2 => true
#   return true

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - If sub_root is nil, return true.
# - If root is nil, return false.
# - If the trees rooted at root and sub_root are identical, return true.
# - Otherwise search root.left and root.right.
#
# Time Complexity:
#   O(n * m) in the worst case, where n is root nodes and m is sub_root nodes.
#
# Space Complexity:
#   O(h), where h is the height of root, plus comparison recursion depth.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def same_tree?(p, q)
  return true if p.nil? && q.nil?
  return false if p.nil? || q.nil?
  return false if p.val != q.val

  same_tree?(p.left, q.left) && same_tree?(p.right, q.right)
end

def subtree?(root, sub_root)
  return true if sub_root.nil?
  return false if root.nil?

  same_tree?(root, sub_root) ||
    subtree?(root.left, sub_root) ||
    subtree?(root.right, sub_root)
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    3,
    TreeNode.new(4, TreeNode.new(1), TreeNode.new(2)),
    TreeNode.new(5)
  )
  sub_root = TreeNode.new(4, TreeNode.new(1), TreeNode.new(2))

  puts subtree_brute?(root, sub_root) # true
  puts subtree?(root, sub_root)       # true

  different = TreeNode.new(4, TreeNode.new(1), TreeNode.new(3))

  puts subtree_brute?(root, different) # false
  puts subtree?(root, different)       # false
end
