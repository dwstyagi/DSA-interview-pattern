# frozen_string_literal: true

# LeetCode 720: Longest Word in Dictionary
#
# Problem:
# Given an array of strings words, return the longest word where every prefix
# is also in the array. If tie, return lexicographically smallest.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Sort by length then lexicographically. For each word, check all prefixes exist.
#    Time Complexity: O(n * m^2)
#    Space Complexity: O(n * m)
#
# 2. Bottleneck
#    Checking prefixes via set. Trie: build from all words, then DFS only along
#    complete-word paths.
#
# 3. Optimized Accepted Approach
#    Build trie. DFS: only traverse edges where the child is an end_of_word node.
#    Track longest (or lexicographically smallest) word found.
#
#    Time Complexity: O(n * m)
#    Space Complexity: O(n * m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# words=["w","wo","wor","worl","world"]
# All are prefixes of each other -> trie path w->o->r->l->d all end_of_word
# DFS follows all -> returns "world"
#
# Edge Cases:
# - Single char words: any single char always valid (empty prefix = root)
# - Tie in length: return lexicographically smallest

def longest_word_brute(words)
  word_set = words.to_set
  result = ''
  words.sort.each do |word|
    if word.length == 1 || word_set.include?(word[0...-1])
      result = word if word.length > result.length
    end
  end
  result
end

class LWNode
  attr_accessor :children, :end_of_word, :word

  def initialize
    @children = {}
    @end_of_word = false
    @word = nil
  end
end

def longest_word(words)
  root = LWNode.new
  words.each do |word|
    node = root
    word.each_char do |c|
      node.children[c] ||= LWNode.new
      node = node.children[c]
    end
    node.end_of_word = true
    node.word = word
  end

  result = ''
  stack = [root]
  until stack.empty?
    node = stack.pop
    node.children.each_value do |child|
      next unless child.end_of_word
      if child.word.length > result.length ||
         (child.word.length == result.length && child.word < result)
        result = child.word
      end
      stack << child
    end
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  puts longest_word_brute(%w[w wo wor worl world])    # "world"
  puts longest_word(%w[a banana app appl ap apply apple])  # "apple"
end
