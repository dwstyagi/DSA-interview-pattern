# frozen_string_literal: true

# LeetCode 24: Swap Nodes in Pairs
#
# Problem:
# Given a linked list, swap every two adjacent nodes and return its head.
# You must solve it without modifying the node values — only change pointers.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Collect all values into an array.
#    Swap adjacent pairs in the array.
#    Rebuild the list.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra array is unnecessary.
#    We can swap pointers directly in-place using a dummy head to simplify
#    edge cases at the head of the list.
#
# 3. Optimized Accepted Approach
#    Use a dummy node before head to unify edge cases.
#    Use a prev pointer starting at dummy.
#    While two nodes ahead exist (prev.next and prev.next.next):
#    - Identify the pair: first = prev.next, second = prev.next.next
#    - Rewire: prev.next = second, first.next = second.next, second.next = first
#    - Advance prev to first (now the second in the pair)
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# List: 1 -> 2 -> 3 -> 4
# dummy -> 1 -> 2 -> 3 -> 4, prev = dummy
#
# step 1: first=1, second=2
#   prev.next = 2
#   first.next = second.next = 3
#   second.next = first = 1
#   list: dummy -> 2 -> 1 -> 3 -> 4
#   prev = first = 1
#
# step 2: first=3, second=4
#   prev.next = 4
#   first.next = second.next = nil
#   second.next = first = 3
#   list: dummy -> 2 -> 1 -> 4 -> 3
#   prev = first = 3
#
# prev.next = nil -> exit
# return dummy.next = 2 -> 1 -> 4 -> 3 ✓
#
# Edge Cases:
# - Empty list -> return nil
# - Single node -> return as-is (no pair to swap)
# - Odd length: last node stays in place

# singly linked list node
class ListNode # rubocop:disable Style/Documentation
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

# brute force: swap values in array, rebuild
def swap_pairs_brute(head)
  values = []
  current = head
  while current
    values << current.val
    current = current.next
  end

  # swap adjacent pairs in the array
  (0...values.length - 1).step(2) do |i|
    values[i], values[i + 1] = values[i + 1], values[i]
  end

  # rebuild list with swapped values
  dummy = ListNode.new(0)
  current = dummy
  values.each do |val|
    current.next = ListNode.new(val)
    current = current.next
  end

  dummy.next
end

# optimized: in-place pointer rewiring with dummy head
def swap_pairs(head)
  dummy = ListNode.new(0)
  dummy.next = head
  prev = dummy # prev always points to the node before the current pair

  while prev.next&.next # need at least two nodes ahead
    first = prev.next        # first node of the pair
    second = prev.next.next  # second node of the pair

    # rewire pointers to swap the pair
    prev.next = second        # prev now points to second
    first.next = second.next  # first points to whatever was after second
    second.next = first       # second points back to first

    prev = first # advance prev to first (now the tail of the swapped pair)
  end

  dummy.next # return new head (dummy.next after rewiring)
end

if __FILE__ == $PROGRAM_NAME
  vals = [1, 2, 3, 4]
  nodes = vals.map { |v| ListNode.new(v) }
  nodes.each_cons(2) { |a, b| a.next = b }

  result = swap_pairs(nodes.first)
  output = []
  while result
    output << result.val
    result = result.next
  end
  puts "Result: #{output}"
end
