# frozen_string_literal: true

# LeetCode 786: K-th Smallest Prime Fraction
#
# Problem:
# Given a sorted array arr of prime numbers (and 1), return the k-th smallest
# fraction among all fractions arr[i]/arr[j] where i < j.
# Return the result as [arr[i], arr[j]].
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all pairs, sort by fraction value, return k-th.
#    Time Complexity: O(n^2 log n)
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    Storing n^2 fractions — real-valued binary search on the fraction value.
#
# 3. Optimized Accepted Approach
#    Real-valued binary search fraction f in [0.0, 1.0].
#    Feasibility: count pairs where arr[i]/arr[j] <= f using two pointers.
#    When count >= k, record the largest fraction <= f found during counting.
#    Time Complexity: O(n log(1/epsilon)) ~ O(100n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# arr=[1,2,3,5], k=3
# All fractions: 1/2=0.5, 1/3=0.33, 1/5=0.2, 2/3=0.67, 2/5=0.4, 3/5=0.6
# Sorted: 0.2(1/5), 0.33(1/3), 0.4(2/5), 0.5(1/2), 0.6(3/5), 0.67(2/3)
# k=3 → answer = 2/5 = [2,5] ✓
#
# Edge Cases:
# - k=1 -> smallest fraction = 1/arr.last
# - k=n*(n-1)/2 -> largest fraction

def kth_smallest_prime_fraction_brute(arr, k)
  fractions = []
  n = arr.length
  (0...n).each do |i|
    ((i + 1)...n).each do |j|
      fractions << [arr[i].to_f / arr[j], arr[i], arr[j]]
    end
  end
  fractions.sort_by(&:first)[k - 1][1..2]
end

def kth_smallest_prime_fraction(arr, k)
  n    = arr.length
  lo   = 0.0
  hi   = 1.0
  p_num, p_den = 0, 1

  100.times do
    mid   = (lo + hi) / 2.0
    count = 0
    p_num, p_den = 0, 1
    j = 1

    (0...n).each do |i|
      j += 1 while j < n && arr[i].to_f / arr[j] > mid
      break if j >= n
      count += n - j
      # track the largest fraction <= mid
      if arr[i].to_f / arr[j] > p_num.to_f / p_den
        p_num = arr[i]
        p_den = arr[j]
      end
    end

    if count >= k
      hi = mid
    else
      lo = mid
    end
  end

  [p_num, p_den]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{kth_smallest_prime_fraction_brute([1, 2, 3, 5], 3).inspect}"  # [2, 5]
  puts "Opt:   #{kth_smallest_prime_fraction([1, 2, 3, 5], 3).inspect}"         # [2, 5]
  puts "Brute: #{kth_smallest_prime_fraction_brute([1, 7], 1).inspect}"          # [1, 7]
  puts "Opt:   #{kth_smallest_prime_fraction([1, 7], 1).inspect}"                # [1, 7]
end
