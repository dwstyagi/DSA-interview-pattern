# frozen_string_literal: true

# LeetCode 49: Group Anagrams
#
# Problem:
# Given an array of strings strs, group the anagrams together.
# You can return the answer in any order.
#
# Examples:
#   Input:  strs = ["eat","tea","tan","ate","nat","bat"]
#   Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
#   Why:    "eat","tea","ate" all sort to "aet". "tan","nat" sort to "ant". "bat" is alone.
#
#   Input:  strs = ["a"]
#   Output: [["a"]]
#   Why:    Single element — forms its own group.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each pair of strings, check if they are anagrams. Group them.
#    O(n^2 * L) where L = average word length.
#
#    Time Complexity: O(n^2 * L)
#    Space Complexity: O(n * L)
#
# 2. Bottleneck
#    Pairwise checking is quadratic. We can use a canonical key instead.
#
# 3. Optimized Accepted Approach
#    Sort each string's characters to get a canonical key.
#    Group strings by their sorted key using a hash.
#
#    Time Complexity: O(n * L log L)
#    Space Complexity: O(n * L)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# strs = ["eat","tea","tan","ate","nat","bat"]
# "eat" sorted → "aet" → group "aet": ["eat"]
# "tea" sorted → "aet" → group "aet": ["eat","tea"]
# "tan" sorted → "ant" → group "ant": ["tan"]
# "ate" sorted → "aet" → group "aet": ["eat","tea","ate"]
# "nat" sorted → "ant" → group "ant": ["tan","nat"]
# "bat" sorted → "abt" → group "abt": ["bat"]
# Result: [["eat","tea","ate"],["tan","nat"],["bat"]]
#
# Edge Cases:
# - Single string          -> [[string]]
# - All unique (no groups) -> each in its own group
# - Empty string           -> groups with "" key

def group_anagrams_brute(strs)
  groups = []
  used = Array.new(strs.length, false)

  strs.each_with_index do |s, i|
    next if used[i]

    group = [s]
    used[i] = true
    strs.each_with_index do |t, j|
      next if used[j]

      # Two strings are anagrams iff their sorted chars match
      if s.chars.sort == t.chars.sort
        group << t
        used[j] = true
      end
    end
    groups << group
  end

  groups
end

def group_anagrams(strs)
  # Group by the sorted-characters canonical key
  strs.group_by { |w| w.chars.sort.join }
      .values
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{group_anagrams_brute(%w[eat tea tan ate nat bat]).inspect}"
  puts "Optimized:   #{group_anagrams(%w[eat tea tan ate nat bat]).inspect}"
end
