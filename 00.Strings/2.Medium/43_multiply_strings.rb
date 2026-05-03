# frozen_string_literal: true

# LeetCode 43: Multiply Strings
#
# Problem:
# Given two non-negative integers num1 and num2 represented as strings,
# return the product of num1 and num2 as a string.
# You must not convert the inputs to integer directly.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Convert both strings to integers, multiply, convert back to string.
#    (Not allowed by problem constraint but shows the idea.)
#
#    Time Complexity: O(n + m)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Cannot use built-in integer conversion. Must simulate grade-school multiplication.
#
# 3. Optimized Accepted Approach
#    Grade-school digit-by-digit multiplication.
#    digit num1[i] * digit num2[j] contributes to positions i+j and i+j+1 in result array.
#    Propagate carries from right to left.
#
#    Time Complexity: O(n * m) where n, m = lengths of num1, num2
#    Space Complexity: O(n + m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# num1 = "23", num2 = "45"
# positions array of size 2+2=4: [0, 0, 0, 0]
# i=0(2), j=0(4): pos[0+1] += 8, pos[0] += 0  → [0,8,0,0]
# i=0(2), j=1(5): pos[0+2] += 10... carry propagates
# i=1(3), j=0(4): ...
# Final propagation → [1, 0, 3, 5] → "1035"
#
# Edge Cases:
# - Either operand is "0" -> "0"
# - Single digit numbers  -> direct product

def multiply_brute(num1, num2)
  # Direct conversion for reference (violates problem constraint)
  (num1.to_i * num2.to_i).to_s
end

def multiply(num1, num2)
  return '0' if num1 == '0' || num2 == '0'

  m = num1.length
  n = num2.length
  pos = Array.new(m + n, 0)

  # Multiply each digit pair and add to correct positions
  (m - 1).downto(0) do |i|
    (n - 1).downto(0) do |j|
      # Product affects two positions
      product = (num1[i].to_i) * (num2[j].to_i)
      p1 = i + j       # higher position (carry)
      p2 = i + j + 1   # lower position

      total = product + pos[p2]
      pos[p2] = total % 10
      pos[p1] += total / 10
    end
  end

  # Skip leading zeros and join digits
  pos.drop_while(&:zero?).join
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{multiply_brute('23', '45')}" # "1035"
  puts "Optimized:   #{multiply('23', '45')}"       # "1035"
  puts "Brute force: #{multiply_brute('999', '999')}" # "998001"
  puts "Optimized:   #{multiply('999', '999')}"       # "998001"
end
