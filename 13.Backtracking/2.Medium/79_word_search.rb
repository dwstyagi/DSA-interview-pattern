# frozen_string_literal: true

# LeetCode 79: Word Search
#
# Problem:
# Given an m x n grid of characters and a string word, return true if word
# exists in the grid. The word must be formed by sequentially adjacent cells
# (horizontally or vertically). Each cell may be used only once.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try starting from every cell, DFS in all 4 directions with backtracking.
#    This is already the standard approach.
#    Time Complexity: O(m*n * 4^L) — L=word length
#    Space Complexity: O(L) recursion
#
# 2. Bottleneck
#    Already optimal. Mark cells visited in-place instead of using a set.
#
# 3. Optimized Accepted Approach
#    DFS + backtracking from every cell. Mark cell visited by swapping with '#',
#    recurse, then swap back (restore).
#    Time Complexity: O(m*n * 4^L)
#    Space Complexity: O(L)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# board=[["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word="ABCCED"
# Start (0,0)='A': match word[0]='A', mark '#', try neighbors
# (0,1)='B': match word[1]='B', mark '#', try neighbors
# (0,2)='C': match word[2]='C', ... (0,3)='C': no—try (1,2)='C' ✓
# ... (1,1)='F' skip, (2,2)='E' ✓, (2,1)='D' ✓ → word found ✓
#
# Edge Cases:
# - Word longer than grid cells -> false
# - Single cell grid -> match if grid[0][0] == word

def exist_brute(board, word)
  rows, cols = board.length, board[0].length
  dirs = [[-1,0],[1,0],[0,-1],[0,1]]

  dfs = lambda do |r, c, idx|
    return true if idx == word.length
    return false if r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != word[idx]

    tmp = board[r][c]
    board[r][c] = '#'          # mark visited
    found = dirs.any? { |dr, dc| dfs.call(r+dr, c+dc, idx+1) }
    board[r][c] = tmp          # restore
    found
  end

  rows.times { |r| cols.times { |c| return true if dfs.call(r, c, 0) } }
  false
end

def exist(board, word)
  rows, cols = board.length, board[0].length
  dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  dfs = lambda do |r, c, idx|
    return true if idx == word.length   # matched entire word

    return false if r < 0 || r >= rows || c < 0 || c >= cols
    return false if board[r][c] != word[idx]   # character mismatch

    tmp = board[r][c]
    board[r][c] = '#'           # mark as visited (in-place)
    found = dirs.any? { |dr, dc| dfs.call(r + dr, c + dc, idx + 1) }
    board[r][c] = tmp           # backtrack: restore original character

    found
  end

  rows.times { |r| cols.times { |c| return true if dfs.call(r, c, 0) } }
  false
end

if __FILE__ == $PROGRAM_NAME
  board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]]
  puts "Brute: #{exist_brute(board.map(&:dup), 'ABCCED')}"  # true
  puts "Opt:   #{exist(board.map(&:dup), 'ABCCED')}"         # true
  puts "Brute: #{exist_brute(board.map(&:dup), 'ABCB')}"    # false
  puts "Opt:   #{exist(board.map(&:dup), 'ABCB')}"           # false
end
