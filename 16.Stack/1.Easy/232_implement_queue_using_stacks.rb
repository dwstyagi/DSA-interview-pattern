# frozen_string_literal: true

# LeetCode 232: Implement Queue using Stacks
#
# Problem:
# Implement a FIFO queue using only two stacks.
# Support push, pop, peek, and empty operations.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    On every pop/peek, reverse the entire stack, operate, then reverse back.
#    Time Complexity: O(n) push, O(n) pop
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Reversing twice on every pop is wasteful. Amortize: only transfer from
#    input stack to output stack when output is empty.
#
# 3. Optimized Accepted Approach
#    Two stacks: input and output. push -> input. pop/peek: if output empty,
#    move all from input to output (reverses order). Then operate on output.
#    Amortized O(1) per operation.
#
#    Time Complexity: O(1) amortized
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# push(1), push(2)
# input=[1,2], output=[]
# pop: output empty -> transfer -> input=[], output=[2,1]
#      pop output -> return 1
# peek: output=[2] -> peek -> return 2
#
# Edge Cases:
# - pop from empty queue: undefined (problem guarantees valid calls)
# - Multiple pushes before any pop: all transferred at once

class MyQueueBrute
  def initialize
    @data = []
  end

  def push(x)
    @data << x
  end

  def pop
    @data.shift
  end

  def peek
    @data.first
  end

  def empty?
    @data.empty?
  end
end

class MyQueue
  def initialize
    @input = []
    @output = []
  end

  def push(x)
    @input << x
  end

  def pop
    move_if_needed
    @output.pop
  end

  def peek
    move_if_needed
    @output.last
  end

  def empty?
    @input.empty? && @output.empty?
  end

  private

  def move_if_needed
    @output.push(@input.pop) while @output.empty? && !@input.empty?
  end
end

if __FILE__ == $PROGRAM_NAME
  q = MyQueue.new
  q.push(1)
  q.push(2)
  puts q.peek   # 1
  puts q.pop    # 1
  puts q.empty? # false
end
