# frozen_string_literal: true

# LeetCode 542: 01 Matrix
#
# Problem:
# Given an m x n binary matrix, return a matrix where each cell contains the
# distance to the nearest 0.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each cell, BFS to find nearest 0.
#    Time Complexity: O((m*n)^2)
#    Space Complexity: O(m*n)
#
# 2. Bottleneck
#    Per-cell BFS — flip: multi-source BFS from all 0s simultaneously.
#
# 3. Optimized Accepted Approach
#    Seed queue with all 0 cells at distance 0. BFS outward, update 1-cells.
#    Any 1-cell's first visit is its minimum distance to a 0.
#    Time Complexity: O(m*n)
#    Space Complexity: O(m*n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# mat=[[0,0,0],[0,1,0],[1,1,1]]
# Queue: (0,0,0),(0,1,0),(0,2,0),(1,0,0),(1,2,0)
# Expand: (1,1) gets dist=1 from (0,1) or (1,0)/(1,2)
# (2,0) gets dist=1 from (1,0), (2,2) from (1,2), (2,1) gets dist=2 from (2,0)/(2,2)
# result=[[0,0,0],[0,1,0],[1,2,1]] ✓
#
# Edge Cases:
# - All zeros -> all zeros
# - Single 1 surrounded by 0s -> 1

def update_matrix_brute(mat)
  rows, cols = mat.length, mat[0].length
  dist  = Array.new(rows) { Array.new(cols, Float::INFINITY) }
  dirs  = [[-1,0],[1,0],[0,-1],[0,1]]

  rows.times do |r|
    cols.times do |c|
      next unless mat[r][c] == 1
      q = []
      rows.times { |gr| cols.times { |gc| q << [gr, gc, 0] if mat[gr][gc] == 0 } }
      seen = {}
      until q.empty?
        nr, nc, d = q.shift
        next if seen[[nr,nc]]
        seen[[nr,nc]] = true
        if nr == r && nc == c
          dist[r][c] = d
          break
        end
        dirs.each { |dr, dc| q << [nr+dr, nc+dc, d+1] unless seen[[nr+dr, nc+dc]] rescue nil }
      end
    end
  end

  mat.each_with_index.map { |row, r| row.each_with_index.map { |v, c| v.zero? ? 0 : dist[r][c].to_i } }
end

def update_matrix(mat)
  rows, cols = mat.length, mat[0].length
  dist  = Array.new(rows) { Array.new(cols, Float::INFINITY) }
  queue = []
  dirs  = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  # Seed all zeros at distance 0
  rows.times do |r|
    cols.times do |c|
      if mat[r][c].zero?
        dist[r][c] = 0
        queue << [r, c]
      end
    end
  end

  until queue.empty?
    r, c = queue.shift
    dirs.each do |dr, dc|
      nr, nc = r + dr, c + dc
      next if nr < 0 || nr >= rows || nc < 0 || nc >= cols
      if dist[nr][nc] > dist[r][c] + 1
        dist[nr][nc] = dist[r][c] + 1
        queue << [nr, nc]
      end
    end
  end

  dist.map { |row| row.map(&:to_i) }
end

if __FILE__ == $PROGRAM_NAME
  puts "Opt: #{update_matrix([[0, 0, 0], [0, 1, 0], [1, 1, 1]]).inspect}"
  # [[0,0,0],[0,1,0],[1,2,1]]
end
