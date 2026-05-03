# frozen_string_literal: true

# LeetCode 1065: Index Pairs of a String
#
# Problem:
# Given string text and array words, return all [i, j] pairs where
# text[i..j] is in words. Return sorted.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each starting index i, try all substrings starting at i and check if in words.
#    Time Complexity: O(n^2 * m) where m = avg word length
#    Space Complexity: O(k) where k = number of words
#
# 2. Bottleneck
#    Repeated substring checks. Trie: from each index, traverse trie to find all words.
#
# 3. Optimized Accepted Approach
#    Build trie. For each index i, traverse trie matching text[i..].
#    When end_of_word found, record [i, i+depth-1].
#
#    Time Complexity: O(n * m) where m = max word length
#    Space Complexity: O(total chars in words)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# text="thestoryofleetcodeandme", words=["story","fleet","leetcode"]
# i=3: traverse t-h? no. i=4: t-h-e? no. ... find "story" starting at 3: [3,7]
# find "leetcode" at 12: [12,19]
# find "fleet" — not in text as is
#
# Edge Cases:
# - No words match: return []
# - Overlapping matches at same start: return all

class IPNode
  attr_accessor :children, :end_of_word

  def initialize
    @children = {}
    @end_of_word = false
  end
end

def index_pairs_brute(text, words)
  word_set = words.to_set
  result = []
  n = text.length
  n.times do |i|
    (i...n).each do |j|
      result << [i, j] if word_set.include?(text[i..j])
    end
  end
  result.sort
end

def index_pairs(text, words)
  root = IPNode.new
  words.each do |word|
    node = root
    word.each_char do |c|
      node.children[c] ||= IPNode.new
      node = node.children[c]
    end
    node.end_of_word = true
  end

  result = []
  n = text.length
  n.times do |i|
    node = root
    (i...n).each do |j|
      c = text[j]
      break unless node.children.key?(c)
      node = node.children[c]
      result << [i, j] if node.end_of_word
    end
  end
  result.sort
end

if __FILE__ == $PROGRAM_NAME
  puts index_pairs_brute('thestoryofleetcodeandme', %w[story fleet leetcode]).inspect
  puts index_pairs('ababa', %w[aba ab]).inspect  # [[0,1],[0,2],[2,3],[2,4]]
end
