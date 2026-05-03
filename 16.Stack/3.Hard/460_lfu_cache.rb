# frozen_string_literal: true

# LeetCode 460: LFU Cache
#
# Problem:
# Design a Least Frequently Used cache. get/put both count as use.
# On eviction, remove least frequently used. Ties broken by LRU (least recently used).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    On eviction, scan all entries to find min frequency, then among those find LRU.
#    Time Complexity: O(n) per eviction
#    Space Complexity: O(capacity)
#
# 2. Bottleneck
#    O(n) eviction. Use three structures: key->value hash, key->freq hash,
#    freq->ordered_set_of_keys hash. Track global min_freq.
#
# 3. Optimized Accepted Approach
#    Hash for key->value, key->freq. Hash of freq->LinkedHashSet (ordered).
#    Track min_freq. On put of new key, min_freq resets to 1.
#
#    Time Complexity: O(1) get and put
#    Space Complexity: O(capacity)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# capacity=2
# put(1,1): key_val={1:1}, key_freq={1:1}, freq_keys={1:[1]}, min=1
# put(2,2): {1:1,2:2}, {1:1,2:1}, {1:[1,2]}, min=1
# get(1):   freq[1]=2, move to freq 2 -> {1:[2]}, {2:[1]}, min=1
# put(3,3): evict min_freq=1, LRU in {1:[2]} -> evict 2
#           {1:1,3:3}, key_freq={1:2,3:1}, freq={1:[3],2:[1]}, min=1
# get(2):   -1 (evicted)
#
# Edge Cases:
# - capacity=0: get always -1, put does nothing
# - All operations on same key: frequency grows, never evicted until needed

class LFUCacheBrute
  def initialize(capacity)
    @cap = capacity
    @store = {}
    @freq = {}
    @time = {}
    @t = 0
  end

  def get(key)
    return -1 unless @store.key?(key)
    @freq[key] += 1
    @t += 1; @time[key] = @t
    @store[key]
  end

  def put(key, value)
    return if @cap == 0
    if @store.key?(key)
      @store[key] = value
      get(key)
      return
    end
    if @store.size >= @cap
      lfu_key = @store.keys.min_by { |k| [@freq[k], @time[k]] }
      @store.delete(lfu_key); @freq.delete(lfu_key); @time.delete(lfu_key)
    end
    @store[key] = value
    @freq[key] = 1
    @t += 1; @time[key] = @t
  end
end

class LFUCache
  def initialize(capacity)
    @cap = capacity
    @key_val = {}
    @key_freq = {}
    @freq_keys = Hash.new { |h, k| h[k] = {} }  # freq -> {key => nil} ordered by insertion
    @min_freq = 0
  end

  def get(key)
    return -1 unless @key_val.key?(key)
    increment_freq(key)
    @key_val[key]
  end

  def put(key, value)
    return if @cap == 0
    if @key_val.key?(key)
      @key_val[key] = value
      increment_freq(key)
    else
      evict if @key_val.size >= @cap
      @key_val[key] = value
      @key_freq[key] = 1
      @freq_keys[1][key] = nil
      @min_freq = 1
    end
  end

  private

  def increment_freq(key)
    f = @key_freq[key]
    @key_freq[key] = f + 1
    @freq_keys[f].delete(key)
    @freq_keys[f + 1][key] = nil
    @min_freq += 1 if @freq_keys[@min_freq].empty?
  end

  def evict
    lru_key = @freq_keys[@min_freq].first&.first
    return unless lru_key
    @freq_keys[@min_freq].delete(lru_key)
    @key_val.delete(lru_key)
    @key_freq.delete(lru_key)
  end
end

if __FILE__ == $PROGRAM_NAME
  lfu = LFUCache.new(2)
  lfu.put(1, 1)
  lfu.put(2, 2)
  puts lfu.get(1)   # 1
  lfu.put(3, 3)
  puts lfu.get(2)   # -1
  puts lfu.get(3)   # 3
  lfu.put(4, 4)
  puts lfu.get(1)   # 1
  puts lfu.get(3)   # -1
  puts lfu.get(4)   # 4
end
