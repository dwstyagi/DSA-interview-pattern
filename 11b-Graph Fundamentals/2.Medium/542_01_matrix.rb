# frozen_string_literal: true

# 542. 01 Matrix
#
# 1. Problem Statement
#
# Given a matrix of 0s and 1s, return a matrix where each cell contains its
# shortest four-directional distance to a 0.
#
# 2. Brute Force Approach
#
# Intuition:
# From every 1, run BFS until the nearest 0 is found.
#
# Algorithm:
# For each cell with value 1, perform a fresh shortest-path BFS. Keep zero
# cells as 0.
#
# Time Complexity: O((m * n)^2)
# Space Complexity: O(m * n)

# 3. Brute Force Code
def update_matrix_brute(mat)
  result = Array.new(mat.length) { Array.new(mat[0].length, 0) }

  mat.each_index do |row|
    mat[row].each_index do |col|
      result[row][col] = nearest_zero_distance(mat, row, col) if mat[row][col] == 1
    end
  end

  result
end

# 4. Bottleneck Analysis
#
# Nearby 1s repeat almost the same BFS searches for a zero. Instead, reverse
# the question: let all zeros expand at once, assigning distances only once.
#
# 5. Optimization Journey
#
# Every zero has distance 0. Add all zeros to the initial BFS queue. The first
# time BFS reaches a cell is guaranteed to be its shortest distance because BFS
# explores in increasing number of edges.
#
# 6. Dry Run
#
# mat = [[0,0,0],[0,1,0],[1,1,1]]:
# - All four zeros enter queue with distance 0.
# - Their unvisited neighbors become distance 1.
# - The remaining bottom cells become distance 2 where necessary.
#
# 7. Optimal Solution
#
# Use multi-source BFS, writing a distance when a 1 is first reached.
#
# Time Complexity: O(m * n)
# Space Complexity: O(m * n)

# 8. Optimal Code
def update_matrix(mat)
  rows = mat.length
  cols = mat[0].length
  distance = Array.new(rows) { Array.new(cols, -1) }
  queue = []

  rows.times do |row|
    cols.times do |col|
      next unless mat[row][col].zero?

      distance[row][col] = 0
      queue << [row, col]
    end
  end

  head = 0
  while head < queue.length
    row, col = queue[head]
    head += 1
    matrix_neighbors(rows, cols, row, col).each do |nr, nc|
      next unless distance[nr][nc] == -1

      distance[nr][nc] = distance[row][col] + 1
      queue << [nr, nc]
    end
  end

  distance
end

def nearest_zero_distance(mat, start_row, start_col)
  visited = { [start_row, start_col] => true }
  queue = [[start_row, start_col, 0]]
  head = 0

  while head < queue.length
    row, col, distance = queue[head]
    head += 1
    return distance if mat[row][col].zero?

    matrix_neighbors(mat.length, mat[0].length, row, col).each do |nr, nc|
      next if visited[[nr, nc]]

      visited[[nr, nc]] = true
      queue << [nr, nc, distance + 1]
    end
  end
end

def matrix_neighbors(rows, cols, row, col)
  [[1, 0], [-1, 0], [0, 1], [0, -1]].filter_map do |dr, dc|
    nr = row + dr
    nc = col + dc
    [nr, nc] if nr.between?(0, rows - 1) && nc.between?(0, cols - 1)
  end
end

# Examples
if __FILE__ == $PROGRAM_NAME
  matrix = [[0, 0, 0], [0, 1, 0], [1, 1, 1]]
  p update_matrix_brute(matrix)
  p update_matrix(matrix)
end
