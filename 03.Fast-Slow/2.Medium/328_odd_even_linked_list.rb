# frozen_string_literal: true

# LeetCode 328: Odd Even Linked List
#
# Problem:
# Given the head of a singly linked list, group all nodes with odd indices
# together followed by nodes with even indices. Return the reordered list.
# The first node is considered odd (index 1), second is even (index 2), etc.
# Preserve relative order within each group.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Collect all nodes into an array.
#    Rebuild the list: first all odd-indexed nodes, then even-indexed nodes.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra array is unnecessary.
#    We can maintain two separate chains (odd and even) while traversing once,
#    then connect the odd chain's tail to the even chain's head.
#
# 3. Optimized Accepted Approach
#    Use two pointers: odd (starts at head) and even (starts at head.next).
#    Save even_head to reconnect at the end.
#    While even and even.next exist:
#    - odd.next = even.next  (skip even node, connect to next odd)
#    - odd = odd.next        (advance odd pointer)
#    - even.next = odd.next  (skip odd node, connect to next even)
#    - even = even.next      (advance even pointer)
#    Connect: odd.next = even_head
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# List: 1 -> 2 -> 3 -> 4 -> 5
# odd chain: 1, even chain: 2, even_head = 2
#
# step 1:
#   odd.next = even.next = 3   -> 1->3
#   odd = 3
#   even.next = odd.next = 4   -> 2->4
#   even = 4
#
# step 2:
#   odd.next = even.next = 5   -> 1->3->5
#   odd = 5
#   even.next = odd.next = nil -> 2->4->nil
#   even = nil -> loop exits
#
# Connect: odd.next = even_head -> 1->3->5->2->4 ✓
#
# Edge Cases:
# - 0 or 1 nodes -> return as-is
# - 2 nodes -> no change needed

# singly linked list node
class ListNode # rubocop:disable Style/Documentation
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

# brute force: collect nodes by index parity, rebuild list
def odd_even_list_brute(head)
  return head if head.nil? || head.next.nil?

  odd_nodes = []
  even_nodes = []
  current = head
  index = 1

  while current
    if index.odd?
      odd_nodes << current
    else
      even_nodes << current
    end
    current = current.next
    index += 1
  end

  # connect all odd nodes then even nodes
  all_nodes = odd_nodes + even_nodes
  all_nodes.each_with_index do |node, i|
    node.next = all_nodes[i + 1] # connect to next, nil for last
  end
  all_nodes.last.next = nil

  all_nodes.first
end

# optimized: weave two chains in-place
def odd_even_list(head)
  return head if head.nil? || head.next.nil?

  odd = head           # pointer for odd-indexed chain
  even = head.next     # pointer for even-indexed chain
  even_head = even     # save even chain head to reconnect later

  while even&.next   # continue while even and even.next exist
    odd.next = even.next   # odd skips over even, points to next odd
    odd = odd.next         # advance odd pointer

    even.next = odd.next   # even skips over odd, points to next even
    even = even.next       # advance even pointer
  end

  odd.next = even_head # attach even chain after all odd nodes

  head
end

if __FILE__ == $PROGRAM_NAME
  vals = [1, 2, 3, 4, 5]
  nodes = vals.map { |v| ListNode.new(v) }
  nodes.each_cons(2) { |a, b| a.next = b }

  result = odd_even_list(nodes.first)
  output = []
  while result
    output << result.val
    result = result.next
  end
  puts "Result: #{output}"
end
