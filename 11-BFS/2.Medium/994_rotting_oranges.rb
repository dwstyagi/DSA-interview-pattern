# frozen_string_literal: true

# LeetCode 994: Rotting Oranges
#
# Problem:
# Grid has 0 (empty), 1 (fresh orange), 2 (rotten orange). Every minute, any
# fresh orange adjacent to a rotten orange becomes rotten. Return the minimum
# number of minutes until no fresh oranges remain, or -1 if impossible.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate minute by minute: scan grid, find fresh neighbors of rotten, mark.
#    Time Complexity: O((m*n)^2) — each minute we scan the full grid
#    Space Complexity: O(m*n)
#
# 2. Bottleneck
#    Repeated full scans — seed BFS with ALL rotten oranges at time 0 (multi-source).
#
# 3. Optimized Accepted Approach
#    Multi-source BFS. Seed the queue with all rotten oranges. Each BFS level =
#    one minute. Count remaining fresh at the end.
#    Time Complexity: O(m*n)
#    Space Complexity: O(m*n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[[2,1,1],[1,1,0],[0,1,1]]
# Queue seeded with (0,0). Minute 1: spread to (0,1),(1,0). Minute 2: (0,2),(1,1).
# Minute 3: (2,1). Minute 4: (2,2). All fresh rotted → 4 ✓
#
# Edge Cases:
# - No fresh oranges -> 0
# - Fresh orange unreachable -> -1

def oranges_rotting_brute(grid)
  rows, cols = grid.length, grid[0].length
  grid = grid.map(&:dup)
  mins = 0

  loop do
    newly_rotten = []
    rows.times do |r|
      cols.times do |c|
        next unless grid[r][c] == 2
        [[-1,0],[1,0],[0,-1],[0,1]].each do |dr, dc|
          nr, nc = r + dr, c + dc
          newly_rotten << [nr, nc] if nr.between?(0, rows-1) && nc.between?(0, cols-1) && grid[nr][nc] == 1
        end
      end
    end
    break if newly_rotten.empty?
    newly_rotten.each { |r, c| grid[r][c] = 2 }
    mins += 1
  end

  grid.any? { |row| row.include?(1) } ? -1 : mins
end

def oranges_rotting(grid)
  rows, cols = grid.length, grid[0].length
  grid  = grid.map(&:dup)
  fresh = 0
  queue = []
  dirs  = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  # Seed queue with all rotten oranges; count fresh
  rows.times do |r|
    cols.times do |c|
      if grid[r][c] == 2
        queue << [r, c, 0]
      elsif grid[r][c] == 1
        fresh += 1
      end
    end
  end

  max_mins = 0

  until queue.empty?
    r, c, mins = queue.shift
    dirs.each do |dr, dc|
      nr, nc = r + dr, c + dc
      next if nr < 0 || nr >= rows || nc < 0 || nc >= cols
      next if grid[nr][nc] != 1
      grid[nr][nc] = 2                # mark rotten
      fresh -= 1
      max_mins = mins + 1
      queue << [nr, nc, mins + 1]
    end
  end

  fresh.zero? ? max_mins : -1
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{oranges_rotting_brute([[2,1,1],[1,1,0],[0,1,1]])}"  # 4
  puts "Opt:   #{oranges_rotting([[2,1,1],[1,1,0],[0,1,1]])}"         # 4
  puts "Brute: #{oranges_rotting_brute([[2,1,1],[0,1,1],[1,0,1]])}"  # -1
  puts "Opt:   #{oranges_rotting([[2,1,1],[0,1,1],[1,0,1]])}"         # -1
end
