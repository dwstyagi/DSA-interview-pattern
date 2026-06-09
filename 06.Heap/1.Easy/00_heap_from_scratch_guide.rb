# frozen_string_literal: true

# Heap Guide: Implement MinHeap and MaxHeap from scratch
#
# Ruby does not include a built-in heap / priority queue.
# Instead of using any gem, this file builds a heap with:
#
# - an Array
# - heapify_up after insert
# - heapify_down after remove
# - a comparator block for MinHeap vs MaxHeap
#
# This is the version to study when you want to understand the supporting
# functions behind heap problems instead of treating the heap like a black box.

# -----------------------------------------------------------------------------
# Mental Model
#
# A binary heap is a complete binary tree stored inside an array.
#
# For index i:
# - parent index      = (i - 1) / 2
# - left child index  = (2 * i) + 1
# - right child index = (2 * i) + 2
#
# MinHeap rule:
# - parent <= children
# - root is the smallest value
#
# MaxHeap rule:
# - parent >= children
# - root is the largest value
#
# Time complexity:
# - push: O(log n)
# - pop: O(log n)
# - peek: O(1)
# - size / empty?: O(1)
# -----------------------------------------------------------------------------

class BinaryHeap
  attr_reader :items

  def initialize(&priority)
    @items = []
    @priority = priority || ->(parent, child) { (parent <=> child) <= 0 }
  end

  def push(value)
    @items << value
    heapify_up(last_index)
    self
  end

  def pop
    return nil if empty?
    return @items.pop if size == 1

    root = @items[0]
    @items[0] = @items.pop
    heapify_down(0)
    root
  end

  def peek
    @items[0]
  end

  def size
    @items.length
  end

  def empty?
    @items.empty?
  end

  def clear
    @items.clear
    self
  end

  def include?(value)
    @items.include?(value)
  end

  def delete(value)
    index = @items.index(value)
    return nil if index.nil?

    removed = @items[index]
    replacement = @items.pop

    if index < size
      @items[index] = replacement
      fix_after_value_change(index)
    end

    removed
  end

  def replace(old_value, new_value)
    index = @items.index(old_value)
    return nil if index.nil?

    @items[index] = new_value
    fix_after_value_change(index)
    new_value
  end

  def merge!(other_heap)
    other_heap.items.each do |value|
      push(value)
    end

    self
  end

  private

  def last_index
    size - 1
  end

  def parent_index(index)
    (index - 1) / 2
  end

  def left_child_index(index)
    (2 * index) + 1
  end

  def right_child_index(index)
    (2 * index) + 2
  end

  def higher_priority?(parent, child)
    @priority.call(parent, child)
  end

  def heapify_up(index)
    while index.positive?
      parent = parent_index(index)
      break if higher_priority?(@items[parent], @items[index])

      swap(parent, index)
      index = parent
    end
  end

  def heapify_down(index)
    loop do
      left = left_child_index(index)
      right = right_child_index(index)
      best = index

      best = left if left < size && !higher_priority?(@items[best], @items[left])
      best = right if right < size && !higher_priority?(@items[best], @items[right])

      break if best == index

      swap(index, best)
      index = best
    end
  end

  def fix_after_value_change(index)
    parent = parent_index(index)

    if index.positive? && !higher_priority?(@items[parent], @items[index])
      heapify_up(index)
    else
      heapify_down(index)
    end
  end

  def swap(left, right)
    @items[left], @items[right] = @items[right], @items[left]
  end
end

class MinHeap < BinaryHeap
  def initialize
    super { |parent, child| (parent <=> child) <= 0 }
  end

  def min
    peek
  end
end

class MaxHeap < BinaryHeap
  def initialize
    super { |parent, child| (parent <=> child) >= 0 }
  end

  def max
    peek
  end
end

# -----------------------------------------------------------------------------
# 1. MinHeap Basics
# -----------------------------------------------------------------------------
def min_heap_demo(nums)
  heap = MinHeap.new

  nums.each do |num|
    heap.push(num)
  end

  sorted = []
  sorted << heap.pop until heap.empty?

  sorted
end

# Example:
# min_heap_demo([5, 1, 9, 2]) -> [1, 2, 5, 9]

# -----------------------------------------------------------------------------
# 2. MaxHeap Basics
# -----------------------------------------------------------------------------
def max_heap_demo(nums)
  heap = MaxHeap.new

  nums.each do |num|
    heap.push(num)
  end

  sorted_desc = []
  sorted_desc << heap.pop until heap.empty?

  sorted_desc
end

# Example:
# max_heap_demo([5, 1, 9, 2]) -> [9, 5, 2, 1]

# -----------------------------------------------------------------------------
# 3. Supporting Functions
# -----------------------------------------------------------------------------
def heap_supporting_functions_demo
  min_heap = MinHeap.new

  min_heap.push(30)
  min_heap.push(10)
  min_heap.push(20)

  {
    raw_array_shape: min_heap.items.dup,       # heap order, not sorted order
    size_after_push: min_heap.size,            # 3
    empty_after_push: min_heap.empty?,         # false
    peek_with_peek: min_heap.peek,             # 10, does not remove
    peek_with_min: min_heap.min,               # 10, MinHeap-specific alias
    removed_with_pop: min_heap.pop,            # 10, removes root
    size_after_pop: min_heap.size,             # 2
    includes_20: min_heap.include?(20),        # true
    replaced_20_with_5: min_heap.replace(20, 5),
    peek_after_replace: min_heap.peek,         # 5
    deleted_5: min_heap.delete(5),             # removes 5
    size_after_delete: min_heap.size,          # 1
    cleared_heap: min_heap.clear.items,        # []
    empty_after_clear: min_heap.empty?         # true
  }
end

# Method cheat sheet:
#
#   heap.push(value)              -> insert value
#   heap.pop                      -> remove and return root
#   heap.peek                     -> read root without removing
#   heap.size                     -> number of items
#   heap.empty?                   -> true / false
#   heap.clear                    -> remove every item
#   heap.include?(value)          -> check whether value exists
#   heap.delete(value)            -> delete first matching value
#   heap.replace(old, new)        -> change first matching old value to new
#   heap.merge!(other_heap)       -> push all items from another heap
#
# MinHeap:
#
#   heap.min                      -> same as peek
#
# MaxHeap:
#
#   heap.max                      -> same as peek

# -----------------------------------------------------------------------------
# 4. Top K Largest: MinHeap of Size K
# -----------------------------------------------------------------------------
def top_k_largest(nums, k)
  min_heap = MinHeap.new

  nums.each do |num|
    min_heap.push(num)
    min_heap.pop if min_heap.size > k
  end

  result = []
  result << min_heap.pop until min_heap.empty?
  result.reverse
end

# Why a MinHeap for largest values?
# - Keep only k values.
# - If more than k values are present, pop the smallest.
# - The heap keeps the best k values seen so far.

def kth_largest(nums, k)
  min_heap = MinHeap.new

  nums.each do |num|
    min_heap.push(num)
    min_heap.pop if min_heap.size > k
  end

  min_heap.peek
end

# -----------------------------------------------------------------------------
# 5. Top K Smallest: MaxHeap of Size K
# -----------------------------------------------------------------------------
def top_k_smallest(nums, k)
  max_heap = MaxHeap.new

  nums.each do |num|
    max_heap.push(num)
    max_heap.pop if max_heap.size > k
  end

  result = []
  result << max_heap.pop until max_heap.empty?
  result.reverse
end

# Why a MaxHeap for smallest values?
# - Keep only k values.
# - If more than k values are present, pop the largest.
# - The heap keeps the smallest k values seen so far.

# -----------------------------------------------------------------------------
# 6. Store More Data With Arrays
# -----------------------------------------------------------------------------
def rank_scores_with_max_heap(scores)
  max_heap = MaxHeap.new

  scores.each_with_index do |score, index|
    max_heap.push([score, index])
  end

  ranked_indices = []

  until max_heap.empty?
    score, index = max_heap.pop
    ranked_indices << { score: score, original_index: index }
  end

  ranked_indices
end

# Arrays compare lexicographically in Ruby:
# [90, 2] > [80, 5]
# [90, 2] > [90, 1]
#
# This is handy for storing:
# - [score, index]
# - [frequency, value]
# - [distance, x, y]

# -----------------------------------------------------------------------------
# 7. Merge Two Heaps
# -----------------------------------------------------------------------------
def merge_min_heaps(left_nums, right_nums)
  left_heap = MinHeap.new
  right_heap = MinHeap.new

  left_nums.each { |num| left_heap.push(num) }
  right_nums.each { |num| right_heap.push(num) }

  left_heap.merge!(right_heap)

  merged = []
  merged << left_heap.pop until left_heap.empty?
  merged
end

# -----------------------------------------------------------------------------
# 8. Quick Choice Cheat Sheet
# -----------------------------------------------------------------------------
#
# Need largest item repeatedly?
#   Use MaxHeap.
#
# Need smallest item repeatedly?
#   Use MinHeap.
#
# Need kth largest?
#   Use MinHeap of size k. Answer is heap.peek.
#
# Need kth smallest?
#   Use MaxHeap of size k. Answer is heap.peek.
#
# Need top k frequent?
#   Count first with tally, then heap by [count, value].
#
# Need closest k points?
#   Use distance squared: x*x + y*y.
#   For k closest, keep MaxHeap of size k so farthest among kept values gets
#   removed when the heap grows too large.

if __FILE__ == $PROGRAM_NAME
  nums = [5, 1, 9, 2, 7]

  puts "MinHeap sorted:      #{min_heap_demo(nums).inspect}"
  puts "MaxHeap sorted desc: #{max_heap_demo(nums).inspect}"
  puts "Top 3 largest:      #{top_k_largest(nums, 3).inspect}"
  puts "3rd largest:        #{kth_largest(nums, 3).inspect}"
  puts "Top 3 smallest:     #{top_k_smallest(nums, 3).inspect}"
  puts "Support methods:    #{heap_supporting_functions_demo.inspect}"
  puts "Ranked scores:      #{rank_scores_with_max_heap([50, 90, 70]).inspect}"
  puts "Merged heaps:       #{merge_min_heaps([4, 1], [3, 2]).inspect}"
end
