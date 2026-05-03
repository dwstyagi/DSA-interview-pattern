# frozen_string_literal: true

# LeetCode 51: N-Queens
#
# Problem:
# Place n queens on an n×n chessboard so that no two queens attack each other.
# Queens attack along rows, columns, and diagonals.
# Return all distinct solutions, each represented as an array of strings.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try every permutation of column positions for each row.
#    For each permutation, check if it's a valid board.
#    Time Complexity: O(n! * n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    We re-validate from scratch. Instead, prune invalid placements
#    during backtracking so we never explore invalid branches.
#
# 3. Optimized Accepted Approach
#    Backtracking row-by-row. Track which columns, diagonals (\), and
#    anti-diagonals (/) are occupied using sets. Place a queen in each
#    column of the current row if no conflict, recurse to next row.
#
#    Time Complexity: O(n!)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n = 4, row = 0
#   try col=0: cols={0}, diag={0}, anti={0} -> row 1
#     try col=2: cols={0,2}, diag={1}, anti={1} -> row 2
#       col=0 blocked (cols), col=1: diag=3 anti=-1 ok -> row 3
#         no valid col -> backtrack
#       col=3: diag=3 anti=-1 ok -> row 3
#         col=1: diag=4 anti=2 ok -> solution [".Q..", "...Q", "Q...", "..Q."]
#
# Edge Cases:
# - n=1: single queen, one solution ["Q"]
# - n=2,3: no solutions

def solve_n_queens_brute(n)
  results = []
  board = Array.new(n) { Array.new(n, '.') }

  def valid?(board, row, col, n)
    (0...row).each do |r|
      return false if board[r][col] == 'Q'
    end
    r, c = row - 1, col - 1
    while r >= 0 && c >= 0
      return false if board[r][c] == 'Q'
      r -= 1; c -= 1
    end
    r, c = row - 1, col + 1
    while r >= 0 && c < n
      return false if board[r][c] == 'Q'
      r -= 1; c += 1
    end
    true
  end

  place = lambda do |row|
    if row == n
      results << board.map(&:join)
      return
    end
    (0...n).each do |col|
      next unless valid?(board, row, col, n)
      board[row][col] = 'Q'
      place.call(row + 1)
      board[row][col] = '.'
    end
  end

  place.call(0)
  results
end

# optimized: backtracking with O(1) conflict checks via sets
def solve_n_queens(n)
  results = []
  queens = []
  cols = Set.new
  diag = Set.new    # row - col
  anti = Set.new    # row + col

  place = lambda do |row|
    if row == n
      board = queens.map { |c| '.' * c + 'Q' + '.' * (n - c - 1) }
      results << board
      return
    end
    (0...n).each do |col|
      next if cols.include?(col) || diag.include?(row - col) || anti.include?(row + col)
      cols.add(col); diag.add(row - col); anti.add(row + col)
      queens << col
      place.call(row + 1)
      queens.pop
      cols.delete(col); diag.delete(row - col); anti.delete(row + col)
    end
  end

  place.call(0)
  results
end

if __FILE__ == $PROGRAM_NAME
  n = 4
  puts "Brute force solutions for n=#{n}:"
  solve_n_queens_brute(n).each { |sol| sol.each { |row| puts row }; puts }
  puts "Optimized solutions for n=#{n}:"
  solve_n_queens(n).each { |sol| sol.each { |row| puts row }; puts }
end
