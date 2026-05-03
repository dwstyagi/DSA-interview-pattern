# frozen_string_literal: true

# LeetCode 19: Remove Nth Node From End of List
#
# Problem:
# Given the head of a singly linked list and an integer n, remove the nth node
# from the end of the list and return the head of the modified list.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    First traverse the list to count its length.
#    Convert "nth from the end" into "index from the front".
#    Traverse again to the node before the target and remove it.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
#    This is correct, but it needs two passes.
#
# 2. Bottleneck
#    The first pass only exists to learn the list length.
#    We can avoid that by using two pointers with a fixed gap.
#
# 3. Optimized Accepted Approach
#    Use a dummy node before head.
#    Move fast n + 1 steps ahead of slow, then move both together until fast
#    reaches nil.
#
#    At that point, slow is exactly before the node to remove.
#    Remove it with:
#      slow.next = slow.next.next
#
#    Why dummy node?
#    It handles removing the original head without special-case code.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# list = 1 -> 2 -> 3 -> 4 -> 5
# n = 2
#
# dummy -> 1 -> 2 -> 3 -> 4 -> 5
# slow = dummy
# fast = dummy
#
# Move fast n + 1 = 3 steps:
# fast points to 3
#
# Move slow and fast together:
# fast: 4, slow: 1
# fast: 5, slow: 2
# fast: nil, slow: 3
#
# slow is before target node 4.
# Remove 4:
# 1 -> 2 -> 3 -> 5
#
# Edge Cases:
# - removing the head
# - single node list
# - removing the last node

class ListNode
  attr_accessor :val, :next

  def initialize(val = 0, next_node = nil)
    @val = val
    @next = next_node
  end
end

def remove_nth_from_end_true_brute_force(head, target_from_end)
  dummy = ListNode.new(0, head)
  length = linked_list_length(head)
  steps_to_previous = length - target_from_end
  previous = dummy

  steps_to_previous.times do
    previous = previous.next
  end

  previous.next = previous.next.next
  dummy.next
end

def remove_nth_from_end(head, target_from_end)
  dummy = ListNode.new(0, head)
  slow = dummy
  fast = dummy

  (target_from_end + 1).times do
    fast = fast.next
  end

  while fast
    slow = slow.next
    fast = fast.next
  end

  slow.next = slow.next.next
  dummy.next
end

def linked_list_length(head)
  length = 0
  current = head

  while current
    length += 1
    current = current.next
  end

  length
end

def build_linked_list(values)
  dummy = ListNode.new
  current = dummy

  values.each do |value|
    current.next = ListNode.new(value)
    current = current.next
  end

  dummy.next
end

def linked_list_values(head)
  values = []
  current = head

  while current
    values << current.val
    current = current.next
  end

  values
end

if __FILE__ == $PROGRAM_NAME
  brute_force_head = build_linked_list([1, 2, 3, 4, 5])
  optimized_head = build_linked_list([1, 2, 3, 4, 5])
  target_from_end = 2

  brute_force_result = remove_nth_from_end_true_brute_force(brute_force_head, target_from_end)
  optimized_result = remove_nth_from_end(optimized_head, target_from_end)

  puts "True brute force: #{linked_list_values(brute_force_result)}"
  puts "Optimized:        #{linked_list_values(optimized_result)}"
end
