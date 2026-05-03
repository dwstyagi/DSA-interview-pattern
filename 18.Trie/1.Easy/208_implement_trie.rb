# frozen_string_literal: true

# LeetCode 208: Implement Trie (Prefix Tree)
#
# Problem:
# Implement a trie with insert, search, and startsWith operations.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use a hash/set to store all inserted words. search = O(1) lookup.
#    startsWith requires scanning all words for prefix match.
#    Time Complexity: O(n * m) for startsWith
#    Space Complexity: O(total characters)
#
# 2. Bottleneck
#    startsWith is O(n*m). Trie gives O(m) for all operations where m = word length.
#
# 3. Optimized Accepted Approach
#    Each trie node stores a hash of children and a flag end_of_word.
#    insert: create nodes along the path. search/startsWith: traverse path.
#
#    Time Complexity: O(m) per operation
#    Space Complexity: O(total characters)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# insert("apple"): a->p->p->l->e (end=true)
# search("apple"): traverse a->p->p->l->e, end=true -> true
# search("app"):   traverse a->p->p, end=false -> false
# startsWith("app"): traverse a->p->p -> true (exists)
#
# Edge Cases:
# - search non-existent word: false
# - startsWith empty string: always true

class TrieBrute
  def initialize
    @words = Set.new
  end

  def insert(word)
    @words.add(word)
  end

  def search(word)
    @words.include?(word)
  end

  def starts_with?(prefix)
    @words.any? { |w| w.start_with?(prefix) }
  end
end

class TrieNode
  attr_accessor :children, :end_of_word

  def initialize
    @children = {}
    @end_of_word = false
  end
end

class Trie
  def initialize
    @root = TrieNode.new
  end

  def insert(word)
    node = @root
    word.each_char do |c|
      node.children[c] ||= TrieNode.new
      node = node.children[c]
    end
    node.end_of_word = true
  end

  def search(word)
    node = find_node(word)
    !node.nil? && node.end_of_word
  end

  def starts_with?(prefix)
    !find_node(prefix).nil?
  end

  private

  def find_node(prefix)
    node = @root
    prefix.each_char do |c|
      return nil unless node.children.key?(c)
      node = node.children[c]
    end
    node
  end
end

if __FILE__ == $PROGRAM_NAME
  trie = Trie.new
  trie.insert('apple')
  puts trie.search('apple')     # true
  puts trie.search('app')       # false
  puts trie.starts_with?('app') # true
  trie.insert('app')
  puts trie.search('app')       # true
end
