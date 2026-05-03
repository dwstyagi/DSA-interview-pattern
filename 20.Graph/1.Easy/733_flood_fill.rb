# frozen_string_literal: true

# LeetCode 733: Flood Fill
#
# Problem:
# Given image grid, starting pixel (sr, sc) and color, flood fill: change all
# pixels connected (4-directional) with same original color to new color.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS/DFS from starting pixel, change color of all reachable same-color pixels.
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n)
#
# 2. Bottleneck
#    Already optimal. BFS uses a queue; DFS uses recursion stack.
#
# 3. Optimized Accepted Approach
#    DFS in-place. If original color equals new color, return immediately.
#    Otherwise recursively fill.
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n) recursion
#
# -----------------------------------------------------------------------------
# Dry Run
#
# image=[[1,1,1],[1,1,0],[1,0,1]], sr=1, sc=1, color=2
# original=1, new=2
# DFS from (1,1)=1 -> change to 2, recurse all 4 directions
# Result: [[2,2,2],[2,2,0],[2,0,1]]
#
# Edge Cases:
# - Start pixel already has new color: return unchanged
# - Single pixel image: change that pixel

def flood_fill_brute(image, sr, sc, color)
  rows = image.length
  cols = image[0].length
  original = image[sr][sc]
  return image if original == color

  fill = lambda do |r, c|
    return if r < 0 || r >= rows || c < 0 || c >= cols || image[r][c] != original
    image[r][c] = color
    fill.call(r + 1, c); fill.call(r - 1, c)
    fill.call(r, c + 1); fill.call(r, c - 1)
  end
  fill.call(sr, sc)
  image
end

# optimized: same DFS (already optimal)
def flood_fill(image, sr, sc, color)
  rows = image.length
  cols = image[0].length
  original = image[sr][sc]
  return image if original == color

  dfs = lambda do |r, c|
    return if r < 0 || r >= rows || c < 0 || c >= cols || image[r][c] != original
    image[r][c] = color
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each { |dr, dc| dfs.call(r + dr, c + dc) }
  end
  dfs.call(sr, sc)
  image
end

if __FILE__ == $PROGRAM_NAME
  puts flood_fill_brute([[1, 1, 1], [1, 1, 0], [1, 0, 1]], 1, 1, 2).inspect
  # [[2,2,2],[2,2,0],[2,0,1]]
end
