# frozen_string_literal: true

# LeetCode 2269: Find the K-Beauty of a Number
#
# Problem:
# Given an integer num and an integer k, return the k-beauty of num.
# The k-beauty is the count of substrings of num (when written as a string)
# of length k that are divisors of num.
# A substring that is 0 is not a valid divisor.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Convert num to a string. Slide through every substring of length k.
#    For each substring, convert it to an integer.
#    Skip if it is 0. Count it if num % substring == 0.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
#    Why O(n)?
#    - n - k + 1 substrings to check (n = number of digits)
#    - O(1) work per substring
#    - num <= 10^9 so n <= 9, effectively O(1) in practice
#
# 2. Bottleneck
#    No bottleneck. The input size is at most 9 digits.
#    Brute force is already optimal.
#
# 3. Optimized Accepted Approach
#    Same as brute force — sliding window over the digit string.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# num = 240, k = 2
#
# s = "240"
#
# i = 0
# sub = "24".to_i = 24
# 24 != 0, 240 % 24 == 0 -> count = 1
#
# i = 1
# sub = "40".to_i = 40
# 40 != 0, 240 % 40 == 0 -> count = 2
#
# Final answer = 2
#
# Edge Cases:
# - Substring is "0" -> skip (division by zero)
# - k equals total digits -> only one substring to check
# - No substring divides num -> return 0

def divisor_substrings(num, window_length)
  digits = num.to_s
  count = 0

  (0..(digits.length - window_length)).each do |i|
    sub = digits[i, window_length].to_i
    next if sub.zero?

    count += 1 if (num % sub).zero?
  end

  count
end

if __FILE__ == $PROGRAM_NAME
  num = 240
  k = 2

  puts "K-beauty: #{divisor_substrings(num, k)}"
end
