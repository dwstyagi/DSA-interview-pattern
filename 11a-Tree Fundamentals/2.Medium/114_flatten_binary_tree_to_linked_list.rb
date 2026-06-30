# frozen_string_literal: true

# 114. Flatten Binary Tree to Linked List
#
# 1. Problem Statement
#
# Given the root of a binary tree, flatten the tree into a linked list in-place.
# The linked list must use each node's right pointer, every left pointer must be
# nil, and the node order must match a preorder traversal.

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
# Preorder traversal already gives exactly the required linked-list order:
# root, then left subtree, then right subtree.
#
# Algorithm:
# 1. Store all tree nodes in preorder in an array.
# 2. Visit the array from left to right.
# 3. Clear each node's left pointer and connect its right pointer to the next
#    node in the array.
#
# Time Complexity: O(n)
# Space Complexity: O(n) for the preorder array.

# 3. Brute Force Code
def flatten_brute(root)
  nodes = []

  preorder = lambda do |node|
    next if node.nil?

    nodes << node
    preorder.call(node.left)
    preorder.call(node.right)
  end

  preorder.call(root)

  nodes.each_with_index do |node, index|
    node.left = nil
    node.right = nodes[index + 1]
  end

  root
end

# 4. Bottleneck Analysis
#
# The brute-force solution is fast enough in time, but it stores every node
# before it can begin rewiring the tree. That O(n) auxiliary array is the
# limitation: the tree itself already has enough pointers to represent the
# final preorder chain.
#
# 5. Optimization Journey
#
# At a node with a left subtree, the final order must be:
#
#   node -> flattened left subtree -> flattened right subtree
#
# Therefore:
# 1. Find the rightmost node in the current node's left subtree. In preorder,
#    that node becomes the tail of the flattened left subtree.
# 2. Attach the current right subtree after that tail.
# 3. Move the left subtree to the right pointer.
# 4. Clear the left pointer and continue along the new right chain.
#
# Each original edge is followed only a constant number of times, so this
# rewires the tree in O(n) time without a traversal array.
#
# 6. Dry Run
#
# Tree:
#
#       1
#      / \
#     2   5
#    / \   \
#   3   4   6
#
# current = 1:
# - The rightmost node in 1's left subtree is 4.
# - Set 4.right = 5, then move 2 to 1.right and set 1.left = nil.
# - Chain begins: 1 -> 2 -> 4 -> 5 -> 6.
#
# current = 2:
# - The rightmost node in 2's left subtree is 3.
# - Set 3.right = 4, then move 3 to 2.right and set 2.left = nil.
# - Chain becomes: 1 -> 2 -> 3 -> 4 -> 5 -> 6.
#
# The remaining nodes have no left child, so advancing right finishes the work.
#
# 7. Optimal Solution
#
# Walk down the tree through right pointers. Whenever a node has a left child,
# splice that left subtree between the node and its old right subtree. This is
# an in-place preorder transformation.
#
# Time Complexity: O(n)
# Space Complexity: O(1) auxiliary space.

# 8. Optimal Code
def flatten(root)
  prev = nil

  dfs = lambda do |node|
    return if node.nil?

    dfs.call(node.right)
    dfs.call(node.left)

    node.right = prev
    node.left = nil
    prev = node
  end

  dfs.call(root)
end

def right_chain_values(root)
  values = []
  current = root

  until current.nil?
    raise 'Flattened tree must not contain left pointers' if current.left

    values << current.val
    current = current.right
  end

  values
end

# Examples
if __FILE__ == $PROGRAM_NAME
  brute_root = TreeNode.new(
    1,
    TreeNode.new(2, TreeNode.new(3), TreeNode.new(4)),
    TreeNode.new(5, nil, TreeNode.new(6))
  )
  flatten_brute(brute_root)
  p right_chain_values(brute_root) # [1, 2, 3, 4, 5, 6]

  optimal_root = TreeNode.new(
    1,
    TreeNode.new(2, TreeNode.new(3), TreeNode.new(4)),
    TreeNode.new(5, nil, TreeNode.new(6))
  )
  flatten(optimal_root)
  p right_chain_values(optimal_root) # [1, 2, 3, 4, 5, 6]
end
