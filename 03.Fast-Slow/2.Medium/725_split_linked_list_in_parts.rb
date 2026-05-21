# frozen_string_literal: true

# LeetCode 725: Split Linked List in Parts
#
# Problem:
# Given the head of a singly linked list and an integer k, split the list into
# k consecutive parts. Each part should be as equal in length as possible.
# Earlier parts should be longer if the list can't be split evenly.
# Return an array of k parts (use nil for empty parts).
#
# Examples:
#   Input:  head = [1,2,3], k = 5
#   Output: [[1],[2],[3],[],[]]
#   Why:    3 nodes into 5 parts: first 3 get 1 node each, last 2 are empty.
#
#   Input:  head = [1,2,3,4,5,6,7,8,9,10], k = 3
#   Output: [[1,2,3,4],[5,6,7],[8,9,10]]
#   Why:    10 nodes / 3 parts = 3 each, with 1 extra -> first part gets 4, rest get 3.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Collect all nodes into an array.
#    Split the array into k parts mathematically.
#    Rebuild each part as a linked list.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Rebuilding is wasteful. We can split in-place by:
#    1. Counting the total length
#    2. Computing base size and remainder
#    3. Cutting the list at each part boundary
#
# 3. Optimized Accepted Approach
#    Count total length n.
#    base = n / k (minimum nodes per part)
#    remainder = n % k (first `remainder` parts get one extra node)
#    For each of k parts:
#    - Take base nodes (+ 1 if remainder > 0)
#    - Cut the list (set last node's next to nil)
#    - Decrement remainder
#
#    Time Complexity: O(n + k)
#    Space Complexity: O(k) for the result array
#
# -----------------------------------------------------------------------------
# Dry Run
#
# List: 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7 -> 8 -> 9 -> 10, k=3
# n=10, base=3, remainder=1
#
# part 0: size=3+1=4, nodes: 1->2->3->4, cut after 4 -> remainder=0
# part 1: size=3+0=3, nodes: 5->6->7, cut after 7
# part 2: size=3+0=3, nodes: 8->9->10
#
# result: [[1,2,3,4], [5,6,7], [8,9,10]] ✓
#
# Edge Cases:
# - k > n: some parts will be nil
# - k == 1: return the whole list as one part
# - Empty list: return k nil parts

# singly linked list node
class ListNode
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

# optimized: count length, compute sizes, cut in-place
def split_list_to_parts(head, size)
  # count total length
  length = 0
  current = head
  while current
    length += 1
    current = current.next
  end

  base = length / size      # minimum nodes per part
  remainder = length % size # first `remainder` parts get one extra node

  result = Array.new(size)  # pre-fill with nil for empty parts
  current = head

  size.times do |i|
    part_head = current
    part_size = base + (remainder.positive? ? 1 : 0) # extra node for early parts
    remainder -= 1 if remainder.positive?

    # advance to the last node of this part
    (part_size - 1).times { current = current.next if current }

    # cut the list: save next, terminate current part
    if current
      next_part = current.next
      current.next = nil   # disconnect this part from the rest
      current = next_part  # move to start of next part
    end

    result[i] = part_head
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  vals = (1..10).to_a
  nodes = vals.map { |v| ListNode.new(v) }
  nodes.each_cons(2) { |a, b| a.next = b }

  parts = split_list_to_parts(nodes.first, 3)
  parts.each_with_index do |part, i|
    values = []
    current = part
    while current
      values << current.val
      current = current.next
    end
    puts "Part #{i}: #{values}"
  end
end
