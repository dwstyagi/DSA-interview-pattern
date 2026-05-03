# frozen_string_literal: true

# LeetCode 352: Data Stream as Disjoint Intervals
#
# Problem:
# Given a data stream of integers, return the summary of it as a list of disjoint intervals.
# Implement SummaryRanges: addNum(val) and getIntervals() methods.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Store all added numbers in a set. getIntervals: sort all numbers, group consecutive.
#
#    Time Complexity: addNum O(1), getIntervals O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Re-sorting on every getIntervals call if intervals are queried frequently.
#
# 3. Optimized Accepted Approach
#    Maintain a sorted list of disjoint intervals. On addNum, binary search for insertion
#    point, then merge with neighbors if they become adjacent or overlapping.
#
#    Time Complexity: addNum O(n) (insertion shift), getIntervals O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# add(1) → [[1,1]]
# add(3) → [[1,1],[3,3]]
# add(7) → [[1,1],[3,3],[7,7]]
# add(2) → merge [1,1],[3,3] via 2 → [[1,3],[7,7]]
# add(6) → merge [3,3] and [7,7] via 6 → [[1,3],[6,7]]
#
# Edge Cases:
# - Adding same number twice -> no change
# - Values at boundaries -> proper merge

class SummaryRangesBrute # rubocop:disable Style/Documentation
  def initialize
    @nums = []
  end

  def add_num(val)
    @nums << val unless @nums.include?(val)
  end

  def get_intervals
    return [] if @nums.empty?

    sorted = @nums.sort
    result = []
    start = sorted[0]
    prev  = sorted[0]

    sorted[1..].each do |n|
      if n == prev + 1
        prev = n
      else
        result << [start, prev]
        start = n
        prev  = n
      end
    end
    result << [start, prev]
    result
  end
end

class SummaryRanges # rubocop:disable Style/Documentation
  def initialize
    @intervals = [] # sorted disjoint intervals
  end

  def add_num(val)
    new_interval = [val, val]
    merged = []
    inserted = false

    @intervals.each do |iv|
      if iv[1] + 1 < new_interval[0]
        # Current interval ends before new interval starts
        merged << iv
      elsif new_interval[1] + 1 < iv[0]
        # New interval ends before current starts; insert new first
        merged << new_interval unless inserted
        inserted = true
        merged << iv
      else
        # Overlapping or adjacent: merge into new_interval
        new_interval[0] = [new_interval[0], iv[0]].min
        new_interval[1] = [new_interval[1], iv[1]].max
      end
    end

    merged << new_interval unless inserted
    @intervals = merged
  end

  def get_intervals
    @intervals
  end
end

if __FILE__ == $PROGRAM_NAME
  sr = SummaryRangesBrute.new
  sr.add_num(1); sr.add_num(3); sr.add_num(7); sr.add_num(2); sr.add_num(6)
  puts "Brute: #{sr.get_intervals.inspect}"

  sr2 = SummaryRanges.new
  sr2.add_num(1); sr2.add_num(3); sr2.add_num(7); sr2.add_num(2); sr2.add_num(6)
  puts "Opt:   #{sr2.get_intervals.inspect}"
  # Both: [[1,3],[6,7]]
end
