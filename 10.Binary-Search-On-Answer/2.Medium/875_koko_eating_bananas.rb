# frozen_string_literal: true

#
# 1. Problem Statement
# --------------------
#
# Koko loves eating bananas. There are n piles of bananas where
# piles[i] represents the number of bananas in the ith pile.
#
# Koko has h hours to finish eating all the bananas.
#
# She chooses an integer eating speed k (bananas/hour). Every hour,
# she chooses one pile and eats at most k bananas from that pile.
# If the pile contains fewer than k bananas, she finishes the pile
# and waits until the next hour before starting another pile.
#
# Return the minimum integer eating speed k such that Koko can finish
# all the bananas within h hours.
#
# Example:
#
# Input:
# piles = [3,6,7,11]
# h = 8
#
# Output:
# 4
#

# ============================================================
# 2. Brute Force Approach
# ============================================================

#
# Intuition
# ---------
#
# We do not know the minimum eating speed.
#
# The slowest possible speed is 1 banana/hour.
# The fastest possible speed is the size of the largest pile because
# eating faster than the largest pile provides no additional benefit.
#
# Therefore, we simply try every possible speed.
#
# For every speed:
#
# 1. Calculate how many hours Koko would need.
# 2. If she can finish within h hours, that speed is our answer.
#
# How do we calculate the required hours?
#
# Suppose:
#
# pile = 7
# speed = 3
#
# Hour 1 -> Eat 3 bananas
# Hour 2 -> Eat 3 bananas
# Hour 3 -> Eat 1 banana
#
# Total = 3 hours
#
# Mathematically,
#
# hours = ceil(pile / speed)
#
# Since Ruby performs integer division for integers,
# we convert the pile to float before calling ceil.
#
# Algorithm
# ---------
#
# 1. Find the maximum pile.
# 2. Try every speed from 1 to max_pile.
# 3. Compute total hours required.
# 4. Return the first speed whose required hours <= h.
#
# Time Complexity
# ---------------
#
# Let
#
# n = number of piles
# m = maximum pile size
#
# Trying every speed:
# O(m)
#
# Computing hours:
# O(n)
#
# Overall:
#
# O(n × m)
#
# Space Complexity
# ----------------
#
# O(1)
#

# ============================================================
# 3. Brute Force Code
# ============================================================

def brute_force_hours_needed(piles, speed)
  hours = 0

  piles.each do |pile|
    hours += (pile.to_f / speed).ceil
  end

  hours
end

def brute_force_min_eating_speed(piles, h)
  max_pile = piles.max

  (1..max_pile).each do |speed|
    return speed if brute_force_hours_needed(piles, speed) <= h
  end

  -1
end

# ============================================================
# 4. Bottleneck Analysis
# ============================================================

#
# The brute force solution checks every possible eating speed.
#
# Suppose:
#
# largest pile = 1,000,000,000
#
# Then we may test
#
# 1
# 2
# 3
# ...
# 1,000,000,000
#
# For every speed we again iterate through every pile.
#
# Even though most speeds are obviously too slow or unnecessarily fast,
# we still compute the required hours for each one.
#
# The repeated work is:
#
# - Testing every possible speed.
# - Recalculating total hours for speeds that can be skipped.
#
# This leads to
#
# O(n × maxPile)
#
# which is far too slow.
#
# Can we search the answer more intelligently?
#

# ============================================================
# 5. Optimization Journey
# ============================================================

#
# Observation 1
# -------------
#
# Suppose speed = 4 works.
#
# Then every speed larger than 4 will also work because
# Koko is eating faster.
#
# Example
#
# Speed 4 -> Finish in 8 hours ✅
# Speed 5 -> Finish in 7 hours ✅
# Speed 6 -> Finish in 6 hours ✅
#
# ------------------------------------------------------------
#
# Observation 2
#
# Suppose speed = 3 does NOT work.
#
# Then every smaller speed also fails.
#
# Example
#
# Speed 3 -> 10 hours ❌
# Speed 2 -> 14 hours ❌
# Speed 1 -> 27 hours ❌
#
# ------------------------------------------------------------
#
# This creates a monotonic search space.
#
# Speed:
#
# 1 2 3 4 5 6 7 8 ...
#
# Possible?
#
# F F F T T T T T
#
# There is exactly one transition:
#
# False -------> True
#
# Whenever we have a monotonic search space,
# Binary Search becomes applicable.
#
# ------------------------------------------------------------
#
# Binary Search Range
#
# Minimum speed = 1
#
# Maximum speed = largest pile
#
# Instead of checking every speed,
# Binary Search repeatedly cuts the search space in half.
#
# For each middle speed:
#
# 1. Compute required hours.
#
# 2. If hours <= h
#
#    Current speed works.
#
#    Save it as a possible answer and try to find
#    an even smaller valid speed.
#
# 3. Otherwise
#
#    Current speed is too slow.
#
#    Search the larger speeds.
#
# Eventually Binary Search finds the smallest
# speed that satisfies the condition.
#

# ============================================================
# 6. Dry Run
# ============================================================

#
# Example
#
# piles = [3,6,7,11]
# h = 8
#
# Search Space
#
# left = 1
# right = 11
#
# -------------------------------------
#
# mid = 6
#
# Hours
#
# 3  -> 1
# 6  -> 1
# 7  -> 2
# 11 -> 2
#
# Total = 6
#
# 6 <= 8
#
# Answer = 6
#
# Search left half
#
# right = 5
#
# -------------------------------------
#
# left = 1
# right = 5
#
# mid = 3
#
# Hours
#
# 3  -> 1
# 6  -> 2
# 7  -> 3
# 11 -> 4
#
# Total = 10
#
# Too many hours
#
# Need a larger speed.
#
# left = 4
#
# -------------------------------------
#
# left = 4
# right = 5
#
# mid = 4
#
# Hours
#
# 3  -> 1
# 6  -> 2
# 7  -> 2
# 11 -> 3
#
# Total = 8
#
# Valid
#
# Answer = 4
#
# Search left
#
# right = 3
#
# Now
#
# left > right
#
# Return answer = 4
#

# ============================================================
# 7. Optimal Solution
# ============================================================

#
# Algorithm
#
# 1. Set
#
# left = 1
# right = largest pile
#
# 2. While left <= right
#
# Find middle speed.
#
# Compute required hours.
#
# If hours <= h
#
# Current speed works.
#
# Store answer.
#
# Search smaller speeds.
#
# Else
#
# Search larger speeds.
#
# 3. Return stored answer.
#
# Time Complexity
# ---------------
#
# Each Binary Search iteration scans every pile.
#
# Binary Search performs
#
# log(maxPile)
#
# iterations.
#
# Overall:
#
# O(n log(maxPile))
#
# Space Complexity
# ----------------
#
# O(1)
#

# ============================================================
# 8. Optimal Code
# ============================================================

def hours_needed(piles, speed)
  hours = 0

  piles.each do |pile|
    # Number of hours required for this pile
    # hours += (pile + speed - 1) / speed
    hours += (pile.to_f / speed).ceil
  end

  hours
end

def min_eating_speed(piles, h)
  left = 1
  right = piles.max
  answer = right

  while left <= right
    mid = left + ((right - left) / 2)

    if hours_needed(piles, mid) <= h
      answer = mid      # Valid speed
      right = mid - 1   # Try to find a smaller one
    else
      left = mid + 1    # Speed is too slow
    end
  end

  answer
end

# ============================================================
# Example Calls
# ============================================================

puts 'Brute Force Examples'
puts brute_force_min_eating_speed([3, 6, 7, 11], 8)
puts brute_force_min_eating_speed([30, 11, 23, 4, 20], 5)
puts brute_force_min_eating_speed([30, 11, 23, 4, 20], 6)

puts

puts 'Optimal Examples'
puts min_eating_speed([3, 6, 7, 11], 8)
puts min_eating_speed([30, 11, 23, 4, 20], 5)
puts min_eating_speed([30, 11, 23, 4, 20], 6)
