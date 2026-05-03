# frozen_string_literal: true

# LeetCode 340: Longest Substring with At Most K Distinct Characters
#
# Problem:
# Given a string s and an integer k, return the length of the longest substring
# that contains at most k distinct characters.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every possible substring (left, right).
#    Track distinct characters using a hash.
#    Break early if distinct count exceeds k.
#    Update max length if valid.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(k)
#
# 2. Bottleneck
#    We restart from every left, rebuilding the hash from scratch each time.
#    When the window exceeds k distinct chars, we only need to shrink from
#    the left until we're back to k distinct — not restart entirely.
#
# 3. Optimized Accepted Approach
#    Use a sliding window with a hash tracking character counts.
#    Expand right one step at a time.
#    When hash has more than k keys, shrink from left — decrement count,
#    delete key if count hits 0.
#    Track max window size throughout.
#
#    Time Complexity: O(n)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "eceba", k = 2
#
# right=0, hash={e:1}, result=1
# right=1, hash={e:1,c:1}, result=2
# right=2, hash={e:2,c:1}, result=3
# right=3, hash={e:2,c:1,b:1} -> 3 distinct
#   shrink: hash={e:1,c:0} -> delete c -> hash={e:1,b:1}, left=2, result=3
# right=4, hash={e:1,b:1,a:1} -> 3 distinct
#   shrink: hash={b:1,a:1}, left=3, result=3
#
# Final answer = 3
#
# Edge Cases:
# - k = 0 -> return 0
# - Empty string -> return 0
# - k >= s.length -> return s.length

def length_of_longest_substring_k_distinct_brute(text, max_distinct)
  max_length = 0

  (0...text.length).each do |left|
    counts = Hash.new(0)
    (left...text.length).each do |right|
      counts[text[right]] += 1
      break if counts.length > max_distinct

      max_length = [max_length, right - left + 1].max
    end
  end

  max_length
end

def length_of_longest_substring_k_distinct(text, max_distinct)
  return 0 if max_distinct.zero?

  counts = Hash.new(0)
  left = 0
  best_length = 0

  text.each_char.with_index do |char, right|
    counts[char] += 1
    left = shrink_to_max_distinct(text, counts, left, max_distinct)
    best_length = [best_length, right - left + 1].max
  end

  best_length
end

def shrink_to_max_distinct(text, counts, left, max_distinct)
  while counts.length > max_distinct
    left_char = text[left]
    counts[left_char] -= 1
    counts.delete(left_char) if counts[left_char].zero?
    left += 1
  end
  left
end

if __FILE__ == $PROGRAM_NAME
  s = 'eceba'
  k = 2

  puts "Brute force: #{length_of_longest_substring_k_distinct_brute(s, k)}"
  puts "Optimized:   #{length_of_longest_substring_k_distinct(s, k)}"
end
