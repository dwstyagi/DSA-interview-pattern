# frozen_string_literal: true

# LeetCode 1268: Search Suggestions System
#
# Problem:
# Given products array and searchWord, after each character typed, return up to
# 3 lexicographically smallest products that have searchWord[0..i] as prefix.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each prefix, filter products and sort, take first 3.
#    Time Complexity: O(n * m * log n) per character, O(n * m^2 * log n) total
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Sorting repeatedly. Sort once, then use binary search or trie.
#
# 3. Optimized Accepted Approach
#    Sort products. For each prefix, use binary search to find the range of
#    matching products, take first 3.
#
#    Time Complexity: O(n log n + m * log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# products=["mobile","mouse","moneypot","monitor","mousepad"], searchWord="mouse"
# sorted: ["mobile","moneypot","monitor","mouse","mousepad"]
# prefix "m": all 5 -> first 3: ["mobile","moneypot","monitor"]
# prefix "mo": ["mobile","moneypot","monitor","mouse","mousepad"] -> same 3
# prefix "mou": ["mouse","mousepad"] -> ["mouse","mousepad"]
# prefix "mous": ["mouse","mousepad"]
# prefix "mouse": ["mouse","mousepad"]
#
# Edge Cases:
# - No matching products: empty list for that prefix
# - Less than 3 matches: return all

def suggested_products_brute(products, search_word)
  products.sort!
  result = []
  search_word.length.times do |i|
    prefix = search_word[0..i]
    matches = products.select { |p| p.start_with?(prefix) }.first(3)
    result << matches
  end
  result
end

def suggested_products(products, search_word)
  products.sort!
  result = []
  prefix = ''
  search_word.each_char do |c|
    prefix += c
    lo = products.bsearch_index { |p| p >= prefix } || products.length
    result << products[lo...lo + 3].select { |p| p.start_with?(prefix) }.first(3)
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  puts suggested_products_brute(%w[mobile mouse moneypot monitor mousepad], 'mouse').inspect
  puts suggested_products(%w[havana], 'havana').inspect
end
