# frozen_string_literal: true

# =============================================================================
# LeetCode 116: Populating Next Right Pointers in Each Node
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given a perfect binary tree, populate each node's next pointer to point to its
# next right node. If there is no next right node, the next pointer should be nil.
#
# A perfect binary tree has all leaves on the same level and every parent has two
# children.

class Node
  attr_accessor :val, :left, :right, :next

  def initialize(val = 0, left = nil, right = nil, next_node = nil)
    @val = val
    @left = left
    @right = right
    @next = next_node
  end
end

# -----------------------------------------------------------------------------
# 2. Brute Force Approach
# -----------------------------------------------------------------------------
#
# Intuition:
# Use BFS level order. Nodes in the same queue snapshot belong to the same level,
# so we can connect each previous node to the current node.
#
# How the algorithm works:
# - BFS level by level.
# - Keep a prev pointer for the current level.
# - For each node, set prev.next = node when prev exists.
# - After the level ends, the final node's next remains nil.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(w), where w is maximum width.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def connect_brute(root)
  return nil if root.nil?

  queue = [root]

  until queue.empty?
    prev = nil

    queue.size.times do
      node = queue.shift
      prev.next = node if prev
      prev = node

      queue << node.left if node.left
      queue << node.right if node.right
    end
  end

  root
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# BFS uses extra queue space. But the tree is perfect, and each level's next
# pointers can help us walk that level after it is connected.
#
# The limitation is storing nodes in a queue even though the structure guarantees
# predictable child relationships.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# For a perfect binary tree:
# - node.left.next should point to node.right.
# - node.right.next should point to node.next.left when node.next exists.
#
# If we process level by level using already-created next pointers, we can link
# the next level without a queue.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree:
#       1
#      / \
#     2   3
#    / \ / \
#   4  5 6  7
#
# At node 1:
#   2.next = 3
#
# Next level starts at 2:
#   4.next = 5
#   5.next = 6 because 2.next is 3
#   6.next = 7
#
# Each level is connected left to right.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - Start with the leftmost node of the current level.
# - While that level has children:
#   - Walk the current level using next pointers.
#   - Connect each node's children.
#   - Move down to leftmost.left.
#
# Time Complexity:
#   O(n), because every node is processed once.
#
# Space Complexity:
#   O(1), excluding the tree itself.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def connect(root)
  return nil if root.nil?

  leftmost = root

  while leftmost.left # While there is a next level
    current = leftmost

    while current
      current.left.next = current.right

      # Bridge across neighboring parents.
      current.right.next = current.next.left if current.next

      current = current.next
    end

    leftmost = leftmost.left
  end

  root
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = Node.new(
    1,
    Node.new(2, Node.new(4), Node.new(5)),
    Node.new(3, Node.new(6), Node.new(7))
  )

  connect(root)

  puts root.left.next.val              # 3
  puts root.left.right.next.val        # 6
  puts root.right.right.next.inspect   # nil

  root2 = Node.new(1, Node.new(2), Node.new(3))
  connect_brute(root2)
  puts root2.left.next.val # 3
end
