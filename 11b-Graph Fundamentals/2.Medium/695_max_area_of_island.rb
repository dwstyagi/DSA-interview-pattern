# frozen_string_literal: true

# 695. Max Area of Island
#
# 1. Problem Statement
#
# Given a binary grid, return the largest number of four-directionally
# connected land cells in any island.
#
# 2. Brute Force Approach
#
# Intuition:
# Start a search at every land cell and count its entire connected island.
#
# Algorithm:
# Create a fresh visited set for each land cell, run DFS, and keep the largest
# count returned.
#
# Time Complexity: O((m * n)^2)
# Space Complexity: O(m * n)

# 3. Brute Force Code
def max_area_of_island_brute(grid)
  largest = 0

  grid.each_index do |row|
    grid[row].each_index do |col|
      next unless grid[row][col] == 1

      largest = [largest, island_area(grid, row, col, {})].max
    end
  end

  largest
end

# 4. Bottleneck Analysis
#
# Every cell in a large island recomputes that island's whole area. Global
# marking lets one traversal count each island once.
#
# 5. Optimization Journey
#
# When scanning finds an unvisited land cell, it must be the first encounter
# for one island. DFS changes that island's cells to 0 while counting them.
# Compare the finished count to the answer.
#
# 6. Dry Run
#
# Grid [[0,0,1],[1,1,1],[0,1,0]]:
# - The first land at (0,2) starts a flood fill.
# - It reaches five connected land cells.
# - The largest area becomes 5.
#
# 7. Optimal Solution
#
# Flood-fill each island once and update the maximum with its area.
#
# Time Complexity: O(m * n)
# Space Complexity: O(m * n)

# 8. Optimal Code
def max_area_of_island(grid)
  largest = 0

  grid.each_index do |row|
    grid[row].each_index do |col|
      next unless grid[row][col] == 1

      largest = [largest, sink_and_count(grid, row, col)].max
    end
  end

  largest
end

def island_area(grid, start_row, start_col, visited)
  key = [start_row, start_col]
  return 0 if visited[key] || grid[start_row][start_col].zero?

  visited[key] = true
  1 + area_neighbors(grid, start_row, start_col).sum do |row, col|
    island_area(grid, row, col, visited)
  end
end

def sink_and_count(grid, start_row, start_col)
  stack = [[start_row, start_col]]
  grid[start_row][start_col] = 0
  area = 0

  until stack.empty?
    row, col = stack.pop
    area += 1
    area_neighbors(grid, row, col).each do |nr, nc|
      next if grid[nr][nc].zero?

      grid[nr][nc] = 0
      stack << [nr, nc]
    end
  end

  area
end

def area_neighbors(grid, row, col)
  [[1, 0], [-1, 0], [0, 1], [0, -1]].filter_map do |dr, dc|
    nr = row + dr
    nc = col + dc
    [nr, nc] if nr.between?(0, grid.length - 1) && nc.between?(0, grid[0].length - 1)
  end
end

# Examples
if __FILE__ == $PROGRAM_NAME
  grid = [[0, 0, 1], [1, 1, 1], [0, 1, 0]]
  p max_area_of_island_brute(grid) # 5
  p max_area_of_island(grid.map(&:dup)) # 5
end
