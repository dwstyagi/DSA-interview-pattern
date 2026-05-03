# frozen_string_literal: true

# LeetCode 506: Relative Ranks
#
# Problem:
# Given an integer array score of n athletes, find their relative ranks.
# The 1st place gets "Gold Medal", 2nd gets "Silver Medal", 3rd gets
# "Bronze Medal", and the rest get their rank number as a string.
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

def find_relative_ranks_brute(score)
  n = score.length
  result = Array.new(n)
  score.each_with_index do |s, i|
    rank = 1
    score.each { |other| rank += 1 if other > s }  # count how many beat s
    result[i] = case rank
                when 1 then "Gold Medal"
                when 2 then "Silver Medal"
                when 3 then "Bronze Medal"
                else rank.to_s
                end
  end
  result
end

def find_relative_ranks(score)
  # sort indices by descending score to get rank order
  sorted_indices = score.each_index.sort_by { |i| -score[i] }
  result = Array.new(score.length)

  sorted_indices.each_with_index do |original_idx, rank|
    result[original_idx] = case rank
                           when 0 then "Gold Medal"
                           when 1 then "Silver Medal"
                           when 2 then "Bronze Medal"
                           else (rank + 1).to_s
                           end
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{find_relative_ranks_brute([5, 4, 3, 2, 1]).inspect}"
  puts "Opt:   #{find_relative_ranks([5, 4, 3, 2, 1]).inspect}"
  puts "Brute: #{find_relative_ranks_brute([10, 3, 8, 9, 4]).inspect}"
  puts "Opt:   #{find_relative_ranks([10, 3, 8, 9, 4]).inspect}"
end
