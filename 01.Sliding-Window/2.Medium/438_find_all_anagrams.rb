# frozen_string_literal: true

# LeetCode 438: Find All Anagrams in a String
#
# Problem:
# Given two strings s and p, return an array of all starting indices of
# p's anagrams in s. An anagram has the same characters with the same
# frequency as the original. Order of output does not matter.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Slide a window of size p.length across s.
#    For each window, sort it and compare to sorted p.
#    If match, record the starting index.
#
#    Time Complexity: O(n * k log k) — n windows, k = p.length, sort each
#    Space Complexity: O(k)
#
# 2. Bottleneck
#    Sorting every window from scratch is wasted work.
#    When sliding by one step, only one character enters and one leaves.
#    We can update counts incrementally instead of re-sorting.
#
# 3. Optimized Accepted Approach
#    Use two hash maps — one for p counts, one for the current window.
#    Build p_count once. Initialize window_count for the first window.
#    Slide the window: add incoming char, remove outgoing char.
#    If window_count == p_count, record the starting index.
#
#    Time Complexity: O(n)
#    Space Complexity: O(k) — at most 26 keys per hash
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "cbaebadb", p = "abc"
# k = 3, p_count = {a:1, b:1, c:1}
#
# Initial window "cba": window_count = {c:1, b:1, a:1} == p_count -> result=[0]
#
# left=1, incoming=s[3]='e', outgoing=s[0]='c'
# window_count = {b:1, a:1, e:1} != p_count
#
# left=2, incoming=s[4]='b', outgoing=s[1]='b'
# window_count = {a:1, e:1, b:1} != p_count
#
# left=3, incoming=s[5]='a', outgoing=s[2]='a'
# window_count = {e:1, b:1, a:1} != p_count
#
# left=4, incoming=s[6]='d', outgoing=s[3]='e'
# window_count = {b:1, a:1, d:1} != p_count
#
# left=5, incoming=s[7]='b', outgoing=s[4]='b'
# window_count = {a:1, d:1, b:1} != p_count
#
# left=6, incoming=s[8] -> out of bounds... wait s="cbaebadb", length=8
# so s[0,3]="cba", last left = 8-3 = 5
#
# Final answer = [0, 6]
#
# Edge Cases:
# - p.length > s.length -> return []
# - s or p empty -> return []
# - No anagram exists -> return []

def find_anagrams_brute(text, pattern)
  result = []
  window_size = pattern.length
  pattern_sorted = pattern.chars.sort

  (0..(text.length - window_size)).each do |left|
    result << left if text[left, window_size].chars.sort == pattern_sorted
  end

  result
end

def find_anagrams(text, pattern)
  window_size = pattern.length
  return [] if window_size.zero? || window_size > text.length

  pattern_count, window_count = initial_window_counts(text, pattern, window_size)
  scan_anagram_windows(text, window_size, pattern_count, window_count)
end

def build_char_count(text)
  counts = Hash.new(0)
  text.each_char { |char| counts[char] += 1 }
  counts
end

def initial_window_counts(text, pattern, window_size)
  [build_char_count(pattern), build_char_count(text[0, window_size])]
end

def scan_anagram_windows(text, window_size, pattern_count, window_count)
  result = []
  result << 0 if window_count == pattern_count
  (1..(text.length - window_size)).each do |left|
    update_window_count(window_count, text[left + window_size - 1], text[left - 1])
    result << left if window_count == pattern_count
  end
  result
end

def update_window_count(window_count, incoming_char, outgoing_char)
  window_count[incoming_char] += 1
  window_count[outgoing_char] -= 1
  window_count.delete(outgoing_char) if window_count[outgoing_char].zero?
end

if __FILE__ == $PROGRAM_NAME
  s = 'cbaebadb'
  p = 'abc'

  puts "Brute force: #{find_anagrams_brute(s, p)}"
  puts "Optimized:   #{find_anagrams(s, p)}"
end
