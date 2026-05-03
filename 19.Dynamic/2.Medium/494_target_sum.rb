# frozen_string_literal: true

# LeetCode 494: Target Sum
#
# Problem:
# Assign + or - to each number in nums. Return number of ways to make sum = target.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all 2^n combinations of +/- signs, count those summing to target.
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Reduce to subset sum: P - N = target, P + N = total -> P = (total + target) / 2.
#    Count subsets with sum = P.
#
# 3. Optimized Accepted Approach
#    If (total + target) is odd or target > total, return 0.
#    Else DP: count subsets summing to P = (total + target) / 2.
#
#    Time Complexity: O(n * P)
#    Space Complexity: O(P)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[1,1,1,1,1], target=3
# total=5, P=(5+3)/2=4
# count subsets with sum 4: C(5,4)=5
# Result: 5
#
# Edge Cases:
# - target > total: 0
# - (total + target) odd: 0

def find_target_sum_ways_brute(nums, target)
  count = 0
  rec = lambda do |i, current|
    if i == nums.length
      count += 1 if current == target
      return
    end
    rec.call(i + 1, current + nums[i])
    rec.call(i + 1, current - nums[i])
  end
  rec.call(0, 0)
  count
end

def find_target_sum_ways(nums, target)
  total = nums.sum
  return 0 if (total + target).odd? || (total + target) < 0
  p = (total + target) / 2
  dp = Array.new(p + 1, 0)
  dp[0] = 1
  nums.each do |n|
    next if n > p
    p.downto(n) { |s| dp[s] += dp[s - n] }
  end
  dp[p]
end

if __FILE__ == $PROGRAM_NAME
  puts find_target_sum_ways_brute([1, 1, 1, 1, 1], 3)  # 5
  puts find_target_sum_ways([1], 1)                     # 1
end
