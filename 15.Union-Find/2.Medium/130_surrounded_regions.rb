# frozen_string_literal: true

# LeetCode 130: Surrounded Regions
#
# Problem:
# Given a board of 'X' and 'O', flip all 'O's not connected to the border to 'X'.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS/DFS from all border 'O's to mark safe regions. Then flip unmarked 'O's.
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n)
#
# 2. Bottleneck
#    Already O(m*n). Union-Find: connect all border 'O's to a virtual node.
#    Any 'O' connected to virtual node is safe.
#
# 3. Optimized Accepted Approach
#    DFS from all border 'O' cells, mark them as 'S'. Then convert:
#    'O' -> 'X', 'S' -> 'O'.
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# board=[["X","X","X"],["X","O","X"],["X","X","X"]]
# No border 'O's. Inner 'O' at (1,1) gets flipped to 'X'.
# Result: all 'X'
#
# Edge Cases:
# - No 'O's: no change
# - All border 'O's: no change

def solve_brute(board)
  return if board.empty?
  rows = board.length
  cols = board[0].length

  mark = lambda do |r, c|
    return if r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != 'O'
    board[r][c] = 'S'
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each { |dr, dc| mark.call(r + dr, c + dc) }
  end

  rows.times { |r| mark.call(r, 0); mark.call(r, cols - 1) }
  cols.times { |c| mark.call(0, c); mark.call(rows - 1, c) }

  rows.times do |r|
    cols.times do |c|
      board[r][c] = board[r][c] == 'S' ? 'O' : 'X'
    end
  end
end

# optimized: same DFS approach (already optimal for this problem)
def solve(board)
  return if board.empty?
  rows = board.length
  cols = board[0].length

  dfs = lambda do |r, c|
    return if r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != 'O'
    board[r][c] = 'S'
    dfs.call(r + 1, c); dfs.call(r - 1, c)
    dfs.call(r, c + 1); dfs.call(r, c - 1)
  end

  rows.times { |r| dfs.call(r, 0); dfs.call(r, cols - 1) }
  cols.times { |c| dfs.call(0, c); dfs.call(rows - 1, c) }

  rows.times do |r|
    cols.times do |c|
      if board[r][c] == 'S' then board[r][c] = 'O'
      elsif board[r][c] == 'O' then board[r][c] = 'X'
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board = [%w[X X X X], %w[X O O X], %w[X X O X], %w[X O X X]]
  solve(board)
  board.each { |row| puts row.join }
end
