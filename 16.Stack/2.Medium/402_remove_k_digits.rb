# frozen_string_literal: true

# LeetCode 402: Remove K Digits
#
# Problem:
# Given number string num and integer k, remove k digits to make smallest possible number.
# Return result without leading zeros.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all combinations of removing k digits. O(n choose k).
#    Time Complexity: O(n^k)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Greedy: remove a digit when the digit to its left is larger than current.
#    This reduces the most significant position possible.
#
# 3. Optimized Accepted Approach
#    Monotonic stack (increasing). While stack top > current and k > 0, pop (remove).
#    Push current. If k > 0 remaining, remove from end.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# num="1432219", k=3
# '1': stack=[1]
# '4': stack=[1,4]
# '3': top=4>3, k=3->2, pop -> stack=[1]; push 3 -> [1,3]
# '2': top=3>2, k=2->1, pop -> [1]; top=1<2, push 2 -> [1,2]
# '2': stack=[1,2,2]
# '1': top=2>1, k=1->0, pop -> [1,2]; push 1 -> [1,2,1]
# '9': stack=[1,2,1,9]
# k=0, result="1219"
#
# Edge Cases:
# - k >= num.length: return "0"
# - Leading zeros after removal: strip them

def remove_kdigits_brute(num, k)
  arr = num.chars
  k.times do
    removed = false
    (0...arr.length - 1).each do |i|
      if arr[i] > arr[i + 1]
        arr.delete_at(i)
        removed = true
        break
      end
    end
    arr.pop unless removed
  end
  result = arr.join.sub(/^0+/, '')
  result.empty? ? '0' : result
end

def remove_kdigits(num, k)
  stack = []
  num.each_char do |c|
    stack.pop while k > 0 && !stack.empty? && stack.last > c && (k -= 1) >= 0
    stack << c
  end
  stack.pop(k) if k > 0
  result = stack.join.sub(/^0+/, '')
  result.empty? ? '0' : result
end

if __FILE__ == $PROGRAM_NAME
  puts remove_kdigits_brute('1432219', 3)  # "1219"
  puts remove_kdigits('10200', 1)           # "200"
  puts remove_kdigits('10', 2)              # "0"
end
