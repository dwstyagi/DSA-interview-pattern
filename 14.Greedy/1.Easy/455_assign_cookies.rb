# frozen_string_literal: true

# LeetCode 455: Assign Cookies
#
# Problem:
# Assign cookies to children. Child i has greed factor g[i]; cookie j has size s[j].
# Give cookie j to child i if s[j] >= g[i]. Maximize number of content children.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all permutations of cookie assignments and track maximum content children.
#    Time Complexity: O(n! * m!)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Permutations are unnecessary. Greedily give the smallest sufficient cookie
#    to the least greedy unserved child.
#
# 3. Optimized Accepted Approach
#    Sort both arrays. Use two pointers: try to satisfy child with current cookie;
#    if cookie >= greed, move both pointers; else move cookie pointer only.
#
#    Time Complexity: O(n log n + m log m)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# g = [1,2,3], s = [1,1]
# Sorted g=[1,2,3], s=[1,1]
# i=0,j=0: s[0]=1 >= g[0]=1 -> content=1, i=1,j=1
# i=1,j=1: s[1]=1 < g[1]=2 -> j=2 (out of range) -> done
# Result: 1
#
# Edge Cases:
# - No cookies: return 0
# - All cookies too small: return 0

def find_content_children_brute(g, s)
  g_sorted = g.sort
  s_sorted = s.sort
  count = 0
  s_idx = 0
  g_sorted.each do |greed|
    while s_idx < s_sorted.length && s_sorted[s_idx] < greed
      s_idx += 1
    end
    if s_idx < s_sorted.length
      count += 1
      s_idx += 1
    end
  end
  count
end

# optimized: two-pointer after sorting (same complexity, cleaner)
def find_content_children(g, s)
  g.sort!
  s.sort!
  child = 0
  cookie = 0
  while child < g.length && cookie < s.length
    child += 1 if s[cookie] >= g[child]
    cookie += 1
  end
  child
end

if __FILE__ == $PROGRAM_NAME
  puts find_content_children_brute([1, 2, 3], [1, 1])  # 1
  puts find_content_children([1, 2], [1, 2, 3])         # 2
end
