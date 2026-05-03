# frozen_string_literal: true

# LeetCode 11: Container With Most Water
#
# Problem:
# Given an integer array height, choose two lines that together with the x-axis
# form a container. Return the maximum amount of water the container can store.
#
# Area between two indices:
#   (right - left) * [height[left], height[right]].min
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every pair of lines.
#    For each pair, compute the width, the limiting height, and the area.
#    Track the maximum area.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Brute force checks all pairs even though many can be discarded using the
#    shorter-height rule.
#    The area is limited by the shorter line, so moving the taller line inward
#    cannot improve the limiting height for the current shorter line.
#
# 3. Optimized Accepted Approach
#    Use two pointers from opposite ends.
#    Start with the widest possible container.
#    At each step:
#    - compute the current area
#    - move the pointer with the smaller height inward
#
#    Why move the smaller side?
#    The current area is limited by that smaller height.
#    Keeping it while reducing width cannot produce a larger area, so the only
#    useful chance is to look for a taller line on that side.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# height = [1, 8, 6, 2, 5, 4, 8, 3, 7]
#
# left = 0, right = 8
# width = 8, min height = 1, area = 8
# move left because height[left] is smaller
#
# left = 1, right = 8
# width = 7, min height = 7, area = 49
# best = 49
# move right because height[right] is smaller
#
# Continue inward.
# No later container beats 49.
#
# Final answer = 49
#
# Edge Cases:
# - exactly two lines -> only one possible container
# - equal heights -> moving either pointer is acceptable
# - increasing or decreasing heights still work with the same rule

def max_area_true_brute_force(height)
  max_area = 0

  (0...height.length).each do |left|
    ((left + 1)...height.length).each do |right|
      max_area = [max_area, container_area(height, left, right)].max
    end
  end

  max_area
end

def max_area(height)
  left = 0
  right = height.length - 1
  max_area = 0

  while left < right
    max_area = [max_area, container_area(height, left, right)].max

    if height[left] < height[right]
      left += 1
    else
      right -= 1
    end
  end

  max_area
end

def container_area(height, left, right)
  width = right - left
  limiting_height = [height[left], height[right]].min
  width * limiting_height
end

if __FILE__ == $PROGRAM_NAME
  height = [1, 8, 6, 2, 5, 4, 8, 3, 7]

  puts "True brute force: #{max_area_true_brute_force(height)}"
  puts "Optimized:        #{max_area(height)}"
end
