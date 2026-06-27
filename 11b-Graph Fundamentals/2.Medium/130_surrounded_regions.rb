# frozen_string_literal: true

# 130. Surrounded Regions
#
# 1. Problem Statement
#
# Flip every 'O' fully surrounded by 'X' to 'X'. An 'O' connected to a border
# cannot be flipped.
#
# 2. Brute Force Approach
#
# Intuition:
# For each 'O', search its whole region and check whether that region touches a
# border. Flip the region only if it does not.
#
# Algorithm:
# Launch DFS from every 'O' with a fresh visited set.
#
# Time Complexity: O((m * n)^2)
# Space Complexity: O(m * n)

# 3. Brute Force Code
def solve_brute(board)
  board.each_index do |row|
    board[row].each_index do |col|
      next unless board[row][col] == 'O'

      region, touches_border = region_info(board, row, col)
      region.each { |r, c| board[r][c] = 'X' } unless touches_border
    end
  end
end

# 4. Bottleneck Analysis
#
# Cells in one region repeatedly trigger the same region search. More
# importantly, deciding which interior regions to flip is harder than deciding
# which cells are safe: safe cells are exactly those connected to the border.
#
# 5. Optimization Journey
#
# Start from every border 'O' and mark every reachable 'O' as temporarily safe
# ('S'). Then:
# - Remaining 'O' cells are surrounded, so flip them to 'X'.
# - Convert 'S' back to 'O'.
#
# 6. Dry Run
#
# For [["X","X","X"],["X","O","X"],["X","O","X"]]:
# - The bottom-border O marks itself and the center O as safe.
# - No O remains to flip.
# - Restore both safe marks to O.
#
# 7. Optimal Solution
#
# Flood-fill only from border O cells, then make one final pass to flip or
# restore markers.
#
# Time Complexity: O(m * n)
# Space Complexity: O(m * n)

# 8. Optimal Code
def solve(board)
  return if board.empty?

  rows = board.length
  cols = board[0].length
  border = []
  rows.times do |row|
    border << [row, 0]
    border << [row, cols - 1]
  end
  cols.times do |col|
    border << [0, col]
    border << [rows - 1, col]
  end

  border.each { |row, col| mark_safe(board, row, col) }

  rows.times do |row|
    cols.times do |col|
      board[row][col] = 'X' if board[row][col] == 'O'
      board[row][col] = 'O' if board[row][col] == 'S'
    end
  end
end

def region_info(board, start_row, start_col)
  visited = { [start_row, start_col] => true }
  stack = [[start_row, start_col]]
  region = []
  touches_border = false

  until stack.empty?
    row, col = stack.pop
    region << [row, col]
    touches_border ||= row.zero? || col.zero? || row == board.length - 1 || col == board[0].length - 1
    board_neighbors(board, row, col).each do |nr, nc|
      next unless board[nr][nc] == 'O' && !visited[[nr, nc]]

      visited[[nr, nc]] = true
      stack << [nr, nc]
    end
  end

  [region, touches_border]
end

def mark_safe(board, row, col)
  return unless board[row][col] == 'O'

  stack = [[row, col]]
  board[row][col] = 'S'
  until stack.empty?
    current_row, current_col = stack.pop
    board_neighbors(board, current_row, current_col).each do |nr, nc|
      next unless board[nr][nc] == 'O'

      board[nr][nc] = 'S'
      stack << [nr, nc]
    end
  end
end

def board_neighbors(board, row, col)
  [[1, 0], [-1, 0], [0, 1], [0, -1]].filter_map do |dr, dc|
    nr = row + dr
    nc = col + dc
    [nr, nc] if nr.between?(0, board.length - 1) && nc.between?(0, board[0].length - 1)
  end
end

# Examples
if __FILE__ == $PROGRAM_NAME
  board = [['X', 'X', 'X', 'X'], ['X', 'O', 'O', 'X'], ['X', 'X', 'O', 'X'], ['X', 'O', 'X', 'X']]
  brute = board.map(&:dup)
  solve_brute(brute)
  p brute
  solve(board)
  p board
end
