# frozen_string_literal: true

# LeetCode 778: Swim in Rising Water
#
# Problem:
# Grid where grid[r][c] is elevation. Wait t seconds for water to reach elevation t.
# Find minimum t to swim from (0,0) to (n-1,n-1).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each t from 0 to n^2-1, check if path exists using BFS where cells
#    with elevation > t are blocked.
#    Time Complexity: O(n^4)
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    Binary search on t with BFS check: O(n^2 log n).
#    Or: Union-Find on sorted cells by elevation.
#
# 3. Optimized Accepted Approach
#    Dijkstra/Binary search + BFS. Simpler: sort all cells by elevation,
#    add them one by one via Union-Find. When (0,0) and (n-1,n-1) connected, return t.
#
#    Time Complexity: O(n^2 log n)
#    Space Complexity: O(n^2)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[[0,2],[1,3]] n=2
# sorted cells by elevation: [(0,0,0),(1,0,1),(0,1,2),(1,1,3)]
# add (0,0): connected to none, check: no
# add (1,0): union (0,0)-(1,0), check if 0,0 connected to 1,1: no
# add (0,1): union (0,0)-(0,1), check: no
# add (1,1): union (1,0)-(1,1) and (0,1)-(1,1) -> all connected -> return elevation=3
#
# Edge Cases:
# - n=1: return grid[0][0]

def swim_in_water_brute(grid)
  n = grid.length
  can_swim = lambda do |t|
    return false if grid[0][0] > t
    visited = Array.new(n) { Array.new(n, false) }
    stack = [[0, 0]]
    while stack.any?
      r, c = stack.pop
      return true if r == n - 1 && c == n - 1
      next if visited[r][c]
      visited[r][c] = true
      [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dr, dc|
        nr, nc = r + dr, c + dc
        next if nr < 0 || nr >= n || nc < 0 || nc >= n || visited[nr][nc] || grid[nr][nc] > t
        stack << [nr, nc]
      end
    end
    false
  end
  (0...n * n).find { |t| can_swim.call(t) }
end

# optimized: Union-Find on cells sorted by elevation
def swim_in_water(grid)
  n = grid.length
  parent = Array.new(n * n) { |i| i }
  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }
  union = lambda do |a, b|
    pa, pb = find.call(a), find.call(b)
    parent[pa] = pb unless pa == pb
  end

  added = Array.new(n) { Array.new(n, false) }
  cells = (0...n).flat_map { |r| (0...n).map { |c| [grid[r][c], r, c] } }.sort

  cells.each do |t, r, c|
    added[r][c] = true
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dr, dc|
      nr, nc = r + dr, c + dc
      next if nr < 0 || nr >= n || nc < 0 || nc >= n || !added[nr][nc]
      union.call(r * n + c, nr * n + nc)
    end
    return t if find.call(0) == find.call(n * n - 1)
  end
  n * n - 1
end

if __FILE__ == $PROGRAM_NAME
  puts swim_in_water_brute([[0, 2], [1, 3]])  # 3
  puts swim_in_water([[0, 1, 2, 3, 4], [24, 23, 22, 21, 5], [12, 13, 14, 15, 16],
                      [11, 17, 18, 19, 20], [10, 9, 8, 7, 6]])  # 16
end
