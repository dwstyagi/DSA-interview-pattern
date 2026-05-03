# frozen_string_literal: true

# LeetCode 1019: Next Greater Node in Linked List
#
# Problem:
# Given linked list, return array where answer[i] = value of next greater node
# for node i (0-indexed). 0 if no greater node.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Convert list to array, then for each element scan right for greater.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Repeated scans. Monotonic decreasing stack on the array.
#
# 3. Optimized Accepted Approach
#    Convert to array. Monotonic stack of indices. When current > stack top,
#    pop and set result[top] = current.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# list: 2->7->4->3->5
# arr = [2,7,4,3,5]
# i=0(2): push 0
# i=1(7): 7>2 -> result[0]=7, pop; push 1
# i=2(4): 4<7, push 2
# i=3(3): 3<4, push 3
# i=4(5): 5>3 -> result[3]=5; 5>4 -> result[2]=5; 5<7, push 4
# Result: [7,0,5,5,0]
#
# Edge Cases:
# - Single node: [0]
# - Strictly decreasing: all zeros

class ListNode
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

def next_larger_nodes_brute(head)
  arr = []
  cur = head
  while cur
    arr << cur.val
    cur = cur.next
  end
  n = arr.length
  result = Array.new(n, 0)
  n.times do |i|
    (i + 1...n).each do |j|
      if arr[j] > arr[i]
        result[i] = arr[j]
        break
      end
    end
  end
  result
end

def next_larger_nodes(head)
  arr = []
  cur = head
  while cur
    arr << cur.val
    cur = cur.next
  end
  n = arr.length
  result = Array.new(n, 0)
  stack = []
  n.times do |i|
    while !stack.empty? && arr[stack.last] < arr[i]
      result[stack.pop] = arr[i]
    end
    stack << i
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  nodes = [2, 7, 4, 3, 5].map { |v| ListNode.new(v) }
  nodes.each_cons(2) { |a, b| a.next = b }
  puts next_larger_nodes_brute(nodes[0]).inspect  # [7,0,5,5,0]
  puts next_larger_nodes(nodes[0]).inspect        # [7,0,5,5,0]
end
