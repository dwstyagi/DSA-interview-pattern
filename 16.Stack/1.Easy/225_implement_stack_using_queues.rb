# frozen_string_literal: true

# LeetCode 225: Implement Stack using Queues
#
# Problem:
# Implement a LIFO stack using only queues.
# Support push, pop, top, and empty.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Two queues: on push, enqueue to q2, then dequeue all from q1 to q2, swap.
#    Time Complexity: O(n) push, O(1) pop
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Two-queue approach is standard. Single queue: on push, enqueue then rotate
#    queue by (size-1) to bring new element to front.
#
# 3. Optimized Accepted Approach
#    Single queue. push(x): enqueue x, then rotate queue size-1 times.
#    pop/top: dequeue from front.
#
#    Time Complexity: O(n) push, O(1) pop/top
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# push(1): queue=[1]
# push(2): enqueue 2 -> [1,2], rotate 1 time -> [2,1]
# top -> 2 (front)
# pop -> 2, queue=[1]
#
# Edge Cases:
# - Single element: straightforward
# - pop/top on empty: undefined (problem guarantees valid)

class MyStackBrute
  def initialize
    @q1 = []
    @q2 = []
  end

  def push(x)
    @q2 << x
    @q2 << @q1.shift until @q1.empty?
    @q1, @q2 = @q2, @q1
  end

  def pop
    @q1.shift
  end

  def top
    @q1.first
  end

  def empty?
    @q1.empty?
  end
end

class MyStack
  def initialize
    @queue = []
  end

  def push(x)
    @queue << x
    (@queue.size - 1).times { @queue << @queue.shift }
  end

  def pop
    @queue.shift
  end

  def top
    @queue.first
  end

  def empty?
    @queue.empty?
  end
end

if __FILE__ == $PROGRAM_NAME
  s = MyStack.new
  s.push(1)
  s.push(2)
  puts s.top    # 2
  puts s.pop    # 2
  puts s.empty? # false
end
