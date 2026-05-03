# frozen_string_literal: true

# LeetCode 934: Shortest Bridge
#
# Problem:
# Given an n x n binary matrix grid (exactly two islands), return the minimum
# number of 0s you must flip to connect the two islands.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Find all cells of island 1, find all cells of island 2, compute min
#    Manhattan distance between any pair minus 1.
#    Time Complexity: O(n^4)
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    Pairwise distance check — DFS to mark island 1, then BFS outward to reach
#    island 2.
#
# 3. Optimized Accepted Approach
#    DFS: find first land cell, flood-fill island 1 (mark with 2), enqueue all
#    its cells. BFS: expand outward layer by layer until we hit a '1' (island 2).
#    The BFS level count is the answer.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n^2)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[[0,1],[1,0]]
# DFS marks (0,1) as 2 → queue=[(0,1)]
# BFS level 1: expand (0,1) → (1,1)=0 mark, (0,0)=0 mark; expand (1,0)=1 → found! → return 1 ✓
#
# Edge Cases:
# - Islands already adjacent -> 0
# - Islands separated by large water body -> BFS levels

def shortest_bridge(grid)
  n    = grid.length
  dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]]
  grid = grid.map(&:dup)
  queue = []

  dfs = lambda do |r, c|
    return if r < 0 || r >= n || c < 0 || c >= n || grid[r][c] != 1
    grid[r][c] = 2     # mark as visited island 1
    queue << [r, c]    # enqueue for BFS start
    dirs.each { |dr, dc| dfs.call(r + dr, c + dc) }
  end

  # Find the first land cell to start DFS
  found = false
  n.times do |r|
    break if found
    n.times do |c|
      if grid[r][c] == 1
        dfs.call(r, c)
        found = true
        break
      end
    end
  end

  # BFS from all island-1 cells, count layers until island 2
  steps = 0
  until queue.empty?
    queue.size.times do
      r, c = queue.shift
      dirs.each do |dr, dc|
        nr, nc = r + dr, c + dc
        next if nr < 0 || nr >= n || nc < 0 || nc >= n
        return steps if grid[nr][nc] == 1    # reached island 2
        next if grid[nr][nc] != 0
        grid[nr][nc] = 2                     # mark water as visited
        queue << [nr, nc]
      end
    end
    steps += 1
  end

  -1 # unreachable for valid input
end

def shortest_bridge_brute(grid)
  n = grid.length
  islands = []
  visited = Array.new(n) { Array.new(n, false) }
  dirs = [[-1,0],[1,0],[0,-1],[0,1]]

  dfs = lambda do |r, c, island|
    return if r < 0 || r >= n || c < 0 || c >= n || visited[r][c] || grid[r][c] == 0
    visited[r][c] = true
    island << [r, c]
    dirs.each { |dr, dc| dfs.call(r + dr, c + dc, island) }
  end

  n.times do |r|
    n.times do |c|
      next if visited[r][c] || grid[r][c] == 0
      island = []
      dfs.call(r, c, island)
      islands << island
      break if islands.length == 2
    end
    break if islands.length == 2
  end

  min_dist = Float::INFINITY
  islands[0].each do |r1, c1|
    islands[1].each do |r2, c2|
      dist = (r1 - r2).abs + (c1 - c2).abs - 1
      min_dist = [min_dist, dist].min
    end
  end
  min_dist
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{shortest_bridge_brute([[0,1],[1,0]])}"            # 1
  puts "Opt:   #{shortest_bridge([[0,1],[1,0]])}"                   # 1
  puts "Brute: #{shortest_bridge_brute([[1,1,1,1,1],[1,0,0,0,1],[1,0,1,0,1],[1,0,0,0,1],[1,1,1,1,1]])}" # 1
  puts "Opt:   #{shortest_bridge([[1,1,1,1,1],[1,0,0,0,1],[1,0,1,0,1],[1,0,0,0,1],[1,1,1,1,1]])}"        # 1
end
