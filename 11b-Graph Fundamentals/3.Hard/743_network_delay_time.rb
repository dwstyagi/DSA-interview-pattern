# frozen_string_literal: true

# 743. Network Delay Time
#
# 1. Problem Statement
#
# Given directed weighted edges times[i] = [u, v, w], return how long it takes
# for a signal sent from k to reach all n nodes. Return -1 if any node cannot
# be reached.
#
# 2. Brute Force Approach
#
# Intuition:
# Keep relaxing every edge, because a better time to one node may improve the
# time to another node.
#
# Algorithm:
# Use Bellman-Ford style relaxation for n - 1 rounds.
#
# Time Complexity: O(V * E)
# Space Complexity: O(V)

# 3. Brute Force Code
def network_delay_time_brute(times, n, k)
  distance = Array.new(n + 1, Float::INFINITY)
  distance[k] = 0

  (n - 1).times do
    changed = false
    times.each do |from, to, weight|
      next if distance[from].infinite?

      candidate = distance[from] + weight
      next unless candidate < distance[to]

      distance[to] = candidate
      changed = true
    end
    break unless changed
  end

  answer = distance[1..].max
  answer.infinite? ? -1 : answer
end

# 4. Bottleneck Analysis
#
# Bellman-Ford repeatedly scans every edge, even when only a small part of the
# graph has a newly improved distance. Since all weights are positive, the next
# closest unprocessed node is always safe to finalize.
#
# 5. Optimization Journey
#
# Dijkstra's algorithm keeps a priority queue ordered by current best time.
# Whenever the smallest time is popped, no later route can improve it because
# every remaining edge weight is positive. That avoids full edge rescans.
#
# 6. Dry Run
#
# times = [[2,1,1],[2,3,1],[3,4,1]], k = 2:
# - Start with node 2 at time 0.
# - Relax 1 to time 1 and 3 to time 1.
# - Pop 3, relax 4 to time 2.
# - Maximum finalized time is 2.
#
# 7. Optimal Solution
#
# Build an adjacency list and run Dijkstra from k. The answer is the maximum
# shortest distance among nodes 1 through n.
#
# Time Complexity: O((V + E) log V)
# Space Complexity: O(V + E)

# 8. Optimal Code
def network_delay_time(times, n, k)
  graph = Array.new(n + 1) { [] }
  times.each { |from, to, weight| graph[from] << [to, weight] }

  distance = Array.new(n + 1, Float::INFINITY)
  distance[k] = 0
  heap = MinHeap.new
  heap.push([0, k])

  until heap.empty?
    current_time, node = heap.pop
    next if current_time > distance[node]

    graph[node].each do |neighbor, weight|
      candidate = current_time + weight
      next unless candidate < distance[neighbor]

      distance[neighbor] = candidate
      heap.push([candidate, neighbor])
    end
  end

  answer = distance[1..].max
  answer.infinite? ? -1 : answer
end

class MinHeap
  def initialize
    @data = []
  end

  def push(value)
    @data << value
    sift_up(@data.length - 1)
  end

  def pop
    swap(0, @data.length - 1)
    minimum = @data.pop
    sift_down(0)
    minimum
  end

  def empty?
    @data.empty?
  end

  private

  def sift_up(index)
    while index.positive?
      parent = (index - 1) / 2
      break if @data[parent][0] <= @data[index][0]

      swap(parent, index)
      index = parent
    end
  end

  def sift_down(index)
    loop do
      left = (index * 2) + 1
      right = left + 1
      smallest = index
      smallest = left if left < @data.length && @data[left][0] < @data[smallest][0]
      smallest = right if right < @data.length && @data[right][0] < @data[smallest][0]
      break if smallest == index

      swap(index, smallest)
      index = smallest
    end
  end

  def swap(first, second)
    @data[first], @data[second] = @data[second], @data[first]
  end
end

# Examples
if __FILE__ == $PROGRAM_NAME
  times = [[2, 1, 1], [2, 3, 1], [3, 4, 1]]
  p network_delay_time_brute(times, 4, 2) # 2
  p network_delay_time(times, 4, 2) # 2
end
