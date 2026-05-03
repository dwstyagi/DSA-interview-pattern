# frozen_string_literal: true

# LeetCode 860: Lemonade Change
#
# Problem:
# Each customer pays $5, $10, or $20 for a $5 lemonade. Give correct change.
# Return true if you can give every customer correct change, false otherwise.
# You start with no change.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate with a map of all bill counts. For $20, try both change combos.
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Already O(n). The key greedy insight: for a $20 bill, prefer to give
#    $10+$5 change rather than $5+$5+$5 to preserve $5 bills for future use.
#
# 3. Optimized Accepted Approach
#    Track count of $5 and $10 bills. Greedily use $10 before $5 when making
#    change for $20.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# bills = [5, 5, 5, 10, 20]
# $5:  five=1
# $5:  five=2
# $5:  five=3
# $10: five=2, ten=1
# $20: ten=1, five=1 -> use $10+$5 -> ten=0, five=1 -> ok
# Result: true
#
# Edge Cases:
# - First bill is $10 or $20: impossible to make change -> false

def lemonade_change_brute(bills)
  counts = Hash.new(0)
  bills.each do |bill|
    counts[bill] += 1
    change = bill - 5
    next if change == 0
    if change == 15
      if counts[10] > 0
        counts[10] -= 1; change -= 10
      end
      needed = change / 5
      return false if counts[5] < needed
      counts[5] -= needed
    elsif change == 5
      return false if counts[5] == 0
      counts[5] -= 1
    end
  end
  true
end

# optimized: track only fives and tens
def lemonade_change(bills)
  five = 0
  ten = 0
  bills.each do |bill|
    case bill
    when 5
      five += 1
    when 10
      return false if five == 0
      five -= 1
      ten += 1
    when 20
      if ten > 0 && five > 0
        ten -= 1; five -= 1
      elsif five >= 3
        five -= 3
      else
        return false
      end
    end
  end
  true
end

if __FILE__ == $PROGRAM_NAME
  puts lemonade_change_brute([5, 5, 5, 10, 20])  # true
  puts lemonade_change([5, 5, 10, 10, 20])        # false
end
