# frozen_string_literal: true

# 958. Check Completeness of a Binary Tree
#
# 1. Problem Statement
#
# Return true when a binary tree is complete: every level except possibly the
# last is full, and nodes in the last level are as far left as possible.

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
# Number nodes as though they were in an array representation of a complete
# tree. A complete tree with n nodes must occupy exactly indices 0 through
# n - 1, with no gaps.
#
# Algorithm:
# 1. Breadth-first traverse while assigning index 0 to root.
# 2. Assign children indices 2 * i + 1 and 2 * i + 2.
# 3. Store all assigned indices and confirm the largest one is n - 1.
#
# Time Complexity: O(n)
# Space Complexity: O(n)

# 3. Brute Force Code
def is_complete_tree_brute(root)
  return true if root.nil?

  indices = []
  level = [[root, 0]]

  until level.empty?
    node, index = level.shift
    indices << index
    level << [node.left, (index * 2) + 1] if node.left
    level << [node.right, (index * 2) + 2] if node.right
  end

  indices.max == indices.length - 1
end

# 4. Bottleneck Analysis
#
# Indexing proves completeness indirectly and stores an unnecessary collection
# of every position. It also produces increasingly large indices for deep,
# sparse trees. We can recognize the defining left-to-right property directly.
#
# 5. Optimization Journey
#
# In level-order traversal of a complete tree:
# - Real nodes appear first.
# - Once a missing child position is reached, every later position must also
#   be missing.
#
# Therefore, include nil children in BFS. After seeing the first nil, any later
# non-nil node proves there was a gap before a real node, so the tree is not
# complete.
#
# 6. Dry Run
#
# Tree: [1, 2, 3, 4, 5, 6]
#
# BFS sees: 1, 2, 3, 4, 5, 6, nil, nil, ...
# - The first nil sets seen_nil = true.
# - No later real node appears, so the tree is complete.
#
# For [1, 2, 3, 4, 5, nil, 7], BFS sees nil before 7. Seeing 7 after that nil
# immediately returns false.
#
# 7. Optimal Solution
#
# Perform level-order traversal including nil placeholders. Track whether a nil
# has been seen. A non-nil node after that point makes the tree incomplete.
#
# Time Complexity: O(n)
# Space Complexity: O(n)

# 8. Optimal Code
def is_complete_tree(root)
  queue = [root]
  head = 0
  seen_nil = false

  while head < queue.length
    node = queue[head]
    head += 1

    if node.nil?
      seen_nil = true
    elsif seen_nil
      return false
    else
      queue << node.left
      queue << node.right
    end
  end

  true
end

# Examples
if __FILE__ == $PROGRAM_NAME
  complete = TreeNode.new(
    1,
    TreeNode.new(2, TreeNode.new(4), TreeNode.new(5)),
    TreeNode.new(3, TreeNode.new(6))
  )
  p is_complete_tree_brute(complete) # true
  p is_complete_tree(complete) # true

  incomplete = TreeNode.new(
    1,
    TreeNode.new(2, TreeNode.new(4), TreeNode.new(5)),
    TreeNode.new(3, nil, TreeNode.new(7))
  )
  p is_complete_tree(incomplete) # false
end
