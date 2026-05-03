# frozen_string_literal: true

# LeetCode 745: Prefix and Suffix Search
#
# Problem:
# Design WordFilter that supports f(prefix, suffix) returning the largest index
# of a word that has the given prefix and suffix. Return -1 if none.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each query, scan all words to find matching prefix and suffix. Return last index.
#    Time Complexity: O(n * m) per query
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    For many queries, brute force is O(q * n * m). Precompute: store all
#    (prefix#suffix) combinations in a hash, mapping to largest index.
#
# 3. Optimized Accepted Approach
#    For each word at index i, store all "prefix{suffix}" pairs in a hash.
#    Query: look up "prefix{suffix}" directly.
#
#    Time Complexity: O(n * m^2) build, O(1) query
#    Space Complexity: O(n * m^2)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# words=["apple"]
# pairs: a{e, a{le, a{ple, a{pple, a{apple, ap{e, ... apple{apple, etc. -> all map to index 0
# f("a","e"): "a{e" -> 0
# f("b",""):  "b{" -> -1
#
# Edge Cases:
# - Empty prefix or suffix: match from start or from end of any word
# - Multiple words with same prefix/suffix: return last index

class WordFilterBrute
  def initialize(words)
    @words = words
  end

  def f(pref, suff)
    result = -1
    @words.each_with_index do |w, i|
      result = i if w.start_with?(pref) && w.end_with?(suff)
    end
    result
  end
end

class WordFilter
  def initialize(words)
    @lookup = {}
    words.each_with_index do |word, i|
      m = word.length
      (0..m).each do |p|
        (0..m).each do |s|
          key = "#{word[0...p]}{#{word[m - s..]}"
          @lookup[key] = i
        end
      end
    end
  end

  def f(pref, suff)
    @lookup.fetch("#{pref}{#{suff}", -1)
  end
end

if __FILE__ == $PROGRAM_NAME
  wf = WordFilter.new(['apple'])
  puts wf.f('a', 'e')   # 0
  puts wf.f('b', '')    # -1
  puts wf.f('', 'apple') # 0
end
