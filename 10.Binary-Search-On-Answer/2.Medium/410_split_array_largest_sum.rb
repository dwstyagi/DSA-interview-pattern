# frozen_string_literal: true

# LeetCode 410: Split Array Largest Sum
#
# Problem:
# Given an integer array nums and an integer k, split nums into k non-empty
# subarrays to minimize the largest sum among the subarrays.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all ways to place k-1 splits, take minimum of maximum subarray sums.
#    Time Complexity: O(n^k) — exponential
#    Space Complexity: O(k)
#
# 2. Bottleneck
#    Exponential partitioning — binary search on answer (the max sum) with a
#    greedy feasibility check.
#
# 3. Optimized Accepted Approach
#    Binary search max_sum in [max(nums), sum(nums)].
#    Feasibility: greedily count chunks needed with that max_sum cap.
#    If chunks needed <= k, then max_sum is feasible.
#    Time Complexity: O(n log(sum(nums)))
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[7,2,5,10,8], k=2
# lo=10, hi=32 → mid=21 → chunks: [7,2,5]=14,[10,8]=18 → 2<=2 → hi=21
# lo=10, hi=21 → mid=15 → chunks: [7,2,5]=14,[10]=10,[8]=8 → 3>2 → lo=16
# lo=16, hi=21 → mid=18 → chunks: [7,2,5]=14,[10,8]=18 → 2<=2 → hi=18
# lo=16, hi=18 → mid=17 → chunks: [7,2,5]=14,[10]=10,[8]=8 → 3>2 → lo=18
# lo=18, hi=18 → return 18 ✓
#
# Edge Cases:
# - k == nums.length -> each element is its own subarray, answer = max(nums)
# - k == 1 -> one subarray, answer = sum(nums)

def split_array_brute(nums, k)
  # DP: dp[i][j] = min largest sum for first i elements split into j parts
  n = nums.length
  prefix = [0]
  nums.each { |x| prefix << prefix.last + x }

  dp = Array.new(n + 1) { Array.new(k + 1, Float::INFINITY) }
  dp[0][0] = 0

  (1..n).each do |i|
    (1..[i, k].min).each do |j|
      (0...i).each do |m|
        sub_sum = prefix[i] - prefix[m]
        dp[i][j] = [dp[i][j], [dp[m][j - 1], sub_sum].max].min
      end
    end
  end

  dp[n][k]
end

def split_array(nums, k)
  lo, hi = nums.max, nums.sum

  feasible = lambda do |max_sum|
    chunks, cur = 1, 0
    nums.each do |n|
      if cur + n > max_sum
        chunks += 1  # start new chunk
        cur = 0
      end
      cur += n
    end
    chunks <= k
  end

  while lo < hi
    mid = (lo + hi) / 2
    feasible.call(mid) ? hi = mid : lo = mid + 1
  end

  lo
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{split_array_brute([7, 2, 5, 10, 8], 2)}"  # 18
  puts "Opt:   #{split_array([7, 2, 5, 10, 8], 2)}"         # 18
  puts "Brute: #{split_array_brute([1, 2, 3, 4, 5], 2)}"    # 9
  puts "Opt:   #{split_array([1, 2, 3, 4, 5], 2)}"           # 9
end
