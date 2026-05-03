# frozen_string_literal: true

# LeetCode 37: Sudoku Solver
#
# Problem:
# Solve a Sudoku puzzle by filling in the empty cells ('.').
# Each row, column, and 3x3 box must contain digits 1-9 exactly once.
# The input board is guaranteed to have exactly one solution.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all digits 1-9 in each empty cell, validate the entire board after
#    each placement. Exponential with redundant work.
#    Time Complexity: O(9^(empty cells))
#    Space Complexity: O(1) ignoring recursion
#
# 2. Bottleneck
#    Validating the whole board after each placement is wasteful. Instead
#    maintain sets of used digits per row/col/box, so each check is O(1).
#
# 3. Optimized Accepted Approach
#    Backtracking with bitset-based conflict tracking.
#    For each empty cell try digits 1-9; place if no conflict in its row,
#    column, and 3×3 box. Recurse. Undo on failure.
#
#    Time Complexity: O(9^m) where m = number of empty cells
#    Space Complexity: O(1) extra (board modified in-place)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# board[0][0] = '.' -> try '1': check row 0, col 0, box 0 -> if no conflict place '1', recurse
# If stuck at some cell -> backtrack, try next digit
# Continue until all 81 cells filled
#
# Edge Cases:
# - Fully filled board: no empty cells, return immediately
# - Minimal clues: backtracking explores deeply but finds unique solution

def solve_sudoku_brute(board)
  def valid?(board, row, col, num)
    (0..8).each do |i|
      return false if board[row][i] == num
      return false if board[i][col] == num
      box_r = (row / 3) * 3 + i / 3
      box_c = (col / 3) * 3 + i % 3
      return false if board[box_r][box_c] == num
    end
    true
  end

  solve = lambda do
    (0..8).each do |r|
      (0..8).each do |c|
        next unless board[r][c] == '.'
        ('1'..'9').each do |num|
          if valid?(board, r, c, num)
            board[r][c] = num
            return true if solve.call
            board[r][c] = '.'
          end
        end
        return false
      end
    end
    true
  end

  solve.call
end

# optimized: track conflicts with sets for O(1) lookup
def solve_sudoku(board)
  rows  = Array.new(9) { Set.new }
  cols  = Array.new(9) { Set.new }
  boxes = Array.new(9) { Set.new }

  (0..8).each do |r|
    (0..8).each do |c|
      next if board[r][c] == '.'
      d = board[r][c]
      rows[r].add(d)
      cols[c].add(d)
      boxes[(r / 3) * 3 + c / 3].add(d)
    end
  end

  solve = lambda do
    (0..8).each do |r|
      (0..8).each do |c|
        next unless board[r][c] == '.'
        b = (r / 3) * 3 + c / 3
        ('1'..'9').each do |d|
          next if rows[r].include?(d) || cols[c].include?(d) || boxes[b].include?(d)
          board[r][c] = d
          rows[r].add(d); cols[c].add(d); boxes[b].add(d)
          return true if solve.call
          board[r][c] = '.'
          rows[r].delete(d); cols[c].delete(d); boxes[b].delete(d)
        end
        return false
      end
    end
    true
  end

  solve.call
end

if __FILE__ == $PROGRAM_NAME
  board = [
    ['5','3','.','.','7','.','.','.','.'],
    ['6','.','.','1','9','5','.','.','.'],
    ['.','9','8','.','.','.','.','6','.'],
    ['8','.','.','.','6','.','.','.','3'],
    ['4','.','.','8','.','3','.','.','1'],
    ['7','.','.','.','2','.','.','.','6'],
    ['.','6','.','.','.','.','2','8','.'],
    ['.','.','.','4','1','9','.','.','5'],
    ['.','.','.','.','8','.','.','7','9']
  ]
  solve_sudoku(board)
  board.each { |row| puts row.join(' ') }
end
