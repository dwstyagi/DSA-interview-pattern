# frozen_string_literal: true

# LeetCode 8: String to Integer (atoi)
#
# Problem:
# Implement the myAtoi(string s) function, which converts a string to a 32-bit signed integer.
# Algorithm: 1) Ignore leading whitespace. 2) Read optional +/- sign.
# 3) Read digits until non-digit or end. 4) Clamp to [-2^31, 2^31 - 1].
#
# Examples:
#   Input:  s = "   -042"
#   Output: -42
#   Why:    Skip spaces, read '-' sign, read digits "042" -> -42.
#
#   Input:  s = "1337c0d3"
#   Output: 1337
#   Why:    Read digits "1337", stop at 'c' (non-digit) -> 1337.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use Ruby's built-in .to_i and clamp — but this misses edge case behavior.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Built-in doesn't follow the strict Atoi spec. Need explicit state machine.
#
# 3. Optimized Accepted Approach
#    State machine with 4 strict steps: lstrip → sign → digits → clamp.
#    Stop parsing at first non-digit after sign.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "   -42"
# lstrip → "-42"
# sign = -1, i = 1
# digit loop: '4','2' → result = 42
# sign * 42 = -42
#
# s = "4193 with words"
# sign = 1, i = 0
# digits: '4','1','9','3' → result = 4193
# stop at ' ' → 4193
#
# Edge Cases:
# - Pure whitespace   -> 0
# - Overflow "99999999999" -> 2147483647
# - Leading sign only -> 0

INT_MIN = -2**31
INT_MAX = 2**31 - 1

def my_atoi_brute(s)
  # Rough version using Ruby's to_i with clamp
  s.lstrip.to_i.clamp(INT_MIN, INT_MAX)
end

def my_atoi(s)
  # Step 1: strip leading whitespace
  s = s.lstrip
  return 0 if s.empty?

  # Step 2: read optional sign
  sign = 1
  i = 0
  if s[0] == '+' || s[0] == '-'
    sign = s[0] == '-' ? -1 : 1
    i = 1
  end

  # Step 3: read digits, stop at first non-digit
  result = 0
  while i < s.length && s[i].match?(/\d/)
    result = result * 10 + s[i].to_i
    i += 1
  end

  # Step 4: apply sign and clamp to 32-bit range
  (sign * result).clamp(INT_MIN, INT_MAX)
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{my_atoi_brute('   -42')}"         # -42
  puts "Optimized:   #{my_atoi('   -42')}"               # -42
  puts "Brute force: #{my_atoi_brute('4193 with words')}" # 4193
  puts "Optimized:   #{my_atoi('4193 with words')}"       # 4193
  puts "Optimized:   #{my_atoi('99999999999')}"           # 2147483647
end
