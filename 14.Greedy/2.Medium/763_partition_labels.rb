# frozen_string_literal: true

# LeetCode 763: Partition Labels
#
# Problem:
# Partition string s into as many parts as possible so that each letter
# appears in at most one part. Return the sizes of these parts.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each possible partition point, check that no character spans the boundary.
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Record the last occurrence of each character first. Then greedy: extend
#    current partition to the last occurrence of every character seen so far.
#
# 3. Optimized Accepted Approach
#    Single pass to record last[c] for each char. Second pass: track end of
#    current partition as max last occurrence. When i == end, partition done.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1) — at most 26 chars
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "ababcbacadefegdehijhklij"
# last: a=8, b=5, c=7, d=14, e=15, f=11, g=13, h=19, i=22, j=23, k=20, l=21
# i=0(a): end=8; i=1(b): end=8; ... i=8(a): i==end -> part size=9, start=9
# i=9(d): end=14; ... i=15(e): end=15; i==end -> part size=7, start=16
# i=16(i): end=22; ... i=23(j): end=23; i==end -> part size=8
# Result: [9,7,8]
#
# Edge Cases:
# - Single char repeated: one partition of size n
# - All unique chars: n partitions of size 1

def partition_labels_brute(s)
  last = {}
  s.chars.each_with_index { |c, i| last[c] = i }
  result = []
  start = 0
  end_idx = 0
  s.chars.each_with_index do |c, i|
    end_idx = [end_idx, last[c]].max
    if i == end_idx
      result << (end_idx - start + 1)
      start = i + 1
    end
  end
  result
end

# optimized: same approach, alias for clarity
def partition_labels(s)
  last = {}
  s.chars.each_with_index { |c, i| last[c] = i }
  result = []
  start = 0
  finish = 0
  s.chars.each_with_index do |c, i|
    finish = [finish, last[c]].max
    if i == finish
      result << (finish - start + 1)
      start = i + 1
    end
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  puts partition_labels_brute('ababcbacadefegdehijhklij').inspect  # [9,7,8]
  puts partition_labels('eccbbbbdec').inspect                       # [10]
end
