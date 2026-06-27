# frozen_string_literal: true

# 124. Binary Tree Maximum Path Sum
#
# 1. Problem Statement
#
# A path is any sequence of nodes connected by edges, with no node repeated.
# Return the largest possible sum of values along a non-empty path in a binary
# tree. The path may start and end at any nodes.

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
# Convert the tree into an undirected graph. Starting from each node, explore
# every simple path that begins there and record the largest running sum.
#
# Algorithm:
# 1. Build an adjacency list for the tree.
# 2. Start DFS at every node.
# 3. During a DFS, never revisit the previous node, so every explored route is
#    a valid simple path.
#
# Time Complexity: O(n^2), because a DFS can visit O(n) nodes for each start.
# Space Complexity: O(n) for the adjacency list and recursion stack.

# 3. Brute Force Code
def max_path_sum_brute(root)
  return 0 if root.nil?

  graph = Hash.new { |hash, key| hash[key] = [] }
  nodes = []

  build_graph = lambda do |node, parent|
    next if node.nil?

    nodes << node
    if parent
      graph[node] << parent
      graph[parent] << node
    end
    build_graph.call(node.left, node)
    build_graph.call(node.right, node)
  end
  build_graph.call(root, nil)

  best = -Float::INFINITY
  nodes.each do |start|
    search = lambda do |node, previous, sum|
      best = [best, sum].max
      graph[node].each do |neighbor|
        search.call(neighbor, node, sum + neighbor.val) unless neighbor == previous
      end
    end
    search.call(start, nil, start.val)
  end

  best
end

# 4. Bottleneck Analysis
#
# The brute-force method recomputes nearly the same downward paths from many
# different starting nodes. The tree structure lets a node summarize all that
# repeated work with one value: its best path that can extend upward.
#
# 5. Optimization Journey
#
# At a node, a path can use:
# - the node alone,
# - the node plus one child branch, or
# - both child branches joined through the node.
#
# A path sent to the parent cannot include both children, because that would
# split into two directions. So each recursive call returns only:
#
#   node.val + max(0, left_gain, right_gain)
#
# But while standing at the node, we can update the global answer with:
#
#   node.val + max(0, left_gain) + max(0, right_gain)
#
# Negative gains are discarded because starting fresh at the node is better.
#
# 6. Dry Run
#
# For [-10, 9, 20, nil, nil, 15, 7]:
# - Node 15 returns gain 15; node 7 returns gain 7.
# - At 20, through_sum = 20 + 15 + 7 = 42, so best becomes 42.
# - Node 20 returns 20 + max(15, 7) = 35 to -10.
# - At -10, its through_sum is -10 + 0 + 35 = 25.
#
# Final answer: 42.
#
# 7. Optimal Solution
#
# Use postorder DFS. Each child returns its best non-branching upward gain,
# while each node also evaluates the best complete path that turns through it.
#
# Time Complexity: O(n)
# Space Complexity: O(h), where h is the tree height.

# 8. Optimal Code
def max_path_sum(root)
  best = -Float::INFINITY

  gain = lambda do |node|
    next 0 if node.nil?

    left_gain = [gain.call(node.left), 0].max
    right_gain = [gain.call(node.right), 0].max

    # This path may use both branches, so it is only used for the global answer.
    best = [best, node.val + left_gain + right_gain].max

    node.val + [left_gain, right_gain].max
  end

  gain.call(root)
  best
end

# Examples
if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    -10,
    TreeNode.new(9),
    TreeNode.new(20, TreeNode.new(15), TreeNode.new(7))
  )

  p max_path_sum_brute(root) # 42
  p max_path_sum(root) # 42
end
