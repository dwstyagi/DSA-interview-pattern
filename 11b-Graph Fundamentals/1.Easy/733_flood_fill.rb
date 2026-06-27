# frozen_string_literal: true

# 733. Flood Fill
#
# 1. Problem Statement
#
# Starting from image[sr][sc], replace its color and the color of every
# four-directionally connected cell with the same original color.
#
# 2. Brute Force Approach
#
# Intuition:
# Repeatedly scan the whole image. Whenever a cell next to a changed cell still
# has the original color, change it too. Stop when a scan makes no changes.
#
# Algorithm:
# Propagate one layer at a time by full-grid scanning until the connected region
# is exhausted.
#
# Time Complexity: O((m * n)^2) in the worst case.
# Space Complexity: O(1), excluding the input image.

# 3. Brute Force Code
def flood_fill_brute(image, sr, sc, color)
  original = image[sr][sc]
  return image if original == color

  image[sr][sc] = color
  changed = true
  directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]

  while changed
    changed = false
    image.each_index do |row|
      image[row].each_index do |col|
        next unless image[row][col] == original

        touches_fill = directions.any? do |dr, dc|
          nr = row + dr
          nc = col + dc
          nr.between?(0, image.length - 1) &&
            nc.between?(0, image[0].length - 1) &&
            image[nr][nc] == color
        end
        next unless touches_fill

        image[row][col] = color
        changed = true
      end
    end
  end

  image
end

# 4. Bottleneck Analysis
#
# Full-grid scans repeatedly inspect cells outside the connected component.
# A graph traversal can visit only cells reachable from the starting cell.
#
# 5. Optimization Journey
#
# Treat every matching cell as a graph node with up to four neighbors. Change a
# cell when it is discovered, which also marks it visited. Only matching
# neighbors are added to the traversal.
#
# 6. Dry Run
#
# image = [[1,1,1],[1,1,0],[1,0,1]], start = (1,1), color = 2:
# - Color (1,1), then enqueue its matching neighbors.
# - Continue outward through the connected 1s.
# - The isolated bottom-right 1 remains unchanged.
#
# 7. Optimal Solution
#
# Run BFS from the start cell through cells with the original color.
#
# Time Complexity: O(m * n)
# Space Complexity: O(m * n) in the largest filled region.

# 8. Optimal Code
def flood_fill(image, sr, sc, color)
  original = image[sr][sc]
  return image if original == color

  queue = [[sr, sc]]
  image[sr][sc] = color
  head = 0
  directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]

  while head < queue.length
    row, col = queue[head]
    head += 1

    directions.each do |dr, dc|
      nr = row + dr
      nc = col + dc
      next unless nr.between?(0, image.length - 1) &&
                  nc.between?(0, image[0].length - 1) &&
                  image[nr][nc] == original

      image[nr][nc] = color
      queue << [nr, nc]
    end
  end

  image
end

# Examples
if __FILE__ == $PROGRAM_NAME
  image = [[1, 1, 1], [1, 1, 0], [1, 0, 1]]
  p flood_fill_brute(image.map(&:dup), 1, 1, 2)
  p flood_fill(image.map(&:dup), 1, 1, 2)
end
