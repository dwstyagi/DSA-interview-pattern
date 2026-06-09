# frozen_string_literal: true

# LeetCode 23: Merge k Sorted Lists
#
# Problem:
# Given an array of k linked lists, each sorted in ascending order, merge all
# the lists into one sorted linked list and return its head.
#
# The merged list must also be sorted in ascending order.
#
# Examples:
#   Input:  lists = [[1,4,5],[1,3,4],[2,6]]
#   Output: [1,1,2,3,4,4,5,6]
#   Why:    Merge all three sorted lists into one sorted list.
#
#   Input:  lists = []
#   Output: []
#   Why:    No lists to merge, so return nil / empty.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. Brute Force
#    Collect all values from all lists into one array.
#    Sort the array.
#    Rebuild a new linked list from the sorted values.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Sorting every value ignores the fact that each list is already sorted.
#    We only need the smallest current head from each list at any time.
#
# 3. Optimized Min-Heap Approach
#    Keep a MinHeap of the current head node from each non-empty list.
#    Pop the smallest node, append it to the result, and push its next node.
#    Repeat until the heap is empty.
#    Time Complexity: O(n log k)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# lists = [[1->4->5], [1->3->4], [2->6]]
#
# Initial heap: [1(list0), 1(list1), 2(list2)]
# Pop 1(list0) -> push 4(list0)
# Pop 1(list1) -> push 3(list1)
# Pop 2(list2) -> push 6(list2)
# Pop 3(list1) -> push 4(list1)
# Continue until heap is empty.
#
# Final answer:
# 1->1->2->3->4->4->5->6
#
# Edge Cases:
# - Empty lists array
# - Some lists are nil
# - k = 1
# - Duplicate values across lists

class ListNode
  attr_accessor :val, :next

  def initialize(val = 0, nxt = nil)
    @val = val
    @next = nxt
  end
end

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Collect every value from every list
# - Sort all values
# - Rebuild a new linked list from the sorted values
#
# Time: O(n log n)
# Space: O(n)
def merge_k_lists_brute_force(lists)
  values = []

  lists.each do |head|
    current = head
    while current
      values << current.val
      current = current.next
    end
  end

  dummy = ListNode.new
  tail = dummy

  values.sort.each do |value|
    tail.next = ListNode.new(value)
    tail = tail.next
  end

  dummy.next
end

# -----------------------------
# OPTIMIZED MIN-HEAP SOLUTION
# -----------------------------
# Idea:
# - Keep only the current smallest candidate from each list in a MinHeap
# - Heap stores [value, order, node]
# - `order` is a tie-breaker so nodes with equal values stay comparable
# - Pop the smallest node, append it to the result, and push its next node
#
# Time: O(n log k)
# Space: O(k)
require 'algorithms'
def merge_k_lists(lists)
  min_heap = Containers::MinHeap.new
  order = 0

  lists.each do |head|
    next unless head

    min_heap.push([head.val, order, head])
    order += 1
  end

  dummy = ListNode.new
  tail = dummy

  until min_heap.empty?
    _value, _id, node = min_heap.pop
    next_node = node.next

    node.next = nil
    tail.next = node
    tail = node

    next unless next_node

    min_heap.push([next_node.val, order, next_node])
    order += 1
  end

  dummy.next
end

if __FILE__ == $PROGRAM_NAME
  def build_list(values)
    dummy = ListNode.new
    tail = dummy

    values.each do |value|
      tail.next = ListNode.new(value)
      tail = tail.next
    end

    dummy.next
  end

  lists = [build_list([1, 4, 5]), build_list([1, 3, 4]), build_list([2, 6])]

  brute_head = merge_k_lists_brute_force(lists)
  brute_output = []
  while brute_head
    brute_output << brute_head.val
    brute_head = brute_head.next
  end

  opt_head = merge_k_lists(lists)
  opt_output = []
  while opt_head
    opt_output << opt_head.val
    opt_head = opt_head.next
  end

  puts "Brute: #{brute_output.inspect}"
  puts "Opt:   #{opt_output.inspect}"
end
