# frozen_string_literal: true

# LeetCode 506: Relative Ranks
#
# Problem:
# Given an integer array score of n athletes, find their relative ranks.
# The 1st place gets "Gold Medal", 2nd gets "Silver Medal", 3rd gets
# "Bronze Medal", and the rest get their rank number as a string.
#
# Examples:
#   Input:  score = [5,4,3,2,1]
#   Output: ["Gold Medal","Silver Medal","Bronze Medal","4","5"]
#   Why:    Sort by score descending; top 3 get medals, rest get rank numbers.
#
#   Input:  score = [10,3,8,9,4]
#   Output: ["Gold Medal","5","Bronze Medal","Silver Medal","4"]
#   Why:    10 is 1st (Gold), 9 is 2nd (Silver), 8 is 3rd (Bronze), others ranked 4,5.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each athlete, count how many others scored higher. That count + 1 is
#    their rank. Assign medals accordingly.
#    Time Complexity: O(n²)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Comparing each element against all others is O(n²) — redundant work.
#
# 3. Optimized Accepted Approach
#    Sort indices by score descending (max-heap simulation via sort).
#    Iterate sorted indices to assign ranks: index 0 → Gold, 1 → Silver,
#    2 → Bronze, rest → rank number string.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# score = [5, 4, 3, 2, 1]
# sorted indices by score desc: [0, 1, 2, 3, 4]
# idx 0 → score 5 → result[0] = "Gold Medal"
# idx 1 → score 4 → result[1] = "Silver Medal"
# idx 2 → score 3 → result[2] = "Bronze Medal"
# idx 3 → score 2 → result[3] = "4"
# idx 4 → score 1 → result[4] = "5"
# Output: ["Gold Medal", "Silver Medal", "Bronze Medal", "4", "5"]
#
# Edge Cases:
# - Single athlete → "Gold Medal"
# - All same score → (problem guarantees distinct scores)

# -----------------------------
# BRUTE FORCE
# -----------------------------
# For each athlete:
# - count how many athletes have a higher score
# - rank = higher_count + 1
# - convert rank into medal string or numeric string
#
# Time: O(n^2)
# Space: O(n)
def find_relative_ranks_true_brute_force(scores)
  # result[i] will store the final rank string for athlete i
  result = Array.new(scores.length)

  # Check every athlete one by one
  scores.each_with_index do |score, athlete_index|
    higher_scores = 0

    # Count how many scores are strictly greater than current score
    scores.each do |other_score|
      higher_scores += 1 if other_score > score
    end

    # If 0 scores are higher, rank is 1
    # If 1 score is higher, rank is 2
    # and so on...
    rank = higher_scores + 1

    # Convert rank into required output format
    result[athlete_index] =
      case rank
      when 1 then 'Gold Medal'
      when 2 then 'Silver Medal'
      when 3 then 'Bronze Medal'
      else rank.to_s
      end
  end

  result
end

# -----------------------------
# OPTIMIZED HEAP SOLUTION
# -----------------------------
# Idea:
# - Use a max heap so highest score comes out first
# - Store [score, original_index] in heap
# - Pop one by one and assign:
#   1 -> Gold Medal
#   2 -> Silver Medal
#   3 -> Bronze Medal
#   4+ -> numeric rank as string
# - Put answer back at original index
#
# Time: O(n log n)
# Space: O(n)
require 'algorithms'
def find_relative_ranks(scores)
  # Max heap will give highest score first
  max_heap = Containers::MaxHeap.new

  # result[i] stores answer for athlete at original index i
  result = Array.new(scores.length)

  # Push [score, original_index] into heap
  # So even after sorting by score, we can place answer back correctly
  scores.each_with_index do |score, athlete_index|
    max_heap.push([score, athlete_index])
  end

  current_rank = 1

  # Pop athletes in descending score order
  until max_heap.empty?
    _, athlete_index = max_heap.pop

    # Assign medal or rank string based on current rank
    result[athlete_index] =
      case current_rank
      when 1 then 'Gold Medal'
      when 2 then 'Silver Medal'
      when 3 then 'Bronze Medal'
      else current_rank.to_s
      end

    current_rank += 1
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{find_relative_ranks_brute([5, 4, 3, 2, 1]).inspect}"
  puts "Opt:   #{find_relative_ranks([5, 4, 3, 2, 1]).inspect}"
  puts "Brute: #{find_relative_ranks_brute([10, 3, 8, 9, 4]).inspect}"
  puts "Opt:   #{find_relative_ranks([10, 3, 8, 9, 4]).inspect}"
end
