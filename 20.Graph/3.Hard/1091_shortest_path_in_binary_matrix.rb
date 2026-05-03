# frozen_string_literal: true

# LeetCode 1091: Shortest Path in Binary Matrix
#
# Problem:
# Given n×n binary matrix, find shortest clear path (all 0s) from top-left to bottom-right.
# Can move in 8 directions. Return path length or -1.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS from (0,0) in 8 directions. BFS naturally finds shortest path.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    Already optimal with BFS.
#
# 3. Optimized Accepted Approach
#    BFS with visited array. Level = path length. Return when (n-1,n-1) reached.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n^2)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[[0,1],[1,0]]
# BFS from (0,0): can go to (1,1) diagonally -> path length 2
# Result: 2
#
# Edge Cases:
# - Start or end is 1: return -1
# - 1x1 grid with 0: return 1

def shortest_path_binary_matrix_brute(grid)
  n = grid.length
  return -1 if grid[0][0] == 1 || grid[n - 1][n - 1] == 1
  return 1 if n == 1
  visited = Array.new(n) { Array.new(n, false) }
  visited[0][0] = true
  queue = [[0, 0, 1]]
  dirs = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
  until queue.empty?
    r, c, d = queue.shift
    dirs.each do |dr, dc|
      nr, nc = r + dr, c + dc
      next if nr < 0 || nr >= n || nc < 0 || nc >= n || visited[nr][nc] || grid[nr][nc] == 1
      return d + 1 if nr == n - 1 && nc == n - 1
      visited[nr][nc] = true
      queue << [nr, nc, d + 1]
    end
  end
  -1
end

# optimized: same BFS (already optimal)
def shortest_path_binary_matrix(grid)
  shortest_path_binary_matrix_brute(grid)
end

if __FILE__ == $PROGRAM_NAME
  puts shortest_path_binary_matrix_brute([[0, 1], [1, 0]])           # 2
  puts shortest_path_binary_matrix([[0, 0, 0], [1, 1, 0], [1, 1, 0]])  # 4
end
