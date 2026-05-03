# frozen_string_literal: true

# LeetCode 142: Linked List Cycle II
#
# Problem:
# Given the head of a linked list, return the node where the cycle begins.
# If there is no cycle, return nil.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Traverse the list and store each visited node in a Set.
#    The first node we visit that is already in the Set is the cycle start.
#    If we reach nil, return nil.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    We use O(n) extra space for the Set.
#    Floyd's algorithm can find the cycle start in O(1) space using math.
#
# 3. Optimized Accepted Approach
#    Phase 1: detect cycle with slow/fast pointers (141).
#    Phase 2: reset slow to head, keep fast at meeting point.
#    Move both 1 step at a time — they meet at the cycle start.
#
#    Why does phase 2 work?
#    Let L = distance from head to cycle start
#    Let x = distance from cycle start to meeting point
#    Let C = cycle length
#    Fast travels 2*(L+x), slow travels L+x, and fast = slow + n*C
#    => L+x = n*C => L = n*C - x
#    So a pointer from head and one from meeting point both travel L steps
#    and land on the cycle start.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# List: 3 -> 2 -> 0 -> -4 -> (back to 2), cycle starts at node(2)
#
# Phase 1 (detect):
# slow=3, fast=3
# step 1: slow=2, fast=0
# step 2: slow=0, fast=2  (fast: -4->2)
# step 3: slow=-4, fast=-4 (fast: 0->-4... wait 2->0->-4)
# slow == fast at -4 -> cycle detected
#
# Phase 2 (find start):
# reset slow to head (3), keep fast at -4
# step 1: slow=2, fast=2  (fast: -4->2)
# slow == fast at node(2) -> cycle start found ✓
#
# Edge Cases:
# - No cycle -> return nil
# - Cycle at head -> L=0, pointers meet at head immediately in phase 2

# singly linked list node
class ListNode # rubocop:disable Style/Documentation
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

# brute force: first repeated node in a Set is the cycle start
def detect_cycle_brute(head)
  visited = Set.new
  current = head

  while current
    return current if visited.include?(current) # first revisit = cycle start

    visited.add(current)
    current = current.next
  end

  nil # no cycle
end

# optimized: Floyd's two-phase algorithm
def detect_cycle(head)
  slow = head
  fast = head

  # phase 1: detect if a cycle exists, find meeting point
  while fast&.next
    slow = slow.next
    fast = fast.next.next
    break if slow == fast # met inside the cycle
  end

  return nil unless fast&.next # no cycle (fast hit nil)

  # phase 2: find cycle start
  # reset slow to head, keep fast at meeting point
  # both move 1 step — they meet at cycle entry
  slow = head
  while slow != fast
    slow = slow.next
    fast = fast.next
  end

  slow # cycle start node
end

if __FILE__ == $PROGRAM_NAME
  node1 = ListNode.new(3)
  node2 = ListNode.new(2)
  node3 = ListNode.new(0)
  node4 = ListNode.new(-4)

  node1.next = node2
  node2.next = node3
  node3.next = node4
  node4.next = node2 # cycle back to node2

  puts "Brute force cycle start: #{detect_cycle_brute(node1).val}"
  puts "Optimized cycle start:   #{detect_cycle(node1).val}"
end
