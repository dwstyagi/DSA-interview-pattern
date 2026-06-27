# frozen_string_literal: true

# 997. Find the Town Judge
#
# 1. Problem Statement
#
# In a town of n people, the judge trusts nobody and is trusted by everyone
# else. Return the judge's label, or -1 when no judge exists.
#
# 2. Brute Force Approach
#
# Intuition:
# Check each person as a possible judge. They qualify only when they never
# appear as a truster and every other person appears as trusting them.
#
# Algorithm:
# For each candidate, scan all trust pairs to count incoming and outgoing
# relationships.
#
# Time Complexity: O(n * t), where t is trust.length.
# Space Complexity: O(1)

# 3. Brute Force Code
def find_judge_brute(n, trust)
  (1..n).each do |candidate|
    incoming = 0
    outgoing = false

    trust.each do |from, to|
      outgoing = true if from == candidate
      incoming += 1 if to == candidate
    end

    return candidate if !outgoing && incoming == n - 1
  end

  -1
end

# 4. Bottleneck Analysis
#
# Each candidate causes another full scan of the same trust list. The only
# facts that matter are how many people trust someone and whether they trust
# anyone, so those facts should be accumulated once.
#
# 5. Optimization Journey
#
# Use one score per person:
# - Giving trust subtracts 1.
# - Receiving trust adds 1.
#
# A judge receives n - 1 trusts and gives none, so their score is exactly
# n - 1. Everyone else fails that condition.
#
# 6. Dry Run
#
# n = 3, trust = [[1, 3], [2, 3]]
# - score[1] becomes -1.
# - score[3] becomes 1.
# - score[2] becomes -1.
# - score[3] becomes 2, which equals n - 1.
#
# 7. Optimal Solution
#
# Calculate trust scores in one pass, then return the person whose score is
# n - 1.
#
# Time Complexity: O(n + t)
# Space Complexity: O(n)

# 8. Optimal Code
def find_judge(n, trust)
  score = Array.new(n + 1, 0)

  trust.each do |from, to|
    score[from] -= 1
    score[to] += 1
  end

  (1..n).each { |person| return person if score[person] == n - 1 }
  -1
end

# Examples
if __FILE__ == $PROGRAM_NAME
  trust = [[1, 3], [2, 3]]
  p find_judge_brute(3, trust) # 3
  p find_judge(3, trust) # 3
end
