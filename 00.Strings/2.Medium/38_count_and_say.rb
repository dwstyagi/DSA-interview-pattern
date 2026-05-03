# frozen_string_literal: true

# LeetCode 38: Count and Say
#
# Problem:
# The count-and-say sequence is a sequence of digit strings defined by the recursive formula:
# countAndSay(1) = "1"
# countAndSay(n) = run-length encoding of countAndSay(n-1)
# Return the nth term.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Iteratively build the sequence from "1" up to n using run-length encoding.
#
#    Time Complexity: O(n * L) where L = average string length
#    Space Complexity: O(L)
#
# 2. Bottleneck
#    No known asymptotic improvement. This is inherently iterative/recursive.
#
# 3. Optimized Accepted Approach
#    Same approach, cleaner implementation. For each iteration:
#    scan the current string, group consecutive identical digits,
#    output count + digit for each group.
#
#    Time Complexity: O(n * L)
#    Space Complexity: O(L)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=4: start with "1"
# step 1→2: "1" = one 1 → "11"
# step 2→3: "11" = two 1s → "21"
# step 3→4: "21" = one 2, one 1 → "1211"
# Result: "1211"
#
# Edge Cases:
# - n=1  -> "1"
# - n=2  -> "11"

def count_and_say_brute(n)
  # Iterative approach using regex scan for runs
  result = '1'
  (n - 1).times do
    # Scan consecutive runs of the same character
    result = result.scan(/(.)\1*/).map { |group| "#{group[0].length}#{group[0][0]}" }.join
  end
  result
end

def count_and_say(n)
  result = '1'

  (n - 1).times do
    next_result = ''
    i = 0
    while i < result.length
      char = result[i]
      count = 0
      # Count consecutive occurrences of the same digit
      count += 1 while i + count < result.length && result[i + count] == char
      next_result += "#{count}#{char}"
      i += count
    end
    result = next_result
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{count_and_say_brute(4)}" # "1211"
  puts "Optimized:   #{count_and_say(4)}"       # "1211"
  puts "Brute force: #{count_and_say_brute(1)}" # "1"
  puts "Optimized:   #{count_and_say(1)}"       # "1"
end
