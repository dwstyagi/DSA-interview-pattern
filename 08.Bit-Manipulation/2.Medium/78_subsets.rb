# frozen_string_literal: true

# LeetCode 78: Subsets
#
# Problem:
# Given an integer array nums of unique elements, return all possible subsets
# (the power set). The solution set must not contain duplicate subsets.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Backtracking: for each element, choose include or exclude.
#    Time Complexity: O(2^n * n) for generating all subsets
#    Space Complexity: O(n) recursion stack
#
# 2. Bottleneck
#    Both approaches are O(2^n * n) — bitmask is iterative and clean.
#
# 3. Optimized Accepted Approach
#    Bitmask enumeration: for each mask in 0..(2^n - 1), bit i set means
#    include nums[i] in the subset. Iterates all 2^n subsets systematically.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(1) extra (result not counted)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 2, 3]
# mask=000 (0): [] → []
# mask=001 (1): bit 0 → [1]
# mask=010 (2): bit 1 → [2]
# mask=011 (3): bits 0,1 → [1,2]
# mask=100 (4): bit 2 → [3]
# mask=101 (5): bits 0,2 → [1,3]
# mask=110 (6): bits 1,2 → [2,3]
# mask=111 (7): bits 0,1,2 → [1,2,3]
#
# Edge Cases:
# - Empty array → [[]]
# - Single element → [[], [element]]

def subsets_brute(nums)
  result = []

  backtrack = ->(start, path) {
    result << path.dup
    (start...nums.length).each do |i|
      path << nums[i]
      backtrack.call(i + 1, path)
      path.pop
    end
  }

  backtrack.call(0, [])
  result
end

def subsets(nums)
  n = nums.length
  result = []

  (0...(1 << n)).each do |mask|
    subset = []
    (0...n).each { |i| subset << nums[i] if (mask >> i) & 1 == 1 }
    result << subset
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{subsets_brute([1, 2, 3]).inspect}"
  puts "Opt:   #{subsets([1, 2, 3]).inspect}"
  puts "Brute: #{subsets_brute([0]).inspect}"
  puts "Opt:   #{subsets([0]).inspect}"
end
