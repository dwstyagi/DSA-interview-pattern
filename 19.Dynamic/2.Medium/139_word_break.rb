# frozen_string_literal: true

# LeetCode 139: Word Break
#
# Problem:
# Given string s and word dictionary, return true if s can be segmented into
# space-separated dictionary words.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursion: at each position try all words as prefix, recurse on remainder.
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Overlapping subproblems. DP: dp[i] = can we segment s[0..i-1].
#
# 3. Optimized Accepted Approach
#    dp[0]=true. For each i, try all j < i: if dp[j] and s[j..i-1] in dict, dp[i]=true.
#
#    Time Complexity: O(n^2 * m) where m = avg word length
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s="leetcode", wordDict=["leet","code"]
# dp[0]=true
# i=4: j=0, s[0..3]="leet" in dict, dp[0]=true -> dp[4]=true
# i=8: j=4, s[4..7]="code" in dict, dp[4]=true -> dp[8]=true
# Result: true
#
# Edge Cases:
# - Single char word: dp builds char by char
# - s in dict directly: dp[n]=true at first pass

def word_break_brute?(s, word_dict)
  dict = word_dict.to_set
  memo = {}
  rec = lambda do |start|
    return true if start == s.length
    return memo[start] if memo.key?(start)
    (start...s.length).each do |fin|
      return memo[start] = true if dict.include?(s[start..fin]) && rec.call(fin + 1)
    end
    memo[start] = false
  end
  rec.call(0)
end

def word_break?(s, word_dict)
  dict = word_dict.to_set
  n = s.length
  dp = Array.new(n + 1, false)
  dp[0] = true
  (1..n).each do |i|
    (0...i).each do |j|
      if dp[j] && dict.include?(s[j...i])
        dp[i] = true
        break
      end
    end
  end
  dp[n]
end

if __FILE__ == $PROGRAM_NAME
  puts word_break_brute?('leetcode', %w[leet code])          # true
  puts word_break?('catsandog', %w[cats dog sand and cat])   # false
end
