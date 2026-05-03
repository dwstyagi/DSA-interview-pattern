# frozen_string_literal: true

# LeetCode 286: Walls and Gates
#
# Problem:
# Given an m x n grid filled with -1 (wall), 0 (gate), or INF (empty room).
# Fill each empty room with the distance to its nearest gate.
# INF = 2147483647
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each empty room, BFS to find nearest gate. O(m*n) BFS per cell.
#    Time Complexity: O((m*n)^2)
#    Space Complexity: O(m*n)
#
# 2. Bottleneck
#    Per-cell BFS — flip it: multi-source BFS from all gates simultaneously.
#
# 3. Optimized Accepted Approach
#    Seed queue with all gates (distance 0). BFS outward, update empty rooms
#    only when we reach them (guarantees minimum distance).
#    Time Complexity: O(m*n)
#    Space Complexity: O(m*n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# INF=2147483647, grid:
# [INF, -1, 0, INF]
# [INF, INF, INF, -1]
# [INF, -1, INF, -1]
# [0, -1, INF, INF]
# Gates at (0,2) and (3,0). Multi-source BFS fills distances.
# result: [3,-1,0,1],[2,2,1,-1],[1,-1,2,-1],[0,-1,3,4] ✓
#
# Edge Cases:
# - No gates -> all INF remain
# - Room next to gate -> distance 1

INF = 2_147_483_647

def walls_and_gates_brute(rooms)
  return if rooms.empty?
  rows, cols = rooms.length, rooms[0].length
  dirs = [[-1,0],[1,0],[0,-1],[0,1]]

  bfs_from = lambda do |sr, sc|
    dist = Array.new(rows) { Array.new(cols, Float::INFINITY) }
    dist[sr][sc] = 0
    q = [[sr, sc]]
    until q.empty?
      r, c = q.shift
      dirs.each do |dr, dc|
        nr, nc = r + dr, c + dc
        next if nr < 0 || nr >= rows || nc < 0 || nc >= cols
        next if rooms[nr][nc] == -1 || dist[nr][nc] != Float::INFINITY
        dist[nr][nc] = dist[r][c] + 1
        q << [nr, nc]
      end
    end
    dist
  end

  rows.times do |r|
    cols.times do |c|
      next unless rooms[r][c] == INF
      # BFS from each gate
      best = INF
      rows.times do |gr|
        cols.times do |gc|
          next unless rooms[gr][gc] == 0
          d = bfs_from.call(gr, gc)
          best = [best, d[r][c].to_i == Float::INFINITY.to_i ? INF : d[r][c].to_i].min
        end
      end
      rooms[r][c] = best
    end
  end
end

def walls_and_gates(rooms)
  return if rooms.empty?
  rows, cols = rooms.length, rooms[0].length
  dirs  = [[-1, 0], [1, 0], [0, -1], [0, 1]]
  queue = []

  # Seed all gates
  rows.times do |r|
    cols.times do |c|
      queue << [r, c] if rooms[r][c].zero?
    end
  end

  until queue.empty?
    r, c = queue.shift
    dirs.each do |dr, dc|
      nr, nc = r + dr, c + dc
      next if nr < 0 || nr >= rows || nc < 0 || nc >= cols
      next if rooms[nr][nc] != INF   # only update empty rooms not yet visited
      rooms[nr][nc] = rooms[r][c] + 1
      queue << [nr, nc]
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  grid = [[INF, -1, 0, INF], [INF, INF, INF, -1], [INF, -1, INF, -1], [0, -1, INF, INF]]
  walls_and_gates(grid)
  puts "Opt: #{grid.inspect}"
  # [[3,-1,0,1],[2,2,1,-1],[1,-1,2,-1],[0,-1,3,4]]
end
