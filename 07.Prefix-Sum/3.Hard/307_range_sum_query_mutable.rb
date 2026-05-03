# frozen_string_literal: true

# LeetCode 307: Range Sum Query - Mutable
#
# Problem:
# Implement NumArray that supports:
# - update(index, val): update nums[index] to val
# - sum_range(left, right): sum of elements between left and right (inclusive)
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Store array, update O(1), query O(n) by summing.
#    Time Complexity: O(1) update, O(n) query
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    O(n) query is slow for many queries.
#
# 3. Optimized Accepted Approach
#    Fenwick Tree (Binary Indexed Tree): O(log n) for both update and query.
#    BIT supports prefix sums; range query = prefix(r) - prefix(l-1).
#    Time Complexity: O(log n) per update and query
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 3, 5]
# sum_range(0, 2) = 9
# update(1, 2): nums becomes [1, 2, 5]
# sum_range(0, 2) = 8
#
# Edge Cases:
# - Single element array → update and query trivially
# - Range covering entire array → returns total sum

class NumArrayBrute
  def initialize(nums)
    @nums = nums.dup
  end

  def update(index, val)
    @nums[index] = val
  end

  def sum_range(left, right)
    @nums[left..right].sum
  end
end

class NumArrayMutable
  def initialize(nums)
    @n = nums.length
    @bit = Array.new(@n + 1, 0)   # 1-indexed BIT

    nums.each_with_index { |v, i| update(i, v) }
  end

  def update(index, val)
    # diff from stored value
    diff = val - point_query(index)
    i = index + 1   # BIT is 1-indexed
    while i <= @n
      @bit[i] += diff
      i += i & (-i)   # move to parent
    end
  end

  def sum_range(left, right)
    prefix(right + 1) - prefix(left)
  end

  private

  def point_query(index)
    prefix(index + 1) - prefix(index)
  end

  def prefix(i)
    total = 0
    while i > 0
      total += @bit[i]
      i -= i & (-i)   # move to next ancestor
    end
    total
  end
end

if __FILE__ == $PROGRAM_NAME
  brute = NumArrayBrute.new([1, 3, 5])
  puts "Brute: #{brute.sum_range(0, 2)}"  # 9
  brute.update(1, 2)
  puts "Brute: #{brute.sum_range(0, 2)}"  # 8

  opt = NumArrayMutable.new([1, 3, 5])
  puts "Opt:   #{opt.sum_range(0, 2)}"    # 9
  opt.update(1, 2)
  puts "Opt:   #{opt.sum_range(0, 2)}"    # 8
end
