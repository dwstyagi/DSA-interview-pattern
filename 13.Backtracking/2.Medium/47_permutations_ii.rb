# frozen_string_literal: true

# LeetCode 47: Permutations II
#
# Problem:
# Given a collection of numbers nums that might contain duplicates, return all
# unique permutations.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all permutations, add to a set for dedup.
#    Time Complexity: O(n! * n)
#    Space Complexity: O(n! * n)
#
# 2. Bottleneck
#    Set-based dedup post-generation — prune duplicates during backtracking.
#
# 3. Optimized Accepted Approach
#    Sort nums. Skip used[i]. Also skip if nums[i]==nums[i-1] && !used[i-1]
#    (only use a duplicate if the previous duplicate is already used in the path).
#    Time Complexity: O(n! * n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[1,1,2] sorted
# pick i=0 (1, used[0]=true): → pick i=1 (1, skip if !used[0]? no, used[0]=true, ok)
# pick i=1 (1, used[1]=true): → pick i=2 (2) → [1,1,2] ✓
# ... skip duplicate generation at same level ✓
#
# Edge Cases:
# - All same [1,1,1] -> [[1,1,1]]
# - No duplicates -> n! permutations

def permute_unique_brute(nums)
  result = Set.new
  nums.permutation.each { |p| result << p }
  result.to_a
end

def permute_unique(nums)
  nums.sort!    # must sort to group duplicates
  result = []
  used   = Array.new(nums.length, false)

  backtrack = lambda do |path|
    if path.length == nums.length
      result << path.dup
      return
    end

    nums.each_with_index do |n, i|
      next if used[i]
      # Skip: if current == previous AND previous NOT used → would create duplicate branch
      next if i > 0 && nums[i] == nums[i - 1] && !used[i - 1]
      used[i] = true
      path << n
      backtrack.call(path)
      path.pop
      used[i] = false
    end
  end

  backtrack.call([])
  result
end

if __FILE__ == $PROGRAM_NAME
  require 'set'
  puts "Opt: #{permute_unique([1, 1, 2]).sort.inspect}"  # [[1,1,2],[1,2,1],[2,1,1]]
  puts "Opt: #{permute_unique([1, 2, 3]).length}"         # 6
end
