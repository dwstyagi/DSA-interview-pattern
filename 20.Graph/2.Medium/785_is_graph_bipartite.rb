# frozen_string_literal: true

# LeetCode 785: Is Graph Bipartite?
#
# Problem:
# Given adjacency list of undirected graph, return true if it can be colored
# with 2 colors such that no adjacent nodes share the same color.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all 2-colorings. Exponential.
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    BFS/DFS with 2-coloring: assign alternating colors. If conflict, not bipartite.
#
# 3. Optimized Accepted Approach
#    BFS from each uncolored node. Color = 0 or 1. Neighbors get opposite color.
#    If neighbor same color as current, not bipartite.
#
#    Time Complexity: O(V + E)
#    Space Complexity: O(V)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# graph=[[1,3],[0,2],[1,3],[0,2]]
# BFS from 0: color[0]=0, neighbors 1,3 -> color 1
# 1's neighbors 0(0),2 -> color[2]=0; 3's neighbors 0(0),2 -> color[2] already 0, ok
# No conflict -> true
#
# graph=[[1,2,3],[0,2],[0,1,3],[0,2]]: check if conflict occurs -> false
#
# Edge Cases:
# - Single node: bipartite
# - Odd cycle: not bipartite

def is_bipartite_brute?(graph)
  n = graph.length
  color = Array.new(n, -1)
  n.times do |start|
    next if color[start] != -1
    queue = [start]
    color[start] = 0
    until queue.empty?
      v = queue.shift
      graph[v].each do |nb|
        if color[nb] == -1
          color[nb] = 1 - color[v]
          queue << nb
        elsif color[nb] == color[v]
          return false
        end
      end
    end
  end
  true
end

def is_bipartite?(graph)
  n = graph.length
  color = Array.new(n, -1)
  n.times do |start|
    next if color[start] != -1
    color[start] = 0
    stack = [start]
    until stack.empty?
      v = stack.pop
      graph[v].each do |nb|
        if color[nb] == -1
          color[nb] = 1 - color[v]
          stack << nb
        elsif color[nb] == color[v]
          return false
        end
      end
    end
  end
  true
end

if __FILE__ == $PROGRAM_NAME
  puts is_bipartite_brute?([[1, 3], [0, 2], [1, 3], [0, 2]])   # true
  puts is_bipartite?([[1, 2, 3], [0, 2], [0, 1, 3], [0, 2]])   # false
end
