# frozen_string_literal: true

# LeetCode 1791: Find Center of Star Graph
#
# Problem:
# Given a star graph with n nodes and n-1 edges, return the center node.
# The center node is connected to all other nodes.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Count degrees of all nodes. Return node with degree n-1.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    We can find the center by checking only first two edges.
#    The center must appear in both.
#
# 3. Optimized Accepted Approach
#    Check first two edges: center is the common node between edges[0] and edges[1].
#
#    Time Complexity: O(1)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# edges=[[1,2],[2,3],[4,2]]
# edges[0]=[1,2], edges[1]=[2,3]
# common: 2 appears in both -> center = 2
#
# Edge Cases:
# - Guaranteed star graph, so always exactly one center

def find_center_brute(edges)
  degree = Hash.new(0)
  edges.each { |u, v| degree[u] += 1; degree[v] += 1 }
  degree.max_by(&:last)[0]
end

def find_center(edges)
  e0 = edges[0]
  e1 = edges[1]
  e0.find { |n| e1.include?(n) }
end

if __FILE__ == $PROGRAM_NAME
  puts find_center_brute([[1, 2], [2, 3], [4, 2]])  # 2
  puts find_center([[1, 2], [5, 1], [1, 3], [1, 4]])  # 1
end
