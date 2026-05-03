# frozen_string_literal: true

# LeetCode 820: Short Encoding of Words
#
# Problem:
# Encode words as a single string where each word ends with '#'.
# A word can reference a suffix of the encoded string.
# Return minimum length of encoded string.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each word, check if it's a suffix of any other word. If so, skip it.
#    Time Complexity: O(n^2 * m)
#    Space Complexity: O(n * m)
#
# 2. Bottleneck
#    Checking all pairs is O(n^2). Trie of reversed words: shared suffixes share
#    a path. Only leaf nodes contribute to encoding length.
#
# 3. Optimized Accepted Approach
#    Build trie of reversed words. Each leaf node represents a word that cannot
#    be encoded as a suffix of another. Sum (word_length + 1) for each leaf.
#
#    Time Complexity: O(n * m)
#    Space Complexity: O(n * m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# words = ["time","me","bell"]
# reversed: "emit","em","lleb"
# trie: e->m->i->t (leaf, word "time"), e->m (not leaf - "me" is suffix of "time")
# Actually: insert "emit": e-m-i-t; insert "em": e-m (already exists, just mark)
# "em" becomes non-leaf, "emit" leaf
# leaves: "emit" (len 4+1=5), "lleb" (len 4+1=5) -> total 10
#
# Edge Cases:
# - No shared suffixes: sum all (length+1)
# - All words are suffixes of one word: only longest contributes

class SENode
  attr_accessor :children

  def initialize
    @children = {}
  end
end

def minimum_length_encoding_brute(words)
  word_set = words.to_set
  result = 0
  word_set.each do |word|
    suffix_of_another = word_set.any? { |other| other != word && other.end_with?(word) }
    result += word.length + 1 unless suffix_of_another
  end
  result
end

def minimum_length_encoding(words)
  root = SENode.new
  nodes = {}
  words.uniq.each do |word|
    node = root
    word.reverse.each_char do |c|
      node.children[c] ||= SENode.new
      node = node.children[c]
    end
    nodes[node] = word
  end
  nodes.sum { |node, word| node.children.empty? ? word.length + 1 : 0 }
end

if __FILE__ == $PROGRAM_NAME
  puts minimum_length_encoding_brute(%w[time me bell])  # 10
  puts minimum_length_encoding(%w[t])                    # 2
end
