local function bits(num, digits)
    local t = {}
    local rest = num
    local j = 0
    while num > 0 do
        j = j + 1
        rest = num % 2
        table.insert(t, 1, rest)
        num = (num - rest) / 2
    end
    for _ = j + 1, digits do
        table.insert(t, 1, 0)
    end
    return table.concat(t)
end

local function mockPermissionBits()
    local t = {}
    for _ = 1, 32 do
        table.insert(t, bits(math.random(math.pow(2, 16)), 16))
    end return table.concat(t)
end

math.randomseed(1323434)
for i = 1, 9000000 do
    local companyId = string.format("%1d%06d", (i % 9 + 1), math.random(100000))
    redis.call("hset", "RegionPermission", companyId, mockPermissionBits())
end
