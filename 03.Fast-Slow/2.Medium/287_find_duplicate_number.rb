# frozen_string_literal: true

# LeetCode 287: Find the Duplicate Number
#
# Problem:
# Given an array nums containing n+1 integers where each integer is in [1, n],
# there is exactly one duplicate number. Find and return it.
# Must not modify the array and use only O(1) extra space.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Sort the array and check adjacent elements for duplicates.
#    (But this modifies the array — violates constraints.)
#    Alternative: use a Set to track seen numbers.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n) — violates space constraint
#
# 2. Bottleneck
#    Set uses O(n) extra space.
#    Key insight: treat the array as an implicit linked list where
#    each index points to nums[index] (like a "next pointer").
#    Since values are in [1, n] and there are n+1 elements, a duplicate
#    value means two indices point to the same "next" — creating a cycle.
#    Apply Floyd's cycle detection to find the duplicate (= cycle entry).
#
# 3. Optimized Accepted Approach
#    Treat f(i) = nums[i] as a linked list traversal function.
#    The duplicate number is guaranteed to create a cycle.
#    Use Floyd's two-phase algorithm:
#    Phase 1: find meeting point inside cycle (slow moves 1, fast moves 2)
#    Phase 2: reset slow to start (index 0), advance both 1 step -> meet at duplicate
#
#    Why index 0? nums values are in [1,n] so index 0 is never a "destination"
#    — it's the safe starting point outside the cycle.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 3, 4, 2, 2]  (n=4, indices 0..4, values 1..4, duplicate=2)
#
# Implicit linked list: 0->1->3->2->4->2->4->... (cycle at index 2)
#
# Phase 1 (find meeting point):
# slow=nums[0]=1, fast=nums[nums[0]]=nums[1]=3
# step 1: slow=nums[1]=3, fast=nums[nums[3]]=nums[2]=4
# step 2: slow=nums[3]=2, fast=nums[nums[4]]=nums[2]=4
# step 3: slow=nums[2]=4, fast=nums[nums[4]]=nums[2]=4
# slow==fast=4 -> met
#
# Phase 2 (find cycle entry = duplicate):
# reset slow=nums[0]=1, fast stays at 4
# step 1: slow=nums[1]=3, fast=nums[4]=2
# step 2: slow=nums[3]=2, fast=nums[2]=4
# step 3: slow=nums[2]=4, fast=nums[4]=2
# hmm... let me redo with 0-based index traversal:
#
# Treat as: start=0, step = nums[current_index]
# slow=0, fast=0
# step 1: slow=nums[0]=1, fast=nums[nums[0]]=nums[1]=3
# step 2: slow=nums[1]=3, fast=nums[nums[3]]=nums[2]=4
# step 3: slow=nums[3]=2, fast=nums[nums[4]]=nums[2]=4
# step 4: slow=nums[2]=4, fast=nums[nums[4]]=nums[2]=4
# slow==fast=4 (index)
# phase 2: slow=0
# step 1: slow=nums[0]=1, fast=nums[4]=2
# step 2: slow=nums[1]=3, fast=nums[2]=4
# step 3: slow=nums[3]=2, fast=nums[4]=2
# slow==fast=2 -> duplicate is nums[2]=... wait, the value is the index: 2 ✓
#
# Edge Cases:
# - Duplicate at start of cycle
# - Multiple occurrences of duplicate (still works, only one duplicate guaranteed)

# brute force: use a Set (violates O(1) space but shows thinking)
def find_duplicate_brute(nums)
  seen = Set.new

  nums.each do |num|
    return num if seen.include?(num) # first repeated value is the duplicate

    seen.add(num)
  end

  -1 # should never reach here per problem constraints
end

# optimized: Floyd's cycle detection on implicit linked list f(i) = nums[i]
def find_duplicate(nums)
  slow = 0
  fast = 0

  # phase 1: find meeting point inside the cycle
  loop do
    slow = nums[slow]             # 1 step: follow one pointer
    fast = nums[nums[fast]]       # 2 steps: follow two pointers
    break if slow == fast         # met inside the cycle
  end

  # phase 2: find cycle entry = the duplicate number
  slow = 0 # reset slow to start (outside the cycle)
  while slow != fast
    slow = nums[slow]  # both move 1 step
    fast = nums[fast]
  end

  slow # cycle entry = duplicate value
end

if __FILE__ == $PROGRAM_NAME
  nums = [1, 3, 4, 2, 2]

  puts "Brute force: #{find_duplicate_brute(nums)}"
  puts "Optimized:   #{find_duplicate(nums)}"
end
