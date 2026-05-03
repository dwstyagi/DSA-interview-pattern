# frozen_string_literal: true

# LeetCode 55: Jump Game
#
# Problem:
# Given nums where nums[i] is the max jump length from index i.
# Return true if you can reach the last index, starting from index 0.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS/DFS from index 0, try all reachable positions.
#    Time Complexity: O(2^n) worst case
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    We only need to track the farthest reachable index, not all paths.
#
# 3. Optimized Accepted Approach
#    Greedy: track max_reach. For each index i <= max_reach, update
#    max_reach = max(max_reach, i + nums[i]). If max_reach >= last index, true.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, 3, 1, 1, 4]
# i=0: max_reach = max(0, 0+2) = 2
# i=1: max_reach = max(2, 1+3) = 4 >= 4 -> return true
#
# nums = [3, 2, 1, 0, 4]
# i=0: max_reach=3; i=1: max_reach=3; i=2: max_reach=3; i=3: max_reach=3
# i=4: 4 > max_reach=3 -> never reached -> return false
#
# Edge Cases:
# - Single element: always true
# - nums[0] = 0 and length > 1: false

def can_jump_brute?(nums)
  reachable = Array.new(nums.length, false)
  reachable[0] = true
  nums.length.times do |i|
    next unless reachable[i]
    (1..nums[i]).each do |jump|
      reachable[i + jump] = true if i + jump < nums.length
    end
  end
  reachable[-1]
end

# optimized: greedy max reach
def can_jump?(nums)
  max_reach = 0
  nums.each_with_index do |jump, i|
    return false if i > max_reach
    max_reach = [max_reach, i + jump].max
    return true if max_reach >= nums.length - 1
  end
  true
end

if __FILE__ == $PROGRAM_NAME
  puts can_jump_brute?([2, 3, 1, 1, 4])  # true
  puts can_jump?([3, 2, 1, 0, 4])        # false
end
