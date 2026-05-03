# frozen_string_literal: true

# LeetCode 995: Minimum Number of K Consecutive Bit Flips
#
# Problem:
# Given a binary array nums and an integer window_size, in one operation you
# may choose any contiguous subarray of length window_size and flip every bit
# in that window. Return the minimum number of flips needed to make the whole
# array equal to 1. If it is impossible, return -1.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Scan from left to right.
#    If the current bit is 0, flip the entire window starting at that index.
#    Count the flip and continue. If a needed flip would go out of bounds,
#    return -1.
#
#    Time Complexity: O(n * k)
#    Space Complexity: O(n) here because we duplicate the array
#
#    Why O(n * k)?
#    - at most O(n) starting positions
#    - each explicit flip touches k elements
#
# 2. Bottleneck
#    Every flip explicitly updates all k elements in its window.
#    That repeated work is wasteful.
#    At index i, we only need to know whether the total number of active flips
#    affecting i is even or odd. Even means the bit is unchanged; odd means it
#    is toggled.
#
# 3. Optimized Accepted Approach
#    Use a sliding-window style parity tracker.
#    Keep:
#    - flip_starts[i] = 1 if a flip begins at index i
#    - active_flips = number of flip windows currently affecting this index
#
#    For each index:
#    - expire a flip that started k positions ago
#    - compute the effective bit using:
#        nums[i] ^ (active_flips % 2)
#    - if the effective bit is 0, we must start a new flip here
#    - if that window does not fit, return -1
#
#    This greedy decision is forced:
#    once we move past index i, no future window can still change it.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [0, 0, 0, 1, 0, 1, 1, 0]
# window_size = 3
#
# index = 0
# active_flips = 0
# effective_bit = 0 ^ 0 = 0
# must flip here
# flip_starts[0] = 1, active_flips = 1, flips = 1
#
# index = 1
# effective_bit = 0 ^ 1 = 1
# no flip
#
# index = 2
# effective_bit = 0 ^ 1 = 1
# no flip
#
# index = 3
# flip starting at 0 expires, active_flips = 0
# effective_bit = 1 ^ 0 = 1
# no flip
#
# index = 4
# effective_bit = 0 ^ 0 = 0
# must flip here
# flip_starts[4] = 1, active_flips = 1, flips = 2
#
# index = 5
# effective_bit = 1 ^ 1 = 0
# must flip here
# flip_starts[5] = 1, active_flips = 2, flips = 3
#
# Remaining indices stay effectively 1 after expirations.
# Final answer = 3
#
# Edge Cases:
# - window_size = 1 -> flip each zero individually
# - if a required flip does not fit inside the array -> return -1
# - parity matters, not the exact number of active flips

def min_k_bit_flips_true_brute_force(nums, window_size)
  flips = 0
  bits = nums.dup
  (0...bits.length).each do |index|
    next if bits[index] == 1
    return -1 if index + window_size > bits.length

    flip_window(bits, index, window_size)
    flips += 1
  end
  flips
end

def flip_window(bits, index, window_size)
  (index...(index + window_size)).each { |i| bits[i] ^= 1 }
end

def min_k_bit_flips(nums, window_size)
  flip_starts = Array.new(nums.length, 0)
  active_flips = 0

  nums.each_with_index.reduce(0) do |flips, (bit, index)|
    active_flips -= flip_starts[index - window_size] if index >= window_size
    next flips if effective_bit(bit, active_flips).positive?
    return -1 if index + window_size > nums.length

    flip_starts[index] = 1
    active_flips += 1
    flips + 1
  end
end

def effective_bit(bit, active_flips)
  bit ^ (active_flips % 2)
end

if __FILE__ == $PROGRAM_NAME
  nums = [0, 0, 0, 1, 0, 1, 1, 0]
  window_size = 3

  puts "True brute force: #{min_k_bit_flips_true_brute_force(nums, window_size)}"
  puts "Optimized:        #{min_k_bit_flips(nums, window_size)}"
end
