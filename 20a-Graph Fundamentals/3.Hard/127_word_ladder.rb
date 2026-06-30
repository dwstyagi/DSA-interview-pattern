# frozen_string_literal: true

# 127. Word Ladder
#
# 1. Problem Statement
#
# Return the length of the shortest sequence transforming begin_word into
# end_word, changing one letter at a time and using only words in word_list.
#
# 2. Brute Force Approach
#
# Intuition:
# Compare the current word against every dictionary word to find one-letter
# neighbors, then BFS for the shortest sequence.
#
# Algorithm:
# During each BFS expansion, scan the full word list and enqueue words differing
# by exactly one character.
#
# Time Complexity: O(n^2 * l), where l is word length.
# Space Complexity: O(n)

# 3. Brute Force Code
def ladder_length_brute(begin_word, end_word, word_list)
  return 0 unless word_list.include?(end_word)

  queue = [[begin_word, 1]]
  visited = { begin_word => true }
  head = 0
  while head < queue.length
    word, length = queue[head]
    head += 1
    return length if word == end_word

    word_list.each do |candidate|
      next if visited[candidate] || !one_letter_apart?(word, candidate)

      visited[candidate] = true
      queue << [candidate, length + 1]
    end
  end
  0
end

# 4. Bottleneck Analysis
#
# Every BFS node scans the whole dictionary to discover neighbors. Words sharing
# all but one letter can be grouped once, allowing direct lookup of candidates.
#
# 5. Optimization Journey
#
# Replace each character position with '*'. For example, hot has patterns
# *ot, h*t, and ho*. Any words in the same pattern bucket differ by one letter.
# Build buckets once, then BFS through the relevant buckets.
#
# 6. Dry Run
#
# begin = "hit", end = "cog":
# - "hit" uses pattern h*t to find "hot".
# - "hot" reaches "dot" and "lot".
# - BFS eventually reaches "cog" at length 5.
#
# 7. Optimal Solution
#
# Precompute wildcard buckets and BFS from begin_word. Clear a used bucket after
# scanning it so its neighbors are not repeatedly revisited.
#
# Time Complexity: O(n * l^2)
# Space Complexity: O(n * l)

# 8. Optimal Code
def ladder_length(begin_word, end_word, word_list)
  return 0 unless word_list.include?(end_word)

  buckets = Hash.new { |hash, key| hash[key] = [] }
  (word_list + [begin_word]).each do |word|
    word.length.times { |index| buckets[word[0...index] + '*' + word[(index + 1)..]] << word }
  end

  queue = [[begin_word, 1]]
  visited = { begin_word => true }
  head = 0
  while head < queue.length
    word, length = queue[head]
    head += 1
    return length if word == end_word

    word.length.times do |index|
      pattern = word[0...index] + '*' + word[(index + 1)..]
      buckets[pattern].each do |neighbor|
        next if visited[neighbor]

        visited[neighbor] = true
        queue << [neighbor, length + 1]
      end
      buckets[pattern] = []
    end
  end
  0
end

def one_letter_apart?(first, second)
  first.chars.zip(second.chars).count { |left, right| left != right } == 1
end

# Examples
if __FILE__ == $PROGRAM_NAME
  words = %w[hot dot dog lot log cog]
  p ladder_length_brute('hit', 'cog', words) # 5
  p ladder_length('hit', 'cog', words) # 5
end
