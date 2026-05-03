# frozen_string_literal: true

# LeetCode 155: Min Stack
#
# Problem:
# Design a stack that supports push, pop, top, and getMin in O(1) time.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Regular stack for push/pop/top. For getMin, scan entire stack.
#    Time Complexity: O(n) for getMin
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    getMin is O(n). Maintain a second "min stack" in parallel to track minimums.
#
# 3. Optimized Accepted Approach
#    Two stacks: main stack and min_stack. On push(val), push to min_stack if val
#    <= current min (or min_stack empty). On pop, also pop min_stack if top == min.
#
#    Time Complexity: O(1) all operations
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# push(-2): stack=[-2], min=[-2]
# push(0):  stack=[-2,0], min=[-2]
# push(-3): stack=[-2,0,-3], min=[-2,-3]
# getMin -> -3
# pop:      stack=[-2,0], min=[-2]
# top -> 0
# getMin -> -2
#
# Edge Cases:
# - Pushing duplicates of minimum: use <= not < when pushing to min stack

class MinStackBrute
  def initialize
    @stack = []
  end

  def push(val)
    @stack << val
  end

  def pop
    @stack.pop
  end

  def top
    @stack.last
  end

  def get_min
    @stack.min
  end
end

class MinStack
  def initialize
    @stack = []
    @min_stack = []
  end

  def push(val)
    @stack << val
    @min_stack << val if @min_stack.empty? || val <= @min_stack.last
  end

  def pop
    val = @stack.pop
    @min_stack.pop if val == @min_stack.last
    val
  end

  def top
    @stack.last
  end

  def get_min
    @min_stack.last
  end
end

if __FILE__ == $PROGRAM_NAME
  ms = MinStack.new
  ms.push(-2)
  ms.push(0)
  ms.push(-3)
  puts ms.get_min  # -3
  ms.pop
  puts ms.top      # 0
  puts ms.get_min  # -2
end
