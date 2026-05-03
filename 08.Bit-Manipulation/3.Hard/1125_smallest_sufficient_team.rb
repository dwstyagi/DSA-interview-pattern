# frozen_string_literal: true

# LeetCode 1125: Smallest Sufficient Team
#
# Problem:
# Given required_skills and people (each person has a subset of skills),
# return the indices of a smallest team that covers all required skills.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all subsets of people, check if they cover all skills.
#    Time Complexity: O(2^n * m) where n = people count, m = skills count
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Exponential in number of people.
#
# 3. Optimized Accepted Approach
#    Bitmask DP on skill states. dp[mask] = smallest team achieving mask.
#    Encode each person's skills as a bitmask. For each person, update all
#    achievable states to see if adding them creates a smaller team.
#    Time Complexity: O(2^m * n) where m = number of skills
#    Space Complexity: O(2^m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# req=["java","nodejs","reactjs"], people=[["java"],["nodejs"],["nodejs","reactjs"]]
# Skills: java=0, nodejs=1, reactjs=2; target=0b111=7
# person 0: mask=001 (java)
# person 1: mask=010 (nodejs)
# person 2: mask=110 (nodejs+reactjs)
# dp[111] = dp[001] + person2 = [0,2] (size 2) vs dp[010]+person2=[1,2]
# Smallest = [0, 2] or [1, 2]
#
# Edge Cases:
# - Single person covers all skills → team of 1
# - Each person covers one unique skill → team = all people

def smallest_sufficient_team(req_skills, people)
  skill_index = req_skills.each_with_index.to_h   # skill → bit position
  m = req_skills.length
  total = (1 << m) - 1   # all skills covered bitmask

  # dp[mask] = list of people indices that achieves this skill mask with minimum size
  dp = Array.new(1 << m, nil)
  dp[0] = []

  people.each_with_index do |skills, pi|
    skill_mask = skills.reduce(0) do |mask, s|
      mask | (1 << skill_index[s])
    end

    (0...dp.length).each do |cur_mask|
      next if dp[cur_mask].nil?   # unreachable state

      new_mask = cur_mask | skill_mask
      # update if this path is smaller
      if dp[new_mask].nil? || dp[new_mask].length > dp[cur_mask].length + 1
        dp[new_mask] = dp[cur_mask] + [pi]
      end
    end
  end

  dp[total]
end

def smallest_sufficient_team_brute(req_skills, people)
  skill_set = req_skills.to_set
  n = people.length
  best = nil

  (0...(1 << n)).each do |mask|
    team = (0...n).select { |i| (mask >> i) & 1 == 1 }
    covered = team.flat_map { |i| people[i] }.to_set
    if covered.superset?(skill_set) && (best.nil? || team.size < best.size)
      best = team
    end
  end

  best
end

if __FILE__ == $PROGRAM_NAME
  require 'set'
  puts "Brute: #{smallest_sufficient_team_brute(["java", "nodejs", "reactjs"],
    [["java"], ["nodejs"], ["nodejs", "reactjs"]]).inspect}"
  puts "Opt:   #{smallest_sufficient_team(["java", "nodejs", "reactjs"],
    [["java"], ["nodejs"], ["nodejs", "reactjs"]]).inspect}"
end
