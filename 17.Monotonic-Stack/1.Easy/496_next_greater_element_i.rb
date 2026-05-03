# frozen_string_literal: true

# LeetCode 496: Next Greater Element I
#
# Problem:
# nums1 is a subset of nums2. For each element in nums1, find its next greater
# element in nums2. Return -1 if no greater element to the right.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each element in nums1, find its position in nums2, then scan right for greater.
#    Time Complexity: O(m * n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Repeated scanning of nums2. Precompute next greater for every element in nums2
#    using a monotonic stack, then answer queries in O(1).
#
# 3. Optimized Accepted Approach
#    Monotonic decreasing stack on nums2. When popping, record next greater in a hash.
#    Then for each element of nums1, look up hash.
#
#    Time Complexity: O(m + n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums1=[4,1,2], nums2=[1,3,4,2]
# i=0(1): stack=[1]
# i=1(3): 3>1 -> next_greater[1]=3, pop; push 3 -> stack=[3]
# i=2(4): 4>3 -> next_greater[3]=4, pop; push 4 -> stack=[4]
# i=3(2): 2<4 -> push 2 -> stack=[4,2]
# Remaining: no greater -> next_greater[4]=-1, next_greater[2]=-1
# Result: [-1, 3, -1]
#
# Edge Cases:
# - All elements in nums2 decreasing: all -1
# - All elements in nums1 have next greater: no -1

def next_greater_element_brute(nums1, nums2)
  nums1.map do |n|
    idx = nums2.index(n)
    greater = nums2[idx + 1..].find { |x| x > n }
    greater || -1
  end
end

def next_greater_element(nums1, nums2)
  next_greater = {}
  stack = []
  nums2.each do |n|
    while !stack.empty? && stack.last < n
      next_greater[stack.pop] = n
    end
    stack << n
  end
  nums1.map { |n| next_greater.fetch(n, -1) }
end

if __FILE__ == $PROGRAM_NAME
  puts next_greater_element_brute([4, 1, 2], [1, 3, 4, 2]).inspect  # [-1,3,-1]
  puts next_greater_element([2, 4], [1, 2, 3, 4]).inspect            # [3,-1]
end
