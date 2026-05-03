# frozen_string_literal: true

# LeetCode 658: Find K Closest Elements
#
# Problem:
# Given a sorted integer array arr, two integers k and x, return the k closest
# integers to x in the array. The result should also be sorted in ascending order.
# Ties broken by smaller element.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Sort all elements by distance to x (ties broken by value), take first k,
#    then sort result ascending.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    We don't need to sort all elements — the array is already sorted.
#
# 3. Optimized Accepted Approach
#    Binary search to find the window of k elements.
#    Binary search on left pointer: if arr[mid+k] - x < x - arr[mid], slide right.
#    Window [left, left+k) is the answer.
#    Time Complexity: O(log(n-k) + k)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# arr = [1,2,3,4,5], k=4, x=3
# BS: l=0, r=1 (n-k=1)
# mid=0: arr[0+4]-3 = 5-3=2, 3-arr[0]=3-1=2 → equal → move r=0
# l=r=0 → window [0,4) = [1,2,3,4]
#
# Edge Cases:
# - x smaller than all elements → return first k
# - x larger than all elements → return last k

def find_closest_elements_brute(arr, k, x)
  arr.sort_by { |v| [(v - x).abs, v] }.first(k).sort
end

def find_closest_elements(arr, k, x)
  l = 0
  r = arr.length - k   # left boundary of the k-window can range [0, n-k]

  while l < r
    mid = (l + r) / 2
    # compare distances of the two ends of the candidate window
    if x - arr[mid] > arr[mid + k] - x
      l = mid + 1   # right end is closer, slide window right
    else
      r = mid       # left end is closer or equal, keep or shrink right
    end
  end

  arr[l, k]   # slice k elements starting at left pointer
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{find_closest_elements_brute([1, 2, 3, 4, 5], 4, 3).inspect}"  # [1,2,3,4]
  puts "Opt:   #{find_closest_elements([1, 2, 3, 4, 5], 4, 3).inspect}"        # [1,2,3,4]
  puts "Brute: #{find_closest_elements_brute([1, 2, 3, 4, 5], 4, -1).inspect}" # [1,2,3,4]
  puts "Opt:   #{find_closest_elements([1, 2, 3, 4, 5], 4, -1).inspect}"       # [1,2,3,4]
end
