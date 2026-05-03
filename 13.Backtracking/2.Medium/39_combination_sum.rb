# frozen_string_literal: true

# LeetCode 39: Combination Sum
#
# Problem:
# Given an array of distinct integers candidates and a target integer,
# return all unique combinations where chosen numbers sum to target.
# Numbers can be used unlimited times.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS all combinations including reuse, filter by sum == target.
#    Time Complexity: O(target / min_candidate ^ candidates.length)
#    Space Complexity: O(target / min_candidate)
#
# 2. Bottleneck
#    Exploring all combinations without pruning — prune when sum > target.
#
# 3. Optimized Accepted Approach
#    Backtracking: sort candidates. For each candidate >= previous (start index),
#    add to path and recurse with same index (allow reuse). Prune if sum > target.
#    Time Complexity: O(n^(target/min_candidate))
#    Space Complexity: O(target/min_candidate)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# candidates=[2,3,6,7], target=7
# try 2: remaining=5 → try 2: remaining=3 → try 2: remaining=1 → try 2: -1 prune
#   try 3: remaining=0 → [2,2,3] ✓; try 6: prune; try 7: prune
# try 3: remaining=4 → ... try 7: remaining=0 → [7] ✓
# result=[[2,2,3],[7]] ✓
#
# Edge Cases:
# - No valid combination -> []
# - Single candidate equals target -> [[target]]

def combination_sum_brute(candidates, target)
  result = []
  candidates = candidates.sort

  dfs = lambda do |start, path, remaining|
    return result << path.dup if remaining.zero?
    return if remaining < 0

    (start...candidates.length).each do |i|
      break if candidates[i] > remaining  # pruning
      path << candidates[i]
      dfs.call(i, path, remaining - candidates[i])  # i (not i+1) to allow reuse
      path.pop
    end
  end

  dfs.call(0, [], target)
  result
end

def combination_sum(candidates, target)
  candidates.sort!
  result = []

  backtrack = lambda do |start, path, remaining|
    return result << path.dup if remaining.zero?

    (start...candidates.length).each do |i|
      break if candidates[i] > remaining  # sorted → all further are too large
      path << candidates[i]
      backtrack.call(i, path, remaining - candidates[i])  # i allows reuse
      path.pop
    end
  end

  backtrack.call(0, [], target)
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{combination_sum_brute([2, 3, 6, 7], 7).sort.inspect}"  # [[2,2,3],[7]]
  puts "Opt:   #{combination_sum([2, 3, 6, 7], 7).sort.inspect}"         # [[2,2,3],[7]]
end
