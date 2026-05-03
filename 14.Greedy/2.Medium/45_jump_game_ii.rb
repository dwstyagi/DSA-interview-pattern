# frozen_string_literal: true

# LeetCode 45: Jump Game II
#
# Problem:
# Given nums where nums[i] is the max jump from index i.
# Return the minimum number of jumps to reach the last index.
# It's guaranteed you can reach the last index.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS level-by-level, each level is one jump. Return level when last index reached.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    BFS visits same nodes multiple times. Greedy: at each jump, extend as far
#    as possible within the current jump range.
#
# 3. Optimized Accepted Approach
#    Greedy with two pointers: cur_end (end of current jump range) and
#    farthest (farthest reachable). When i == cur_end, increment jumps and
#    set cur_end = farthest.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, 3, 1, 1, 4]
# jumps=0, cur_end=0, farthest=0
# i=0: farthest=2; i==cur_end -> jumps=1, cur_end=2
# i=1: farthest=4; i=2: farthest=4; i==cur_end -> jumps=2, cur_end=4 -> done
# Result: 2
#
# Edge Cases:
# - Single element: 0 jumps needed
# - nums[0] >= n-1: 1 jump

def jump_brute(nums)
  n = nums.length
  dist = Array.new(n, Float::INFINITY)
  dist[0] = 0
  (0...n).each do |i|
    (1..nums[i]).each do |j|
      next if i + j >= n
      dist[i + j] = [dist[i + j], dist[i] + 1].min
    end
  end
  dist[-1]
end

# optimized: greedy range expansion
def jump(nums)
  jumps = 0
  cur_end = 0
  farthest = 0
  (0...nums.length - 1).each do |i|
    farthest = [farthest, i + nums[i]].max
    if i == cur_end
      jumps += 1
      cur_end = farthest
    end
  end
  jumps
end

if __FILE__ == $PROGRAM_NAME
  puts jump_brute([2, 3, 1, 1, 4])  # 2
  puts jump([2, 3, 0, 1, 4])        # 2
end
