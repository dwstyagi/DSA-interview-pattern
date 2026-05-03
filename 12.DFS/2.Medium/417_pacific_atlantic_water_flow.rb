# frozen_string_literal: true

# LeetCode 417: Pacific Atlantic Water Flow
#
# Problem:
# Given an m x n grid of heights, water flows to adjacent cells with <= height.
# Pacific touches top/left border, Atlantic touches bottom/right border.
# Return coordinates where water can flow to both oceans.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each cell, DFS to check if Pacific reachable AND Atlantic reachable.
#    Time Complexity: O((m*n)^2)
#    Space Complexity: O(m*n)
#
# 2. Bottleneck
#    Per-cell DFS — reverse the flow: DFS from ocean borders uphill.
#
# 3. Optimized Accepted Approach
#    DFS from all Pacific-border cells (top, left) — mark pacific_reach.
#    DFS from all Atlantic-border cells (bottom, right) — mark atlantic_reach.
#    Cells in both sets are the answer.
#    Time Complexity: O(m*n)
#    Space Complexity: O(m*n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# heights=[[1,2,2,3,5],[3,2,3,4,4],[2,4,5,3,1],[6,7,1,4,5],[5,1,1,2,4]]
# Pacific reachable from top/left borders going uphill.
# Atlantic reachable from bottom/right borders going uphill.
# Intersection = [[0,4],[1,3],[1,4],[2,2],[3,0],[3,1],[4,0]] ✓
#
# Edge Cases:
# - 1x1 grid -> [[0,0]] (touches both oceans)

def pacific_atlantic_brute(heights)
  rows, cols = heights.length, heights[0].length
  dirs = [[-1,0],[1,0],[0,-1],[0,1]]

  can_reach = lambda do |r, c, border_check|
    visited = Array.new(rows) { Array.new(cols, false) }
    stack   = [[r, c]]
    visited[r][c] = true
    until stack.empty?
      cr, cc = stack.pop
      return true if border_check.call(cr, cc)
      dirs.each do |dr, dc|
        nr, nc = cr+dr, cc+dc
        next if nr < 0 || nr >= rows || nc < 0 || nc >= cols || visited[nr][nc]
        next if heights[nr][nc] > heights[cr][cc]
        visited[nr][nc] = true
        stack << [nr, nc]
      end
    end
    false
  end

  pacific  = ->(r, c) { r == 0 || c == 0 }
  atlantic = ->(r, c) { r == rows-1 || c == cols-1 }

  result = []
  rows.times { |r| cols.times { |c| result << [r,c] if can_reach.call(r,c,pacific) && can_reach.call(r,c,atlantic) } }
  result
end

def pacific_atlantic(heights)
  rows, cols = heights.length, heights[0].length
  dirs = [[-1,0],[1,0],[0,-1],[0,1]]

  pac = Array.new(rows) { Array.new(cols, false) }
  atl = Array.new(rows) { Array.new(cols, false) }

  dfs = lambda do |r, c, visited, prev_h|
    return if r < 0 || r >= rows || c < 0 || c >= cols
    return if visited[r][c] || heights[r][c] < prev_h  # water flows downhill, we go uphill
    visited[r][c] = true
    dirs.each { |dr, dc| dfs.call(r+dr, c+dc, visited, heights[r][c]) }
  end

  # DFS from Pacific borders (top row, left col)
  rows.times { |r| dfs.call(r, 0,        pac, heights[r][0]) }
  cols.times { |c| dfs.call(0, c,        pac, heights[0][c]) }

  # DFS from Atlantic borders (bottom row, right col)
  rows.times { |r| dfs.call(r, cols-1,   atl, heights[r][cols-1]) }
  cols.times { |c| dfs.call(rows-1, c,   atl, heights[rows-1][c]) }

  result = []
  rows.times { |r| cols.times { |c| result << [r, c] if pac[r][c] && atl[r][c] } }
  result
end

if __FILE__ == $PROGRAM_NAME
  heights = [[1,2,2,3,5],[3,2,3,4,4],[2,4,5,3,1],[6,7,1,4,5],[5,1,1,2,4]]
  puts "Opt: #{pacific_atlantic(heights).inspect}"
  # [[0,4],[1,3],[1,4],[2,2],[3,0],[3,1],[4,0]]
end
