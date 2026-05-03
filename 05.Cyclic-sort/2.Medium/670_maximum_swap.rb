# frozen_string_literal: true

# LeetCode 670: Maximum Swap
#
# Problem:
# You are given an integer num. You can swap two digits at most once to get the maximum valued number.
# Return the maximum valued number you can get.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all pairs of digit swaps; return the maximum resulting number.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Can observe that we want to find the leftmost digit that can be swapped with
#    a larger digit to its right, and that larger digit should be the rightmost occurrence
#    (for maximum value).
#
# 3. Optimized Accepted Approach
#    Record the last index of each digit 0-9.
#    For each digit from left to right, try to find a larger digit to its right
#    (check digits 9 down to current+1). Swap the first such opportunity.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1) — at most 10 digit slots
#
# -----------------------------------------------------------------------------
# Dry Run
#
# num = 2736
# digits = [2,7,3,6]
# last = {2:0, 7:1, 3:2, 6:3}
# i=0(2): try digits 9..3 → 7 at idx 1 > idx 0 → swap → [7,2,3,6] → 7236
#
# num = 9973
# digits = [9,9,7,3]
# i=0(9): no larger → skip
# i=1(9): no larger → skip
# i=2(7): check 9: last[9]=1, but 1<2 → no. check 8: not present. → nothing
# return 9973
#
# Edge Cases:
# - Already max    -> no swap needed, return as-is
# - Single digit   -> return as-is

def maximum_swap_brute(num)
  digits = num.to_s.chars.map(&:to_i)
  n = digits.length
  max_val = num

  (0...n).each do |i|
    ((i + 1)...n).each do |j|
      digits[i], digits[j] = digits[j], digits[i]
      val = digits.join.to_i
      max_val = [max_val, val].max
      digits[i], digits[j] = digits[j], digits[i]
    end
  end

  max_val
end

def maximum_swap(num)
  digits = num.to_s.chars.map(&:to_i)
  n = digits.length

  # Record the last index of each digit 0-9
  last = {}
  digits.each_with_index { |d, i| last[d] = i }

  n.times do |i|
    # Try to find a larger digit (9 down to digits[i]+1) that appears to the right
    (9).downto(digits[i] + 1) do |d|
      if last[d] && last[d] > i
        # Swap digits[i] with the largest digit to its right
        digits[i], digits[last[d]] = digits[last[d]], digits[i]
        return digits.join.to_i
      end
    end
  end

  num
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{maximum_swap_brute(2736)}" # 7236
  puts "Optimized:   #{maximum_swap(2736)}"       # 7236
  puts "Brute force: #{maximum_swap_brute(9973)}" # 9973
  puts "Optimized:   #{maximum_swap(9973)}"       # 9973
end
