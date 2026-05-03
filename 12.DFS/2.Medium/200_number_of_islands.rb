# frozen_string_literal: true

# LeetCode 200: Number of Islands (DFS approach)
#
# Problem:
# Given an m x n grid of '1's (land) and '0's (water), return the number of
# islands (connected land components).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each '1' cell, recursively flood-fill marking connected land.
#    Count how many times we start a new flood-fill.
#    Time Complexity: O(m*n)
#    Space Complexity: O(m*n) — recursion stack
#
# 2. Bottleneck
#    Already optimal — DFS marks each cell exactly once.
#
# 3. Optimized Accepted Approach
#    DFS flood-fill: mutate grid in-place ('1' → '0') to mark visited.
#    Avoids extra visited array.
#    Time Complexity: O(m*n)
#    Space Complexity: O(m*n) worst case recursion stack (for a single island)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[["1","1","0"],["0","1","0"],["0","0","1"]]
# (0,0)=1: DFS marks (0,0),(0,1),(1,1) → count=1
# (2,2)=1: DFS marks (2,2) → count=2
# result=2 ✓
#
# Edge Cases:
# - All water -> 0
# - All land -> 1

def num_islands_brute(grid)
  return 0 if grid.empty?
  grid  = grid.map(&:dup)
  count = 0
  dirs  = [[-1,0],[1,0],[0,-1],[0,1]]

  dfs = lambda do |r, c|
    return if r < 0 || r >= grid.length || c < 0 || c >= grid[0].length || grid[r][c] != '1'
    grid[r][c] = '0'
    dirs.each { |dr, dc| dfs.call(r + dr, c + dc) }
  end

  grid.each_with_index { |row, r| row.each_with_index { |v, c| (count += 1; dfs.call(r, c)) if v == '1' } }
  count
end

def num_islands(grid)
  return 0 if grid.empty?
  grid  = grid.map(&:dup)
  count = 0
  rows, cols = grid.length, grid[0].length

  dfs = lambda do |r, c|
    return if r < 0 || r >= rows || c < 0 || c >= cols
    return if grid[r][c] != '1'
    grid[r][c] = '0'               # mark visited in-place
    dfs.call(r + 1, c)
    dfs.call(r - 1, c)
    dfs.call(r, c + 1)
    dfs.call(r, c - 1)
  end

  rows.times do |r|
    cols.times do |c|
      next unless grid[r][c] == '1'
      count += 1
      dfs.call(r, c)
    end
  end

  count
end

if __FILE__ == $PROGRAM_NAME
  grid = [["1","1","0","0","0"],["1","1","0","0","0"],["0","0","1","0","0"],["0","0","0","1","1"]]
  puts "Brute: #{num_islands_brute(grid)}"  # 3
  puts "Opt:   #{num_islands(grid)}"         # 3
end
