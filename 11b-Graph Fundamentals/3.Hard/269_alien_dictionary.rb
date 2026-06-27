# frozen_string_literal: true

# 269. Alien Dictionary
#
# 1. Problem Statement
#
# Given words sorted according to an unknown alphabet, return one valid order of
# the letters. Return an empty string if no valid order exists.
#
# 2. Brute Force Approach
#
# Intuition:
# Try every possible ordering of the unique letters and keep one that makes the
# given word list sorted.
#
# Algorithm:
# Generate permutations of the characters and compare adjacent words using each
# candidate order.
#
# Time Complexity: O(C! * W * L), where C is unique letters.
# Space Complexity: O(C)

# 3. Brute Force Code
def alien_order_brute(words)
  letters = words.join.chars.uniq
  letters.permutation do |order|
    rank = {}
    order.each_with_index { |char, index| rank[char] = index }
    return order.join if sorted_by_rank?(words, rank)
  end
  ''
end

# 4. Bottleneck Analysis
#
# Trying all alphabets ignores the direct information in the sorted list. The
# first differing character between adjacent words gives one required ordering
# edge, and those edges are enough to build a graph.
#
# 5. Optimization Journey
#
# Compare each adjacent pair:
# - If word1 = "abc" and word2 = "abd", then c must come before d.
# - Once the first difference is found, later letters say nothing about order.
# - If a longer word appears before its own prefix, the input is invalid.
#
# Then topologically sort the letter graph.
#
# 6. Dry Run
#
# words = ["wrt","wrf","er","ett","rftt"]:
# - t -> f from wrt/wrf.
# - w -> e from wrf/er.
# - r -> t from er/ett.
# - e -> r from ett/rftt.
# - Topological order is "wertf".
#
# 7. Optimal Solution
#
# Build precedence edges from adjacent words and run Kahn's algorithm. If the
# sorted output does not include every letter, a cycle exists.
#
# Time Complexity: O(total characters + edges)
# Space Complexity: O(C + edges)

# 8. Optimal Code
def alien_order(words)
  graph = Hash.new { |hash, key| hash[key] = [] }
  indegree = {}
  words.join.each_char { |char| indegree[char] = 0 }

  words.each_cons(2) do |first, second|
    return '' if first.length > second.length && first.start_with?(second)

    limit = [first.length, second.length].min
    limit.times do |index|
      next if first[index] == second[index]

      unless graph[first[index]].include?(second[index])
        graph[first[index]] << second[index]
        indegree[second[index]] += 1
      end
      break
    end
  end

  queue = indegree.keys.select { |char| indegree[char].zero? }
  order = []
  head = 0

  while head < queue.length
    char = queue[head]
    head += 1
    order << char

    graph[char].each do |neighbor|
      indegree[neighbor] -= 1
      queue << neighbor if indegree[neighbor].zero?
    end
  end

  order.length == indegree.length ? order.join : ''
end

def sorted_by_rank?(words, rank)
  words.each_cons(2).all? do |first, second|
    compare_words(first, second, rank) <= 0
  end
end

def compare_words(first, second, rank)
  [first.length, second.length].min.times do |index|
    next if first[index] == second[index]

    return rank[first[index]] <=> rank[second[index]]
  end
  first.length <=> second.length
end

# Examples
if __FILE__ == $PROGRAM_NAME
  words = %w[wrt wrf er ett rftt]
  p alien_order_brute(words) # "wertf"
  p alien_order(words) # "wertf"
end
