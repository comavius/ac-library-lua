-- Disjoint Set Union (DSU) data structure
-- Average time complexity of query is O(alpha(N)) by using path compression and union by size.

DSU = {}
DSU.__index = DSU

-- constructor
function DSU.new(n)
    -- n must be a positive integer
    assert(math.type(n) == "integer", "DSU.new: n(size of graph) must be an integer")
    assert(n > 0, "DSU.new: n(size of graph) must be greater than 0")
    -- class instance
    local self = setmetatable({}, DSU)
    -- member variables declaration
    self.private = {
        _n = 0,
        -- if i is a leader (or root), then parent_or_size[i] is -size, else parent_or_size[i] is the parent of i
        _parent_or_size = {}
    }
    -- member variables initialization
    self.private._n = n
    for i = 1, n do
        self.private._parent_or_size[i] = -1
    end
    return self
end

-- returns the leader of the new set
function DSU:merge(a, b)
    -- a and b must be in range [1, n]
    assert(math.type(a) == "integer", "DSU:merge: a must be an integer")
    assert(math.type(b) == "integer", "DSU:merge: b must be an integer")
    assert(self.private._n >= a and a > 0, "DSU:merge: a must be in range [1, n]")
    assert(self.private._n >= b and b > 0, "DSU:merge: b must be in range [1, n]")
    -- find the leader of a and b
    local leader_of_a = self:leader(a)
    local leader_of_b = self:leader(b)
    if (leader_of_a == leader_of_b) then
        return leader_of_a
    end
    -- union by size
    local size_of_a = -self.private._parent_or_size[leader_of_a]
    local size_of_b = -self.private._parent_or_size[leader_of_b]
    if size_of_a < size_of_b then
        self.private._parent_or_size[leader_of_b] = -(size_of_a + size_of_b)
        self.private._parent_or_size[leader_of_a] = leader_of_b
        return leader_of_b
    else
        self.private._parent_or_size[leader_of_a] = -(size_of_a + size_of_b)
        self.private._parent_or_size[leader_of_b] = leader_of_a
        return leader_of_a
    end
end

-- returns if a and b are in the same set
function DSU:same(a, b)
    -- a and b must be in range [1, n]
    assert(math.type(a) == "integer", "DSU:same: a must be an integer")
    assert(math.type(b) == "integer", "DSU:same: b must be an integer")
    assert(self.private._n >= a and a > 0, "DSU:same: a must be in range [1, n]")
    assert(self.private._n >= b and b > 0, "DSU:same: b must be in range [1, n]")
    -- find the leader of a and b
    return self:leader(a) == self:leader(b)
end

-- returns the leader of the set
function DSU:leader(a)
    -- a must be in range [1, n]
    assert(math.type(a) == "integer", "DSU:leader: a must be an integer")
    assert(self.private._n >= a and a > 0, "DSU:leader: a must be in range [1, n]")
    -- find the leader recursively
    -- i if a is a leader (see declaration in DSU.new)
    if self.private._parent_or_size[a] <= 0 then
        return a
    else
        -- path compression
        self.private._parent_or_size[a] = self:leader(self.private._parent_or_size[a])
        return self.private._parent_or_size[a]
    end
end

-- returns the size of the set
function DSU:size(a)
    -- a must be in range [1, n]
    assert(math.type(a) == "integer", "DSU:size: a must be an integer")
    assert(self.private._n >= a and a > 0, "DSU:size: a must be in range [1, n]")
    -- find the leader of a
    local leader_of_a = self:leader(a)
    return -self.private._parent_or_size[leader_of_a]
end

-- returns the sets in the DSU
function DSU:groups()
    local groups = {}
    for i = 1, self.private._n do
        local leader_of_i = self:leader(i)
        if groups[leader_of_i] == nil then
            groups[leader_of_i] = {}
        end
        table.insert(groups[leader_of_i], i)
    end
    return groups
end

return {
    DSU = DSU
}
