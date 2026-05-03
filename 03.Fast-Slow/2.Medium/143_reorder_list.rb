# frozen_string_literal: true

# LeetCode 143: Reorder List
#
# Problem:
# Given the head of a singly linked list: L0 -> L1 -> ... -> Ln
# Reorder it to: L0 -> Ln -> L1 -> Ln-1 -> L2 -> Ln-2 -> ...
# Do not return a new list — modify in-place.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Collect all nodes into an array.
#    Use two pointers (left, right) to interleave nodes from front and back.
#    Rebuild the list.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra array uses O(n) space.
#    We can do it in O(1) space with three steps:
#    1. Find middle with slow/fast pointers
#    2. Reverse the second half
#    3. Merge the two halves by interleaving
#
# 3. Optimized Accepted Approach
#    Phase 1: find middle using slow/fast pointers
#    Phase 2: reverse the second half in-place
#    Phase 3: merge first half and reversed second half node by node
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# List: 1 -> 2 -> 3 -> 4 -> 5
#
# Phase 1 (find middle):
# slow=1, fast=1
# step 1: slow=2, fast=3
# step 2: slow=3, fast=5
# fast.next=nil -> exit, slow=3 (middle)
# first half: 1->2->3, second half: 4->5 (starting from slow.next)
# cut: slow.next = nil -> first half: 1->2->3
#
# Phase 2 (reverse second half 4->5):
# result: 5->4
#
# Phase 3 (merge 1->2->3 and 5->4):
# step 1: 1.next=5, 5.next=2 -> 1->5->2->3
# step 2: 2.next=4, 4.next=3 -> 1->5->2->4->3
# second half exhausted -> done
# result: 1->5->2->4->3 ✓
#
# Edge Cases:
# - 1 or 2 nodes -> no reordering needed
# - Even length: 1->2->3->4 -> 1->4->2->3

# singly linked list node
class ListNode # rubocop:disable Style/Documentation
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

# helper: reverse a linked list in-place, return new head
def reverse_list(head)
  prev = nil
  current = head

  while current
    next_node = current.next
    current.next = prev
    prev = current
    current = next_node
  end

  prev
end

# brute force: collect into array, interleave from both ends
def reorder_list_brute(head)
  return if head.nil? || head.next.nil?

  nodes = []
  current = head
  while current
    nodes << current
    current = current.next
  end

  left = 0
  right = nodes.length - 1

  while left < right
    nodes[left].next = nodes[right]   # connect front to back
    left += 1
    break if left == right            # odd length: stop here

    nodes[right].next = nodes[left]   # connect back to next front
    right -= 1
  end

  nodes[left].next = nil # terminate the list
end

# optimized: find middle, reverse second half, merge
def reorder_list(head)
  return if head.nil? || head.next.nil?

  # phase 1: find middle
  slow = head
  fast = head
  slow = slow.next and fast = fast.next.next while fast&.next

  # slow is at the middle; cut the list in two halves
  second = slow.next
  slow.next = nil # terminate first half

  # phase 2: reverse the second half
  second = reverse_list(second)

  # phase 3: merge by interleaving
  first = head
  while second
    tmp1 = first.next   # save rest of first half
    tmp2 = second.next  # save rest of second half

    first.next = second   # insert second half node
    second.next = tmp1    # connect back to first half

    first = tmp1   # advance first pointer
    second = tmp2  # advance second pointer
  end
end

if __FILE__ == $PROGRAM_NAME
  vals = [1, 2, 3, 4, 5]
  nodes = vals.map { |v| ListNode.new(v) }
  nodes.each_cons(2) { |a, b| a.next = b }

  reorder_list(nodes.first)

  output = []
  current = nodes.first
  while current
    output << current.val
    current = current.next
  end
  puts "Result: #{output}"
end
