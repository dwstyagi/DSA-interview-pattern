# frozen_string_literal: true

# LeetCode 13: Roman to Integer
#
# Problem:
# Given a roman numeral, convert it to an integer.
# Roman numerals: I=1, V=5, X=10, L=50, C=100, D=500, M=1000
# Subtractive cases: IV=4, IX=9, XL=40, XC=90, CD=400, CM=900
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Build a map of all two-character and one-character combinations,
#    scan left to right, match two-char first.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    The map approach works but is verbose; the subtract-if-smaller rule is cleaner.
#
# 3. Optimized Accepted Approach
#    Single pass: for each character, if its value is less than the next character's value,
#    subtract it; otherwise add it. This naturally handles all subtractive cases.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "MCMXCIV"  (= 1994)
# M=1000 < nothing → +1000
# C=100  < M=1000 → -100
# M=1000 > nothing in pair → +1000
# X=10   < C=100 → -10
# C=100  > nothing in pair → +100
# I=1    < V=5 → -1
# V=5 → +5
# Total = 1000 - 100 + 1000 - 10 + 100 - 1 + 5 = 1994
#
# Edge Cases:
# - Single character "I" -> 1
# - All additive "III"   -> 3
# - All subtractive "IV" -> 4

ROMAN_MAP = { 'I' => 1, 'V' => 5, 'X' => 10, 'L' => 50,
              'C' => 100, 'D' => 500, 'M' => 1000 }.freeze

def roman_to_int_brute(s)
  # Two-character lookup first, then single character
  two_char = { 'IV' => 4, 'IX' => 9, 'XL' => 40, 'XC' => 90, 'CD' => 400, 'CM' => 900 }
  result = 0
  i = 0
  while i < s.length
    two = s[i, 2]
    if two_char[two]
      result += two_char[two]
      i += 2
    else
      result += ROMAN_MAP[s[i]]
      i += 1
    end
  end
  result
end

def roman_to_int(s)
  result = 0

  s.each_char.with_index do |char, i|
    val      = ROMAN_MAP[char]
    next_val = ROMAN_MAP[s[i + 1]] || 0

    # If current value is less than next, it's a subtractive case → subtract
    if val < next_val
      result -= val
    else
      result += val
    end
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{roman_to_int_brute('MCMXCIV')}" # 1994
  puts "Optimized:   #{roman_to_int('MCMXCIV')}"       # 1994
  puts "Brute force: #{roman_to_int_brute('III')}"     # 3
  puts "Optimized:   #{roman_to_int('III')}"           # 3
end
