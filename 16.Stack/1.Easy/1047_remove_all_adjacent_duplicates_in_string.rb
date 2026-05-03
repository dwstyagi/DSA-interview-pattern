# frozen_string_literal: true

# LeetCode 1047: Remove All Adjacent Duplicates in String
#
# Problem:
# Remove all adjacent duplicate pairs from a string repeatedly until no more exist.
# Return the final string.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Repeatedly scan and remove adjacent duplicates until string stops changing.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Scanning repeatedly is wasteful. Stack approach handles it in one pass.
#
# 3. Optimized Accepted Approach
#    Use a stack. For each char: if stack top equals char, pop (remove pair).
#    Otherwise push. Result is stack joined.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "abbaca"
# 'a': stack=[a]
# 'b': stack=[a,b]
# 'b': top='b'==cur -> pop -> stack=[a]
# 'a': top='a'==cur -> pop -> stack=[]
# 'c': stack=[c]
# 'a': stack=[c,a]
# Result: "ca"
#
# Edge Cases:
# - No adjacent duplicates: return s unchanged
# - All same chars (even count): return ""

def remove_duplicates_brute(s)
  str = s.dup
  prev = nil
  while str != prev
    prev = str
    str = str.gsub(/(.)\1/, '')
  end
  str
end

def remove_duplicates(s)
  stack = []
  s.each_char do |c|
    if stack.last == c
      stack.pop
    else
      stack << c
    end
  end
  stack.join
end

if __FILE__ == $PROGRAM_NAME
  puts remove_duplicates_brute('abbaca')  # "ca"
  puts remove_duplicates('azxxzy')        # "ay"
end
