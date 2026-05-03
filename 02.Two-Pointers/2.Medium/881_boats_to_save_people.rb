# frozen_string_literal: true

# LeetCode 881: Boats to Save People
#
# Problem:
# Given an array people where people[i] is one person's weight and an integer
# limit, return the minimum number of boats needed to carry everyone.
# Each boat can carry at most two people, and their total weight must be
# less than or equal to limit.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Sort the people by weight.
#    Repeatedly take the heaviest remaining person and search for a partner who
#    can fit with them.
#    If a partner exists, remove that partner too. Count one boat either way.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Searching for a partner for every heaviest person repeats work.
#    Once sorted, the best partner to test against the heaviest person is the
#    lightest remaining person.
#
#    If the heaviest cannot fit with the lightest, they cannot fit with anyone.
#    If they can fit with the lightest, pairing them saves one boat.
#
# 3. Optimized Accepted Approach
#    Sort people.
#    Use two pointers:
#    - left points to the lightest remaining person
#    - right points to the heaviest remaining person
#
#    Always place the heaviest person on a boat.
#    If the lightest can fit with them, pair both and move left.
#    Move right in every iteration because the heaviest is handled.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(1) extra, depending on sorting implementation
#
# -----------------------------------------------------------------------------
# Dry Run
#
# people = [3, 2, 2, 1]
# limit = 3
# sorted = [1, 2, 2, 3]
#
# left = 0, right = 3
# 1 + 3 > 3, so 3 goes alone
# boats = 1, right = 2
#
# left = 0, right = 2
# 1 + 2 <= 3, pair them
# boats = 2, left = 1, right = 1
#
# left = 1, right = 1
# one person remains, send them alone
# boats = 3
#
# Final answer = 3
#
# Edge Cases:
# - one person -> one boat
# - two people fit together -> one boat
# - two people do not fit together -> two boats
# - everyone too heavy to pair -> one boat per person

def num_rescue_boats_true_brute_force(people, limit)
  remaining = people.sort
  boats = 0

  until remaining.empty?
    heaviest = remaining.pop
    partner_index = remaining.rindex { |weight| weight + heaviest <= limit }
    remaining.delete_at(partner_index) if partner_index
    boats += 1
  end

  boats
end

def num_rescue_boats(people, limit)
  people.sort!
  left = 0
  right = people.length - 1
  boats = 0

  while left <= right
    left += 1 if people[left] + people[right] <= limit
    right -= 1
    boats += 1
  end

  boats
end

if __FILE__ == $PROGRAM_NAME
  people = [3, 2, 2, 1]
  limit = 3

  puts "True brute force: #{num_rescue_boats_true_brute_force(people, limit)}"
  puts "Optimized:        #{num_rescue_boats(people, limit)}"
end
