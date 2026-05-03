# frozen_string_literal: true

# LeetCode 676: Implement Magic Dictionary
#
# Problem:
# Design a data structure that is initialized with a list of words.
# search(word) returns true if there exists a word in the dictionary that
# differs from word by exactly one character.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each dictionary word of same length, count differing characters.
#    Return true if any has exactly 1 difference.
#    Time Complexity: O(n * m) per search
#    Space Complexity: O(n * m)
#
# 2. Bottleneck
#    Same complexity with or without trie, but trie enables early termination
#    and is more flexible for extensions.
#
# 3. Optimized Accepted Approach
#    Trie with DFS search: traverse normally; when mismatch occurs, allow
#    exactly one character substitution (try all 26 letters), continue without fault.
#
#    Time Complexity: O(26 * m) per search = O(m)
#    Space Complexity: O(n * m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# buildDict(["hello","leetcode"])
# search("hello"): need exactly 1 diff -> "hello" differs from "hello" by 0 -> no
#                  differs from "leetcode" by many -> check len match first
# search("hhllo"): h-h match, e vs h mismatch (fault=1), l-l match, l-l match, o-o match -> true
#
# Edge Cases:
# - word not in dict with 1 diff: true
# - word in dict (0 diffs): false (need exactly 1)
# - No same-length word: false

class MagicDictionaryBrute
  def initialize
    @words = []
  end

  def build_dict(dictionary)
    @words = dictionary
  end

  def search(word)
    @words.any? do |w|
      next false if w.length != word.length
      diffs = w.chars.zip(word.chars).count { |a, b| a != b }
      diffs == 1
    end
  end
end

class MagicDictNode
  attr_accessor :children, :end_of_word

  def initialize
    @children = {}
    @end_of_word = false
  end
end

class MagicDictionary
  def initialize
    @root = MagicDictNode.new
  end

  def build_dict(dictionary)
    dictionary.each do |word|
      node = @root
      word.each_char do |c|
        node.children[c] ||= MagicDictNode.new
        node = node.children[c]
      end
      node.end_of_word = true
    end
  end

  def search(word)
    dfs(@root, word, 0, false)
  end

  private

  def dfs(node, word, idx, used_fault)
    return node.end_of_word && used_fault if idx == word.length
    c = word[idx]
    node.children.each do |k, child|
      if k == c
        return true if dfs(child, word, idx + 1, used_fault)
      elsif !used_fault
        return true if dfs(child, word, idx + 1, true)
      end
    end
    false
  end
end

if __FILE__ == $PROGRAM_NAME
  md = MagicDictionary.new
  md.build_dict(%w[hello leetcode])
  puts md.search('hello')  # false
  puts md.search('hhllo')  # true
  puts md.search('hell')   # false
  puts md.search('leetcoded') # false
end
