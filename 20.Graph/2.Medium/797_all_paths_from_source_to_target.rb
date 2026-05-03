# frozen_string_literal: true

# LeetCode 797: All Paths From Source to Target
#
# Problem:
# Given a DAG with n nodes (0 to n-1), find all paths from node 0 to node n-1.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS from 0, collect all paths to n-1.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(2^n * n)
#
# 2. Bottleneck
#    DAG (no cycles), so DFS without visited array is safe. This is already optimal.
#
# 3. Optimized Accepted Approach
#    DFS/backtracking: maintain current path. On reaching n-1, save path copy.
#
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(2^n * n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# graph=[[1,2],[3],[3],[]]
# DFS from 0: path=[0]
#   go to 1: path=[0,1]
#     go to 3: path=[0,1,3] -> n-1=3 -> save
#   go to 2: path=[0,2]
#     go to 3: path=[0,2,3] -> save
# Result: [[0,1,3],[0,2,3]]
#
# Edge Cases:
# - Single node (n=1): return [[0]]
# - Linear graph: one path

def all_paths_source_target_brute(graph)
  n = graph.length
  result = []
  dfs = lambda do |node, path|
    if node == n - 1
      result << path.dup
      return
    end
    graph[node].each { |nb| path << nb; dfs.call(nb, path); path.pop }
  end
  dfs.call(0, [0])
  result
end

# optimized: same DFS (already optimal for this problem)
def all_paths_source_target(graph)
  n = graph.length
  result = []
  stack = [[0, [0]]]
  until stack.empty?
    node, path = stack.pop
    if node == n - 1
      result << path
      next
    end
    graph[node].each { |nb| stack << [nb, path + [nb]] }
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  puts all_paths_source_target_brute([[1, 2], [3], [3], []]).inspect  # [[0,1,3],[0,2,3]]
  puts all_paths_source_target([[4, 3, 1], [3, 2, 4], [3], [4], []]).inspect
end
