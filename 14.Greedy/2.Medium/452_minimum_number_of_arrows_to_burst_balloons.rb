# frozen_string_literal: true

# LeetCode 452: Minimum Number of Arrows to Burst Balloons
#
# Problem:
# Balloons are represented as [xstart, xend]. An arrow shot at x bursts all
# balloons where xstart <= x <= xend. Return minimum arrows to burst all balloons.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all positions for arrows, check coverage. Exponential.
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Reduce to interval scheduling: shoot at the end of the earliest-ending
#    balloon to pop as many overlapping balloons as possible.
#
# 3. Optimized Accepted Approach
#    Sort by end coordinate. Shoot at first balloon's end. Any balloon that
#    starts after this arrow position needs a new arrow.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# points = [[10,16],[2,8],[1,6],[7,12]]
# sorted by end: [[1,6],[2,8],[7,12],[10,16]]
# arrow=6: bursts [1,6],[2,8] (8>=6 and 2<=6)
# i=2: start=7 > 6 -> new arrow=12; arrow=12
# i=3: start=10 <= 12 -> burst -> done
# Result: 2
#
# Edge Cases:
# - Single balloon: 1 arrow
# - Non-overlapping: one arrow per balloon

def find_min_arrow_shots_brute(points)
  return 0 if points.empty?
  sorted = points.sort_by(&:last)
  arrows = 1
  arrow_pos = sorted[0][1]
  (1...sorted.length).each do |i|
    if sorted[i][0] > arrow_pos
      arrows += 1
      arrow_pos = sorted[i][1]
    end
  end
  arrows
end

# optimized: same greedy, cleaner variable naming
def find_min_arrow_shots(points)
  return 0 if points.empty?
  points.sort_by!(&:last)
  arrows = 1
  pos = points[0][1]
  (1...points.length).each do |i|
    if points[i][0] > pos
      arrows += 1
      pos = points[i][1]
    end
  end
  arrows
end

if __FILE__ == $PROGRAM_NAME
  puts find_min_arrow_shots_brute([[10, 16], [2, 8], [1, 6], [7, 12]])  # 2
  puts find_min_arrow_shots([[1, 2], [3, 4], [5, 6], [7, 8]])           # 4
end
