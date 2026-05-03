# frozen_string_literal: true

# LeetCode 744: Find Smallest Letter Greater Than Target
#
# Problem:
# Given a sorted array of lowercase letters and a target letter, return the
# smallest letter in the array that is strictly greater than target.
# Letters wrap around: if none found, return letters[0].
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Linear scan; first letter strictly greater than target.
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear scan on sorted array.
#
# 3. Optimized Accepted Approach
#    Upper-bound binary search: find first letter > target.
#    Wrap around: if result == n, return letters[0].
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# letters=['c','f','j'], target='c'
# l=0,r=3: mid=1, 'f' > 'c' → r=1
# l=0,r=1: mid=0, 'c' not > 'c' → l=1
# l=r=1 → letters[1]='f' ✓
#
# Edge Cases:
# - Target >= all letters → return letters[0] (wrap)
# - Target < all letters → return letters[0]

def next_greatest_letter_brute(letters, target)
  letters.find { |c| c > target } || letters[0]
end

def next_greatest_letter(letters, target)
  l = 0
  r = letters.length   # half-open for upper-bound

  while l < r
    mid = (l + r) / 2
    if letters[mid] <= target
      l = mid + 1   # need strictly greater
    else
      r = mid       # letters[mid] > target; this or left could be answer
    end
  end

  letters[l % letters.length]   # wrap around if l == letters.length
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{next_greatest_letter_brute(%w[c f j], "c")}"   # "f"
  puts "Opt:   #{next_greatest_letter(%w[c f j], "c")}"         # "f"
  puts "Brute: #{next_greatest_letter_brute(%w[c f j], "d")}"   # "f"
  puts "Opt:   #{next_greatest_letter(%w[c f j], "d")}"         # "f"
  puts "Brute: #{next_greatest_letter_brute(%w[c f j], "j")}"   # "c" (wrap)
  puts "Opt:   #{next_greatest_letter(%w[c f j], "j")}"         # "c" (wrap)
end
