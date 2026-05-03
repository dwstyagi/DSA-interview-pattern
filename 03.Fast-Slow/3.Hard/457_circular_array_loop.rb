# frozen_string_literal: true

# LeetCode 457: Circular Array Loop
#
# Problem:
# Given a circular integer array nums, return true if there is a cycle.
# A cycle must:
# - Have length > 1 (no single-element cycle)
# - Move in only one direction (all steps forward or all steps backward)
# Movement: from index i, next index is (i + nums[i]) % n (circular)
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each starting index, simulate the traversal tracking visited indices.
#    If we revisit the start, it's a valid cycle.
#    Check direction consistency throughout.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Revisiting indices across different starting points is wasted work.
#    Use Floyd's cycle detection from each starting index.
#    If slow == fast and cycle length > 1, return true.
#    Mark dead-end indices as 0 to skip them in future iterations.
#
# 3. Optimized Accepted Approach
#    For each index i:
#    - Use slow/fast pointers on the circular traversal function
#    - At each step, check direction consistency
#      (nums[slow] and nums[fast] must have same sign as nums[i])
#    - If slow == fast, check cycle length > 1
#    - If invalid direction detected, mark indices as 0 (dead end)
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, -1, 1, 2, 2]
#
# i=0: direction = positive (nums[0]=2 > 0)
# slow=0, fast=0
# step 1: slow=next(0)=2, fast=next(next(0))=next(2)=3
# step 2: slow=next(2)=3, fast=next(next(3))=next(0)=2
# step 3: slow=next(3)=0, fast=next(next(2))=next(3)=0
# slow==fast=0 -> check cycle length: next(0)=2 != 0 -> length > 1 -> return true ✓
#
# Edge Cases:
# - All same values -> might be a single-element cycle (invalid, length must > 1)
# - nums[i] = 0 -> skip (no movement)
# - Direction change in cycle -> invalid

# next index in circular array (handles negative steps too)
def next_index(nums, i)
  n = nums.length
  ((i + nums[i]) % n + n) % n # double mod to handle negatives in Ruby
end

# check if two indices move in the same direction
def same_direction?(nums, i, j)
  (nums[i] > 0) == (nums[j] > 0)
end

# brute force: simulate from each index, track visited
def circular_array_loop_brute?(nums)
  n = nums.length

  n.times do |start|
    next if nums[start].zero? # no movement

    visited = {}
    i = start
    step = 0

    loop do
      break if visited[i] # revisited
      break unless same_direction?(nums, start, i) # direction changed

      visited[i] = step
      i = next_index(nums, i)
      step += 1
    end

    # valid cycle if we revisited and cycle length > 1
    return true if visited[i] && step - visited[i] > 1
  end

  false
end

# optimized: Floyd's cycle detection with direction check and dead-end marking
def circular_array_loop?(nums)
  n = nums.length

  n.times do |i|
    next if nums[i].zero? # skip dead ends

    slow = i
    fast = i

    # advance slow 1 step, fast 2 steps, checking direction at each step
    loop do
      # advance slow one step (check direction)
      slow_next = next_index(nums, slow)
      break unless same_direction?(nums, i, slow_next)

      slow = slow_next

      # advance fast two steps (check direction at each)
      fast_next = next_index(nums, fast)
      break unless same_direction?(nums, i, fast_next)

      fast = fast_next
      fast_next = next_index(nums, fast)
      break unless same_direction?(nums, i, fast_next)

      fast = fast_next

      # check if cycle found
      if slow == fast
        # verify cycle length > 1 (next of slow must not be slow itself)
        return true if next_index(nums, slow) != slow

        break # single-element cycle, invalid
      end
    end
  end

  false
end

if __FILE__ == $PROGRAM_NAME
  nums = [2, -1, 1, 2, 2]

  puts "Brute force: #{circular_array_loop_brute?(nums)}"
  puts "Optimized:   #{circular_array_loop?(nums)}"
end
