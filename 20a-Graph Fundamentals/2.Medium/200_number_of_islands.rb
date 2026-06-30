# frozen_string_literal: true

# 200. Number of Islands
#
# 1. Problem Statement
#
# Given a grid of '1' land and '0' water, return the number of islands formed
# by four-directionally connected land cells.
#
# 2. Brute Force Approach
#
# Intuition:
# For every land cell, repeatedly search the grid to decide whether it belongs
# to a previously discovered island.
#
# Algorithm:
# Build the reachable land set for each land cell and store unique sets.
#
# Time Complexity: O((m * n)^2)
# Space Complexity: O((m * n)^2) in the worst case.

# 3. Brute Force Code
def num_islands_brute(grid)
  islands = {}

  grid.each_index do |row|
    grid[row].each_index do |col|
      next unless grid[row][col] == '1'

      cells = island_cells(grid, row, col)
      islands[cells.sort] = true
    end
  end

  islands.length
end

# 4. Bottleneck Analysis
#
# Every land cell in one island launches the same flood fill. Once a flood fill
# discovers an island, its cells should be marked so none of them starts again.
#
# 5. Optimization Journey
#
# Scan the grid. A '1' starts a new island, then DFS changes every connected
# land cell to '0'. The mutation acts as the visited set and guarantees each
# cell is processed once.
#
# 6. Dry Run
#
# For [['1','1','0'],['0','1','0'],['1','0','1']]:
# - (0,0) starts island 1 and clears (0,0), (0,1), (1,1).
# - (2,0) starts island 2.
# - (2,2) starts island 3.
#
# 7. Optimal Solution
#
# Count flood-fill starts while turning visited land into water.
#
# Time Complexity: O(m * n)
# Space Complexity: O(m * n) in the worst-case DFS stack.

# 8. Optimal Code
def num_islands(grid)
  islands = 0

  grid.each_index do |row|
    grid[row].each_index do |col|
      next unless grid[row][col] == '1'

      islands += 1
      sink_island(grid, row, col)
    end
  end

  islands
end

def island_cells(grid, start_row, start_col)
  cells = []
  visited = { [start_row, start_col] => true }
  stack = [[start_row, start_col]]

  until stack.empty?
    row, col = stack.pop
    cells << [row, col]
    grid_neighbors(grid, row, col).each do |nr, nc|
      next unless grid[nr][nc] == '1' && !visited[[nr, nc]]

      visited[[nr, nc]] = true
      stack << [nr, nc]
    end
  end

  cells
end

def sink_island(grid, start_row, start_col)
  stack = [[start_row, start_col]]
  grid[start_row][start_col] = '0'

  until stack.empty?
    row, col = stack.pop
    grid_neighbors(grid, row, col).each do |nr, nc|
      next unless grid[nr][nc] == '1'

      grid[nr][nc] = '0'
      stack << [nr, nc]
    end
  end
end

def grid_neighbors(grid, row, col)
  [[1, 0], [-1, 0], [0, 1], [0, -1]].filter_map do |dr, dc|
    nr = row + dr
    nc = col + dc
    [nr, nc] if nr.between?(0, grid.length - 1) && nc.between?(0, grid[0].length - 1)
  end
end

# Examples
if __FILE__ == $PROGRAM_NAME
  grid = [['1', '1', '0'], ['0', '1', '0'], ['1', '0', '1']]
  p num_islands_brute(grid) # 3
  p num_islands(grid.map(&:dup)) # 3
end
