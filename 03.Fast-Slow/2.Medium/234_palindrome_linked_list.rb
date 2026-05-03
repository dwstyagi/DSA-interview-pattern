# frozen_string_literal: true

# LeetCode 234: Palindrome Linked List
#
# Problem:
# Given the head of a singly linked list, return true if it is a palindrome,
# false otherwise.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Collect all values into an array.
#    Check if the array equals its reverse.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra array uses O(n) space.
#    We can do it in O(1) space by:
#    1. Finding the middle with slow/fast pointers
#    2. Reversing the second half in-place
#    3. Comparing both halves node by node
#
# 3. Optimized Accepted Approach
#    Phase 1: find middle using slow/fast pointers
#    Phase 2: reverse the second half of the list
#    Phase 3: compare first half and reversed second half
#    (Phase 4: optionally restore the list)
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# List: 1 -> 2 -> 2 -> 1
#
# Phase 1 (find middle):
# slow=1, fast=1
# step 1: slow=2(first), fast=2(second)
# step 2: fast.next=1, fast.next.next=nil -> fast&.next fails? no:
#   fast=2(second), fast.next=1, so continue
#   slow=2(second), fast=nil... wait
#   fast = fast.next.next = 1.next = nil
#   next iteration: fast is nil -> exit
# slow = 2 (second) = start of second half
#
# Phase 2 (reverse second half: 2->1):
# prev=nil, current=2(second)
# step 1: next=1, current.next=nil, prev=2, current=1
# step 2: next=nil, current.next=2, prev=1, current=nil
# reversed: 1 -> 2
#
# Phase 3 (compare):
# first half: 1->2, second half reversed: 1->2
# 1==1, 2==2 -> palindrome ✓
#
# Edge Cases:
# - Single node -> true
# - Two same nodes -> true
# - Two different nodes -> false

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
    next_node = current.next  # save next before overwriting
    current.next = prev       # reverse the pointer
    prev = current            # move prev forward
    current = next_node       # move current forward
  end

  prev # new head (was the last node)
end

# brute force: collect values and check palindrome
def palindrome_brute?(head)
  values = []
  current = head

  while current
    values << current.val
    current = current.next
  end

  values == values.reverse # compare array with its reverse
end

# optimized: find middle, reverse second half, compare
def palindrome?(head)
  return true if head.nil? || head.next.nil? # 0 or 1 node is always palindrome

  # phase 1: find middle of the list
  slow = head
  fast = head
  slow = slow.next and fast = fast.next.next while fast&.next

  # slow is now at the start of the second half

  # phase 2: reverse the second half
  second_half = reverse_list(slow)

  # phase 3: compare first and second halves
  left = head
  right = second_half
  result = true

  while right # second half may be shorter (middle node excluded)
    if left.val != right.val
      result = false
      break
    end
    left = left.next
    right = right.next
  end

  # phase 4: restore the list (good practice in interviews)
  reverse_list(second_half)

  result
end

if __FILE__ == $PROGRAM_NAME
  # palindrome: 1 -> 2 -> 2 -> 1
  vals = [1, 2, 2, 1]
  nodes = vals.map { |v| ListNode.new(v) }
  nodes.each_cons(2) { |a, b| a.next = b }

  puts "Brute force: #{palindrome_brute?(nodes.first)}"
  puts "Optimized:   #{palindrome?(nodes.first)}"

  # not palindrome: 1 -> 2 -> 3
  vals2 = [1, 2, 3]
  nodes2 = vals2.map { |v| ListNode.new(v) }
  nodes2.each_cons(2) { |a, b| a.next = b }

  puts "Brute force: #{palindrome_brute?(nodes2.first)}"
  puts "Optimized:   #{palindrome?(nodes2.first)}"
end
