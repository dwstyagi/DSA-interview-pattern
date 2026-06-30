# frozen_string_literal: true

# 778. Swim in Rising Water
#
# 1. Problem Statement
#
# Given an n x n grid where grid[row][col] is the time when that cell becomes
# passable, return the earliest time you can move from the top-left cell to the
# bottom-right cell.
#
# 2. Brute Force Approach
#
# Intuition:
# Try each possible time and check whether a path exists using only cells whose
# values are at most that time.
#
# Algorithm:
# For time from grid[0][0] upward, run DFS/BFS over available cells. Return the
# first time that reaches the target.
#
# Time Complexity: O(n^4) in the worst case.
# Space Complexity: O(n^2)

# 3. Brute Force Code
def swim_in_water_brute(grid)
  time = grid[0][0]
  max_time = grid.flatten.max

  while time <= max_time
    return time if reachable_at_time?(grid, time)

    time += 1
  end
end

# 4. Bottleneck Analysis
#
# Rechecking reachability from scratch for every time repeats nearly identical
# searches. The route cost is the maximum cell value along the path, so this is
# a shortest-path problem where path cost is a max operation instead of a sum.
#
# 5. Optimization Journey
#
# Use a min-heap ordered by cell height. Always step into the lowest available
# frontier cell next. The answer for a route is the maximum height seen so far.
# When the target is popped, that maximum is minimal because all lower-frontier
# options have already been considered.
#
# 6. Dry Run
#
# grid = [[0,2],[1,3]]:
# - Start at 0, answer so far 0.
# - Heap has 1 and 2; pop 1 first, answer becomes 1.
# - Eventually pop 3 at target, answer becomes 3.
#
# 7. Optimal Solution
#
# Run Dijkstra-like best-first search over grid cells, using the current cell
# elevation as the priority and tracking the maximum elevation popped so far.
#
# Time Complexity: O(n^2 log n)
# Space Complexity: O(n^2)

# 8. Optimal Code
def swim_in_water(grid)
  rows = grid.length
  heap = WaterMinHeap.new
  heap.push([grid[0][0], 0, 0])
  visited = { [0, 0] => true }
  answer = 0

  until heap.empty?
    height, row, col = heap.pop
    answer = [answer, height].max
    return answer if row == rows - 1 && col == rows - 1

    water_neighbors(rows, row, col).each do |nr, nc|
      next if visited[[nr, nc]]

      visited[[nr, nc]] = true
      heap.push([grid[nr][nc], nr, nc])
    end
  end
end

def reachable_at_time?(grid, time)
  return false if grid[0][0] > time

  n = grid.length
  visited = { [0, 0] => true }
  stack = [[0, 0]]

  until stack.empty?
    row, col = stack.pop
    return true if row == n - 1 && col == n - 1

    water_neighbors(n, row, col).each do |nr, nc|
      next if visited[[nr, nc]] || grid[nr][nc] > time

      visited[[nr, nc]] = true
      stack << [nr, nc]
    end
  end

  false
end

def water_neighbors(n, row, col)
  [[1, 0], [-1, 0], [0, 1], [0, -1]].filter_map do |dr, dc|
    nr = row + dr
    nc = col + dc
    [nr, nc] if nr.between?(0, n - 1) && nc.between?(0, n - 1)
  end
end

class WaterMinHeap
  def initialize
    @data = []
  end

  def push(value)
    @data << value
    sift_up(@data.length - 1)
  end

  def pop
    swap(0, @data.length - 1)
    minimum = @data.pop
    sift_down(0)
    minimum
  end

  def empty?
    @data.empty?
  end

  private

  def sift_up(index)
    while index.positive?
      parent = (index - 1) / 2
      break if @data[parent][0] <= @data[index][0]

      swap(parent, index)
      index = parent
    end
  end

  def sift_down(index)
    loop do
      left = (index * 2) + 1
      right = left + 1
      smallest = index
      smallest = left if left < @data.length && @data[left][0] < @data[smallest][0]
      smallest = right if right < @data.length && @data[right][0] < @data[smallest][0]
      break if smallest == index

      swap(index, smallest)
      index = smallest
    end
  end

  def swap(first, second)
    @data[first], @data[second] = @data[second], @data[first]
  end
end

# Examples
if __FILE__ == $PROGRAM_NAME
  grid = [[0, 2], [1, 3]]
  p swim_in_water_brute(grid) # 3
  p swim_in_water(grid) # 3
end
