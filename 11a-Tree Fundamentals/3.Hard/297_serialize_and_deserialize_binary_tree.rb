# frozen_string_literal: true

# 297. Serialize and Deserialize Binary Tree
#
# 1. Problem Statement
#
# Design an algorithm that converts a binary tree into a string and reconstructs
# the exact same tree from that string.

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
# Level-order traversal mirrors the common array representation of a tree.
# Keep nil placeholders so missing children are not confused with absent data.
#
# Algorithm:
# 1. Serialize with BFS, writing '#' for nil positions.
# 2. Deserialize by reading values in pairs as left and right children.
#
# Time Complexity: O(n)
# Space Complexity: O(n), including the serialized tokens and BFS queue.

# 3. Brute Force Code
class CodecBrute
  def serialize(root)
    return '' if root.nil?

    tokens = []
    queue = [root]
    head = 0

    while head < queue.length
      node = queue[head]
      head += 1

      if node
        tokens << node.val.to_s
        queue << node.left
        queue << node.right
      else
        tokens << '#'
      end
    end

    tokens.join(',')
  end

  def deserialize(data)
    return nil if data.empty?

    tokens = data.split(',')
    root = TreeNode.new(tokens[0].to_i)
    queue = [root]
    head = 0
    index = 1

    while head < queue.length && index < tokens.length
      node = queue[head]
      head += 1

      if tokens[index] != '#'
        node.left = TreeNode.new(tokens[index].to_i)
        queue << node.left
      end
      index += 1

      if index < tokens.length && tokens[index] != '#'
        node.right = TreeNode.new(tokens[index].to_i)
        queue << node.right
      end
      index += 1
    end

    root
  end
end

# 4. Bottleneck Analysis
#
# Level-order serialization keeps nil positions all the way through the final
# leaves. Those trailing markers add noise and require careful pair management
# during reconstruction. A recursive tree is more naturally described by its
# root followed by its two subtrees.
#
# 5. Optimization Journey
#
# Preorder writes:
#
#   root, serialized left subtree, serialized right subtree
#
# A '#' marker for nil makes this representation unambiguous. During
# deserialization:
# - Read one token.
# - '#' means this subtree is nil.
# - A value creates a node, then recursively consumes exactly its left tokens
#   followed by exactly its right tokens.
#
# The token order and recursive call order line up perfectly.
#
# 6. Dry Run
#
# Tree:
#
#     1
#    / \
#   2   3
#
# Serialization: "1,2,#,#,3,#,#"
#
# Deserialization reads 1, recursively builds 2 with two nil children, then
# returns to build 3 with two nil children. Every token is consumed once.
#
# 7. Optimal Solution
#
# Use preorder DFS with '#' for nil nodes. The serializer emits an explicit
# subtree boundary for every missing child, and the deserializer consumes the
# tokens in the same recursive order.
#
# Time Complexity: O(n)
# Space Complexity: O(n) for tokens and recursion.

# 8. Optimal Code
class Codec
  def serialize(root)
    tokens = []

    traverse = lambda do |node|
      if node.nil?
        tokens << '#'
        next
      end

      tokens << node.val.to_s
      traverse.call(node.left)
      traverse.call(node.right)
    end

    traverse.call(root)
    tokens.join(',')
  end

  def deserialize(data)
    tokens = data.split(',')
    index = 0

    build = lambda do
      token = tokens[index]
      index += 1
      next nil if token == '#'

      node = TreeNode.new(token.to_i)
      node.left = build.call
      node.right = build.call
      node
    end

    build.call
  end
end

def inorder_values(root)
  return [] if root.nil?

  inorder_values(root.left) + [root.val] + inorder_values(root.right)
end

# Examples
if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(1, TreeNode.new(2), TreeNode.new(3))

  brute_codec = CodecBrute.new
  brute_data = brute_codec.serialize(root)
  p brute_data # "1,2,3,#,#,#,#"
  p inorder_values(brute_codec.deserialize(brute_data)) # [2, 1, 3]

  codec = Codec.new
  data = codec.serialize(root)
  p data # "1,2,#,#,3,#,#"
  p inorder_values(codec.deserialize(data)) # [2, 1, 3]
end
