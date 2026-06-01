# frozen_string_literal: true

# LeetCode 160: Intersection of Two Linked Lists
#
# Problem:
# Given the heads of two singly linked lists, return the node at which the two
# lists intersect. If they do not intersect, return nil.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each node in list A, scan all of list B for a match.
#    Time Complexity: O(m*n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Double loop — use a hash set to store all nodes of A, then scan B.
#    Time Complexity: O(m+n), Space: O(m)
#
# 3. Optimized Accepted Approach
#    Two-pointer: pointer a traverses A then B; pointer b traverses B then A.
#    They meet at the intersection (or both reach nil at the same time).
#    Length difference is neutralized by switching.
#    Time Complexity: O(m+n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# A: 4→1→8→4→5, B: 5→6→1→8→4→5  (intersection at 8)
# pA walks: 4,1,8(found!) — after switching: lengths equalized
# pA=pB when both reach node 8 ✓
#
# Edge Cases:
# - No intersection -> both pointers reach nil simultaneously
# - One list is a sublist of the other

# rubocop:disable Style/Documentation
class ListNode
  attr_accessor :val, :next
  def initialize(val = 0, next_node = nil)
    @val = val; @next = next_node
  end
end
# rubocop:enable Style/Documentation

def get_intersection_node_brute(head_a, head_b)
  require 'set'
  visited = Set.new
  curr = head_a
  visited << curr while (curr = curr) && (visited.add?(curr); curr = curr.next)
  curr = head_b
  curr = curr.next until curr.nil? || visited.include?(curr)
  curr
end

def get_intersection_node(head_a, head_b)
  a, b = head_a, head_b

  # Advance each pointer; when exhausted, redirect to the other list's head
  until a == b
    a = a ? a.next : head_b   # switch to head_b after exhausting A
    b = b ? b.next : head_a   # switch to head_a after exhausting B
  end

  a  # nil if no intersection, otherwise the intersection node
end

if __FILE__ == $PROGRAM_NAME
  # Build: A=[4,1,8,4,5], B=[5,6,1,8,4,5] intersecting at 8
  common = ListNode.new(8, ListNode.new(4, ListNode.new(5)))
  head_a = ListNode.new(4, ListNode.new(1, common))
  head_b = ListNode.new(5, ListNode.new(6, ListNode.new(1, common)))
  result = get_intersection_node(head_a, head_b)
  puts "Opt: intersection val=#{result&.val}"  # 8
end
