# frozen_string_literal: true

# LeetCode 146: LRU Cache
#
# Problem:
# Design a data structure that follows LRU (Least Recently Used) cache eviction policy.
# get(key): return value or -1 if not present (mark as recently used).
# put(key, value): insert or update. Evict LRU if over capacity.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use an array to track order. On get/put, move item to end. On eviction, remove front.
#    Time Complexity: O(n) for get/put due to array search
#    Space Complexity: O(capacity)
#
# 2. Bottleneck
#    O(n) search. Hash for O(1) lookup + doubly linked list for O(1) order updates.
#
# 3. Optimized Accepted Approach
#    Hash + doubly linked list. Sentinel head/tail nodes simplify edge cases.
#    get: find in hash, move node to tail, return value.
#    put: if exists update and move to tail; else add at tail and evict from head if over capacity.
#
#    Time Complexity: O(1) get and put
#    Space Complexity: O(capacity)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# capacity=2
# put(1,1): cache={1:1}, order=[1]
# put(2,2): cache={1:1,2:2}, order=[1,2]
# get(1):   cache={1:1,2:2}, order=[2,1] -> return 1
# put(3,3): evict LRU=2, cache={1:1,3:3}, order=[1,3]
# get(2):   return -1 (evicted)
#
# Edge Cases:
# - capacity=1: every put evicts previous
# - put existing key: update value, move to recently used

class LRUCacheBrute
  def initialize(capacity)
    @cap = capacity
    @cache = {}
    @order = []
  end

  def get(key)
    return -1 unless @cache.key?(key)
    @order.delete(key)
    @order << key
    @cache[key]
  end

  def put(key, value)
    if @cache.key?(key)
      @order.delete(key)
    elsif @cache.size >= @cap
      lru = @order.shift
      @cache.delete(lru)
    end
    @cache[key] = value
    @order << key
  end
end

class LRUCache
  Node = Struct.new(:key, :val, :prev, :next)

  def initialize(capacity)
    @cap = capacity
    @map = {}
    @head = Node.new(0, 0)
    @tail = Node.new(0, 0)
    @head.next = @tail
    @tail.prev = @head
  end

  def get(key)
    return -1 unless @map.key?(key)
    move_to_tail(@map[key])
    @map[key].val
  end

  def put(key, value)
    if @map.key?(key)
      @map[key].val = value
      move_to_tail(@map[key])
    else
      node = Node.new(key, value)
      @map[key] = node
      insert_before_tail(node)
      if @map.size > @cap
        lru = @head.next
        remove_node(lru)
        @map.delete(lru.key)
      end
    end
  end

  private

  def remove_node(node)
    node.prev.next = node.next
    node.next.prev = node.prev
  end

  def insert_before_tail(node)
    node.prev = @tail.prev
    node.next = @tail
    @tail.prev.next = node
    @tail.prev = node
  end

  def move_to_tail(node)
    remove_node(node)
    insert_before_tail(node)
  end
end

if __FILE__ == $PROGRAM_NAME
  cache = LRUCache.new(2)
  cache.put(1, 1)
  cache.put(2, 2)
  puts cache.get(1)   # 1
  cache.put(3, 3)
  puts cache.get(2)   # -1
  cache.put(4, 4)
  puts cache.get(1)   # -1
  puts cache.get(3)   # 3
  puts cache.get(4)   # 4
end
