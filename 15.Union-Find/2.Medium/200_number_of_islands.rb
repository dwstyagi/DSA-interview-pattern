# frozen_string_literal: true

# LeetCode 200: Number of Islands
#
# Problem:
# Given a 2D grid of '1's (land) and '0's (water), count the number of islands.
# An island is surrounded by water and formed by connecting adjacent land cells.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS/BFS from each unvisited '1', mark all connected '1's as visited.
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n)
#
# 2. Bottleneck
#    Already O(m*n). Union-Find is an alternative with same complexity.
#
# 3. Optimized Accepted Approach
#    DFS: for each unvisited '1', increment count, DFS to mark connected land.
#    Mutate grid to avoid visited array (or use separate visited).
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n) recursion stack
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid = [["1","1","0"],["0","1","0"],["0","0","1"]]
# (0,0)='1' -> count=1, DFS marks (0,0),(0,1),(1,1) -> '0'
# (2,2)='1' -> count=2
# Result: 2
#
# Edge Cases:
# - All water: 0
# - All land: 1

def num_islands_brute(grid)
  return 0 if grid.empty?
  rows = grid.length
  cols = grid[0].length
  count = 0
  visited = Array.new(rows) { Array.new(cols, false) }

  dfs = lambda do |r, c|
    return if r < 0 || r >= rows || c < 0 || c >= cols
    return if visited[r][c] || grid[r][c] == '0'
    visited[r][c] = true
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each { |dr, dc| dfs.call(r + dr, c + dc) }
  end

  rows.times do |r|
    cols.times do |c|
      next if visited[r][c] || grid[r][c] == '0'
      count += 1
      dfs.call(r, c)
    end
  end
  count
end

# optimized: mutate grid in-place (sink visited land)
def num_islands(grid)
  return 0 if grid.empty?
  rows = grid.length
  cols = grid[0].length
  count = 0

  sink = lambda do |r, c|
    return if r < 0 || r >= rows || c < 0 || c >= cols || grid[r][c] != '1'
    grid[r][c] = '0'
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each { |dr, dc| sink.call(r + dr, c + dc) }
  end

  rows.times do |r|
    cols.times do |c|
      next unless grid[r][c] == '1'
      count += 1
      sink.call(r, c)
    end
  end
  count
end

if __FILE__ == $PROGRAM_NAME
  grid1 = [%w[1 1 0], %w[0 1 0], %w[0 0 1]]
  puts num_islands_brute(grid1)  # 2
  grid2 = [%w[1 1 1 1 0], %w[1 1 0 1 0], %w[1 1 0 0 0], %w[0 0 0 0 0]]
  puts num_islands(grid2)        # 1
end
