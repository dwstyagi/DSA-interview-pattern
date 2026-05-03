# frozen_string_literal: true

# LeetCode 784: Letter Case Permutation
#
# Problem:
# Given a string s, transform every letter individually to be lowercase or
# uppercase to create another string. Return a list of all possible strings.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Iterate character by character, maintain a list of current strings,
#    branch when a letter is encountered.
#    Time Complexity: O(2^L * n) — L=letter count
#    Space Complexity: O(2^L * n)
#
# 2. Bottleneck
#    Same complexity — backtracking is cleaner and avoids building many strings.
#
# 3. Optimized Accepted Approach
#    Backtracking on character index. At each alpha character, branch into
#    lowercase and uppercase. Non-alpha characters: just move forward.
#    Time Complexity: O(2^L * n)
#    Space Complexity: O(L) recursion depth
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s="a1b2"
# idx=0, s[0]='a' alpha: branch 'a' (recurse idx=1) and 'A' (recurse idx=1)
# idx=1, s[1]='1' digit: recurse idx=2 for both branches
# idx=2, s[2]='b' alpha: branch 'b' and 'B' in each → 4 branches
# idx=3, s[3]='2' digit: advance → all 4 complete
# result=["a1b2","a1B2","A1b2","A1B2"] ✓
#
# Edge Cases:
# - All digits -> single string (no branching)
# - All letters -> 2^n strings

def letter_case_permutation_brute(s)
  result = [s.dup]
  s.length.times do |i|
    next unless s[i] =~ /[a-zA-Z]/
    result = result.flat_map { |str| [str.dup.tap { |x| x[i] = x[i].downcase }, str.dup.tap { |x| x[i] = x[i].upcase }] }
  end
  result.uniq
end

def letter_case_permutation(s)
  result = []
  chars  = s.chars

  backtrack = lambda do |idx|
    if idx == chars.length
      result << chars.join  # complete assignment
      return
    end

    if chars[idx] =~ /[a-zA-Z]/
      chars[idx] = chars[idx].downcase
      backtrack.call(idx + 1)   # choose lowercase
      chars[idx] = chars[idx].upcase
      backtrack.call(idx + 1)   # choose uppercase
      chars[idx] = chars[idx].downcase  # restore (optional, cleanliness)
    else
      backtrack.call(idx + 1)   # digit: no choice
    end
  end

  backtrack.call(0)
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{letter_case_permutation_brute('a1b2').sort.inspect}"  # ["A1B2","A1b2","a1B2","a1b2"]
  puts "Opt:   #{letter_case_permutation('a1b2').sort.inspect}"         # same
  puts "Brute: #{letter_case_permutation_brute('3z4').sort.inspect}"   # ["3Z4","3z4"]
  puts "Opt:   #{letter_case_permutation('3z4').sort.inspect}"          # same
end
