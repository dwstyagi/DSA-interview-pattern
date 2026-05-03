# frozen_string_literal: true

# LeetCode 778: Swim in Rising Water
#
# Problem:
# Given an n x n grid where grid[i][j] is the elevation at (i,j). At time t,
# water rises to t. You can swim from cell to cell if both cells have elevation
# <= t and they are 4-directionally adjacent. Find the minimum t to swim from
# top-left (0,0) to bottom-right (n-1,n-1).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS/DFS for each time t from 0 upward until path exists.
#    Time Complexity: O(n^2 * n^2) = O(n^4)
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    Linear time scan — binary search on t in [grid[0][0], n^2-1].
#
# 3. Optimized Accepted Approach
#    Binary search t. Feasibility: can we reach (n-1,n-1) from (0,0) visiting
#    only cells with elevation <= t? Check via DFS/BFS.
#    Direction: min feasible.
#    Time Complexity: O(n^2 log n)
#    Space Complexity: O(n^2)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[[0,2],[1,3]], n=2
# lo=0, hi=3 → mid=1 → can reach? 0->1(elev1<=1 ✓)->3(elev3>1 ✗) try 0->2(>1 ✗) → no → lo=2
# mid=2 → 0->2(<=2 ✓)->3(>2 ✗), 0->1(<=2 ✓)->3(>2 ✗) → no → lo=3
# lo=3, hi=3 → return 3 ✓
#
# Edge Cases:
# - n=1 -> grid[0][0]
# - Already connected at grid[0][0] time

def swim_in_water_brute(grid)
  n    = grid.length
  dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  can_reach = lambda do |t|
    return false if grid[0][0] > t
    visited = Array.new(n) { Array.new(n, false) }
    stack   = [[0, 0]]
    visited[0][0] = true
    until stack.empty?
      r, c = stack.pop
      return true if r == n - 1 && c == n - 1
      dirs.each do |dr, dc|
        nr, nc = r + dr, c + dc
        next if nr < 0 || nr >= n || nc < 0 || nc >= n
        next if visited[nr][nc] || grid[nr][nc] > t
        visited[nr][nc] = true
        stack << [nr, nc]
      end
    end
    false
  end

  t = grid[0][0]
  t += 1 until can_reach.call(t)
  t
end

def swim_in_water(grid)
  n    = grid.length
  dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  can_reach = lambda do |t|
    return false if grid[0][0] > t
    visited = Array.new(n) { Array.new(n, false) }
    stack   = [[0, 0]]
    visited[0][0] = true
    until stack.empty?
      r, c = stack.pop
      return true if r == n - 1 && c == n - 1
      dirs.each do |dr, dc|
        nr, nc = r + dr, c + dc
        next if nr < 0 || nr >= n || nc < 0 || nc >= n
        next if visited[nr][nc] || grid[nr][nc] > t
        visited[nr][nc] = true
        stack << [nr, nc]
      end
    end
    false
  end

  lo = grid[0][0]
  hi = n * n - 1

  while lo < hi
    mid = (lo + hi) / 2
    can_reach.call(mid) ? hi = mid : lo = mid + 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{swim_in_water_brute([[0, 2], [1, 3]])}"           # 3
  puts "Opt:   #{swim_in_water([[0, 2], [1, 3]])}"                  # 3
  puts "Brute: #{swim_in_water_brute([[0, 1, 2, 3, 4], [24, 23, 22, 21, 5], [12, 13, 14, 15, 16], [11, 17, 18, 19, 20], [10, 9, 8, 7, 6]])}" # 16
  puts "Opt:   #{swim_in_water([[0, 1, 2, 3, 4], [24, 23, 22, 21, 5], [12, 13, 14, 15, 16], [11, 17, 18, 19, 20], [10, 9, 8, 7, 6]])}"        # 16
end
