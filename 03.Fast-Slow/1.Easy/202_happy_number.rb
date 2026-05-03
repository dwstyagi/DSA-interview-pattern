# frozen_string_literal: true

# LeetCode 202: Happy Number
#
# Problem:
# A happy number is defined by the following process:
# Starting with any positive integer, replace the number by the sum of the
# squares of its digits. Repeat until the number equals 1 (happy) or loops
# endlessly in a cycle that does not include 1 (not happy).
# Return true if n is a happy number, false otherwise.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate the process and store each result in a Set.
#    If we see 1, return true.
#    If we see a number already in the Set, we're in a cycle -> return false.
#
#    Time Complexity: O(log n) per step, O(log n) steps before cycle
#    Space Complexity: O(log n)
#
# 2. Bottleneck
#    We use extra space to track seen numbers.
#    The sequence of digit-square sums forms an implicit linked list.
#    If there's a cycle, slow/fast pointers will detect it without a Set.
#
# 3. Optimized Accepted Approach
#    Treat the digit-square transformation as f(n) = next number.
#    Use slow/fast pointers on this implicit sequence.
#    If fast reaches 1, it's happy.
#    If slow == fast (and != 1), there's a cycle -> not happy.
#
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n = 19
#
# digit_square_sum(19) = 1^2 + 9^2 = 1 + 81 = 82
# digit_square_sum(82) = 8^2 + 2^2 = 64 + 4 = 68
# digit_square_sum(68) = 6^2 + 8^2 = 36 + 64 = 100
# digit_square_sum(100) = 1^2 + 0^2 + 0^2 = 1
# -> reached 1 -> return true ✓
#
# n = 2 (not happy, cycles through: 2->4->16->37->58->89->145->42->20->4...)
# slow and fast will eventually meet at a non-1 number -> return false
#
# Edge Cases:
# - n = 1 -> immediately true
# - n = 7 -> happy (7->49->97->130->10->1)

# compute sum of squares of digits
def digit_square_sum(n)
  sum = 0
  while n > 0
    digit = n % 10      # extract last digit
    sum += digit * digit # square it and add
    n /= 10             # remove last digit
  end
  sum
end

# brute force: use a Set to detect when we revisit a number
def happy_number_brute?(n)
  seen = Set.new

  until n == 1
    return false if seen.include?(n) # cycle detected

    seen.add(n)
    n = digit_square_sum(n)
  end

  true # reached 1 -> happy
end

# optimized: Floyd's cycle detection on the implicit digit-square sequence
# slow moves 1 step, fast moves 2 steps
def happy_number?(n)
  slow = n
  fast = digit_square_sum(n) # fast starts one step ahead

  # stop when fast reaches 1 (happy) or slow catches fast (cycle)
  while fast != 1 && slow != fast
    slow = digit_square_sum(slow)              # 1 step
    fast = digit_square_sum(digit_square_sum(fast)) # 2 steps
  end

  fast == 1 # true if happy, false if caught in cycle
end

if __FILE__ == $PROGRAM_NAME
  puts "19 happy? brute:     #{happy_number_brute?(19)}"
  puts "19 happy? optimized: #{happy_number?(19)}"
  puts "2 happy? brute:      #{happy_number_brute?(2)}"
  puts "2 happy? optimized:  #{happy_number?(2)}"
end
