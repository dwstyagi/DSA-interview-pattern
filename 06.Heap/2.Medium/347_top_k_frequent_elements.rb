# frozen_string_literal: true

# LeetCode 347: Top K Frequent Elements
#
# Problem:
# Given an integer array nums and an integer k, return the k most frequent
# elements. You may return the answer in any order.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Count frequencies with a hash, sort by frequency descending, return first k.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Sorting all unique elements when we only need the top k is wasteful.
#
# 3. Optimized Accepted Approach
#    Count frequencies, then use a min-heap of size k keyed on frequency.
#    If heap size exceeds k, pop the minimum-frequency element.
#    The remaining k elements are the most frequent.
#    Time Complexity: O(n log k)
#    Space Complexity: O(n) for frequency map + O(k) for heap
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 1, 1, 2, 2, 3], k = 2
# freq = {1 => 3, 2 => 2, 3 => 1}
# Process (1,3): heap = [[3,1]]
# Process (2,2): heap = [[2,2],[3,1]] → sort by freq
# Process (3,1): heap = [[1,3],[2,2],[3,1]] size=3 > k=2 → pop min_freq(1,3)
# heap = [[2,2],[3,1]] → elements = [1, 2] → answer = [1, 2]
#
# Edge Cases:
# - k = n → return all elements
# - All elements same → return [that element]

def top_k_frequent_brute(nums, k)
  freq = nums.tally
  freq.sort_by { |_, count| -count }.first(k).map(&:first)
end

def top_k_frequent(nums, k)
  freq = nums.tally   # {element => count}

  # simulate min-heap of size k, sorted ascending by frequency
  heap = []

  freq.each do |num, count|
    # insert [count, num] maintaining sorted order by count
    idx = heap.bsearch_index { |v| v[0] >= count } || heap.size
    heap.insert(idx, [count, num])
    heap.shift if heap.size > k   # evict element with lowest frequency
  end

  heap.map { |_, num| num }   # extract just the numbers
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{top_k_frequent_brute([1, 1, 1, 2, 2, 3], 2).inspect}"  # [1, 2]
  puts "Opt:   #{top_k_frequent([1, 1, 1, 2, 2, 3], 2).inspect}"        # [1, 2]
  puts "Brute: #{top_k_frequent_brute([1], 1).inspect}"                  # [1]
  puts "Opt:   #{top_k_frequent([1], 1).inspect}"                        # [1]
end
