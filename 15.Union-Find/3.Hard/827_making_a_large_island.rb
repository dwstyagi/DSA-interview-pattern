# frozen_string_literal: true

# LeetCode 827: Making A Large Island
#
# Problem:
# Change at most one 0 to 1 in a binary grid. Return the size of the largest island.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each 0 cell, flip to 1, run BFS to find largest island, then restore.
#    Time Complexity: O(n^4)
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    Label each island with Union-Find and record sizes. Then for each 0 cell,
#    sum sizes of distinct neighboring islands + 1.
#
# 3. Optimized Accepted Approach
#    Pass 1: Union-Find to label islands and track component sizes.
#    Pass 2: For each 0 cell, sum sizes of unique neighbor components + 1.
#    Return max.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n^2)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[[1,0],[0,1]]
# Island at (0,0): size=1, id=0; island at (1,1): size=1, id=3
# Flip (0,1): neighbors (0,0) and (1,1) distinct -> 1+1+1=3
# Flip (1,0): same -> 3
# Result: 3
#
# Edge Cases:
# - All 1s: no 0 to flip, return n^2
# - All 0s: return 1

def largest_island_brute(grid)
  n = grid.length
  best = 0

  count_island = lambda do |r, c, visited|
    return 0 if r < 0 || r >= n || c < 0 || c >= n || visited[r][c] || grid[r][c] == 0
    visited[r][c] = true
    1 + count_island.call(r+1,c,visited) + count_island.call(r-1,c,visited) +
        count_island.call(r,c+1,visited) + count_island.call(r,c-1,visited)
  end

  has_zero = false
  n.times do |r|
    n.times do |c|
      next unless grid[r][c] == 0
      has_zero = true
      grid[r][c] = 1
      visited = Array.new(n) { Array.new(n, false) }
      best = [best, count_island.call(r, c, visited)].max
      grid[r][c] = 0
    end
  end
  has_zero ? best : n * n
end

# optimized: Union-Find + component size map
def largest_island(grid)
  n = grid.length
  parent = Array.new(n * n) { |i| i }
  size = Array.new(n * n, 1)

  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }
  union = lambda do |a, b|
    pa, pb = find.call(a), find.call(b)
    return if pa == pb
    if size[pa] < size[pb] then parent[pa] = pb; size[pb] += size[pa]
    else parent[pb] = pa; size[pa] += size[pb]
    end
  end

  dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  n.times do |r|
    n.times do |c|
      next if grid[r][c] == 0
      dirs.each do |dr, dc|
        nr, nc = r + dr, c + dc
        union.call(r * n + c, nr * n + nc) if nr >= 0 && nr < n && nc >= 0 && nc < n && grid[nr][nc] == 1
      end
    end
  end

  best = size.max
  n.times do |r|
    n.times do |c|
      next unless grid[r][c] == 0
      neighbors = dirs.filter_map do |dr, dc|
        nr, nc = r + dr, c + dc
        find.call(nr * n + nc) if nr >= 0 && nr < n && nc >= 0 && nc < n && grid[nr][nc] == 1
      end.uniq
      total = 1 + neighbors.sum { |root| size[root] }
      best = [best, total].max
    end
  end
  best
end

if __FILE__ == $PROGRAM_NAME
  puts largest_island_brute([[1, 0], [0, 1]])  # 3
  puts largest_island([[1, 1], [1, 0]])         # 4
end
