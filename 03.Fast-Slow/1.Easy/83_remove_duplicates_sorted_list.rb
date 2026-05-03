# frozen_string_literal: true

# LeetCode 83: Remove Duplicates from Sorted List
#
# Problem:
# Given the head of a sorted linked list, delete all duplicates such that
# each element appears only once. Return the modified list.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Collect all values into an array, deduplicate with uniq, rebuild the list.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra space to rebuild is unnecessary.
#    Since the list is sorted, all duplicates are adjacent.
#    We can skip duplicates in-place with a single pointer.
#
# 3. Optimized Accepted Approach
#    Use one pointer (current) starting at head.
#    While current and current.next exist:
#    - If current.val == current.next.val, skip current.next (bypass it)
#    - Otherwise advance current
#    The list is modified in-place.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# List: 1 -> 1 -> 2 -> 3 -> 3
#
# current = 1 (first)
# current.val == current.next.val (1 == 1) -> skip: current.next = 2
# list: 1 -> 2 -> 3 -> 3
#
# current.val != current.next.val (1 != 2) -> advance: current = 2
#
# current = 2
# current.val != current.next.val (2 != 3) -> advance: current = 3
#
# current = 3 (first)
# current.val == current.next.val (3 == 3) -> skip: current.next = nil
# list: 1 -> 2 -> 3
#
# current.next = nil -> exit loop
# return head -> 1 -> 2 -> 3 ✓
#
# Edge Cases:
# - Empty list -> return nil
# - Single node -> return as-is
# - All same values -> return single node

# singly linked list node
class ListNode
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

# brute force: collect values, dedup, rebuild list
def delete_duplicates_brute(head)
  return head if head.nil?

  # collect all values and remove duplicates
  values = []
  current = head
  while current
    values << current.val
    current = current.next
  end

  # rebuild list from unique values
  dummy = ListNode.new(0)
  current = dummy
  values.uniq.each do |val|
    current.next = ListNode.new(val)
    current = current.next
  end

  dummy.next
end

# optimized: in-place single pass
# sorted list means duplicates are always adjacent
def delete_duplicates(head)
  current = head

  while current&.next  # stop when current or current.next is nil
    if current.val == current.next.val
      current.next = current.next.next # skip the duplicate node
    else
      current = current.next # values differ, move forward
    end
  end

  head # head is unchanged (no leading duplicates possible in sorted list)
end

if __FILE__ == $PROGRAM_NAME
  # build list: 1 -> 1 -> 2 -> 3 -> 3
  vals = [1, 1, 2, 3, 3]
  nodes = vals.map { |v| ListNode.new(v) }
  nodes.each_cons(2) { |a, b| a.next = b }

  result = delete_duplicates(nodes.first)
  output = []
  while result
    output << result.val
    result = result.next
  end
  puts "Result: #{output}"
end
