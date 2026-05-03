# frozen_string_literal: true

# LeetCode 130: Surrounded Regions
#
# Problem:
# Given an m x n grid of 'X' and 'O', capture all regions of 'O' that are
# surrounded by 'X' (not connected to the border). Replace captured 'O's with 'X'.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each 'O', BFS/DFS to check if it touches a border. If not, mark it.
#    Time Complexity: O((m*n)^2)
#    Space Complexity: O(m*n)
#
# 2. Bottleneck
#    Per-cell connectivity check — flip: start from border 'O's, mark safe.
#
# 3. Optimized Accepted Approach
#    DFS from all border 'O' cells, mark them 'S' (safe). Then flip:
#    'O' → 'X' (captured), 'S' → 'O' (restore border-connected).
#    Time Complexity: O(m*n)
#    Space Complexity: O(m*n) recursion
#
# -----------------------------------------------------------------------------
# Dry Run
#
# grid=[["X","X","X","X"],["X","O","O","X"],["X","X","O","X"],["X","O","X","X"]]
# Border O's: (3,1) → DFS marks only (3,1) as S
# Inner O's: (1,1),(1,2),(2,2) get flipped to X
# (3,1) restored to O
# result=[["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","O","X","X"]] ✓
#
# Edge Cases:
# - All X -> unchanged
# - O only on border -> unchanged
# - No O -> unchanged

def solve_brute(board)
  return if board.empty?
  rows, cols = board.length, board[0].length

  check_border = lambda do |r, c, visited|
    return false if r < 0 || r >= rows || c < 0 || c >= cols || visited[[r,c]] || board[r][c] != 'O'
    return true  if r == 0 || r == rows - 1 || c == 0 || c == cols - 1
    visited[[r,c]] = true
    [[-1,0],[1,0],[0,-1],[0,1]].any? { |dr, dc| check_border.call(r+dr, c+dc, visited) }
  end

  rows.times do |r|
    cols.times do |c|
      board[r][c] = 'X' if board[r][c] == 'O' && !check_border.call(r, c, {})
    end
  end
end

def solve(board)
  return if board.empty?
  rows, cols = board.length, board[0].length

  # DFS from border O's, mark safe as 'S'
  dfs = lambda do |r, c|
    return if r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != 'O'
    board[r][c] = 'S'    # mark as safe (border-connected)
    dfs.call(r + 1, c); dfs.call(r - 1, c)
    dfs.call(r, c + 1); dfs.call(r, c - 1)
  end

  # Seed from all border cells
  rows.times { |r| dfs.call(r, 0); dfs.call(r, cols - 1) }
  cols.times { |c| dfs.call(0, c); dfs.call(rows - 1, c) }

  # Flip: O→X (captured), S→O (restore safe)
  rows.times do |r|
    cols.times do |c|
      if board[r][c] == 'O'
        board[r][c] = 'X'
      elsif board[r][c] == 'S'
        board[r][c] = 'O'
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board = [["X","X","X","X"],["X","O","O","X"],["X","X","O","X"],["X","O","X","X"]]
  solve(board)
  puts "Opt: #{board.inspect}"
  # [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","O","X","X"]]
end
