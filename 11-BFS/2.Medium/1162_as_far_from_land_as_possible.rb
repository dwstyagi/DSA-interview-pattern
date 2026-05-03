# frozen_string_literal: true

# LeetCode 1162: As Far from Land as Possible
#
# Problem:
# Given an n x n grid of 0s (water) and 1s (land), find the water cell with
# the maximum distance to the nearest land cell. Return that distance, or -1
# if no land or no water exists.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each water cell, BFS to nearest land. O(n^2) per cell.
#    Time Complexity: O(n^4)
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    Per-cell BFS — multi-source BFS from all land cells simultaneously.
#
# 3. Optimized Accepted Approach
#    Seed queue with all land cells. BFS outward to water cells. The last water
#    cell reached has the maximum distance. Return that distance.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n^2)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[[1,0,1],[0,0,0],[1,0,1]]
# Land cells: (0,0),(0,2),(2,0),(2,2) seeded at dist 0
# Water cells: center (1,1) gets dist=2, edges (0,1),(1,0),(1,2),(2,1) get dist=1
# Max = 2 ✓
#
# Edge Cases:
# - All land -> -1
# - All water -> -1

def max_distance_brute(grid)
  n    = grid.length
  dirs = [[-1,0],[1,0],[0,-1],[0,1]]
  max  = -1

  n.times do |r|
    n.times do |c|
      next unless grid[r][c] == 0
      dist = Array.new(n) { Array.new(n, false) }
      q    = []
      n.times { |gr| n.times { |gc| q << [gr, gc, 0] if grid[gr][gc] == 1 } }
      until q.empty?
        nr, nc, d = q.shift
        if nr == r && nc == c
          max = [max, d].max
          break
        end
        dirs.each do |dr, dc|
          nnr, nnc = nr + dr, nc + dc
          next if nnr < 0 || nnr >= n || nnc < 0 || nnc >= n || dist[nnr][nnc]
          dist[nnr][nnc] = true
          q << [nnr, nnc, d + 1]
        end
      end
    end
  end
  max
end

def max_distance(grid)
  n     = grid.length
  dirs  = [[-1, 0], [1, 0], [0, -1], [0, 1]]
  dist  = Array.new(n) { Array.new(n, -1) }
  queue = []

  # Seed all land cells at distance 0
  n.times do |r|
    n.times do |c|
      if grid[r][c] == 1
        dist[r][c] = 0
        queue << [r, c]
      end
    end
  end

  return -1 if queue.empty? || queue.length == n * n

  max = -1

  until queue.empty?
    r, c = queue.shift
    dirs.each do |dr, dc|
      nr, nc = r + dr, c + dc
      next if nr < 0 || nr >= n || nc < 0 || nc >= n
      next if dist[nr][nc] != -1
      dist[nr][nc] = dist[r][c] + 1
      max = [max, dist[nr][nc]].max
      queue << [nr, nc]
    end
  end

  max
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{max_distance_brute([[1, 0, 1], [0, 0, 0], [1, 0, 1]])}"  # 2
  puts "Opt:   #{max_distance([[1, 0, 1], [0, 0, 0], [1, 0, 1]])}"         # 2
  puts "Brute: #{max_distance_brute([[1, 0, 0], [0, 0, 0], [0, 0, 0]])}"  # 4
  puts "Opt:   #{max_distance([[1, 0, 0], [0, 0, 0], [0, 0, 0]])}"         # 4
end
