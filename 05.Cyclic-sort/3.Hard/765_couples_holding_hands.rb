# frozen_string_literal: true

# LeetCode 765: Couples Holding Hands
#
# Problem:
# N couples sit in 2N seats arranged in a row. We want all couples to sit side by side.
# In one swap, you can swap the positions of any two people.
# Return the minimum number of swaps so that every couple is sitting side by side.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each even seat, if the person next to them is not their partner,
#    find the partner and swap.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear scan to find the partner each time is O(n). Use a position map for O(1) lookup.
#
# 3. Optimized Accepted Approach
#    Maintain a position map: person → seat index.
#    For each even seat i, if row[i+1] is not the partner of row[i],
#    find where the partner is and swap. Count swaps.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n) for position map
#
# -----------------------------------------------------------------------------
# Dry Run
#
# row = [0,2,1,3]
# Seat 0: row[0]=0, partner=1, row[1]=2≠1 → find 1 at pos 2, swap row[1] and row[2]
#   row=[0,1,2,3], swaps=1
# Seat 2: row[2]=2, partner=3, row[3]=3 → already a pair, no swap
# Total swaps = 1
#
# Edge Cases:
# - Already seated correctly -> 0
# - N=1 couple               -> 0 (trivially)

def min_swaps_couples_brute(row)
  swaps = 0
  n = row.length

  i = 0
  while i < n
    # Partner of person x is: if x is even, x+1; if x is odd, x-1
    partner = row[i] ^ 1

    unless row[i + 1] == partner
      # Find the partner's position (linear scan)
      j = i + 2
      j += 1 while j < n && row[j] != partner
      row[i + 1], row[j] = row[j], row[i + 1]
      swaps += 1
    end

    i += 2
  end

  swaps
end

def min_swaps_couples(row)
  n = row.length
  # Build a position map: person → current seat index
  pos = {}
  row.each_with_index { |person, i| pos[person] = i }

  swaps = 0
  i = 0
  while i < n
    partner = row[i] ^ 1 # XOR with 1 flips between pairs (0↔1, 2↔3, ...)

    unless row[i + 1] == partner
      # Find partner's current position and swap
      j = pos[partner]
      # Swap the seat neighbors
      pos[row[i + 1]] = j
      row[i + 1], row[j] = row[j], row[i + 1]
      pos[partner] = i + 1
      swaps += 1
    end

    i += 2
  end

  swaps
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{min_swaps_couples_brute([0, 2, 1, 3])}" # 1
  puts "Optimized:   #{min_swaps_couples([0, 2, 1, 3])}"       # 1
  puts "Brute force: #{min_swaps_couples_brute([3, 2, 0, 1])}" # 0
  puts "Optimized:   #{min_swaps_couples([3, 2, 0, 1])}"       # 0
end
