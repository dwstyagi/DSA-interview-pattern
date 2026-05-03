# frozen_string_literal: true

# LeetCode 305: Number of Islands II
#
# Problem:
# Given m x n grid, initially all water. After each land addition at positions[i],
# return the number of islands after each addition.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    After each addition, run BFS/DFS to count islands.
#    Time Complexity: O(k * m * n) where k = positions count
#    Space Complexity: O(m * n)
#
# 2. Bottleneck
#    Rerunning BFS after each addition is expensive. Union-Find: each addition
#    increments island count, then unions with adjacent land (decrement per union).
#
# 3. Optimized Accepted Approach
#    Union-Find on m*n grid. For each new land cell, set island_count++.
#    Check 4 neighbors; if land and different component, union and island_count--.
#
#    Time Complexity: O(k * alpha(m*n))
#    Space Complexity: O(m * n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# m=3,n=3, positions=[[0,0],[0,1],[1,2],[2,1]]
# add (0,0): count=1, no land neighbors -> [1]
# add (0,1): count=2, neighbor (0,0) -> union, count=1 -> [1]
# add (1,2): count=2, no land neighbors -> [2]
# add (2,1): count=3, no land neighbors -> [3]
# Result: [1,1,2,3]
#
# Edge Cases:
# - Adding same cell twice: skip if already land
# - Single cell: [1]

def num_islands_ii_brute(m, n, positions)
  result = []
  grid = Array.new(m) { Array.new(n, 0) }

  count_islands = lambda do
    visited = Array.new(m) { Array.new(n, false) }
    count = 0
    m.times do |r|
      n.times do |c|
        next if visited[r][c] || grid[r][c] == 0
        count += 1
        stack = [[r, c]]
        while stack.any?
          cr, cc = stack.pop
          next if visited[cr][cc]
          visited[cr][cc] = true
          [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dr, dc|
            nr, nc = cr + dr, cc + dc
            stack << [nr, nc] if nr >= 0 && nr < m && nc >= 0 && nc < n && !visited[nr][nc] && grid[nr][nc] == 1
          end
        end
      end
    end
    count
  end

  positions.each do |r, c|
    grid[r][c] = 1
    result << count_islands.call
  end
  result
end

# optimized: Union-Find with island count tracking
def num_islands_ii(m, n, positions)
  parent = {}
  rank = Hash.new(0)
  islands = 0
  dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]

  find = lambda do |x|
    parent[x] = find.call(parent[x]) unless parent[x] == x
    parent[x]
  end

  result = []
  positions.each do |r, c|
    key = r * n + c
    unless parent.key?(key)
      parent[key] = key
      islands += 1
      dirs.each do |dr, dc|
        nr, nc = r + dr, c + dc
        nb_key = nr * n + nc
        next unless nr >= 0 && nr < m && nc >= 0 && nc < n && parent.key?(nb_key)
        pk, pnb = find.call(key), find.call(nb_key)
        unless pk == pnb
          if rank[pk] < rank[pnb] then parent[pk] = pnb
          elsif rank[pk] > rank[pnb] then parent[pnb] = pk
          else parent[pnb] = pk; rank[pk] += 1
          end
          islands -= 1
        end
      end
    end
    result << islands
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  puts num_islands_ii_brute(3, 3, [[0, 0], [0, 1], [1, 2], [2, 1]]).inspect  # [1,1,2,3]
  puts num_islands_ii(3, 3, [[0, 0], [0, 1], [1, 2], [2, 1]]).inspect        # [1,1,2,3]
end
