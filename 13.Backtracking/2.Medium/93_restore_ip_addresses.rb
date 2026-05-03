# frozen_string_literal: true

# LeetCode 93: Restore IP Addresses
#
# Problem:
# Given a string s containing only digits, return all valid IP addresses that
# can be formed by inserting dots into s. A valid IP has 4 parts, each 0-255,
# and no leading zeros (except "0" itself).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all ways to place 3 dots, check validity of all 4 parts.
#    Time Complexity: O(3^4) = O(81) — at most 3 chars per segment
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Already fast — backtracking is clean and prunes naturally.
#
# 3. Optimized Accepted Approach
#    Backtracking: try 1, 2, or 3 character segments. Validate each (0-255,
#    no leading zeros). After 4 segments, check if all chars consumed.
#    Time Complexity: O(1) — bounded input (max length 12)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s="25525511135"
# try "2": try "5": try "5": try "25511135"→too long for one segment
#   try "255": "25511135"→too long; try "2552": invalid(>255)
# try "255": try "2": try "5": try "51135"→invalid
#   try "255": try "11": try "135" → "255.255.11.135" ✓
# result includes "255.255.11.135" ✓
#
# Edge Cases:
# - s.length < 4 or > 12 -> []
# - "0000" -> ["0.0.0.0"]

def restore_ip_addresses_brute(s)
  result = []
  (1..3).each do |a|
    (1..3).each do |b|
      (1..3).each do |c|
        d = s.length - a - b - c
        next if d < 1 || d > 3
        parts = [s[0,a], s[a,b], s[a+b,c], s[a+b+c,d]]
        next unless parts.all? { |p| p.to_i <= 255 && p == p.to_i.to_s }
        result << parts.join('.')
      end
    end
  end
  result
end

def restore_ip_addresses(s)
  result = []

  valid = lambda do |seg|
    return false if seg.empty? || seg.length > 3
    return false if seg.length > 1 && seg[0] == '0'  # no leading zeros
    seg.to_i <= 255
  end

  backtrack = lambda do |start, parts|
    if parts.length == 4
      result << parts.join('.') if start == s.length   # used all chars
      return
    end

    remaining_parts = 4 - parts.length
    remaining_chars = s.length - start
    return if remaining_chars < remaining_parts || remaining_chars > remaining_parts * 3

    (1..3).each do |len|
      seg = s[start, len]
      break if start + len > s.length
      next unless valid.call(seg)
      parts << seg
      backtrack.call(start + len, parts)
      parts.pop
    end
  end

  backtrack.call(0, [])
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{restore_ip_addresses_brute('25525511135').sort.inspect}"
  puts "Opt:   #{restore_ip_addresses('25525511135').sort.inspect}"
  # ["255.255.11.135", "255.255.111.35"]
end
