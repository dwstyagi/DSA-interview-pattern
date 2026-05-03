# frozen_string_literal: true

# LeetCode 1091: Shortest Path in a Binary Matrix
#
# Problem:
# Given an n x n binary matrix grid, return the length of the shortest clear
# path from top-left (0,0) to bottom-right (n-1,n-1). A clear path has all 0s.
# Movement is 8-directional. Return -1 if no clear path.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS all paths, track minimum length.
#    Time Complexity: Exponential
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    DFS doesn't guarantee shortest — BFS does in unweighted graphs.
#
# 3. Optimized Accepted Approach
#    BFS from (0,0). Explore 8 directions. First time we reach (n-1,n-1) is
#    the shortest path. Mark visited by setting cell to 1.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n^2)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[[0,1],[1,0]]
# Start (0,0)=0 ✓, BFS level 1: expand (0,0) → only (1,1)=0 reachable (diagonal)
# (1,1) is bottom-right → return 2 ✓
#
# Edge Cases:
# - Start or end is 1 -> -1
# - n=1, grid=[[0]] -> 1

def shortest_path_binary_matrix_brute(grid)
  n    = grid.length
  return -1 if grid[0][0] == 1 || grid[n-1][n-1] == 1
  return 1  if n == 1

  dirs  = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
  dist  = Array.new(n) { Array.new(n, Float::INFINITY) }
  dist[0][0] = 1
  queue = [[0, 0, 1]]

  until queue.empty?
    r, c, d = queue.shift
    dirs.each do |dr, dc|
      nr, nc = r + dr, c + dc
      next if nr < 0 || nr >= n || nc < 0 || nc >= n || grid[nr][nc] == 1
      next if d + 1 >= dist[nr][nc]
      dist[nr][nc] = d + 1
      queue << [nr, nc, d + 1]
    end
  end

  dist[n-1][n-1] == Float::INFINITY ? -1 : dist[n-1][n-1]
end

def shortest_path_binary_matrix(grid)
  n = grid.length
  return -1 if grid[0][0] == 1 || grid[n-1][n-1] == 1
  return 1  if n == 1

  dirs  = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
  grid  = grid.map(&:dup)         # clone to mark visited in-place
  queue = [[0, 0, 1]]
  grid[0][0] = 1                  # mark as visited

  until queue.empty?
    r, c, dist = queue.shift
    dirs.each do |dr, dc|
      nr, nc = r + dr, c + dc
      next if nr < 0 || nr >= n || nc < 0 || nc >= n || grid[nr][nc] != 0
      return dist + 1 if nr == n - 1 && nc == n - 1
      grid[nr][nc] = 1            # mark visited before enqueue
      queue << [nr, nc, dist + 1]
    end
  end

  -1
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{shortest_path_binary_matrix_brute([[0,1],[1,0]])}"  # 2
  puts "Opt:   #{shortest_path_binary_matrix([[0,1],[1,0]])}"         # 2
  puts "Brute: #{shortest_path_binary_matrix_brute([[0,0,0],[1,1,0],[1,1,0]])}"  # 4
  puts "Opt:   #{shortest_path_binary_matrix([[0,0,0],[1,1,0],[1,1,0]])}"         # 4
end
