# frozen_string_literal: true

# 105. Construct Binary Tree from Preorder and Inorder Traversal
#
# 1. Problem Statement
#
# Given preorder and inorder traversal arrays of a binary tree with unique
# values, rebuild and return the original binary tree.

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
# The next unused preorder value is always the root of the current subtree.
# Its location in inorder divides that subtree into left and right parts.
#
# Algorithm:
# 1. Take the first preorder value as the root.
# 2. Linearly search for that value in inorder.
# 3. Split both traversal arrays around the root and recursively build both
#    subtrees.
#
# Time Complexity: O(n^2) in a skewed tree because every recursive call can
# search most of its inorder array.
# Space Complexity: O(n^2) in the worst case from recursive array slices.

# 3. Brute Force Code
def build_tree_brute(preorder, inorder)
  return nil if preorder.empty?

  root_value = preorder[0]
  root_index = inorder.index(root_value)
  root = TreeNode.new(root_value)

  left_size = root_index
  root.left = build_tree_brute(preorder[1, left_size], inorder[0, left_size])
  root.right = build_tree_brute(
    preorder[(left_size + 1)..],
    inorder[(root_index + 1)..]
  )

  root
end

# 4. Bottleneck Analysis
#
# Each recursive call repeats a linear search to find its root in inorder.
# Array slicing also creates new arrays again and again. On a tree shaped like
# a linked list, the work becomes:
#
#   n + (n - 1) + (n - 2) + ... + 1 = O(n^2)
#
# 5. Optimization Journey
#
# The root position in inorder is the only information we repeatedly search
# for, so store every value's inorder index in a hash map once.
#
# Then avoid slicing:
# - Keep one preorder_index pointing to the next root.
# - Define a recursive range [left, right] in the inorder array.
# - The preorder value creates the root.
# - Its mapped inorder position splits the range.
#
# Preorder visits root, left, right, so recursively constructing the left
# range first ensures preorder_index is correct for the right range.
#
# 6. Dry Run
#
# preorder = [3, 9, 20, 15, 7]
# inorder  = [9, 3, 15, 20, 7]
#
# build(0, 4):
# - preorder_index = 0, root = 3, inorder index = 1.
# - Left range is [0, 0]; right range is [2, 4].
#
# build(0, 0):
# - preorder_index = 1, root = 9, index = 0.
# - Both child ranges are empty.
#
# build(2, 4):
# - preorder_index = 2, root = 20, index = 3.
# - It creates left child 15 and right child 7.
#
# 7. Optimal Solution
#
# Map each inorder value to its position, then recursively build subtrees using
# inorder boundaries and a single moving preorder pointer.
#
# Time Complexity: O(n)
# Space Complexity: O(n) for the index map and recursion stack.

# 8. Optimal Code
def build_tree(preorder, inorder)
  inorder_index = {}
  inorder.each_with_index { |value, index| inorder_index[value] = index }
  preorder_position = 0

  build_subtree = lambda do |left, right|
    next nil if left > right

    root_value = preorder[preorder_position]
    preorder_position += 1
    root = TreeNode.new(root_value)
    middle = inorder_index[root_value]

    root.left = build_subtree.call(left, middle - 1)
    root.right = build_subtree.call(middle + 1, right)
    root
  end

  build_subtree.call(0, inorder.length - 1)
end

def preorder_values(root)
  return [] if root.nil?

  [root.val] + preorder_values(root.left) + preorder_values(root.right)
end

def inorder_values(root)
  return [] if root.nil?

  inorder_values(root.left) + [root.val] + inorder_values(root.right)
end

# Examples
if __FILE__ == $PROGRAM_NAME
  preorder = [3, 9, 20, 15, 7]
  inorder = [9, 3, 15, 20, 7]

  brute_root = build_tree_brute(preorder, inorder)
  p preorder_values(brute_root) # [3, 9, 20, 15, 7]

  optimal_root = build_tree(preorder, inorder)
  p inorder_values(optimal_root) # [9, 3, 15, 20, 7]
end
