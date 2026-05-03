# frozen_string_literal: true

# LeetCode 125: Valid Palindrome
#
# Problem:
# A phrase is a palindrome if, after converting all uppercase letters to lowercase
# and removing all non-alphanumeric characters, it reads the same forward and backward.
# Return true if s is a palindrome, false otherwise.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Filter non-alphanumeric, downcase, then compare to its reverse.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Building a filtered copy wastes O(n) space; we can compare in-place.
#
# 3. Optimized Accepted Approach
#    Two-pointer: skip non-alphanumeric chars, compare case-insensitively.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "A man, a plan, a canal: Panama"
# filtered = "amanaplanacanalpanama"
# left=0('a') right=19('a') equal → advance
# left=1('m') right=18('m') equal → advance
# ... all match → true
#
# Edge Cases:
# - All non-alphanumeric (e.g. " ") -> true (empty = palindrome)
# - Single char                      -> true
# - "race a car"                     -> false

def valid_palindrome_brute?(s)
  # Filter to alphanumeric only, downcase, then compare to reverse
  cleaned = s.downcase.gsub(/[^a-z0-9]/, '')
  cleaned == cleaned.reverse
end

def valid_palindrome?(s)
  left  = 0
  right = s.length - 1

  while left < right
    # Advance left past non-alphanumeric characters
    left  += 1 while left < right && !s[left].match?(/[a-z0-9]/i)
    # Retreat right past non-alphanumeric characters
    right -= 1 while left < right && !s[right].match?(/[a-z0-9]/i)

    # Case-insensitive comparison of the two pointers
    return false if s[left].downcase != s[right].downcase

    left  += 1
    right -= 1
  end

  true
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{valid_palindrome_brute?('A man, a plan, a canal: Panama')}" # true
  puts "Optimized:   #{valid_palindrome?('A man, a plan, a canal: Panama')}"       # true
  puts "Brute force: #{valid_palindrome_brute?('race a car')}"                     # false
  puts "Optimized:   #{valid_palindrome?('race a car')}"                           # false
end
