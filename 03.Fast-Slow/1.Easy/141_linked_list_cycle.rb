# frozen_string_literal: true

require 'set'

# LeetCode 141: Linked List Cycle
#
# Problem:
# Given the head of a linked list, return true if there is a cycle in the list,
# otherwise return false. A cycle exists if some node can be reached again by
# continuously following the next pointer.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Traverse the list and store each visited node in a Set.
#    If we visit a node that is already in the Set, a cycle exists.
#    If we reach nil, no cycle exists.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    We use O(n) extra space to track visited nodes.
#    We can do better — if a cycle exists, a fast pointer moving 2 steps
#    and a slow pointer moving 1 step will eventually meet inside the cycle.
#    No extra space needed.
#
# 3. Optimized Accepted Approach
#    Use two pointers: slow moves 1 step, fast moves 2 steps.
#    If fast or fast.next reaches nil, no cycle exists.
#    If slow == fast at any point, a cycle exists.
#
#    Why do they meet?
#    - If there's a cycle, fast enters it first and laps slow.
#    - Each step, fast gains 1 step on slow inside the cycle.
#    - So they must eventually land on the same node.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# List: 3 -> 2 -> 0 -> -4 -> (back to 2)
#
# Initial: slow = 3, fast = 3
#
# step 1: slow = 2,  fast = 0   (fast skips: 3->2->0)
# step 2: slow = 0,  fast = 2   (fast skips: 0->-4->2)
# step 3: slow = -4, fast = -4  (fast skips: 2->0->-4... wait, 0->-4)
#          slow == fast -> cycle detected -> return true
#
# No cycle example: 1 -> 2 -> 3 -> nil
# step 1: slow = 2, fast = 3
# step 2: fast.next = nil -> loop exits -> return false
#
# Edge Cases:
# - Empty list (head = nil) -> false, fast&.next is nil immediately
# - Single node, no self-loop -> false
# - Single node pointing to itself -> true, slow == fast after step 1

# singly linked list node
class ListNode
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

# brute force: track every visited node in a Set
# if we see the same node twice, there's a cycle
def cycle_brute?(head)
  visited = Set.new
  current = head

  while current
    return true if visited.include?(current) # already seen -> cycle

    visited.add(current)
    current = current.next
  end

  false # reached nil -> no cycle
end

# optimized: Floyd's tortoise and hare
# slow moves 1 step, fast moves 2 steps
# if they meet -> cycle; if fast hits nil -> no cycle
def cycle?(head)
  slow = head
  fast = head

  # fast&.next: stop if fast is nil OR fast.next is nil (end of list)
  while fast&.next
    slow = slow.next       # tortoise: 1 step at a time
    fast = fast.next.next  # hare: 2 steps at a time

    return true if slow == fast # they met inside the cycle
  end

  false # fast reached end -> no cycle
end

if __FILE__ == $PROGRAM_NAME
  # build list: 3 -> 2 -> 0 -> -4 -> (back to node2)
  node1 = ListNode.new(3)
  node2 = ListNode.new(2)
  node3 = ListNode.new(0)
  node4 = ListNode.new(-4)

  node1.next = node2
  node2.next = node3
  node3.next = node4
  node4.next = node2 # creates the cycle

  puts "Brute force: #{cycle_brute?(node1)}"
  puts "Optimized:   #{cycle?(node1)}"
end
