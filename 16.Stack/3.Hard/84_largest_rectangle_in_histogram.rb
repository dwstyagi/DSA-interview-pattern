# frozen_string_literal: true

# LeetCode 84: Largest Rectangle in Histogram
#
# Problem:
# Given heights array representing histogram bar heights (width=1 each),
# return the area of the largest rectangle.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each pair (i, j), the rectangle height is min(heights[i..j]).
#    Try all pairs and track max area.
#    Time Complexity: O(n^2) or O(n^3)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Redundant range minimum computations. Monotonic stack: for each bar,
#    find the nearest shorter bar on each side.
#
# 3. Optimized Accepted Approach
#    Monotonic increasing stack of indices. When a shorter bar is found,
#    pop and calculate rectangle with popped bar as height.
#    Width = distance between current index and new stack top.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# heights = [2,1,5,6,2,3]
# i=0(2): stack=[0]
# i=1(1): 1<2 -> pop 0: area=2*1=2; push 1 -> stack=[1]
# i=2(5): push 2 -> stack=[1,2]
# i=3(6): push 3 -> stack=[1,2,3]
# i=4(2): 2<6 -> pop 3: area=6*1=6; 2<5 -> pop 2: area=5*2=10; push 4
# i=5(3): push 5 -> stack=[1,4,5]
# End: pop 5: area=3*1=3; pop 4: area=2*2=4; pop 1: area=1*6=6
# Max: 10
#
# Edge Cases:
# - All same height: area = height * n
# - Descending: each bar forms its own rectangle

def largest_rectangle_area_brute(heights)
  n = heights.length
  max_area = 0
  n.times do |i|
    min_h = heights[i]
    (i...n).each do |j|
      min_h = [min_h, heights[j]].min
      max_area = [max_area, min_h * (j - i + 1)].max
    end
  end
  max_area
end

def largest_rectangle_area(heights)
  stack = []
  max_area = 0
  (heights.length + 1).times do |i|
    h = i == heights.length ? 0 : heights[i]
    while !stack.empty? && heights[stack.last] > h
      height = heights[stack.pop]
      width = stack.empty? ? i : i - stack.last - 1
      max_area = [max_area, height * width].max
    end
    stack << i
  end
  max_area
end

if __FILE__ == $PROGRAM_NAME
  puts largest_rectangle_area_brute([2, 1, 5, 6, 2, 3])  # 10
  puts largest_rectangle_area([2, 4])                     # 4
end
