# frozen_string_literal: true

# LeetCode 23: Merge k Sorted Lists
#
# Problem:
# Given an array of k linked lists, each sorted in ascending order,
# merge all lists into one sorted linked list and return its head.
#
# Examples:
#   Input:  lists = [[1,4,5],[1,3,4],[2,6]]
#   Output: [1,1,2,3,4,4,5,6]
#   Why:    Divide and conquer: merge pairs until one list remains.
#           Round1: [1,1,3,4,4,5]+[2,6], Round2: [1,1,2,3,4,4,5,6].
#
#   Input:  lists = []
#   Output: []
#   Why:    No lists to merge — return nil/empty.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Collect all values from all lists into an array.
#    Sort the array.
#    Rebuild a single linked list from the sorted array.
#
#    Time Complexity: O(n log n) where n = total nodes
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Sorting ignores the fact that each list is already sorted — wasted info.
#    Better: use divide and conquer — merge pairs of lists repeatedly.
#    This is O(n log k) since we do log k rounds and each round touches n nodes.
#
# 3. Optimized Accepted Approach
#    Divide and conquer pairwise merge:
#    - Repeatedly merge pairs of lists until only one remains
#    - Each merge of two sorted lists is O(a + b)
#    - log k rounds, each round O(n) total work -> O(n log k)
#
#    Helper: merge two sorted linked lists (standard merge step)
#
#    Time Complexity: O(n log k)
#    Space Complexity: O(log k) recursion stack for divide and conquer
#
# -----------------------------------------------------------------------------
# Dry Run
#
# lists = [[1->4->5], [1->3->4], [2->6]]
#
# Round 1 (merge pairs):
#   merge([1->4->5], [1->3->4]) = 1->1->3->4->4->5
#   merge([2->6], nil)          = 2->6
#   lists = [[1->1->3->4->4->5], [2->6]]
#
# Round 2 (merge pairs):
#   merge([1->1->3->4->4->5], [2->6]) = 1->1->2->3->4->4->5->6
#   lists = [[1->1->2->3->4->4->5->6]]
#
# return 1->1->2->3->4->4->5->6 ✓
#
# Edge Cases:
# - Empty lists array -> return nil
# - Some lists are nil -> skip them
# - k=1 -> return the single list as-is

# singly linked list node
class ListNode
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

# helper: merge two sorted linked lists into one sorted list
def merge_two_lists(list1, list2)
  dummy = ListNode.new(0)
  current = dummy

  while list1 && list2
    if list1.val <= list2.val
      current.next = list1
      list1 = list1.next
    else
      current.next = list2
      list2 = list2.next
    end

    current = current.next
  end

  current.next = list1 || list2

  dummy.next
end

# brute force: collect all values, sort, rebuild
def merge_k_lists_brute(lists)
  values = []

  lists.each do |head|
    current = head
    while current
      values << current.val
      current = current.next
    end
  end

  values.sort!

  dummy = ListNode.new(0)
  current = dummy
  values.each do |val|
    current.next = ListNode.new(val)
    current = current.next
  end

  dummy.next
end

# optimized: divide and conquer pairwise merging
def merge_k_lists(lists)
  return nil if lists.empty?

  # repeatedly merge pairs until one list remains
  while lists.length > 1
    merged = []

    # merge pairs: (0,1), (2,3), (4,5), ...
    lists.each_slice(2) do |pair|
      merged << merge_two_lists(pair[0], pair[1]) # pair[1] may be nil if odd count
    end

    lists = merged # replace with merged results for next round
  end

  lists.first
end

if __FILE__ == $PROGRAM_NAME
  # build three sorted lists: [1->4->5], [1->3->4], [2->6]
  def build_list(vals)
    nodes = vals.map { |v| ListNode.new(v) }
    nodes.each_cons(2) { |a, b| a.next = b }
    nodes.first
  end

  lists = [build_list([1, 4, 5]), build_list([1, 3, 4]), build_list([2, 6])]

  result = merge_k_lists(lists)
  output = []
  while result
    output << result.val
    result = result.next
  end
  puts "Result: #{output}"
end
