math.randomseed(134234)
for i = 1, 1000000 do
    local company = string.format("company%06d", i)
    local lon = 116.0 + math.random(60000) / 100000
    local lat = 39.7 + math.random(90000) / 1000000
    redis.call("geoadd", "company", lon, lat, company)
end
