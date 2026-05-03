# frozen_string_literal: true

# LeetCode 82: Remove Duplicates from Sorted List II
#
# Problem:
# Given the head of a sorted linked list, delete all nodes that have duplicate
# numbers, leaving only distinct numbers. Return the modified list.
# (Unlike LC 83, remove ALL occurrences of duplicated values, not just extras.)
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Count frequency of each value using a hash.
#    Rebuild the list keeping only values with frequency == 1.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra hash is unnecessary.
#    Since the list is sorted, all duplicates are adjacent.
#    Use a dummy head and a prev pointer to skip entire groups of duplicates.
#
# 3. Optimized Accepted Approach
#    Use a dummy node before head (handles case where head itself is a duplicate).
#    prev pointer tracks the last confirmed unique node.
#    current traverses the list:
#    - If current.val == current.next.val, skip all nodes with that value
#    - Otherwise, advance prev to current
#    Always advance current.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# List: 1 -> 2 -> 3 -> 3 -> 4 -> 4 -> 5
# dummy -> 1 -> 2 -> 3 -> 3 -> 4 -> 4 -> 5, prev=dummy, current=1
#
# current=1: 1 != 2 -> prev=1, current=2
# current=2: 2 != 3 -> prev=2, current=3
# current=3: 3 == 3 (duplicate detected)
#   skip all 3s: current=3(first)->3(second)->4 (stop when val differs)
#   prev.next = current = 4 (bypass all 3s)
# current=4: 4 == 4 (duplicate detected)
#   skip all 4s: current=4(first)->4(second)->5
#   prev.next = current = 5
# current=5: 5.next=nil -> prev=5, current=nil -> exit
# return dummy.next = 1 -> 2 -> 5 ✓
#
# Edge Cases:
# - All duplicates -> return empty list (dummy.next = nil)
# - No duplicates -> return list unchanged
# - Duplicates at head -> dummy node handles this cleanly

# singly linked list node
class ListNode # rubocop:disable Style/Documentation
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

# brute force: count frequencies, keep only unique values
def delete_duplicates_brute(head)
  freq = Hash.new(0)
  current = head

  # count frequency of each value
  while current
    freq[current.val] += 1
    current = current.next
  end

  # rebuild with only values that appear exactly once
  dummy = ListNode.new(0)
  current = dummy
  node = head
  while node
    if freq[node.val] == 1
      current.next = ListNode.new(node.val)
      current = current.next
    end
    node = node.next
  end

  dummy.next
end

# optimized: in-place skip of duplicate groups using prev pointer
def delete_duplicates(head)
  dummy = ListNode.new(0)
  dummy.next = head
  prev = dummy    # last confirmed non-duplicate node
  current = head

  while current
    # check if current starts a group of duplicates
    if current.next && current.val == current.next.val
      # skip all nodes with this duplicate value
      dup_val = current.val
      current = current.next while current.val == dup_val

      # bypass the entire duplicate group
      prev.next = current
    else
      # no duplicate at current, advance prev
      prev = current
      current = current.next
    end
  end

  dummy.next
end

if __FILE__ == $PROGRAM_NAME
  vals = [1, 2, 3, 3, 4, 4, 5]
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
