# frozen_string_literal: true

# LeetCode 1631: Path With Minimum Effort
#
# Problem:
# Grid heights. Effort of a path = max absolute difference between consecutive cells.
# Find path from (0,0) to (m-1,n-1) with minimum effort.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS/BFS all paths, track max difference, find minimum.
#    Time Complexity: O(m * n * 2^(m*n))
#    Space Complexity: O(m * n)
#
# 2. Bottleneck
#    Binary search on answer + BFS check. Or Dijkstra treating effort as "cost".
#
# 3. Optimized Accepted Approach
#    Dijkstra: dist[r][c] = min effort to reach (r,c). Priority queue with effort.
#    Update if new effort < recorded effort.
#
#    Time Complexity: O(m * n * log(m * n))
#    Space Complexity: O(m * n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# heights=[[1,2,2],[3,8,2],[5,3,5]]
# Start (0,0)=1: add neighbors
# (0,1)=2: effort=1; (1,0)=3: effort=2
# Process (0,1): (0,2) effort=max(1,0)=1; (1,1) effort=max(1,6)=6
# Process (0,2): (1,2) effort=max(1,0)=1
# Process (1,2): (2,2) effort=max(1,3)=3
# ... min effort to (2,2) = 2
#
# Edge Cases:
# - 1x1 grid: effort = 0
# - All same height: effort = 0

def minimum_effort_path_brute(heights)
  rows = heights.length
  cols = heights[0].length
  lo = 0
  hi = 1_000_000
  dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]

  can_reach = lambda do |effort|
    visited = Array.new(rows) { Array.new(cols, false) }
    queue = [[0, 0]]
    visited[0][0] = true
    until queue.empty?
      r, c = queue.shift
      return true if r == rows - 1 && c == cols - 1
      dirs.each do |dr, dc|
        nr, nc = r + dr, c + dc
        next if nr < 0 || nr >= rows || nc < 0 || nc >= cols || visited[nr][nc]
        next if (heights[nr][nc] - heights[r][c]).abs > effort
        visited[nr][nc] = true
        queue << [nr, nc]
      end
    end
    false
  end

  while lo < hi
    mid = (lo + hi) / 2
    can_reach.call(mid) ? hi = mid : lo = mid + 1
  end
  lo
end

def minimum_effort_path(heights)
  rows = heights.length
  cols = heights[0].length
  dist = Array.new(rows) { Array.new(cols, Float::INFINITY) }
  dist[0][0] = 0
  heap = [[0, 0, 0]]  # [effort, row, col]
  dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  until heap.empty?
    effort, r, c = heap.min
    heap.delete([effort, r, c])
    return effort if r == rows - 1 && c == cols - 1
    next if effort > dist[r][c]
    dirs.each do |dr, dc|
      nr, nc = r + dr, c + dc
      next if nr < 0 || nr >= rows || nc < 0 || nc >= cols
      new_effort = [effort, (heights[nr][nc] - heights[r][c]).abs].max
      if new_effort < dist[nr][nc]
        dist[nr][nc] = new_effort
        heap << [new_effort, nr, nc]
      end
    end
  end
  dist[rows - 1][cols - 1]
end

if __FILE__ == $PROGRAM_NAME
  puts minimum_effort_path_brute([[1, 2, 2], [3, 8, 2], [5, 3, 5]])  # 2
  puts minimum_effort_path([[1, 2, 3], [3, 8, 4], [5, 3, 5]])         # 1
end
