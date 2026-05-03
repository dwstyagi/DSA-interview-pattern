# frozen_string_literal: true

# LeetCode 198: House Robber
#
# Problem:
# Rob houses in a line; can't rob adjacent houses. Maximize total money robbed.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all subsets of non-adjacent houses and find max sum.
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Overlapping subproblems: dp[i] = max(dp[i-1], dp[i-2] + nums[i]).
#
# 3. Optimized Accepted Approach
#    Track two variables: rob1 (best excluding current), rob2 (best including last).
#    At each house: new_rob2 = max(rob2, rob1 + nums[i]). Slide forward.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, 7, 9, 3, 1]
# rob1=0, rob2=0
# 2: new=max(0,0+2)=2 -> rob1=0, rob2=2
# 7: new=max(2,0+7)=7 -> rob1=2, rob2=7
# 9: new=max(7,2+9)=11 -> rob1=7, rob2=11
# 3: new=max(11,7+3)=11 -> rob1=11, rob2=11
# 1: new=max(11,11+1)=12 -> rob2=12
# Result: 12
#
# Edge Cases:
# - Single house: rob it
# - Two houses: rob the larger one

def rob_brute(nums)
  memo = {}
  rec = lambda do |i|
    return 0 if i >= nums.length
    memo[i] ||= [rec.call(i + 1), nums[i] + rec.call(i + 2)].max
  end
  rec.call(0)
end

def rob(nums)
  rob1 = 0
  rob2 = 0
  nums.each do |n|
    rob1, rob2 = rob2, [rob2, rob1 + n].max
  end
  rob2
end

if __FILE__ == $PROGRAM_NAME
  puts rob_brute([2, 7, 9, 3, 1])  # 12
  puts rob([1, 2, 3, 1])           # 4
end
