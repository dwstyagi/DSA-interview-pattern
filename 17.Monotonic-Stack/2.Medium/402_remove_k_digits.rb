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
#    Repeatedly scan left-to-right and remove first digit that is greater than next. k times.
#    Time Complexity: O(n*k)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    O(n*k) can be O(n^2). Monotonic increasing stack does this in O(n).
#
# 3. Optimized Accepted Approach
#    Monotonic increasing stack. Pop while stack top > current digit AND k > 0.
#    If k remaining, remove last k digits. Strip leading zeros.
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
# '3': 4>3 k=3->2, pop; stack=[1,3]
# '2': 3>2 k=2->1, pop; 1<2 push -> [1,2]
# '2': stack=[1,2,2]
# '1': 2>1 k=1->0, pop -> [1,2]; push 1 -> [1,2,1]
# '9': stack=[1,2,1,9]
# k=0 -> result="1219"
#
# Edge Cases:
# - k >= len: return "0"
# - All ascending: remove last k

def remove_kdigits_brute(num, k)
  arr = num.chars
  k.times do
    i = 0
    while i < arr.length - 1
      if arr[i] > arr[i + 1]
        arr.delete_at(i)
        break
      end
      i += 1
    end
    arr.pop if i == arr.length - 1
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
