# frozen_string_literal: true

# LeetCode 200: Number of Islands
#
# Problem:
# Given an m x n 2D binary grid of '1's (land) and '0's (water), return the
# number of islands. An island is surrounded by water and formed by connecting
# adjacent lands horizontally or vertically.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each unvisited land cell, DFS/BFS to mark entire island, count islands.
#    This is already optimal — every cell visited once.
#    Time Complexity: O(m*n)
#    Space Complexity: O(m*n) — visited set or recursion stack
#
# 2. Bottleneck
#    No improvement needed in complexity; BFS avoids recursion stack overflow.
#
# 3. Optimized Accepted Approach
#    BFS flood-fill. For each '1' cell, BFS marks all connected land as visited
#    (by changing to '0' in-place or using a visited set). Increment count.
#    Time Complexity: O(m*n)
#    Space Complexity: O(min(m,n)) — BFS queue at most diagonal width
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid = [["1","1","0"],["0","1","0"],["0","0","1"]]
# (0,0)='1' → BFS marks (0,0),(0,1),(1,1) → count=1
# (2,2)='1' → BFS marks (2,2) → count=2
# result = 2 ✓
#
# Edge Cases:
# - All water -> 0
# - All land -> 1
# - Single cell '1' -> 1

def num_islands_brute(grid)
  return 0 if grid.empty?
  grid = grid.map(&:dup)  # don't modify input
  count = 0
  dirs = [[-1,0],[1,0],[0,-1],[0,1]]

  dfs = lambda do |r, c|
    return if r < 0 || r >= grid.length || c < 0 || c >= grid[0].length
    return if grid[r][c] != '1'
    grid[r][c] = '0'
    dirs.each { |dr, dc| dfs.call(r + dr, c + dc) }
  end

  grid.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      next unless cell == '1'
      count += 1
      dfs.call(r, c)
    end
  end
  count
end

def num_islands(grid)
  return 0 if grid.empty?
  grid  = grid.map(&:dup)   # clone to avoid mutating input
  count = 0
  dirs  = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  grid.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      next unless cell == '1'

      count += 1
      queue = [[r, c]]
      grid[r][c] = '0'                     # mark visited immediately

      until queue.empty?
        cr, cc = queue.shift
        dirs.each do |dr, dc|
          nr, nc = cr + dr, cc + dc
          next if nr < 0 || nr >= grid.length || nc < 0 || nc >= grid[0].length
          next if grid[nr][nc] != '1'
          grid[nr][nc] = '0'               # mark before enqueue to avoid duplicates
          queue << [nr, nc]
        end
      end
    end
  end

  count
end

if __FILE__ == $PROGRAM_NAME
  grid1 = [["1","1","0","0","0"],["1","1","0","0","0"],["0","0","1","0","0"],["0","0","0","1","1"]]
  puts "Brute: #{num_islands_brute(grid1)}"  # 3
  puts "Opt:   #{num_islands(grid1)}"         # 3
end
