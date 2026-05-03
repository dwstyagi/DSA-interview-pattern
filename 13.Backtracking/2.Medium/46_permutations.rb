# frozen_string_literal: true

# LeetCode 46: Permutations
#
# Problem:
# Given an array nums of distinct integers, return all possible permutations.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use Ruby's Array#permutation. Or recursive: for each position pick any unused.
#    Time Complexity: O(n! * n)
#    Space Complexity: O(n! * n)
#
# 2. Bottleneck
#    Same complexity — backtracking with used[] array is clean.
#
# 3. Optimized Accepted Approach
#    Backtracking with a used boolean array. At each step pick any unused number.
#    When path.length == n, record permutation.
#    Time Complexity: O(n! * n)
#    Space Complexity: O(n) recursion depth
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[1,2,3]
# pick 1 → pick 2 → pick 3 → [1,2,3] ✓; backtrack → pick 3 → pick 2 → [1,3,2] ✓
# ... all 6 permutations generated ✓
#
# Edge Cases:
# - Single element -> [[elem]]
# - Empty array -> [[]]

def permute_brute(nums)
  nums.permutation.to_a
end

def permute(nums)
  result = []
  used   = Array.new(nums.length, false)

  backtrack = lambda do |path|
    if path.length == nums.length
      result << path.dup   # complete permutation
      return
    end

    nums.each_with_index do |n, i|
      next if used[i]
      used[i] = true       # choose
      path << n
      backtrack.call(path)
      path.pop             # undo
      used[i] = false
    end
  end

  backtrack.call([])
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{permute_brute([1, 2, 3]).length}"   # 6
  puts "Opt:   #{permute([1, 2, 3]).length}"           # 6
  puts "Opt:   #{permute([1, 2, 3]).sort.inspect}"
end
