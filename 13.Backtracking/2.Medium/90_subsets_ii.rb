# frozen_string_literal: true

# LeetCode 90: Subsets II
#
# Problem:
# Given an integer array nums that may contain duplicates, return all possible
# subsets without duplicate subsets.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all subsets, store in a set to dedupe.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(2^n * n)
#
# 2. Bottleneck
#    Set-based dedup stores all subsets — skip duplicates during backtracking.
#
# 3. Optimized Accepted Approach
#    Sort first. During backtracking, skip nums[i] if i > start && nums[i] == nums[i-1].
#    This prevents generating duplicate subsets at the same recursion level.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[1,2,2] sorted
# backtrack(0,[]): try 1→backtrack(1,[1]): try 2→backtrack(2,[1,2]): try 2→[1,2,2]✓;
#   skip second 2(i=2>start=1,nums[2]==nums[1]) ✓
# backtrack(1,[1]): skip second 2 already handled
# backtrack(0,[]): try 2→...; skip second 2(i=2>start=0,nums[2]==nums[1]) ✓
#
# Edge Cases:
# - All same elements [2,2,2] -> [[],[2],[2,2],[2,2,2]]
# - No duplicates -> same as subsets

def subsets_with_dup_brute(nums)
  result = Set.new([[]])
  nums.sort.each { |n| result = Set.new(result.map { |s| s + [n] }) | result }
  result.to_a
end

def subsets_with_dup(nums)
  nums.sort!   # sort to group duplicates together
  result = []

  backtrack = lambda do |start, path|
    result << path.dup

    (start...nums.length).each do |i|
      next if i > start && nums[i] == nums[i - 1]  # skip duplicates at same level
      path << nums[i]
      backtrack.call(i + 1, path)
      path.pop
    end
  end

  backtrack.call(0, [])
  result
end

if __FILE__ == $PROGRAM_NAME
  require 'set'
  puts "Opt: #{subsets_with_dup([1, 2, 2]).map(&:sort).sort.inspect}"
  # [[], [1], [1, 2], [1, 2, 2], [2], [2, 2]]
end
