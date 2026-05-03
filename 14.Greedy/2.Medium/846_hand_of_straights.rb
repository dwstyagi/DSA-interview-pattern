# frozen_string_literal: true

# LeetCode 846: Hand of Straights
#
# Problem:
# Given an array hand of cards and groupSize, return true if the hand can be
# arranged into groups of groupSize consecutive cards.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Sort, then repeatedly find and remove the smallest available consecutive group.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Scanning for groups is O(n) per group. Use a hash for O(1) lookups.
#    Start each group from the smallest remaining card.
#
# 3. Optimized Accepted Approach
#    Count frequencies. Sort unique cards. For each smallest card with count > 0,
#    try to form a group of groupSize starting at that card.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# hand=[1,2,3,6,2,3,4,7,8], groupSize=3
# freq: {1:1,2:2,3:2,4:1,6:1,7:1,8:1}, sorted keys=[1,2,3,4,6,7,8]
# key=1: form [1,2,3] -> freq: {1:0,2:1,3:1,4:1,...}
# key=2: form [2,3,4] -> freq: {2:0,3:0,4:0,...}
# key=6: form [6,7,8] -> all done -> true
#
# Edge Cases:
# - hand.length % groupSize != 0: return false
# - groupSize = 1: always true

def is_n_straight_hand_brute?(hand, group_size)
  return false if hand.length % group_size != 0
  sorted = hand.sort
  freq = Hash.new(0)
  sorted.each { |c| freq[c] += 1 }
  sorted.uniq.each do |card|
    next if freq[card] == 0
    count = freq[card]
    count.times do
      group_size.times do |i|
        return false if freq[card + i] == 0
        freq[card + i] -= 1
      end
    end
  end
  true
end

# optimized: sorted keys with frequency map
def is_n_straight_hand?(hand, group_size)
  return false if hand.length % group_size != 0
  freq = Hash.new(0)
  hand.each { |c| freq[c] += 1 }
  keys = freq.keys.sort
  keys.each do |card|
    next if freq[card] == 0
    count = freq[card]
    group_size.times do |i|
      return false if freq[card + i] < count
      freq[card + i] -= count
    end
  end
  true
end

if __FILE__ == $PROGRAM_NAME
  puts is_n_straight_hand_brute?([1, 2, 3, 6, 2, 3, 4, 7, 8], 3)  # true
  puts is_n_straight_hand?([1, 2, 3, 4, 5], 4)                     # false
end
