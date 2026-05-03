# frozen_string_literal: true

# LeetCode 406: Queue Reconstruction by Height
#
# Problem:
# People are represented as [h, k] where h = height, k = number of people
# in front with height >= h. Reconstruct the queue from a shuffled version.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all permutations, validate each against the k constraints.
#    Time Complexity: O(n! * n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Greedy insight: sort tallest people first. For equal heights, sort by k.
#    Then insert each person at index k — taller people don't affect shorter ones.
#
# 3. Optimized Accepted Approach
#    Sort by height descending, then k ascending. Insert each at position k.
#    Taller people are placed first; inserting shorter people at k only
#    counts already-placed (taller) people, which is correct.
#
#    Time Complexity: O(n^2) due to array insertions
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# people = [[7,0],[4,4],[7,1],[5,0],[6,1],[5,2]]
# sorted: [[7,0],[7,1],[6,1],[5,0],[5,2],[4,4]]
# insert [7,0] at 0: [[7,0]]
# insert [7,1] at 1: [[7,0],[7,1]]
# insert [6,1] at 1: [[7,0],[6,1],[7,1]]
# insert [5,0] at 0: [[5,0],[7,0],[6,1],[7,1]]
# insert [5,2] at 2: [[5,0],[7,0],[5,2],[6,1],[7,1]]
# insert [4,4] at 4: [[5,0],[7,0],[5,2],[6,1],[4,4],[7,1]]
# Result: [[5,0],[7,0],[5,2],[6,1],[4,4],[7,1]]
#
# Edge Cases:
# - Single person: return as-is
# - All same height: sort by k, answer is sorted order

def reconstruct_queue_brute(people)
  sorted = people.sort_by { |h, k| [-h, k] }
  result = []
  sorted.each { |person| result.insert(person[1], person) }
  result
end

# optimized: same greedy (insertion is the bottleneck, unavoidable)
def reconstruct_queue(people)
  people.sort_by! { |h, k| [-h, k] }
  result = []
  people.each { |person| result.insert(person[1], person) }
  result
end

if __FILE__ == $PROGRAM_NAME
  people = [[7, 0], [4, 4], [7, 1], [5, 0], [6, 1], [5, 2]]
  puts reconstruct_queue_brute(people).inspect
  puts reconstruct_queue([[6, 0], [5, 0], [4, 0], [3, 2], [2, 2], [1, 4]]).inspect
end
