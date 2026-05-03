# frozen_string_literal: true

# LeetCode 269: Alien Dictionary
#
# Problem:
# Given sorted list of alien words, determine the order of letters in the alien alphabet.
# Return any valid order, or "" if impossible (cycle or invalid input).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Compare adjacent words to extract ordering constraints. Topological sort.
#    Time Complexity: O(C) where C = total characters
#    Space Complexity: O(U + min(U^2, N)) U=unique chars, N=word count
#
# 2. Bottleneck
#    Must detect cycles. Kahn's topological sort with cycle detection.
#
# 3. Optimized Accepted Approach
#    Build directed graph from adjacent word comparisons (first differing char).
#    Topological sort (Kahn's BFS). If not all chars processed, cycle exists.
#
#    Time Complexity: O(C)
#    Space Complexity: O(U + E) U=unique letters
#
# -----------------------------------------------------------------------------
# Dry Run
#
# words=["wrt","wrf","er","ett","rftt"]
# Compare wrt/wrf: t<f -> t->f
# Compare wrf/er: w<e -> w->e
# Compare er/ett: r<t -> r->t
# Compare ett/rftt: e<r -> e->r
# Topo: t->f, w->e->r->t -> "wertf" (one valid order)
#
# Edge Cases:
# - Invalid: word1 is prefix of word2 but word1 appears after word2 -> return ""
# - All words length 1: no ordering constraints

def alien_order_brute(words)
  # build adjacency list
  adj = {}
  in_degree = {}
  words.each { |w| w.each_char { |c| adj[c] ||= []; in_degree[c] ||= 0 } }

  (words.length - 1).times do |i|
    w1 = words[i]
    w2 = words[i + 1]
    min_len = [w1.length, w2.length].min
    found = false
    min_len.times do |j|
      if w1[j] != w2[j]
        adj[w1[j]] << w2[j]
        in_degree[w2[j]] += 1
        found = true
        break
      end
    end
    return '' if !found && w1.length > w2.length  # invalid
  end

  queue = in_degree.select { |_, d| d == 0 }.keys
  result = []
  until queue.empty?
    c = queue.shift
    result << c
    adj[c].each do |nb|
      in_degree[nb] -= 1
      queue << nb if in_degree[nb] == 0
    end
  end

  result.length == in_degree.length ? result.join : ''
end

# optimized: same Kahn's approach (already optimal)
def alien_order(words)
  alien_order_brute(words)
end

if __FILE__ == $PROGRAM_NAME
  puts alien_order_brute(%w[wrt wrf er ett rftt])  # "wertf" or similar valid
  puts alien_order(%w[z x])                         # "zx"
  puts alien_order(%w[z x z])                       # "" (cycle)
end
