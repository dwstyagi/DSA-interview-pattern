# frozen_string_literal: true

# LeetCode 85: Maximal Rectangle
#
# Problem:
# Given a binary matrix of '0's and '1's, find the largest rectangle containing only '1's.
# Return its area.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all pairs of top-left and bottom-right corners, check if rectangle is all '1's.
#    Time Complexity: O(m^2 * n^2 * m * n) = O(m^3 * n^3)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Reduce to histogram problem. For each row, compute column heights (consecutive '1's).
#    Apply largest rectangle in histogram.
#
# 3. Optimized Accepted Approach
#    Maintain height array. For each row update heights (reset to 0 if '0').
#    Apply LC 84's monotonic stack solution to each row's heights.
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# matrix=[["1","0","1","0","0"],["1","0","1","1","1"],["1","1","1","1","1"],["1","0","0","1","0"]]
# Row 0 heights: [1,0,1,0,0] -> max rect = 1
# Row 1 heights: [2,0,2,1,1] -> max rect = 3
# Row 2 heights: [3,1,3,2,2] -> max rect = 6
# Row 3 heights: [4,0,0,3,0] -> max rect = 4
# Result: 6
#
# Edge Cases:
# - All '0's: 0
# - Single row: largest_rectangle_in_histogram of that row

def maximal_rectangle_brute(matrix)
  return 0 if matrix.empty?
  max_area = 0
  rows = matrix.length
  cols = matrix[0].length
  heights = Array.new(cols, 0)
  rows.times do |r|
    cols.times { |c| heights[c] = matrix[r][c] == '1' ? heights[c] + 1 : 0 }
    stack = []
    (heights + [0]).each_with_index do |h, i|
      while !stack.empty? && heights[stack.last] > h
        ht = heights[stack.pop]
        w = stack.empty? ? i : i - stack.last - 1
        max_area = [max_area, ht * w].max
      end
      stack << i
    end
  end
  max_area
end

# optimized: same histogram approach per row
def maximal_rectangle(matrix)
  return 0 if matrix.empty?
  cols = matrix[0].length
  heights = Array.new(cols, 0)
  max_area = 0

  hist_max = lambda do |h_arr|
    stack = []
    area = 0
    (h_arr + [0]).each_with_index do |h, i|
      while !stack.empty? && h_arr[stack.last] > h
        ht = h_arr[stack.pop]
        w = stack.empty? ? i : i - stack.last - 1
        area = [area, ht * w].max
      end
      stack << i
    end
    area
  end

  matrix.each do |row|
    cols.times { |c| heights[c] = row[c] == '1' ? heights[c] + 1 : 0 }
    max_area = [max_area, hist_max.call(heights)].max
  end
  max_area
end

if __FILE__ == $PROGRAM_NAME
  matrix = [%w[1 0 1 0 0], %w[1 0 1 1 1], %w[1 1 1 1 1], %w[1 0 0 1 0]]
  puts maximal_rectangle_brute(matrix)  # 6
  puts maximal_rectangle(matrix)        # 6
end
