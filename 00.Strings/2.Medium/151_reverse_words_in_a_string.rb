# frozen_string_literal: true

# LeetCode 151: Reverse Words in a String
#
# Problem:
# Given an input string s, reverse the order of the words.
# A word is a sequence of non-space characters. Words in s are separated by at least one space.
# Return a string of the words in reverse order concatenated by a single space.
# Note: leading/trailing spaces and multiple spaces between words should be removed.
#
# Examples:
#   Input:  s = "the sky is blue"
#   Output: "blue is sky the"
#   Why:    Split into ["the","sky","is","blue"], reverse order -> "blue is sky the".
#
#   Input:  s = "  hello world  "
#   Output: "world hello"
#   Why:    Strip leading/trailing spaces, split -> ["hello","world"], reverse -> "world hello".
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Split on whitespace (handles multiple spaces), reverse the array, join with single space.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    The split approach is already optimal. A manual approach would parse character-by-character.
#
# 3. Optimized Accepted Approach
#    String#split without arguments splits on any whitespace and drops empty tokens.
#    Reverse the resulting array and join with a single space.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "  hello world  "
# split = ["hello", "world"]
# reverse = ["world", "hello"]
# join = "world hello"
#
# s = "a good   example"
# split = ["a", "good", "example"]
# reverse = ["example", "good", "a"]
# join = "example good a"
#
# Edge Cases:
# - Only spaces      -> "" (split returns [])
# - Single word      -> that word
# - Already reversed -> original order returned

def reverse_words_brute(s)
  # Trim manually then split on runs of spaces
  words = []
  word = ''
  s.each_char do |c|
    if c == ' '
      words << word unless word.empty?
      word = ''
    else
      word += c
    end
  end
  words << word unless word.empty?
  words.reverse.join(' ')
end

def reverse_words(s)
  # split without args handles all leading/trailing/multiple spaces
  s.split.reverse.join(' ')
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{reverse_words_brute('  hello world  ')}" # "world hello"
  puts "Optimized:   #{reverse_words('  hello world  ')}"       # "world hello"
  puts "Brute force: #{reverse_words_brute('a good   example')}" # "example good a"
  puts "Optimized:   #{reverse_words('a good   example')}"       # "example good a"
end
