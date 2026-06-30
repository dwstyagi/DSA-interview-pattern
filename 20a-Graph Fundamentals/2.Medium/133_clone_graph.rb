# frozen_string_literal: true

# 133. Clone Graph
#
# 1. Problem Statement
#
# Return a deep copy of a connected undirected graph. Each node has a value and
# a list of neighboring nodes.

class Node
  attr_accessor :val, :neighbors

  def initialize(val = 0, neighbors = [])
    @val = val
    @neighbors = neighbors
  end
end

# 2. Brute Force Approach
#
# Intuition:
# Copy a node, then recursively copy all of its neighbors.
#
# Algorithm:
# 1. Collect every original node with BFS.
# 2. Build a parallel array of copies.
# 3. For each original neighbor, linearly search the original array to find
#    the matching copy.
#
# Time Complexity: O(V^2 + E * V) because each neighbor lookup is linear.
# Space Complexity: O(V)

# 3. Brute Force Code
def clone_graph_brute(node)
  return nil if node.nil?

  originals = [node]
  visited = { node => true }
  head = 0

  while head < originals.length
    current = originals[head]
    head += 1
    current.neighbors.each do |neighbor|
      next if visited[neighbor]

      visited[neighbor] = true
      originals << neighbor
    end
  end

  copies = originals.map { |original| Node.new(original.val) }
  originals.each_with_index do |original, index|
    copies[index].neighbors = original.neighbors.map do |neighbor|
      copies[originals.index(neighbor)]
    end
  end

  copies[0]
end

# 4. Bottleneck Analysis
#
# The brute-force solution repeatedly linearly searches for each neighbor's
# matching copy. In a dense graph this repeats a lot of work. A hash map gives
# constant-time lookup and also fits naturally into DFS.
#
# 5. Optimization Journey
#
# Store a mapping from each original node object to its clone.
# - If a node is already mapped, immediately return its existing clone.
# - Otherwise create and store the clone before recursively cloning neighbors.
#
# Storing first is crucial: a back edge can then reuse the partially built
# clone safely.
#
# 6. Dry Run
#
# For 1 -- 2:
# - Clone 1 and memo[1] = copy_1.
# - Clone 2 and memo[2] = copy_2.
# - From 2, neighbor 1 is already memoized, so attach copy_1.
# - Attach copy_2 to copy_1.
#
# 7. Optimal Solution
#
# DFS through the graph with an original-to-clone hash map.
#
# Time Complexity: O(V + E)
# Space Complexity: O(V)

# 8. Optimal Code
def clone_graph(node)
  clones = {}

  copy = lambda do |current|
    next nil if current.nil?
    next clones[current] if clones[current]

    clones[current] = Node.new(current.val)
    clones[current].neighbors = current.neighbors.map { |neighbor| copy.call(neighbor) }
    clones[current]
  end

  copy.call(node)
end

def graph_values(node)
  return [] if node.nil?

  values = []
  visited = { node => true }
  queue = [node]
  head = 0

  while head < queue.length
    current = queue[head]
    head += 1
    values << current.val
    current.neighbors.each do |neighbor|
      next if visited[neighbor]

      visited[neighbor] = true
      queue << neighbor
    end
  end

  values.sort
end

# Examples
if __FILE__ == $PROGRAM_NAME
  one = Node.new(1)
  two = Node.new(2)
  one.neighbors = [two]
  two.neighbors = [one]

  p graph_values(clone_graph_brute(one)) # [1, 2]
  clone = clone_graph(one)
  p graph_values(clone) # [1, 2]
  p !clone.equal?(one) # true
end
