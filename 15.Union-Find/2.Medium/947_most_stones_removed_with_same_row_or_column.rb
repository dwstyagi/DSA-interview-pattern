# frozen_string_literal: true

# LeetCode 947: Most Stones Removed with Same Row or Column
#
# Problem:
# Stones at grid positions. Remove a stone if another stone shares its row or column.
# Return maximum number of stones that can be removed.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate removal greedily: find removable stones repeatedly.
#    Time Complexity: O(n^3)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Key insight: connected component analysis. All stones sharing a row or column
#    form a connected component. We can remove all but one per component.
#
# 3. Optimized Accepted Approach
#    Union-Find: union stones sharing a row or column. Answer = n - components.
#    Optimize by unioning row index with col index (offset cols by 10001).
#
#    Time Complexity: O(n * alpha(n))
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# stones=[[0,0],[0,1],[1,0],[1,2],[2,1],[2,2]]
# Share row 0: (0,0)-(0,1) -> union
# Share col 0: (0,0)-(1,0) -> union
# ...all become one component
# n=6, components=1 -> remove 5
#
# Edge Cases:
# - Single stone: 0 removals
# - No shared rows/cols: 0 removals

def remove_stones_brute(stones)
  n = stones.length
  parent = Array.new(n) { |i| i }
  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }

  n.times do |i|
    n.times do |j|
      next if i == j
      if stones[i][0] == stones[j][0] || stones[i][1] == stones[j][1]
        pi, pj = find.call(i), find.call(j)
        parent[pi] = pj unless pi == pj
      end
    end
  end

  unique_roots = (0...n).map { |i| find.call(i) }.uniq.length
  n - unique_roots
end

# optimized: union row with offset col so shared row/col chains are captured
def remove_stones(stones)
  parent = {}
  find = lambda do |x|
    parent[x] = x unless parent.key?(x)
    parent[x] = find.call(parent[x]) unless parent[x] == x
    parent[x]
  end

  stones.each do |r, c|
    pr, pc = find.call(r), find.call(c + 10_001)
    parent[pr] = pc unless pr == pc
  end

  roots = stones.map { |r, _| find.call(r) }.uniq.length
  stones.length - roots
end

if __FILE__ == $PROGRAM_NAME
  puts remove_stones_brute([[0, 0], [0, 1], [1, 0], [1, 2], [2, 1], [2, 2]])  # 5
  puts remove_stones([[0, 0], [0, 2], [1, 1], [2, 0], [2, 2]])                # 3
end
