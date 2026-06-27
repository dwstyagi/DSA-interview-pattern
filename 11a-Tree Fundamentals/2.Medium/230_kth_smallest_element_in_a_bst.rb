# frozen_string_literal: true

# =============================================================================
# LeetCode 230: Kth Smallest Element in a BST
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary search tree and an integer k, return the kth
# smallest value among all node values in the tree.

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
# Collect all node values, sort them, and return the value at index k - 1.
#
# How the algorithm works:
# - DFS through the tree.
# - Store every value in an array.
# - Sort the array.
# - Return values[k - 1].
#
# Time Complexity:
#   O(n log n), because sorting dominates.
#
# Space Complexity:
#   O(n), because all values are stored.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def collect_values(node, values)
  return if node.nil?

  values << node.val
  collect_values(node.left, values)
  collect_values(node.right, values)
end

def kth_smallest_brute(root, k)
  values = []
  collect_values(root, values)
  values.sort[k - 1]
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# Sorting is unnecessary because the tree is a BST.
#
# Inorder traversal visits BST values in sorted order:
#   left subtree -> node -> right subtree
#
# So the repeated limitation is doing a full sort after the tree already gives us
# sorted order naturally.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# If inorder gives sorted values, the kth visited node in inorder is the kth
# smallest value.
#
# We can avoid storing every value by maintaining:
# - count of how many nodes have been visited.
# - answer once count == k.
#
# Once answer is found, recursion can stop doing useful work.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# BST:
#     3
#    / \
#   1   4
#    \
#     2
#
# k = 1
#
# inorder visits:
#   1 => count 1, answer 1
#
# Answer: 1.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - Run inorder DFS.
# - Increment count when visiting a node.
# - When count equals k, store the answer.
# - Return the answer.
#
# Time Complexity:
#   O(h + k) on average because we stop after kth visit, O(n) worst case.
#
# Space Complexity:
#   O(h), due to recursion stack.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def kth_smallest(root, k)
  count = 0
  answer = nil

  inorder = lambda do |node|
    return if node.nil? || answer

    inorder.call(node.left)

    count += 1
    answer = node.val if count == k

    inorder.call(node.right)
  end

  inorder.call(root)
  answer
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    3,
    TreeNode.new(1, nil, TreeNode.new(2)),
    TreeNode.new(4)
  )

  puts kth_smallest_brute(root, 1) # 1
  puts kth_smallest(root, 1)       # 1

  puts kth_smallest_brute(root, 3) # 3
  puts kth_smallest(root, 3)       # 3
end
