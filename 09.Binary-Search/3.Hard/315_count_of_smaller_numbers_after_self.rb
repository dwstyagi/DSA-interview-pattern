# frozen_string_literal: true

# LeetCode 315: Count of Smaller Numbers After Self
#
# Problem:
# Given an integer array nums, return an integer array counts where
# counts[i] is the number of smaller elements to the right of nums[i].
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each element, scan all elements to its right and count smaller ones.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Double loop is O(n^2) — use merge sort to count inversions during merge.
#
# 3. Optimized Accepted Approach
#    Modified merge sort with index tracking. During the merge step, when we
#    pick from the right half, all remaining left-half elements are greater —
#    accumulate a "right-picks" counter per left element.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [5, 2, 6, 1]
# merge sort on indices: [0,1,2,3]
# merge [0] [1]: 5>2 → right pick → right_count++ → counts[0]+=1, sorted:[1,0]
# merge [2] [3]: 6>1 → right pick → right_count++ → counts[2]+=1, sorted:[3,2]
# merge [1,0] [3,2]: 2>1 → pick idx3, right_count=1; 2<6 → pick idx1, counts[1]+=1
#                    5>1 → (but idx3 gone) pick idx0 counts[0]+=1; pick idx2 counts[2]+=0
# counts = [2, 1, 1, 0] ✓
#
# Edge Cases:
# - All same elements -> [0,0,...,0]
# - Descending array -> [n-1, n-2, ..., 1, 0]
# - Single element -> [0]

def count_smaller_brute(nums)
  n = nums.length
  counts = Array.new(n, 0)
  (0...n).each do |i|
    ((i + 1)...n).each do |j|
      counts[i] += 1 if nums[j] < nums[i]
    end
  end
  counts
end

def count_smaller(nums)
  n = nums.length
  counts  = Array.new(n, 0)
  indices = (0...n).to_a # track original positions through sort

  merge_sort = lambda do |arr|
    return arr if arr.length <= 1

    mid   = arr.length / 2
    left  = merge_sort.call(arr[0...mid])
    right = merge_sort.call(arr[mid..])

    # merge left and right, counting right-picks
    result      = []
    l, r        = 0, 0
    right_picks = 0 # how many times we've pulled from right so far

    while l < left.length && r < right.length
      if nums[left[l]] <= nums[right[r]]
        # left element stays; all right-picks so far are smaller than left[l]
        counts[left[l]] += right_picks
        result << left[l]
        l += 1
      else
        # right element is smaller — count it as a right-pick
        right_picks += 1
        result << right[r]
        r += 1
      end
    end

    # remaining left elements — each has right_picks smaller elements after
    while l < left.length
      counts[left[l]] += right_picks
      result << left[l]
      l += 1
    end

    result + right[r..]
  end

  merge_sort.call(indices)
  counts
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{count_smaller_brute([5, 2, 6, 1]).inspect}"  # [2, 1, 1, 0]
  puts "Opt:   #{count_smaller([5, 2, 6, 1]).inspect}"         # [2, 1, 1, 0]
  puts "Brute: #{count_smaller_brute([2, 0, 1]).inspect}"      # [2, 0, 0]
  puts "Opt:   #{count_smaller([2, 0, 1]).inspect}"             # [2, 0, 0]
end
