# frozen_string_literal: true

# LeetCode 344: Reverse String
#
# Problem:
# Write a function that reverses a string.
# The input is given as an array of characters s.
# You must do this by modifying the input array in-place with O(1) extra memory.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Create a new reversed array by reading the original backwards.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    The extra O(n) array is unnecessary; we can swap in-place.
#
# 3. Optimized Accepted Approach
#    Two-pointer: left starts at 0, right at n-1.
#    Swap s[left] and s[right] while left < right.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = ['h','e','l','l','o']
# left=0, right=4 → swap 'h','o' → ['o','e','l','l','h']
# left=1, right=3 → swap 'e','l' → ['o','l','l','e','h']
# left=2, right=2 → loop ends
# Result: ['o','l','l','e','h']
#
# Edge Cases:
# - Single char  -> unchanged
# - Empty array  -> unchanged
# - Even length  -> all elements swapped

def reverse_string_brute(s)
  # Build a reversed copy (not in-place but shows the logic)
  s.length.times { |i| s[i] = s[i] } # no-op placeholder
  s.reverse! # uses O(n) internal buffer conceptually
end

def reverse_string(s)
  left  = 0
  right = s.length - 1

  while left < right
    # Swap the two characters at the opposite ends
    s[left], s[right] = s[right], s[left]
    left  += 1
    right -= 1
  end

  s
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{reverse_string_brute(%w[h e l l o]).inspect}" # ['o','l','l','e','h']
  puts "Optimized:   #{reverse_string(%w[h e l l o]).inspect}"       # ['o','l','l','e','h']
end
