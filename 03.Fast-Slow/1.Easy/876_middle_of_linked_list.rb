# frozen_string_literal: true

# LeetCode 876: Middle of the Linked List
#
# Problem:
# Given the head of a singly linked list, return the middle node.
# If there are two middle nodes, return the second middle node.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Traverse the list once to find the total length n.
#    Traverse again to the (n/2)th node and return it.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Two passes is unnecessary.
#    If slow moves 1 step and fast moves 2 steps, when fast reaches the end
#    slow is exactly at the middle — all in one pass.
#
# 3. Optimized Accepted Approach
#    Use slow/fast pointers starting at head.
#    Move slow 1 step and fast 2 steps each iteration.
#    When fast reaches nil (or fast.next is nil), slow is at the middle.
#
#    Why second middle for even length?
#    - `while fast && fast.next` exits when fast.next is nil
#    - At that point slow has moved one extra step past the first middle
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Odd length: 1 -> 2 -> 3 -> 4 -> 5
#
# Initial: slow = 1, fast = 1
# step 1: slow = 2, fast = 3
# step 2: slow = 3, fast = 5
# fast.next = nil -> exit
# return slow = 3 (middle) ✓
#
# Even length: 1 -> 2 -> 3 -> 4 -> 5 -> 6
#
# Initial: slow = 1, fast = 1
# step 1: slow = 2, fast = 3
# step 2: slow = 3, fast = 5
# step 3: slow = 4, fast = nil (fast was 5, fast.next.next = nil... wait)
#   fast = 5, fast.next = 6, so step 3: slow = 4, fast = nil...
#   actually: fast.next = 6 (not nil), so we continue
#   slow = 4, fast = 6.next = nil... fast = nil? no:
#   fast = fast.next.next = 6.next = nil... so fast = nil
#   next iteration: fast is nil -> exit
# return slow = 4 (second middle) ✓
#
# Edge Cases:
# - Single node -> return that node
# - Two nodes -> return second node (second middle)

# singly linked list node
class ListNode # rubocop:disable Style/Documentation
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

# brute force: two passes — first count length, then walk to n/2
def middle_node_brute(head)
  length = 0
  current = head

  # first pass: count total nodes
  while current
    length += 1
    current = current.next
  end

  # second pass: walk to the middle
  current = head
  (length / 2).times { current = current.next }

  current
end

# optimized: slow/fast pointers — one pass
# slow lands on middle when fast reaches the end
def middle_node(head)
  slow = head
  fast = head

  while fast&.next  # stop when fast or fast.next is nil
    slow = slow.next       # tortoise: 1 step
    fast = fast.next.next  # hare: 2 steps
  end

  slow # slow is at the middle (second middle for even length)
end

if __FILE__ == $PROGRAM_NAME
  # build list: 1 -> 2 -> 3 -> 4 -> 5
  nodes = (1..5).map { |i| ListNode.new(i) }
  nodes.each_cons(2) { |a, b| a.next = b }

  puts "Brute force middle: #{middle_node_brute(nodes.first).val}"
  puts "Optimized middle:   #{middle_node(nodes.first).val}"
end
