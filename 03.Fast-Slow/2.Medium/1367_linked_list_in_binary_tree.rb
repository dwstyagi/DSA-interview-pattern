# frozen_string_literal: true

# LeetCode 1367: Linked List in Binary Tree
#
# Problem:
# Given a binary tree root and a linked list head, return true if all the
# elements of the linked list starting from head correspond to some downward
# path in the binary tree, false otherwise.
# A downward path means going from a node to any descendant (not necessarily a leaf).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS from every tree node. At each tree node, try to match the full
#    linked list starting from that node going downward.
#
#    Time Complexity: O(n * m) where n = tree nodes, m = list length
#    Space Complexity: O(h + m) where h = tree height (recursion stack)
#
# 2. Bottleneck
#    Restarting match from every tree node — no better known approach for
#    this problem without KMP. O(n*m) is accepted.
#
# 3. Optimized Accepted Approach (same complexity, cleaner structure)
#    Two recursive functions:
#    - is_sub_path: tries to start a match from every tree node (outer DFS)
#    - dfs_match: checks if list matches starting from a given tree node (inner DFS)
#
#    Time Complexity: O(n * m)
#    Space Complexity: O(h + m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# List: 4 -> 2 -> 8
# Tree:
#         1
#        / \
#       4   4
#      / \   \
#     2   7   2
#    / \       \
#   1   3       6
#              /
#             8
#
# Start match at tree node 4 (left child of root):
#   list=4, tree=4 -> match, go deeper
#   list=2, tree=2 -> match, go deeper
#   list=8, tree=1 or 3 -> no match, backtrack
#
# Start match at tree node 4 (right child of root):
#   list=4, tree=4 -> match, go deeper
#   list=2, tree=2 -> match, go deeper
#   list=8, tree=6 -> no match
#   tree.right=6, 6.left=8 -> wait, we're checking tree node 2's children
#   tree=2 has right child 6, and 6 has left child 8
#   list=8, tree.right.left = 8 -> match, list exhausted -> return true ✓
#
# Edge Cases:
# - Empty list -> always true (empty path matches anywhere)
# - List longer than any path -> false

# linked list node
class ListNode # rubocop:disable Style/Documentation
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

# binary tree node
class TreeNode # rubocop:disable Style/Documentation
  attr_accessor :val, :left, :right

  def initialize(val)
    @val = val
    @left = nil
    @right = nil
  end
end

# check if list matches a downward path starting from this specific tree node
def dfs_match(list_node, tree_node)
  return true if list_node.nil?  # exhausted list -> full match found
  return false if tree_node.nil? # ran out of tree before list -> no match

  return false if list_node.val != tree_node.val # values differ -> no match

  # try to continue match going left or right in the tree
  dfs_match(list_node.next, tree_node.left) ||
    dfs_match(list_node.next, tree_node.right)
end

# try to start a match from every tree node
def is_sub_path(head, root) # rubocop:disable Naming/MethodName
  return false if root.nil? # no more tree nodes to try

  # try starting match at this tree node, or recurse into children
  dfs_match(head, root) ||
    is_sub_path(head, root.left) ||
    is_sub_path(head, root.right)
end

if __FILE__ == $PROGRAM_NAME
  # list: 4 -> 2 -> 8
  l1 = ListNode.new(4)
  l2 = ListNode.new(2)
  l3 = ListNode.new(8)
  l1.next = l2
  l2.next = l3

  # simple tree where path exists
  t1 = TreeNode.new(1)
  t2 = TreeNode.new(4)
  t3 = TreeNode.new(2)
  t4 = TreeNode.new(8)
  t1.left = t2
  t2.left = t3
  t3.right = t4

  puts "Path exists: #{is_sub_path(l1, t1)}"
end
