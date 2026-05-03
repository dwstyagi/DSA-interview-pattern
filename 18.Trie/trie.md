# Pattern 18 — Trie (Prefix Tree)

## Recognize It

Ask yourself:
- Is the problem about **prefixes / suffixes / autocomplete**?
- Do you need to **search many words in a big dictionary** efficiently?
- Is there a **wildcard** or **pattern match** against a fixed word set?
- Would string hashing or repeated prefix comparisons blow up?

If yes → Trie.

---

## Why Trie

```
for N words of length L:
- hash set: O(L) insert/search, but no prefix queries
- trie:     O(L) insert/search AND O(L) prefix query
- trie shares common prefixes → space-efficient for dense dictionaries
```

---

## Core Template

### Insert / Search / Starts-With

```ruby
class TrieNode
  attr_accessor :children, :end_of_word
  def initialize
    @children = {}       # or Array.new(26) for lowercase-only
    @end_of_word = false
  end
end

class Trie
  def initialize
    @root = TrieNode.new
  end

  def insert(word)
    node = @root
    word.each_char do |c|
      node.children[c] ||= TrieNode.new
      node = node.children[c]
    end
    node.end_of_word = true
  end

  def search(word)
    node = find_node(word)
    node && node.end_of_word
  end

  def starts_with(prefix)
    !find_node(prefix).nil?
  end

  private

  def find_node(str)
    node = @root
    str.each_char do |c|
      return nil unless node.children[c]
      node = node.children[c]
    end
    node
  end
end
```

---

### Wildcard Search (Add and Search Word)

```ruby
def search(word, node = @root)
  word.each_char.with_index do |c, i|
    if c == '.'
      rest = word[(i + 1)..]
      return node.children.values.any? { |child| search(rest, child) }
    else
      return false unless node.children[c]
      node = node.children[c]
    end
  end
  node.end_of_word
end
```

---

### Word Search II (Trie + DFS on grid)

```
build a trie of all target words.
DFS from each cell, walking the trie in parallel.
when you hit end_of_word, collect the word (optionally prune the node).
```

```ruby
def find_words(board, words)
  trie = build_trie(words)
  result = []
  rows, cols = board.length, board[0].length

  dfs = ->(r, c, node, path) {
    return if r < 0 || r >= rows || c < 0 || c >= cols
    ch = board[r][c]
    return if ch == '#' || !node.children[ch]

    nxt = node.children[ch]
    path << ch
    if nxt.end_of_word
      result << path.join
      nxt.end_of_word = false              # prevent duplicates
    end

    board[r][c] = '#'                      # mark visited
    [[1,0],[-1,0],[0,1],[0,-1]].each { |dr, dc| dfs.call(r + dr, c + dc, nxt, path) }
    board[r][c] = ch                       # undo

    path.pop
  }

  (0...rows).each { |r| (0...cols).each { |c| dfs.call(r, c, trie.root, []) } }
  result
end
```

---

## Problem List

### Easy

| # | Problem | LC | Use | Track |
|---|---------|-----|-----|-------|
| 1 | Longest Common Prefix | [14](https://leetcode.com/problems/longest-common-prefix/) | (Trie optional) | shared path |
| 2 | Implement Trie (Prefix Tree) | [208](https://leetcode.com/problems/implement-trie-prefix-tree/) | Basic trie | insert/search/prefix |

### Medium

| # | Problem | LC | Use | Track |
|---|---------|-----|-----|-------|
| 3 | Add and Search Word | [211](https://leetcode.com/problems/design-add-and-search-words-data-structure/) | Wildcard | '.' recursion |
| 4 | Map Sum Pairs | [677](https://leetcode.com/problems/map-sum-pairs/) | Prefix sum | store val at node |
| 5 | Replace Words | [648](https://leetcode.com/problems/replace-words/) | Shortest root | stop at first word |
| 6 | Implement Magic Dictionary | [676](https://leetcode.com/problems/implement-magic-dictionary/) | 1-char swap search | branched DFS |
| 7 | Longest Word in Dictionary | [720](https://leetcode.com/problems/longest-word-in-dictionary/) | BFS on trie | prefix must be a word |
| 8 | Index Pairs of a String | [1065](https://leetcode.com/problems/index-pairs-of-a-string/) | Trie + scan | match while walking |
| 9 | Top K Frequent Words | [692](https://leetcode.com/problems/top-k-frequent-words/) | Heap (trie optional) | freq + lex |
| 10 | Short Encoding of Words | [820](https://leetcode.com/problems/short-encoding-of-words/) | Suffix trie | reverse words |
| 11 | Prefix and Suffix Search | [745](https://leetcode.com/problems/prefix-and-suffix-search/) | Combined key | "suffix#prefix" |
| 12 | Search Suggestions System | [1268](https://leetcode.com/problems/search-suggestions-system/) | Trie + DFS top 3 | or binary search |

### Hard

| # | Problem | LC | Use | Track |
|---|---------|-----|-----|-------|
| 13 | Word Search II | [212](https://leetcode.com/problems/word-search-ii/) | Trie + grid DFS | prune visited |
| 14 | Concatenated Words | [472](https://leetcode.com/problems/concatenated-words/) | Trie + DP | walk + recurse on suffix |
| 15 | Palindrome Pairs | [336](https://leetcode.com/problems/palindrome-pairs/) | Reverse trie | per-word split |
| 16 | Stream of Characters | [1032](https://leetcode.com/problems/stream-of-characters/) | Reverse trie | match latest suffix |
| 17 | Maximum XOR of Two Numbers | [421](https://leetcode.com/problems/maximum-xor-of-two-numbers-in-an-array/) | Binary trie | greedy MSB |

---

## Key Tricks to Remember

**Child storage: hash vs array**
```ruby
# array[26]: O(1) access, ~26x memory — fine for lowercase-only
# hash:      flexible chars, Unicode, less memory when sparse
# hash is default unless perf critical
```

**Store extra info at the end-of-word node**
```ruby
# Map Sum: store the "value" at each word's end node
# autocomplete: store frequency or rank at terminal nodes
# saves a second lookup
```

**Prune while DFS-ing (Word Search II)**
```ruby
# set end_of_word = false when a word is collected (prevents duplicates)
# OPTIONAL: delete leaf nodes after collection to shrink future DFS
```

**Reverse for suffix problems**
```ruby
# reverse each word and insert → prefix queries become suffix queries
# Short Encoding, Stream of Characters both use this flip
```

**Binary trie for XOR problems**
```ruby
# insert each number bit by bit (MSB first) into a trie with children [0, 1]
# to maximize XOR, greedily walk the OPPOSITE bit at each level
```

**Wildcard '.'**
```ruby
# recurse into all children at that level
# bound by the wildcard count — worst case multiplies branching
```

---

## Decision Checklist

```
prefix queries on many words?     → trie
autocomplete / suggestions?       → trie + DFS or BFS
find which words appear in text?  → Aho-Corasick or suffix trie
max XOR / bit-prefix problems?    → binary trie
dictionary lookup only (no prefix)→ hash set is simpler
suffix queries?                   → reverse and use prefix trie
```

---

## Solved
- [ ] 14 — Longest Common Prefix
- [ ] 208 — Implement Trie
- [ ] 211 — Add and Search Word
- [ ] 677 — Map Sum Pairs
- [ ] 648 — Replace Words
- [ ] 676 — Magic Dictionary
- [ ] 720 — Longest Word in Dictionary
- [ ] 1065 — Index Pairs of a String
- [ ] 692 — Top K Frequent Words
- [ ] 820 — Short Encoding of Words
- [ ] 745 — Prefix and Suffix Search
- [ ] 1268 — Search Suggestions System
- [ ] 212 — Word Search II
- [ ] 472 — Concatenated Words
- [ ] 336 — Palindrome Pairs
- [ ] 1032 — Stream of Characters
- [ ] 421 — Max XOR of Two Numbers