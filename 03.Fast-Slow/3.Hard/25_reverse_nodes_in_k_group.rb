# frozen_string_literal: true

# LeetCode 25: Reverse Nodes in k-Group
#
# Problem:
# Given the head of a linked list, reverse the nodes of the list k at a time
# and return the modified list. If the number of nodes is not a multiple of k
# then the remaining nodes at the end should stay as-is.
# You may not alter the values in the nodes — only change pointers.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Collect all values into an array.
#    Reverse each group of k values in the array.
#    Rebuild the list.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra array is unnecessary.
#    We can reverse groups of k nodes in-place iteratively using a dummy head.
#
# 3. Optimized Accepted Approach
#    Use a dummy node and a prev pointer (tail of last processed group).
#    For each group of k nodes:
#    1. Check if k nodes remain (if not, stop — leave as-is)
#    2. Identify group_start (prev.next) and group_end (k-th node)
#    3. Reverse k nodes in-place
#    4. Reconnect: prev.next = new_head, group_start.next = next_group
#    5. Advance prev to group_start (now the tail of reversed group)
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# List: 1 -> 2 -> 3 -> 4 -> 5, k=2
# dummy -> 1 -> 2 -> 3 -> 4 -> 5, prev=dummy
#
# Group 1: group_start=1, count k=2 nodes -> group_end=2, next_group=3
#   reverse 1->2 to 2->1
#   prev.next = 2, 1.next = 3
#   list: dummy -> 2 -> 1 -> 3 -> 4 -> 5
#   prev = 1 (tail of reversed group)
#
# Group 2: group_start=3, count k=2 nodes -> group_end=4, next_group=5
#   reverse 3->4 to 4->3
#   prev.next = 4, 3.next = 5
#   list: dummy -> 2 -> 1 -> 4 -> 3 -> 5
#   prev = 3 (tail of reversed group)
#
# Group 3: group_start=5, count k=2 nodes -> only 1 node, stop
# return dummy.next = 2 -> 1 -> 4 -> 3 -> 5 ✓
#
# Edge Cases:
# - k=1 -> no reversal, return as-is
# - k >= n -> reverse entire list (if exactly n) or reverse all but remainder
# - Empty list -> return nil

# singly linked list node
class ListNode # rubocop:disable Style/Documentation
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

# helper: reverse a sublist from head for exactly count nodes
# returns [new_head, new_tail]
def reverse_k_nodes(head, count)
  prev = nil
  current = head

  count.times do
    next_node = current.next
    current.next = prev
    prev = current
    current = next_node
  end

  [prev, head] # new_head=prev, new_tail=original head (now last)
end

# brute force: collect values, reverse in groups, rebuild
def reverse_k_group_brute(head, k)
  values = []
  current = head
  while current
    values << current.val
    current = current.next
  end

  # reverse each complete group of k
  i = 0
  while i + k <= values.length
    values[i, k] = values[i, k].reverse
    i += k
  end

  # rebuild list
  dummy = ListNode.new(0)
  current = dummy
  values.each do |val|
    current.next = ListNode.new(val)
    current = current.next
  end

  dummy.next
end

# optimized: in-place group reversal with dummy head
def reverse_k_group(head, k)
  dummy = ListNode.new(0)
  dummy.next = head
  prev = dummy # tail of the last successfully reversed group

  loop do
    # check if k nodes remain starting from prev.next
    check = prev
    k.times do
      check = check.next
      break if check.nil?
    end
    break if check.nil? # fewer than k nodes remain, stop

    group_start = prev.next  # first node of the current group
    next_group = check.next  # first node of the next group

    # reverse k nodes in-place
    new_head, new_tail = reverse_k_nodes(group_start, k)

    # reconnect reversed group into the list
    prev.next = new_head       # connect previous part to new head
    new_tail.next = next_group # connect new tail to next group

    prev = new_tail # advance prev to the tail of this reversed group
  end

  dummy.next
end

if __FILE__ == $PROGRAM_NAME
  vals = [1, 2, 3, 4, 5]
  nodes = vals.map { |v| ListNode.new(v) }
  nodes.each_cons(2) { |a, b| a.next = b }

  result = reverse_k_group(nodes.first, 2)
  output = []
  while result
    output << result.val
    result = result.next
  end
  puts "Result: #{output}"
end
