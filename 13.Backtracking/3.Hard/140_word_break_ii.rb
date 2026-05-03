# frozen_string_literal: true

# LeetCode 140: Word Break II
#
# Problem:
# Given a string s and a dictionary wordDict, add spaces in s to construct
# all possible sentences where each word is a valid dictionary word.
# Return all such possible sentences.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try every possible split position recursively. At each position, check
#    if the prefix is in the dictionary and recurse on the remainder.
#    Time Complexity: O(2^n * n) — exponential splits
#    Space Complexity: O(2^n * n)
#
# 2. Bottleneck
#    Repeated subproblems: same suffix s[i..] is explored multiple times.
#    Memoize the results for each starting index.
#
# 3. Optimized Accepted Approach
#    Backtracking with memoization. For each index i, try all words in dict
#    that match s starting at i. Cache results for index i to avoid recomputation.
#
#    Time Complexity: O(n * 2^n) worst case (all substrings are words)
#    Space Complexity: O(n * 2^n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "catsanddog", wordDict = ["cat","cats","and","sand","dog"]
# i=0: "cat" matches -> recurse i=3
#   i=3: "sand" matches -> recurse i=7
#     i=7: "dog" matches -> recurse i=10 -> return [""] -> "dog"
#   -> ["sand dog"]
#   "cats" would also match...
# Result: ["cats and dog", "cat sand dog"]
#
# Edge Cases:
# - No valid segmentation: return []
# - Single word equals entire string: return [s]

def word_break_brute(s, word_dict)
  dict = word_dict.to_set
  results = []

  backtrack = lambda do |start, path|
    if start == s.length
      results << path.join(' ')
      return
    end
    (start...s.length).each do |end_idx|
      word = s[start..end_idx]
      if dict.include?(word)
        path << word
        backtrack.call(end_idx + 1, path)
        path.pop
      end
    end
  end

  backtrack.call(0, [])
  results
end

# optimized: backtracking with memoization on suffix index
def word_break(s, word_dict)
  dict = word_dict.to_set
  memo = {}

  # returns array of sentences formed from s[start..]
  build = lambda do |start|
    return memo[start] if memo.key?(start)
    return [''] if start == s.length

    sentences = []
    (start...s.length).each do |fin|
      word = s[start..fin]
      next unless dict.include?(word)
      rest = build.call(fin + 1)
      rest.each do |sentence|
        sentences << (sentence.empty? ? word : "#{word} #{sentence}")
      end
    end
    memo[start] = sentences
  end

  build.call(0)
end

if __FILE__ == $PROGRAM_NAME
  s = 'catsanddog'
  dict = %w[cat cats and sand dog]
  puts "Brute force: #{word_break_brute(s, dict)}"
  puts "Optimized:   #{word_break(s, dict)}"
end
