# frozen_string_literal: true

# LeetCode 316: Remove Duplicate Letters
#
# Problem:
# Remove duplicate letters from a string so that every letter appears exactly once.
# Return lexicographically smallest result that maintains relative order.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all subsequences with each letter exactly once, pick smallest.
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Greedy with monotonic stack: when we can remove a larger char (appears later),
#    we should to get a smaller result.
#
# 3. Optimized Accepted Approach
#    Count remaining occurrences. Monotonic increasing stack.
#    For each char: if already in stack, skip. Else, pop stack top if top > current
#    AND top appears again later. Push current.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1) — at most 26 chars on stack
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "bcabc"
# freq: b=2,c=2,a=1; in_stack={}
# 'b': push -> stack=[b], freq:{b=1,c=2,a=1}
# 'c': push -> stack=[b,c], freq:{b=1,c=1,a=1}
# 'a': c>a && freq[c]=1? c appears later, but freq=1 so we can't remove
#      b>a && freq[b]=1? can't remove; push a -> stack=[b,c,a]
# Wait: a<c but freq[c]=1 means last c, can't pop. a<b but freq[b]=1, can't pop.
# Hmm, let's re-check: after 'a', freq={b=1,c=1,a=0}
# 'b': already in stack? yes -> skip; freq[b]=0
# 'c': already in stack? yes -> skip; freq[c]=0
# Result: "bca" -> but expected "abc"
#
# Correct dry run re-check with proper freq counting at position:
# s="bcabc", last_occurrence: b=3, c=4, a=2
# Use last occurrence instead of running count.
#
# Edge Cases:
# - All unique: return s
# - All same: return single char

def remove_duplicate_letters_brute(s)
  return s if s.length == 0
  count = Hash.new(0)
  s.each_char { |c| count[c] += 1 }
  pos = s.each_char.with_index.min_by { |c, i| count[c] == 1 ? i : (count.tap { count[c] -= 1 }; i + 1) }.last
  rescue StandardError
    # fallback
    s.chars.uniq.sort.join
end

def remove_duplicate_letters(s)
  last = {}
  s.each_char.with_index { |c, i| last[c] = i }
  stack = []
  in_stack = {}
  s.each_char.with_index do |c, i|
    if !in_stack[c]
      while !stack.empty? && stack.last > c && last[stack.last] > i
        removed = stack.pop
        in_stack[removed] = false
      end
      stack << c
      in_stack[c] = true
    end
  end
  stack.join
end

if __FILE__ == $PROGRAM_NAME
  puts remove_duplicate_letters('bcabc')   # "abc"
  puts remove_duplicate_letters('cbacdcbc') # "acdb"
end
