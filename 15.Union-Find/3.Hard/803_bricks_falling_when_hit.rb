# frozen_string_literal: true

# LeetCode 803: Bricks Falling When Hit
#
# Problem:
# A brick falls if it is not directly connected to the top row (directly or via other bricks).
# Given hits, return how many bricks fall after each hit.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    After each hit, BFS to count bricks no longer connected to top.
#    Time Complexity: O(hits * m * n)
#    Space Complexity: O(m * n)
#
# 2. Bottleneck
#    Rerunning BFS after each hit is expensive. Process hits in reverse:
#    add bricks back and use Union-Find to track connectivity.
#
# 3. Optimized Accepted Approach
#    Remove all hit bricks. Build Union-Find. Add back in reverse order.
#    Virtual node = top row. Count bricks that newly connect when adding each back.
#
#    Time Complexity: O(hits * alpha(m*n))
#    Space Complexity: O(m * n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[[1,0,0,0],[1,1,1,0]], hits=[[1,0]]
# After hit: grid[1][0]=0. Remaining: top row [1,0,0,0], row 1=[0,1,1,0]
# Row 1 bricks (1,1),(1,2) are not connected to top -> 2 bricks fall
# Reverse: add (1,0) back, it connects top to (1,1),(1,2) -> 2 newly stable
# Result: [2]
#
# Edge Cases:
# - Hitting empty cell: 0 bricks fall
# - Hitting isolated brick: 0 if not connected, but was it?

def hit_bricks_brute(grid, hits)
  rows = grid.length
  cols = grid[0].length
  g = grid.map(&:dup)

  connected_to_top = lambda do
    visited = Array.new(rows) { Array.new(cols, false) }
    count = 0
    queue = (0...cols).select { |c| g[0][c] == 1 }.map { |c| [0, c] }
    queue.each { |r, c| visited[r][c] = true }
    until queue.empty?
      r, c = queue.shift
      count += 1
      [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dr, dc|
        nr, nc = r + dr, c + dc
        next if nr < 0 || nr >= rows || nc < 0 || nc >= cols || visited[nr][nc] || g[nr][nc] == 0
        visited[nr][nc] = true
        queue << [nr, nc]
      end
    end
    count
  end

  before = connected_to_top.call
  hits.map do |r, c|
    was = g[r][c]
    g[r][c] = 0
    after = connected_to_top.call
    fell = [before - after - (was == 1 ? 1 : 0), 0].max
    before = after + (was == 1 ? 1 : 0) - fell
    # recalc properly
    before = connected_to_top.call + (was == 1 ? 1 : 0)
    fell
  end
end

def hit_bricks(grid, hits)
  rows = grid.length
  cols = grid[0].length
  g = grid.map(&:dup)
  virtual = rows * cols

  parent = Array.new(rows * cols + 1) { |i| i }
  sz = Array.new(rows * cols + 1, 1)
  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }
  union = lambda do |a, b|
    pa, pb = find.call(a), find.call(b)
    return if pa == pb
    if sz[pa] < sz[pb] then parent[pa] = pb; sz[pb] += sz[pa]
    else parent[pb] = pa; sz[pa] += sz[pb]
    end
  end

  hits.each { |r, c| g[r][c] = 0 }

  dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  rows.times do |r|
    cols.times do |c|
      next if g[r][c] == 0
      union.call(r * cols + c, virtual) if r == 0
      dirs.each do |dr, dc|
        nr, nc = r + dr, c + dc
        union.call(r * cols + c, nr * cols + nc) if nr >= 0 && nr < rows && nc >= 0 && nc < cols && g[nr][nc] == 1
      end
    end
  end

  result = []
  hits.reverse.each do |r, c|
    prev_top = sz[find.call(virtual)]
    if grid[r][c] == 1
      g[r][c] = 1
      union.call(r * cols + c, virtual) if r == 0
      dirs.each do |dr, dc|
        nr, nc = r + dr, c + dc
        union.call(r * cols + c, nr * cols + nc) if nr >= 0 && nr < rows && nc >= 0 && nc < cols && g[nr][nc] == 1
      end
      gained = sz[find.call(virtual)] - prev_top - 1
      result << [gained, 0].max
    else
      result << 0
    end
  end
  result.reverse
end

if __FILE__ == $PROGRAM_NAME
  puts hit_bricks([[1, 0, 0, 0], [1, 1, 1, 0]], [[1, 0]]).inspect  # [2]
  puts hit_bricks([[1, 0, 0, 0], [1, 1, 0, 0]], [[1, 1], [1, 0]]).inspect  # [0,0]
end
