# frozen_string_literal: true

# LeetCode 1254: Number of Closed Islands
#
# Problem:
# Given a grid of 0s (land) and 1s (water), return the number of closed islands.
# A closed island is a group of 0s completely surrounded by 1s (not touching border).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each unvisited 0, DFS to check if it touches any border. Count those that don't.
#    Time Complexity: O((m*n)^2)
#    Space Complexity: O(m*n)
#
# 2. Bottleneck
#    Per-island border check — eliminate border-connected 0s first, then count.
#
# 3. Optimized Accepted Approach
#    DFS from all border 0s, flood-fill them to 1 (eliminate open islands).
#    Then count remaining connected 0-components (all are closed).
#    Time Complexity: O(m*n)
#    Space Complexity: O(m*n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[[1,1,1,1,1,1,1],[1,0,0,0,0,0,1],[1,0,1,1,1,0,1],[1,0,1,0,1,0,1],[1,0,1,1,1,0,1],[1,0,0,0,0,0,1],[1,1,1,1,1,1,1]]
# No border 0s (all border is 1). Inner 0s form 2 islands → count=2 ✓
#
# Edge Cases:
# - All land -> 0
# - All water -> 0
# - 0 touching border -> not counted

def closed_island_brute(grid)
  rows, cols = grid.length, grid[0].length
  visited = Array.new(rows) { Array.new(cols, false) }

  is_closed = lambda do |r, c|
    return true  if r < 0 || r >= rows || c < 0 || c >= cols ? false : false rescue false
    return false if grid[r][c] == 1 || visited[r][c]
    # use DFS to check
    stack  = [[r, c]]
    closed = true
    cells  = []
    until stack.empty?
      cr, cc = stack.pop
      next if cr < 0 || cr >= rows || cc < 0 || cc >= cols
      if cr == 0 || cr == rows-1 || cc == 0 || cc == cols-1
        closed = false if grid[cr][cc] == 0
      end
      next if visited[cr][cc] || grid[cr][cc] == 1
      visited[cr][cc] = true
      cells << [cr, cc]
      [[-1,0],[1,0],[0,-1],[0,1]].each { |dr, dc| stack << [cr+dr, cc+dc] }
    end
    closed && cells.length > 0
  end

  count = 0
  rows.times { |r| cols.times { |c| count += 1 if !visited[r][c] && grid[r][c] == 0 && is_closed.call(r, c) } }
  count
end

def closed_island(grid)
  rows, cols = grid.length, grid[0].length
  grid = grid.map(&:dup)

  # Flood-fill border-connected land to water
  dfs = lambda do |r, c|
    return if r < 0 || r >= rows || c < 0 || c >= cols || grid[r][c] != 0
    grid[r][c] = 1   # mark as water (eliminated)
    dfs.call(r+1,c); dfs.call(r-1,c); dfs.call(r,c+1); dfs.call(r,c-1)
  end

  rows.times { |r| dfs.call(r, 0); dfs.call(r, cols - 1) }
  cols.times { |c| dfs.call(0, c); dfs.call(rows - 1, c) }

  # Count remaining 0-components (all closed)
  count = 0
  rows.times do |r|
    cols.times do |c|
      next unless grid[r][c] == 0
      count += 1
      dfs.call(r, c)  # consume the island
    end
  end

  count
end

if __FILE__ == $PROGRAM_NAME
  grid1 = [[1,1,1,1,1,1,1,0],[1,0,0,0,0,1,1,0],[1,0,1,0,1,1,1,0],[1,0,0,0,0,1,0,1],[1,1,1,1,1,1,1,0]]
  puts "Brute: #{closed_island_brute(grid1)}"  # 2
  puts "Opt:   #{closed_island(grid1)}"          # 2
end
