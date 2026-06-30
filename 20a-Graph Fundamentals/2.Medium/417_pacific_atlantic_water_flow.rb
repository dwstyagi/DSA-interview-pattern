# frozen_string_literal: true

# 417. Pacific Atlantic Water Flow
#
# 1. Problem Statement
#
# Return grid coordinates from which water can flow to both the Pacific (top or
# left border) and Atlantic (bottom or right border) oceans. Water flows from a
# cell to equal-or-lower neighboring heights.
#
# 2. Brute Force Approach
#
# Intuition:
# Start a search from every cell and independently check whether it can reach
# each ocean.
#
# Algorithm:
# For every cell, run two DFS traversals downhill, one looking for Pacific and
# one looking for Atlantic.
#
# Time Complexity: O((m * n)^2)
# Space Complexity: O(m * n)

# 3. Brute Force Code
def pacific_atlantic_brute(heights)
  result = []
  heights.each_index do |row|
    heights[row].each_index do |col|
      result << [row, col] if reaches_ocean?(heights, row, col, :pacific) &&
                               reaches_ocean?(heights, row, col, :atlantic)
    end
  end
  result
end

# 4. Bottleneck Analysis
#
# Adjacent cells repeat almost identical downhill searches. Reverse each edge:
# instead of asking which cells can reach an ocean, start at the ocean and move
# uphill to every cell that can flow into it.
#
# 5. Optimization Journey
#
# In reverse flow, a cell can move to an equal-or-higher neighbor. Run one DFS
# from all Pacific-border cells and one from all Atlantic-border cells. A cell
# in both visited sets can reach both oceans in the original direction.
#
# 6. Dry Run
#
# A Pacific traversal begins along the top and left borders. It climbs only to
# equal-or-higher cells. The Atlantic traversal does the same from bottom and
# right. Intersecting their marked coordinates gives the answer.
#
# 7. Optimal Solution
#
# Perform two multi-source reverse DFS traversals and intersect their visited
# sets.
#
# Time Complexity: O(m * n)
# Space Complexity: O(m * n)

# 8. Optimal Code
def pacific_atlantic(heights)
  rows = heights.length
  cols = heights[0].length
  pacific = {}
  atlantic = {}

  rows.times do |row|
    flow_uphill(heights, row, 0, pacific)
    flow_uphill(heights, row, cols - 1, atlantic)
  end
  cols.times do |col|
    flow_uphill(heights, 0, col, pacific)
    flow_uphill(heights, rows - 1, col, atlantic)
  end

  pacific.keys.select { |cell| atlantic[cell] }
end

def reaches_ocean?(heights, row, col, ocean)
  visited = { [row, col] => true }
  stack = [[row, col]]

  until stack.empty?
    current_row, current_col = stack.pop
    return true if ocean == :pacific && (current_row.zero? || current_col.zero?)
    return true if ocean == :atlantic && (current_row == heights.length - 1 || current_col == heights[0].length - 1)

    flow_neighbors(heights, current_row, current_col).each do |nr, nc|
      next if visited[[nr, nc]] || heights[nr][nc] > heights[current_row][current_col]

      visited[[nr, nc]] = true
      stack << [nr, nc]
    end
  end

  false
end

def flow_uphill(heights, start_row, start_col, visited)
  stack = [[start_row, start_col]]
  until stack.empty?
    row, col = stack.pop
    next if visited[[row, col]]

    visited[[row, col]] = true
    flow_neighbors(heights, row, col).each do |nr, nc|
      stack << [nr, nc] if heights[nr][nc] >= heights[row][col] && !visited[[nr, nc]]
    end
  end
end

def flow_neighbors(heights, row, col)
  [[1, 0], [-1, 0], [0, 1], [0, -1]].filter_map do |dr, dc|
    nr = row + dr
    nc = col + dc
    [nr, nc] if nr.between?(0, heights.length - 1) && nc.between?(0, heights[0].length - 1)
  end
end

# Examples
if __FILE__ == $PROGRAM_NAME
  heights = [[1, 2, 2], [3, 2, 3], [2, 4, 5]]
  p pacific_atlantic_brute(heights).sort
  p pacific_atlantic(heights).sort
end
