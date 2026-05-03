# frozen_string_literal: true

# LeetCode 131: Palindrome Partitioning
#
# Problem:
# Given a string s, partition it such that every substring of the partition is
# a palindrome. Return all possible palindrome partitioning.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all 2^(n-1) ways to split the string, filter those where all parts are palindromes.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(2^n * n)
#
# 2. Bottleneck
#    Generating all splits then checking — check palindrome during backtracking.
#
# 3. Optimized Accepted Approach
#    Backtracking: try every substring starting at current index. If it's a
#    palindrome, add to path and recurse from the next index.
#    At end of string, record current path.
#    Time Complexity: O(n * 2^n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s="aab"
# start=0: try "a"(palindrome) → start=1: try "a"(palindrome) → start=2: try "b" → [a,a,b] ✓
#                                start=1: try "ab"(not palindrome) → skip
# start=0: try "aa"(palindrome) → start=2: try "b" → [aa,b] ✓
# start=0: try "aab"(not palindrome) → skip
# result=[["a","a","b"],["aa","b"]] ✓
#
# Edge Cases:
# - Single char -> [["c"]]
# - All same chars "aaa" -> [["a","a","a"],["a","aa"],["aa","a"],["aaa"]]

def partition_brute(s)
  result = []
  n = s.length
  # try all 2^(n-1) cut points
  (0...(1 << (n-1))).each do |mask|
    parts = []
    start = 0
    (0...n-1).each do |i|
      if mask[i] == 1
        parts << s[start..i]
        start = i + 1
      end
    end
    parts << s[start..]
    result << parts if parts.all? { |p| p == p.reverse }
  end
  result
end

def partition(s)
  result = []

  palindrome = ->(sub) { sub == sub.reverse }

  backtrack = lambda do |start, path|
    result << path.dup and return if start == s.length

    (start...s.length).each do |i|
      sub = s[start..i]
      next unless palindrome.call(sub)      # prune non-palindromes early
      path << sub
      backtrack.call(i + 1, path)
      path.pop
    end
  end

  backtrack.call(0, [])
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Opt: #{partition('aab').sort.inspect}"  # [["a","a","b"],["aa","b"]]
  puts "Opt: #{partition('a').inspect}"          # [["a"]]
end
