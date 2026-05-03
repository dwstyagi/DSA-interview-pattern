# frozen_string_literal: true

# LeetCode 135: Candy
#
# Problem:
# Give each child at least one candy. Children with higher rating than their
# neighbors must get more candies. Return minimum total candies.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Repeatedly scan and increment candy for any child with higher rating than
#    neighbor but not more candies, until stable.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Two passes: left-to-right to satisfy left neighbor constraint,
#    right-to-left to satisfy right neighbor constraint.
#
# 3. Optimized Accepted Approach
#    Pass 1 (L to R): if ratings[i] > ratings[i-1], candies[i] = candies[i-1]+1.
#    Pass 2 (R to L): if ratings[i] > ratings[i+1], candies[i] = max(candies[i], candies[i+1]+1).
#    Sum all candies.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# ratings = [1, 0, 2]
# L to R: candies = [1, 1, 2]
# R to L: i=1: ratings[1]=0 < ratings[2]=2 -> no change; i=0: ratings[0]=1 > ratings[1]=0 -> max(1,2)=2
# candies = [2, 1, 2], sum = 5
#
# Edge Cases:
# - All same ratings: n candies total
# - Strictly increasing: 1+2+...+n

def candy_brute(ratings)
  n = ratings.length
  candies = Array.new(n, 1)
  changed = true
  while changed
    changed = false
    (0...n).each do |i|
      if i > 0 && ratings[i] > ratings[i - 1] && candies[i] <= candies[i - 1]
        candies[i] = candies[i - 1] + 1
        changed = true
      end
      if i < n - 1 && ratings[i] > ratings[i + 1] && candies[i] <= candies[i + 1]
        candies[i] = candies[i + 1] + 1
        changed = true
      end
    end
  end
  candies.sum
end

# optimized: two-pass greedy
def candy(ratings)
  n = ratings.length
  candies = Array.new(n, 1)
  (1...n).each do |i|
    candies[i] = candies[i - 1] + 1 if ratings[i] > ratings[i - 1]
  end
  (n - 2).downto(0) do |i|
    candies[i] = [candies[i], candies[i + 1] + 1].max if ratings[i] > ratings[i + 1]
  end
  candies.sum
end

if __FILE__ == $PROGRAM_NAME
  puts candy_brute([1, 0, 2])      # 5
  puts candy([1, 2, 2])            # 4
end
