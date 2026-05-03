# frozen_string_literal: true

# rubocop:disable Style/Documentation
class ListNode
  attr_accessor :val, :next

  def initialize(val = 0, next_node = nil)
    @val = val
    @next = next_node
  end
end
# rubocop:enable Style/Documentation

# LeetCode 61: Rotate List
#
# Problem:
# Given the head of a linked list, rotate the list to the right by k places.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Rotate by 1 step k times. Each step: move last node to front.
#
#    Time Complexity: O(n * k)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Repeating the rotation k times when k can be huge.
#
# 3. Optimized Accepted Approach
#    1) Find length n and tail node (make it circular).
#    2) Effective rotation = k % n.
#    3) New tail is at position n - (k % n) - 1 from head.
#    4) New head is node after new tail; break the cycle.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# list: 1→2→3→4→5, k=2
# n=5, effective k = 2%5 = 2
# new tail at index 5-2-1 = 2 (node with val=3)
# new head = node with val=4
# break: 3→nil, result: 4→5→1→2→3
#
# Edge Cases:
# - k = 0 or k = n -> no change
# - Single node     -> no change
# - k > n           -> k % n used

def rotate_right_brute(head, k)
  return head if head.nil? || head.next.nil? || k == 0

  # Count length
  n = 1
  curr = head
  curr = curr.next and n += 1 while curr.next

  k = k % n
  return head if k == 0

  # Rotate one step at a time
  k.times do
    # Find second-to-last node
    prev = head
    prev = prev.next while prev.next.next
    new_head = prev.next
    prev.next = nil
    new_head.next = head
    head = new_head
  end

  head
end

def rotate_right(head, k)
  return head if head.nil? || head.next.nil? || k == 0

  # Step 1: find length and tail
  tail = head
  n = 1
  while tail.next
    tail = tail.next
    n += 1
  end

  # Step 2: compute effective rotation
  k = k % n
  return head if k == 0

  # Step 3: new tail is at position n-k-1 (0-indexed)
  new_tail = head
  (n - k - 1).times { new_tail = new_tail.next }

  # Step 4: new head is node after new tail
  new_head = new_tail.next
  new_tail.next = nil   # break cycle

  # Step 5: connect old tail to old head
  tail.next = head

  new_head
end

def build_list(arr)
  return nil if arr.empty?

  head = ListNode.new(arr[0])
  curr = head
  arr[1..].each { |v| curr.next = ListNode.new(v); curr = curr.next }
  head
end

def list_to_arr(head)
  result = []
  result << head.val and head = head.next while head
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{list_to_arr(rotate_right_brute(build_list([1, 2, 3, 4, 5]), 2)).inspect}"
  puts "Optimized:   #{list_to_arr(rotate_right(build_list([1, 2, 3, 4, 5]), 2)).inspect}"
  # Both: [4, 5, 1, 2, 3]
end
