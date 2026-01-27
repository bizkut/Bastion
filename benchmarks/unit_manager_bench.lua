
-- Mocks
local Unit = {}
Unit.__index = Unit

function Unit:New(id, x, y, alive, combat)
    local self = setmetatable({}, Unit)
    self.id = id
    self.x = x
    self.y = y
    self.alive = alive
    self.combat = combat
    return self
end

function Unit:IsAlive() return self.alive end
function Unit:IsAffectingCombat() return self.combat end
function Unit:GetDistance(other)
    local dx = self.x - other.x
    local dy = self.y - other.y
    return math.sqrt(dx*dx + dy*dy)
end

local ObjectManager = {
    activeEnemies = {
        each = function(self, cb)
            for _, u in ipairs(self.list) do
                if cb(u) then return true end
            end
        end,
        list = {}
    }
}

local UnitManager = {
    EnumEnemies = function(self, cb)
        return ObjectManager.activeEnemies:each(cb)
    end
}

-- Populate Units
local units = {}
-- 50 units
-- 40 in combat, 10 not
-- spread randomly in 100x100 area
math.randomseed(1234)
for i = 1, 50 do
    local u = Unit:New(
        i,
        math.random(0, 100),
        math.random(0, 100),
        true, -- all alive for stress test
        i <= 40 -- first 40 in combat
    )
    table.insert(units, u)
    table.insert(ObjectManager.activeEnemies.list, u)
end

-- Original Code (Target for baseline)
function UnitManager:GetEnemiesWithMostEnemies_Original(radius)
    local unit = nil
    local count = 0
    local enemies = {}
    self:EnumEnemies(function(u)
        if u:IsAlive() and u:IsAffectingCombat() then
            local c = 0
            self:EnumEnemies(function(other)
                if other:IsAlive() and other:IsAffectingCombat() and u:GetDistance(other) <= radius then
                    c = c + 1
                end
                return false
            end)
            if c > count then
                unit = u
                count = c
                enemies = {}
                self:EnumEnemies(function(other)
                    if other:IsAlive() and u:GetDistance(other) <= radius then
                        table.insert(enemies, other)
                    end
                    return false
                end)
            end
        end
        return false
    end)
    return unit, enemies
end

-- Optimized Code
function UnitManager:GetEnemiesWithMostEnemies_Optimized(radius)
    local candidates = {}
    local num_candidates = 0

    -- Pass 1: Collect candidates
    self:EnumEnemies(function(u)
        if u:IsAlive() and u:IsAffectingCombat() then
            num_candidates = num_candidates + 1
            candidates[num_candidates] = u
        end
        return false
    end)

    if num_candidates == 0 then
        return nil, {}
    end

    local counts = {}
    -- Initialize counts (optional in Lua if we treat nil as 0, but explicit is safer for ++ logic)
    for i = 1, num_candidates do
        counts[i] = 0
    end

    -- Pass 2: Symmetric count
    for i = 1, num_candidates do
        local u = candidates[i]
        -- Count self? Original code: `if ... u:GetDistance(other) <= radius`.
        -- distance(u, u) is 0, so <= radius is true.
        -- So original counts self.
        counts[i] = counts[i] + 1

        for j = i + 1, num_candidates do
            local other = candidates[j]
            if u:GetDistance(other) <= radius then
                counts[i] = counts[i] + 1
                counts[j] = counts[j] + 1
            end
        end
    end

    -- Pass 3: Find winner
    local max_count = -1
    local winner_index = 0

    for i = 1, num_candidates do
        if counts[i] > max_count then
            max_count = counts[i]
            winner_index = i
        end
    end

    if winner_index == 0 then
        return nil, {}
    end

    local winner = candidates[winner_index]

    -- Pass 4: Generate result list (Original behavior: check ALL alive enemies)
    local enemies = {}
    self:EnumEnemies(function(other)
        if other:IsAlive() and winner:GetDistance(other) <= radius then
            table.insert(enemies, other)
        end
        return false
    end)

    return winner, enemies
end

-- Benchmark
local iterations = 1000
local radius = 10

-- Verify correctness first
local orig_u, orig_e = UnitManager:GetEnemiesWithMostEnemies_Original(radius)
local opt_u, opt_e = UnitManager:GetEnemiesWithMostEnemies_Optimized(radius)

if orig_u ~= opt_u then
    print("MISMATCH: Winner unit differs!")
    print("Original:", orig_u and orig_u.id or "nil")
    print("Optimized:", opt_u and opt_u.id or "nil")
else
    print("Winner Match:", orig_u.id)
end

if #orig_e ~= #opt_e then
    print("MISMATCH: List size differs!", #orig_e, #opt_e)
else
    print("List Size Match:", #orig_e)
end

local start_time = os.clock()
for i = 1, iterations do
    UnitManager:GetEnemiesWithMostEnemies_Original(radius)
end
local end_time = os.clock()
print(string.format("Original: %.4f seconds", end_time - start_time))

start_time = os.clock()
for i = 1, iterations do
    UnitManager:GetEnemiesWithMostEnemies_Optimized(radius)
end
end_time = os.clock()
print(string.format("Optimized: %.4f seconds", end_time - start_time))
