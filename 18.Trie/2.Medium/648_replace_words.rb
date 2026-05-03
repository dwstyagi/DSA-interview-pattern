# frozen_string_literal: true

# LeetCode 648: Replace Words
#
# Problem:
# Given a dictionary of roots and a sentence, replace each word in the sentence
# with its shortest root from the dictionary. If no root, keep the word.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each word in sentence, check all roots, find shortest matching prefix.
#    Time Complexity: O(n * m * k) where n = words, m = avg word len, k = roots
#    Space Complexity: O(k)
#
# 2. Bottleneck
#    Checking each root per word is slow. Trie: insert all roots, then for each
#    word traverse trie to find shortest root.
#
# 3. Optimized Accepted Approach
#    Build trie from dictionary. For each sentence word, traverse trie until
#    end_of_word is found (root) or no child exists.
#
#    Time Complexity: O(total chars in dict + total chars in sentence)
#    Space Complexity: O(total chars in dict)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# dictionary=["cat","bat","rat"], sentence="the cattle was rattled by the battery"
# trie contains cat, bat, rat
# "cattle": traverse c-a-t -> end_of_word -> replace with "cat"
# "rattled": traverse r-a-t -> end_of_word -> "rat"
# "battery": traverse b-a-t -> end_of_word -> "bat"
# Result: "the cat was rat by the bat"
#
# Edge Cases:
# - No matching root: keep original word
# - Multiple roots: shortest wins (trie naturally finds it first)

def replace_words_brute(dictionary, sentence)
  sentence.split.map do |word|
    root = dictionary.select { |r| word.start_with?(r) }.min_by(&:length)
    root || word
  end.join(' ')
end

class ReplaceNode
  attr_accessor :children, :end_of_word

  def initialize
    @children = {}
    @end_of_word = false
  end
end

def replace_words(dictionary, sentence)
  root_node = ReplaceNode.new
  dictionary.each do |root|
    node = root_node
    root.each_char do |c|
      node.children[c] ||= ReplaceNode.new
      node = node.children[c]
      break if node.end_of_word  # already a shorter root
    end
    node.end_of_word = true
  end

  sentence.split.map do |word|
    node = root_node
    prefix = []
    word.each_char do |c|
      break unless node.children.key?(c)
      node = node.children[c]
      prefix << c
      break if node.end_of_word
    end
    node.end_of_word ? prefix.join : word
  end.join(' ')
end

if __FILE__ == $PROGRAM_NAME
  puts replace_words_brute(%w[cat bat rat], 'the cattle was rattled by the battery')
  puts replace_words(%w[a b c], 'aadsfasf absbs bbab cadsfafs')
end
