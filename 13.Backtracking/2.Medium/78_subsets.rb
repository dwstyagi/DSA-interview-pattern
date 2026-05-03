# frozen_string_literal: true

# LeetCode 78: Subsets
#
# Problem:
# Given an integer array nums of unique elements, return all possible subsets.
# The solution set must not contain duplicate subsets.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each number, iterate result and add number to each existing subset.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(2^n * n)
#
# 2. Bottleneck
#    Same complexity — backtracking avoids copying intermediate results.
#
# 3. Optimized Accepted Approach
#    Backtracking: at each step, record current path (a subset). Then for each
#    i from start..end, include nums[i] and recurse with i+1 to avoid reuse.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(n) recursion depth
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[1,2,3]
# backtrack(0, []): record [] → try 1: backtrack(1,[1]): record [1] → try 2:
#   backtrack(2,[1,2]): record [1,2] → try 3: backtrack(3,[1,2,3]): record [1,2,3]
# ... all 8 subsets generated ✓
#
# Edge Cases:
# - Empty array -> [[]]
# - Single element -> [[], [elem]]

def subsets_brute(nums)
  result = [[]]
  nums.each { |n| result += result.map { |s| s + [n] } }
  result
end

def subsets(nums)
  result = []

  backtrack = lambda do |start, path|
    result << path.dup          # record current subset at every node

    (start...nums.length).each do |i|
      path << nums[i]
      backtrack.call(i + 1, path)
      path.pop                  # undo
    end
  end

  backtrack.call(0, [])
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{subsets_brute([1, 2, 3]).map(&:sort).sort.inspect}"
  puts "Opt:   #{subsets([1, 2, 3]).map(&:sort).sort.inspect}"
  # [[], [1], [1, 2], [1, 2, 3], [1, 3], [2], [2, 3], [3]]
end
