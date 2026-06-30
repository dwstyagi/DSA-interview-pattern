# frozen_string_literal: true

# 994. Rotting Oranges
#
# 1. Problem Statement
#
# In a grid, 0 is empty, 1 is fresh, and 2 is rotten. Every minute, rotten
# oranges make adjacent fresh oranges rotten. Return the minutes needed to rot
# all fresh oranges, or -1 if impossible.
#
# 2. Brute Force Approach
#
# Intuition:
# Simulate each minute by scanning the entire grid and finding fresh oranges
# adjacent to a rotten orange from the previous minute.
#
# Algorithm:
# Repeatedly scan for fresh cells bordering a currently rotten cell, mark them
# for the next round, and stop once a round makes no change.
#
# Time Complexity: O((m * n)^2)
# Space Complexity: O(m * n)

# 3. Brute Force Code
def oranges_rotting_brute(grid)
  minutes = 0

  loop do
    to_rot = []
    grid.each_index do |row|
      grid[row].each_index do |col|
        next unless grid[row][col] == 1

        to_rot << [row, col] if orange_neighbors(grid, row, col).any? { |nr, nc| grid[nr][nc] == 2 }
      end
    end

    break if to_rot.empty?

    to_rot.each { |row, col| grid[row][col] = 2 }
    minutes += 1
  end

  grid.flatten.include?(1) ? -1 : minutes
end

# 4. Bottleneck Analysis
#
# Full-grid scanning repeats work for cells far from the rotting frontier. The
# oranges that are rotten at one minute are exactly the only cells that can
# affect the next minute.
#
# 5. Optimization Journey
#
# Put all initially rotten oranges into a queue. They are all BFS sources at
# distance 0. Processing one queue layer corresponds to one minute, and newly
# rotten oranges form the next layer.
#
# 6. Dry Run
#
# grid = [[2,1,1],[1,1,0],[0,1,1]]:
# - Minute 0 queue: [(0,0)].
# - Minute 1 rots (0,1) and (1,0).
# - Each following BFS layer represents the next minute.
# - All fresh oranges are gone after 4 minutes.
#
# 7. Optimal Solution
#
# Run multi-source BFS from every initially rotten orange and track fresh count.
#
# Time Complexity: O(m * n)
# Space Complexity: O(m * n)

# 8. Optimal Code
def oranges_rotting(grid)
  queue = []
  fresh = 0

  grid.each_index do |row|
    grid[row].each_index do |col|
      queue << [row, col] if grid[row][col] == 2
      fresh += 1 if grid[row][col] == 1
    end
  end

  minutes = 0
  head = 0
  while head < queue.length && fresh.positive?
    level_end = queue.length
    while head < level_end
      row, col = queue[head]
      head += 1
      orange_neighbors(grid, row, col).each do |nr, nc|
        next unless grid[nr][nc] == 1

        grid[nr][nc] = 2
        fresh -= 1
        queue << [nr, nc]
      end
    end
    minutes += 1
  end

  fresh.zero? ? minutes : -1
end

def orange_neighbors(grid, row, col)
  [[1, 0], [-1, 0], [0, 1], [0, -1]].filter_map do |dr, dc|
    nr = row + dr
    nc = col + dc
    [nr, nc] if nr.between?(0, grid.length - 1) && nc.between?(0, grid[0].length - 1)
  end
end

# Examples
if __FILE__ == $PROGRAM_NAME
  grid = [[2, 1, 1], [1, 1, 0], [0, 1, 1]]
  p oranges_rotting_brute(grid.map(&:dup)) # 4
  p oranges_rotting(grid.map(&:dup)) # 4
end
