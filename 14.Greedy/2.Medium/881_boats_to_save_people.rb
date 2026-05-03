# frozen_string_literal: true

# LeetCode 881: Boats to Save People
#
# Problem:
# people[i] is weight of person i. Each boat carries at most 2 people with
# combined weight <= limit. Return minimum boats needed.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all pairs. Greedy match heaviest with lightest if possible.
#    Time Complexity: O(n^2) with naive pairing
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Sort then two pointers: pair heaviest with lightest if possible.
#    If they fit, use one boat for both; otherwise heaviest goes alone.
#
# 3. Optimized Accepted Approach
#    Sort. Left pointer at lightest, right at heaviest. If sum <= limit, both board;
#    otherwise only heaviest boards. Always increment right (heaviest boards).
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# people=[3,2,2,1], limit=3
# sorted=[1,2,2,3]
# lo=0(1),hi=3(3): 1+3=4>3 -> boat for 3 alone, hi=2, boats=1
# lo=0(1),hi=2(2): 1+2=3<=3 -> boat for both, lo=1,hi=1, boats=2
# lo=1(2)>hi -> done, but lo==hi: one more boat for remaining, boats=3
# Wait: lo=1, hi=1: 1 person left -> boats=3
#
# Edge Cases:
# - Single person: 1 boat
# - All can pair: n/2 boats

def num_rescue_boats_brute(people, limit)
  people.sort!
  lo = 0
  hi = people.length - 1
  boats = 0
  while lo <= hi
    if people[lo] + people[hi] <= limit
      lo += 1
    end
    hi -= 1
    boats += 1
  end
  boats
end

# optimized: same two-pointer (already optimal)
def num_rescue_boats(people, limit)
  people.sort!
  lo = 0
  hi = people.length - 1
  boats = 0
  while lo <= hi
    lo += 1 if people[lo] + people[hi] <= limit
    hi -= 1
    boats += 1
  end
  boats
end

if __FILE__ == $PROGRAM_NAME
  puts num_rescue_boats_brute([3, 2, 2, 1], 3)  # 3
  puts num_rescue_boats([3, 5, 3, 4], 5)         # 4
end
