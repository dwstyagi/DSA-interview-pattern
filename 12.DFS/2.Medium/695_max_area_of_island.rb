# frozen_string_literal: true

# LeetCode 695: Max Area of Island
#
# Problem:
# Given a binary grid (0=water, 1=land), return the maximum area of an island
# (connected group of 1s). Return 0 if no island.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each unvisited '1', DFS counting cells. Track max.
#    Time Complexity: O(m*n)
#    Space Complexity: O(m*n)
#
# 2. Bottleneck
#    Already optimal — DFS returns cell count from each call.
#
# 3. Optimized Accepted Approach
#    DFS returns 1 + sum of recursive calls on all 4 neighbors that are land.
#    Mark visited in-place. Track global max.
#    Time Complexity: O(m*n)
#    Space Complexity: O(m*n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[[0,0,1,0],[0,1,1,0],[0,1,0,0]]
# DFS from (0,2): → (1,2) → (2,1) → (1,1) → area=4 ✓
#
# Edge Cases:
# - All 0s -> 0
# - All 1s -> m*n

def max_area_of_island_brute(grid)
  rows, cols = grid.length, grid[0].length
  visited = Array.new(rows) { Array.new(cols, false) }
  max_area = 0

  dfs = lambda do |r, c|
    return 0 if r < 0 || r >= rows || c < 0 || c >= cols || visited[r][c] || grid[r][c] == 0
    visited[r][c] = true
    1 + dfs.call(r+1,c) + dfs.call(r-1,c) + dfs.call(r,c+1) + dfs.call(r,c-1)
  end

  rows.times { |r| cols.times { |c| max_area = [max_area, dfs.call(r, c)].max } }
  max_area
end

def max_area_of_island(grid)
  rows, cols = grid.length, grid[0].length
  grid = grid.map(&:dup)
  max_area = 0

  dfs = lambda do |r, c|
    return 0 if r < 0 || r >= rows || c < 0 || c >= cols || grid[r][c] == 0
    grid[r][c] = 0                  # mark visited in-place
    1 + dfs.call(r+1,c) + dfs.call(r-1,c) + dfs.call(r,c+1) + dfs.call(r,c-1)
  end

  rows.times { |r| cols.times { |c| max_area = [max_area, dfs.call(r, c)].max } }
  max_area
end

if __FILE__ == $PROGRAM_NAME
  grid = [[0,0,1,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,0,1,1,1,0,0,0],[0,1,1,0,1,0,0,0,0,0,0,0,0]]
  puts "Brute: #{max_area_of_island_brute(grid)}"  # 6
  puts "Opt:   #{max_area_of_island(grid)}"          # 6
end
