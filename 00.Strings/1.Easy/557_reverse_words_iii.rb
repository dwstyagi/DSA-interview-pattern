# frozen_string_literal: true

# LeetCode 557: Reverse Words in a String III
#
# Problem:
# Given a string s, reverse the order of characters in each word within a sentence
# while still preserving whitespace and initial word order.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Split into words, reverse each word's characters individually, rejoin.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    This is essentially O(n) in both approaches; the key difference is in-place vs not.
#    In an interview, demonstrating the two-pointer in-place reversal shows deeper understanding.
#
# 3. Optimized Accepted Approach
#    Split by spaces, reverse each word using two pointers, join.
#    For truly O(1) extra space, work on a character array and reverse word spans in-place.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n) for output (O(1) if we mutate in place)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "Let's take LeetCode contest"
# words = ["Let's", "take", "LeetCode", "contest"]
# reversed = ["s'teL", "ekat", "edoCteeL", "tseetnoc"]
# joined = "s'teL ekat edoCteeL tseetnoc"
#
# Edge Cases:
# - Single word          -> reverse that word
# - Multiple spaces      -> (problem guarantees single spaces)
# - Single character     -> unchanged

def reverse_words_iii_brute(s)
  # Split on spaces and reverse each word string
  s.split(' ').map(&:reverse).join(' ')
end

def reverse_words_iii(s)
  # Convert to char array to reverse words with two pointers
  chars = s.chars
  n = chars.length

  left = 0
  while left < n
    # Find the end of the current word
    right = left
    right += 1 while right < n && chars[right] != ' '

    # Two-pointer reverse within [left, right - 1]
    lo = left
    hi = right - 1
    while lo < hi
      chars[lo], chars[hi] = chars[hi], chars[lo]
      lo += 1
      hi -= 1
    end

    left = right + 1 # jump past the space to the next word
  end

  chars.join
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{reverse_words_iii_brute("Let's take LeetCode contest")}"
  puts "Optimized:   #{reverse_words_iii("Let's take LeetCode contest")}"
  # Both: "s'teL ekat edoCteeL tseetnoc"
end
