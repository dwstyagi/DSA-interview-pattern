# frozen_string_literal: true

# LeetCode 344: Reverse String
#
# Problem:
# Given an array of characters chars, reverse the array in-place.
# The optimized solution should not allocate another full array for the result.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Build a reversed copy of the array, then write those values back into the
#    original array one by one.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Time is already linear, but the brute-force version allocates an extra
#    reversed array.
#    That violates the in-place spirit of the problem and costs O(n) space.
#
# 3. Optimized Accepted Approach
#    Use two pointers from opposite ends.
#    - left starts at the beginning
#    - right starts at the end
#    Swap chars[left] and chars[right], then move both pointers inward.
#
#    Each swap places two characters into their final reversed positions.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# chars = ["h", "e", "l", "l", "o"]
#
# left = 0, right = 4
# swap "h" and "o"
# chars = ["o", "e", "l", "l", "h"]
#
# left = 1, right = 3
# swap "e" and "l"
# chars = ["o", "l", "l", "e", "h"]
#
# left = 2, right = 2
# stop
#
# Final array = ["o", "l", "l", "e", "h"]
#
# Edge Cases:
# - empty array -> nothing changes
# - single character -> already reversed
# - odd length -> middle character stays in place

def reverse_string_true_brute_force(chars)
  reversed = chars.reverse
  chars.each_index { |index| chars[index] = reversed[index] }
end

def reverse_string(chars)
  left = 0
  right = chars.length - 1

  while left < right
    chars[left], chars[right] = chars[right], chars[left]
    left += 1
    right -= 1
  end
end

if __FILE__ == $PROGRAM_NAME
  brute_force_chars = %w[h e l l o]
  optimized_chars = %w[h e l l o]

  reverse_string_true_brute_force(brute_force_chars)
  reverse_string(optimized_chars)

  puts "True brute force: #{brute_force_chars}"
  puts "Optimized:        #{optimized_chars}"
end
