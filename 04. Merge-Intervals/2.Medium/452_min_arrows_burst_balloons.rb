# frozen_string_literal: true

# LeetCode 452: Minimum Number of Arrows to Burst Balloons
#
# Problem:
# There are some spherical balloons taped onto a flat wall represented by the XY-plane.
# Balloons are represented as a 2D integer array points where points[i] = [x_start, x_end].
# An arrow shot vertically at x = k bursts any balloon where x_start <= k <= x_end.
# Return the minimum number of arrows needed to burst all balloons.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try shooting at every unique endpoint; count how many balloons each shot bursts.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Greedy insight: shoot at the earliest end time to maximize overlap benefit.
#
# 3. Optimized Accepted Approach
#    Sort by end time. Greedy: shoot at the end of the first balloon.
#    This burst all balloons whose start <= current arrow position.
#    Count new arrows needed when a balloon is not covered by the current arrow.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# points = [[10,16],[2,8],[1,6],[7,12]]
# sorted by end: [[1,6],[2,8],[7,12],[10,16]]
# arrow=6 (end of [1,6]), count=1
# [2,8]: 2<=6 → covered
# [7,12]: 7>6 → new arrow=12, count=2
# [10,16]: 10<=12 → covered
# Answer: 2
#
# Edge Cases:
# - Single balloon -> 1
# - All identical  -> 1
# - No overlap     -> n

def find_min_arrow_shots_brute(points)
  return 0 if points.empty?

  sorted = points.sort_by { |p| p[1] }
  arrows = 0
  pos = -Float::INFINITY

  sorted.each do |start, enden|
    # If this balloon is not burst by the current arrow, shoot a new one
    if start > pos
      pos = enden
      arrows += 1
    end
  end

  arrows
end

def find_min_arrow_shots(points)
  return 0 if points.empty?

  # Sort balloons by their right end — shoot at the earliest end
  sorted = points.sort_by { |p| p[1] }
  arrows = 1
  # Position of the current arrow (at the end of the first balloon)
  arrow_pos = sorted[0][1]

  sorted[1..].each do |start, _end|
    if start > arrow_pos
      # This balloon is not reached by the current arrow; need a new shot
      arrow_pos = _end
      arrows += 1
    end
    # Else: current arrow also bursts this balloon
  end

  arrows
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{find_min_arrow_shots_brute([[10, 16], [2, 8], [1, 6], [7, 12]])}" # 2
  puts "Optimized:   #{find_min_arrow_shots([[10, 16], [2, 8], [1, 6], [7, 12]])}"       # 2
  puts "Brute force: #{find_min_arrow_shots_brute([[1, 2], [3, 4], [5, 6], [7, 8]])}"    # 4
  puts "Optimized:   #{find_min_arrow_shots([[1, 2], [3, 4], [5, 6], [7, 8]])}"          # 4
end
