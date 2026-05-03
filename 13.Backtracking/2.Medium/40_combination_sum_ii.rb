# frozen_string_literal: true

# LeetCode 40: Combination Sum II
#
# Problem:
# Given a collection of candidates (may have duplicates) and a target, find
# all unique combinations that sum to target. Each number may only be used once.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all subsets, filter by sum == target, deduplicate.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(2^n * n)
#
# 2. Bottleneck
#    Post-generation dedup — skip duplicates at the same recursion level.
#
# 3. Optimized Accepted Approach
#    Sort candidates. Backtrack with start index (i+1 to avoid reuse).
#    Skip if i > start && candidates[i] == candidates[i-1] (same-level duplicate).
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# candidates=[10,1,2,7,6,1,5], target=8, sorted=[1,1,2,5,6,7,10]
# try 1(i=0): try 1(i=1): try 2: try 5→[1,1,2,5]? sum=9>8 no; try [1,1,6]=8 ✓
# try 2(i=2, skip dup at i=1): try 6→[1,2,5]=8 ✓; try [1,7]=8 ✓
# try 2(i=2): [2,6]=8 ✓; try 7: [1,7]=8 already counted... skip dup
# result=[[1,1,6],[1,2,5],[1,7],[2,6]] ✓
#
# Edge Cases:
# - No valid combination -> []
# - All elements same -> at most one combination

def combination_sum2_brute(candidates, target)
  result = Set.new
  candidates.sort!

  dfs = lambda do |start, path, remaining|
    result << path.sort.dup if remaining.zero?
    return if remaining <= 0

    (start...candidates.length).each do |i|
      break if candidates[i] > remaining
      path << candidates[i]
      dfs.call(i + 1, path, remaining - candidates[i])
      path.pop
    end
  end

  dfs.call(0, [], target)
  result.to_a
end

def combination_sum2(candidates, target)
  candidates.sort!
  result = []

  backtrack = lambda do |start, path, remaining|
    return result << path.dup if remaining.zero?

    (start...candidates.length).each do |i|
      break if candidates[i] > remaining
      next if i > start && candidates[i] == candidates[i - 1]  # skip same-level dup
      path << candidates[i]
      backtrack.call(i + 1, path, remaining - candidates[i])   # i+1: no reuse
      path.pop
    end
  end

  backtrack.call(0, [], target)
  result
end

if __FILE__ == $PROGRAM_NAME
  require 'set'
  puts "Opt: #{combination_sum2([10,1,2,7,6,1,5], 8).map(&:sort).sort.inspect}"
  # [[1,1,6],[1,2,5],[1,7],[2,6]]
end
