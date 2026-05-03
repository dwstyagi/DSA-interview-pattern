# frozen_string_literal: true

# LeetCode 125: Valid Palindrome
#
# Problem:
# Given a string text, return true if it is a palindrome after converting all
# uppercase letters to lowercase and removing all non-alphanumeric characters.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Build a cleaned version of the string by:
#    - keeping only alphanumeric characters
#    - converting letters to lowercase
#    Then compare the cleaned string with its reverse.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Time is already linear, but the brute-force version creates extra strings:
#    - the cleaned string
#    - its reversed copy
#
#    That unnecessary O(n) extra space can be avoided.
#
# 3. Optimized Accepted Approach
#    Use two pointers from opposite ends on the original string.
#    - move left forward until it points to an alphanumeric character
#    - move right backward until it points to an alphanumeric character
#    - compare the lowercase versions
#    - if they differ, return false
#    - otherwise move inward
#
#    This keeps the same O(n) time but reduces extra space to O(1).
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# text = "A man, a plan, a canal: Panama"
#
# left starts at 'A'
# right starts at 'a'
# compare 'a' with 'a' -> match
#
# skip spaces and punctuation on both sides
# continue comparing:
# - 'm' with 'm'
# - 'a' with 'a'
# - 'n' with 'n'
#
# all meaningful characters match
#
# Final answer = true
#
# Edge Cases:
# - empty string -> true
# - string with only symbols -> true
# - single character -> true
# - digits are valid alphanumeric characters

def palindrome_brute_force?(text)
  cleaned = text.downcase.gsub(/[^a-z0-9]/, '')
  cleaned == cleaned.reverse
end

def palindrome?(text)
  left = 0
  right = text.length - 1

  while left < right
    left += 1 while left < right && !alphanumeric?(text[left])
    right -= 1 while left < right && !alphanumeric?(text[right])

    return false if text[left].downcase != text[right].downcase

    left += 1
    right -= 1
  end

  true
end

def alphanumeric?(char)
  char.match?(/[a-zA-Z0-9]/)
end

if __FILE__ == $PROGRAM_NAME
  text = 'A man, a plan, a canal: Panama'

  puts "True brute force: #{palindrome_brute_force?(text)}"
  puts "Optimized:        #{palindrome?(text)}"
end
