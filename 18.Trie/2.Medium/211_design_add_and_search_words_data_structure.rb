# frozen_string_literal: true

# LeetCode 211: Design Add and Search Words Data Structure
#
# Problem:
# Implement WordDictionary with addWord and search. search supports '.' as wildcard
# matching any single character.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Store all words. Search: for words with '.', check all stored words against regex.
#    Time Complexity: O(n * m) for search
#    Space Complexity: O(total chars)
#
# 2. Bottleneck
#    Brute force requires scanning all words. Trie: traverse normally for letters,
#    DFS all children for '.'.
#
# 3. Optimized Accepted Approach
#    Trie with DFS search. On '.', recurse into all children at that depth.
#
#    Time Complexity: O(m) average, O(26^m) worst case (all dots)
#    Space Complexity: O(total chars)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# addWord("bad"), addWord("dad"), addWord("mad")
# search("pad"): 'p' not in root.children -> false
# search(".ad"): '.', try b->a->d(end)=true -> return true
# search("b.."): b -> '.': try 'a' -> '.': try 'd' -> end=true -> true
#
# Edge Cases:
# - All wildcards: search all words of that length
# - Empty word: depends on if empty word was inserted

class WordDictionaryBrute
  def initialize
    @words = []
  end

  def add_word(word)
    @words << word
  end

  def search(word)
    pattern = Regexp.new('\A' + word.gsub('.', '.') + '\z')
    @words.any? { |w| w.match?(pattern) }
  end
end

class WordDictNode
  attr_accessor :children, :end_of_word

  def initialize
    @children = {}
    @end_of_word = false
  end
end

class WordDictionary
  def initialize
    @root = WordDictNode.new
  end

  def add_word(word)
    node = @root
    word.each_char do |c|
      node.children[c] ||= WordDictNode.new
      node = node.children[c]
    end
    node.end_of_word = true
  end

  def search(word)
    dfs(@root, word, 0)
  end

  private

  def dfs(node, word, idx)
    return node.end_of_word if idx == word.length
    c = word[idx]
    if c == '.'
      node.children.any? { |_, child| dfs(child, word, idx + 1) }
    else
      return false unless node.children.key?(c)
      dfs(node.children[c], word, idx + 1)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  wd = WordDictionary.new
  wd.add_word('bad')
  wd.add_word('dad')
  wd.add_word('mad')
  puts wd.search('pad')  # false
  puts wd.search('.ad')  # true
  puts wd.search('b..')  # true
end
