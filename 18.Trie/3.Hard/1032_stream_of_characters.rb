# frozen_string_literal: true

# LeetCode 1032: Stream of Characters
#
# Problem:
# Implement StreamChecker with query(letter). Each call appends letter to a stream.
# Return true if any word in the given list is a suffix of the stream.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Maintain stream. For each query, check if any word is a suffix of stream.
#    Time Complexity: O(n * m) per query
#    Space Complexity: O(stream length)
#
# 2. Bottleneck
#    Checking each word per query is slow. Build trie of reversed words.
#    For each query, check if any suffix of the stream matches a word.
#
# 3. Optimized Accepted Approach
#    Trie of reversed words. Maintain active trie nodes (one per "start position").
#    On each new character, advance all active nodes; add root. If any reaches end_of_word, return true.
#
#    Time Complexity: O(m) per query where m = max word length
#    Space Complexity: O(total chars + stream length)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# words=["cd","f","kl"]
# query('a'): stream="a", active_nodes=[] (none match)
# query('b'): stream="ab", no match
# query('c'): stream="abc", try reversed words, 'c' starts "cd" reversed, active=[node after 'c']
# query('d'): 'd' advances node_after_c -> end_of_word -> true!
#
# Edge Cases:
# - Single char word: every matching char returns true
# - Word longer than stream: never matches until stream is long enough

class StreamCheckerBrute
  def initialize(words)
    @words = words
    @stream = ''
  end

  def query(letter)
    @stream += letter
    @words.any? { |w| @stream.end_with?(w) }
  end
end

class SCNode
  attr_accessor :children, :end_of_word

  def initialize
    @children = {}
    @end_of_word = false
  end
end

class StreamChecker
  def initialize(words)
    @root = SCNode.new
    words.each do |word|
      node = @root
      word.reverse.each_char do |c|
        node.children[c] ||= SCNode.new
        node = node.children[c]
      end
      node.end_of_word = true
    end
    @active = []
  end

  def query(letter)
    next_active = []
    (@active + [@root]).each do |node|
      next unless node.children.key?(letter)
      next_active << node.children[letter]
    end
    @active = next_active
    @active.any?(&:end_of_word)
  end
end

if __FILE__ == $PROGRAM_NAME
  sc = StreamChecker.new(%w[cd f kl])
  %w[a b c d e f g h i j k l].each do |c|
    puts "#{c}: #{sc.query(c)}"
  end
end
