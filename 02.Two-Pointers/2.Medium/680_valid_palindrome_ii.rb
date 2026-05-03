# frozen_string_literal: true

# LeetCode 680: Valid Palindrome II
#
# Problem:
# Given a string text, return true if it can be a palindrome after deleting at
# most one character.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    First check whether the original string is already a palindrome.
#    Then try deleting each character one at a time and check whether the
#    remaining string is a palindrome.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Brute force creates many new strings and repeatedly checks palindrome
#    from scratch.
#    We only need to care about the first mismatch while scanning inward.
#
# 3. Optimized Accepted Approach
#    Use two pointers from opposite ends.
#    If characters match, move both pointers inward.
#    On the first mismatch, use the one allowed deletion:
#    - skip the left character
#    - or skip the right character
#
#    If either remaining range is a palindrome, return true.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# text = "abca"
#
# left = 0, right = 3
# 'a' == 'a', move inward
#
# left = 1, right = 2
# 'b' != 'c', one deletion must be used
#
# Try skipping left:
# range "ca" is not palindrome
#
# Try skipping right:
# range "b" is palindrome
#
# Final answer = true
#
# Edge Cases:
# - already palindrome -> true
# - one deletion fixes it -> true
# - more than one deletion needed -> false
# - single character -> true

def valid_palindrome_true_brute_force(text)
  return true if palindrome_range?(text, 0, text.length - 1)

  (0...text.length).each do |index|
    candidate = text[0...index] + text[(index + 1)..]
    return true if candidate == candidate.reverse
  end

  false
end

def valid_palindrome?(text)
  left = 0
  right = text.length - 1

  while left < right
    return one_skip_palindrome?(text, left, right) if text[left] != text[right]

    left += 1
    right -= 1
  end

  true
end

def one_skip_palindrome?(text, left, right)
  palindrome_range?(text, left + 1, right) ||
    palindrome_range?(text, left, right - 1)
end

def palindrome_range?(text, left, right)
  while left < right
    return false if text[left] != text[right]

    left += 1
    right -= 1
  end

  true
end

if __FILE__ == $PROGRAM_NAME
  text = 'abca'

  puts "True brute force: #{valid_palindrome_true_brute_force(text)}"
  puts "Optimized:        #{valid_palindrome?(text)}"
end
