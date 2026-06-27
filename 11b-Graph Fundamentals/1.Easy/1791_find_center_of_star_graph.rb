# frozen_string_literal: true

# 1791. Find Center of Star Graph
#
# 1. Problem Statement
#
# A star graph has one center connected to every other node. Given its edges,
# return the center node.
#
# 2. Brute Force Approach
#
# Intuition:
# The center is the only node whose degree is n - 1.
#
# Algorithm:
# Count how often every node appears in an edge, then return the node with the
# largest degree.
#
# Time Complexity: O(n)
# Space Complexity: O(n)

# 3. Brute Force Code
def find_center_brute(edges)
  degree = Hash.new(0)
  edges.each do |from, to|
    degree[from] += 1
    degree[to] += 1
  end

  degree.max_by { |_node, count| count }[0]
end

# 4. Bottleneck Analysis
#
# Degree counting works, but the star property is stronger than a general graph
# degree test. The center occurs in every edge, so counting all edges is more
# work than is needed.
#
# 5. Optimization Journey
#
# The first two edges must share the center:
#
# - If edges[0] is [a, b] and edges[1] is [a, c], center is a.
# - Otherwise the shared endpoint is b.
#
# No additional edge can change that answer.
#
# 6. Dry Run
#
# edges = [[1, 2], [2, 3], [4, 2]]
# - First edge endpoints: 1 and 2.
# - Second edge contains 2, so center = 2.
#
# 7. Optimal Solution
#
# Compare the two endpoints of the first edge against the second edge.
#
# Time Complexity: O(1)
# Space Complexity: O(1)

# 8. Optimal Code
def find_center(edges)
  first, second = edges[0]
  third, fourth = edges[1]

  first == third || first == fourth ? first : second
end

# Examples
if __FILE__ == $PROGRAM_NAME
  edges = [[1, 2], [2, 3], [4, 2]]
  p find_center_brute(edges) # 2
  p find_center(edges) # 2
end
