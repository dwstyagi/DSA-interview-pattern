# frozen_string_literal: true

# LeetCode 278: First Bad Version
#
# Problem:
# You are a product manager and currently leading a team to develop a product.
# The versions are labeled 1..n. is_bad_version(version) API tells whether
# a version is bad. Find the first bad version.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Linear scan from 1 to n; first bad version encountered is the answer.
#    Time Complexity: O(n) API calls
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(n) API calls.
#
# 3. Optimized Accepted Approach
#    Lower-bound binary search: first index where is_bad_version is true.
#    The space is monotone: false...false...true...true.
#    Time Complexity: O(log n) API calls
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=5, bad=4 (versions 1,2,3 good, 4,5 bad)
# l=1,r=5: mid=3, not bad → l=4
# l=4,r=5: mid=4, bad → r=4
# l=r=4 → return 4 ✓
#
# Edge Cases:
# - Version 1 is bad → return 1
# - All versions good except last → return n

# Mock API for testing
BAD_VERSION = 4
def is_bad_version(v)
  v >= BAD_VERSION
end

def first_bad_version_brute(n)
  (1..n).find { |v| is_bad_version(v) }
end

def first_bad_version(n)
  l = 1
  r = n

  while l < r
    mid = (l + r) / 2
    if is_bad_version(mid)
      r = mid       # mid could be the first bad; don't exclude it
    else
      l = mid + 1   # mid is good, first bad is to the right
    end
  end

  l
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{first_bad_version_brute(5)}"  # 4
  puts "Opt:   #{first_bad_version(5)}"        # 4
  puts "Brute: #{first_bad_version_brute(1)}"  # depends on BAD_VERSION
  puts "Opt:   #{first_bad_version(1)}"
end
