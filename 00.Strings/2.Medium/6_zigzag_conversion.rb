# frozen_string_literal: true

# LeetCode 6: Zigzag Conversion
#
# Problem:
# The string "PAYPALISHIRING" is written in a zigzag pattern on a given number of rows
# like this (numRows=3):
# P   A   H   N
# A P L S I I G
# Y   I   R
# Return the string read left to right, line by line: "PAHNAPLSIIGYIR"
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate the zigzag pattern on a 2D grid, then read row by row.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    2D grid wastes space. We only need one array per row.
#
# 3. Optimized Accepted Approach
#    Maintain an array of strings (one per row). Track current row and direction.
#    Reverse direction at top (row 0) and bottom (row numRows-1).
#    Concatenate all rows at the end.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "PAYPALISHIRING", numRows = 3
# row 0: P, A, H, N
# row 1: A, P, L, S, I, I, G
# row 2: Y, I, R
# result: "PAHNAPLSIIGYIR"
#
# Edge Cases:
# - numRows = 1    -> return s unchanged
# - numRows >= len -> return s unchanged (no zigzag)

def convert_brute(s, num_rows)
  return s if num_rows == 1 || num_rows >= s.length

  # Use a 2D array to simulate placement
  rows = Array.new(num_rows) { [] }
  row = 0
  going_down = false

  s.each_char do |char|
    rows[row] << char
    going_down = !going_down if row == 0 || row == num_rows - 1
    row += going_down ? 1 : -1
  end

  rows.map(&:join).join
end

def convert(s, num_rows)
  return s if num_rows == 1 || num_rows >= s.length

  rows = Array.new(num_rows, '')
  row = 0
  going_down = false

  s.each_char do |char|
    rows[row] += char
    # Reverse direction at top or bottom row
    going_down = !going_down if row == 0 || row == num_rows - 1
    row += going_down ? 1 : -1
  end

  rows.join
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{convert_brute('PAYPALISHIRING', 3)}" # "PAHNAPLSIIGYIR"
  puts "Optimized:   #{convert('PAYPALISHIRING', 3)}"       # "PAHNAPLSIIGYIR"
  puts "Brute force: #{convert_brute('PAYPALISHIRING', 4)}" # "PINALSIGYAHRPI"
  puts "Optimized:   #{convert('PAYPALISHIRING', 4)}"       # "PINALSIGYAHRPI"
end
