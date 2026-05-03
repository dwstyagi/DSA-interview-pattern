# frozen_string_literal: true

# LeetCode 451: Sort Characters By Frequency
#
# Problem:
# Given a string s, sort it in decreasing order based on the frequency of
# characters. Return any valid sorted string.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Count character frequencies, sort characters by frequency descending,
#    build result string by repeating each character its frequency times.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Sorting all unique characters is O(k log k) where k = unique chars.
#    Since k ≤ 128, sorting itself is fast; brute is already near-optimal.
#
# 3. Optimized Accepted Approach
#    Use tally to count, then sort by frequency descending (max-heap simulation).
#    Build result string by repeating each char × its count.
#    Time Complexity: O(n + k log k) ≈ O(n) since k is bounded
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "tree"
# freq = {t: 1, r: 1, e: 2}
# sorted by freq desc: [[e,2],[t,1],[r,1]]
# result = "ee" + "t" + "r" = "eetr"  (or "eerr" etc. — multiple valid answers)
#
# Edge Cases:
# - All same char → return that char repeated
# - All unique chars → any order of single chars

def frequency_sort_brute(s)
  freq = s.chars.tally
  # sort descending by frequency; ties can be in any order
  freq.sort_by { |_, count| -count }
      .map { |char, count| char * count }
      .join
end

def frequency_sort(s)
  freq = s.chars.tally                       # count each character
  # sort descending by count (simulate max-heap drain)
  freq.sort_by { |_, count| -count }
      .each_with_object(+"") { |(char, count), res| res << char * count }
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{frequency_sort_brute("tree")}"    # "eert" or "eetr"
  puts "Opt:   #{frequency_sort("tree")}"          # "eert" or "eetr"
  puts "Brute: #{frequency_sort_brute("cccaaa")}"  # "cccaaa" or "aaaccc"
  puts "Opt:   #{frequency_sort("cccaaa")}"        # "cccaaa" or "aaaccc"
  puts "Brute: #{frequency_sort_brute("Aabb")}"    # "bbAa" or "bbaA"
  puts "Opt:   #{frequency_sort("Aabb")}"          # "bbAa" or "bbaA"
end
