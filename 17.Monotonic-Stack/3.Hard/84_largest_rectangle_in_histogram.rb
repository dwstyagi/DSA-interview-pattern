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
#    For each pair (i, j), rectangle height = min(heights[i..j]). Track max.
#    Time Complexity: O(n^2) with running min, O(n^3) naively
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Repeated range min computations. Monotonic increasing stack: for each bar,
#    find left and right boundaries where it's the shortest.
#
# 3. Optimized Accepted Approach
#    Monotonic increasing stack of indices. When height[i] < height[stack.top],
#    pop and compute area: height[popped] * (i - stack.top - 1).
#    Append sentinel height=0 to flush stack at end.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# heights = [2,1,5,6,2,3], append 0
# i=0(2): push 0
# i=1(1): 1<2 -> pop 0: area=2*1=2, stack empty -> width=1; push 1
# i=2(5): push 2; i=3(6): push 3
# i=4(2): 2<6 -> pop 3: area=6*1=6; 2<5 -> pop 2: area=5*2=10; push 4
# i=5(3): push 5
# i=6(0): 0<3 -> pop 5: area=3*1=3; 0<2 -> pop 4: area=2*2=4;
#          0<1 -> pop 1: area=1*6=6; stack empty
# Max: 10
#
# Edge Cases:
# - Uniform heights: area = h * n
# - Single bar: area = that height

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
  (heights + [0]).each_with_index do |h, i|
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
