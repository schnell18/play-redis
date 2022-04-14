# Redis 集群迁移实验环境

本虚拟开发环境提供了两个集群模式的 redis 和两个哨兵模式的 redis 集群。
方便进行集群迁移测试。

## 使用 RedisShake 迁移 sentinel 模式 redis 集群

### 生成模拟数据

使用 lua 脚本生成大批量数据时会阻塞 redis 服务器，所以不能在哨兵模式的 redis 集群上运行
数据生成脚本。可以通过运行以下命令，启动一个独立的 redis 服务器。在这个实例上生成数据并保存到 aof 文件中。

    ./infractl.sh start redis-standalone

以下是生成模拟数据的 lua 脚本：

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

    math.randomseed(134234)
    for i = 1, 50000 do
        local companyId = string.format("%1d%06d", (i % 9 + 1), math.random(100000))
        redis.call("hset", "RegionPermission", companyId, mockPermissionBits())
    end

在前一步独立 redis 实例上运行该脚本生成测试数据的命令如下：

    redis-cli -a abc123 -p 6479 --eval test-data-generator.lua

生成的 aof 文件在`.state/redis-standalone/data/appendonly.aof`中。
数据生成脚本运行完毕后可以将以上文件拷贝到哨兵模式集群的主节点数据文件夹下。
该文件夹路径为`.state/redis-sentinel1/data/node1/`

### 启动 redis 集群

运行以下命令启动 redis sentinel 集群 1 和集群 2:

    cd ~/play-redis/redis-migrate
    ./infractl.sh start redis-sentinel1 redis-sentinel2 mig-tools

环境启动后可以通过以下命令检测各个容器是否正常工作：

    ./infractl.sh status all

### 配置 RedisShake

RedisShake 配置如下 (provision/apps/mig-tools/config/redis-shake.conf)：

    conf.version = 1
    id = redis-shake

    log.level = info

    system_profile = 9310
    http_profile = 9320

    parallel = 32

    source.type = sentinel

    source.address = mymaster:master@redis-sentinel11:5001;redis-sentinel12:5002;redis-sentinel13:5003

    source.password_raw = abc123

    source.auth_type = auth
    source.tls_enable = false
    source.tls_skip_verify = false
    source.rdb.input =
    source.rdb.parallel = 0
    source.rdb.special_cloud =

    target.type = sentinel
    target.address = mymaster:master@redis-sentinel21:5501;redis-sentinel22:5502;redis-sentinel23:5503

    target.password_raw = abc123

    target.auth_type = auth
    target.db = 0

    target.dbmap =

    target.tls_enable = false
    target.tls_skip_verify = false
    target.rdb.output = local_dump
    target.version =

    fake_time =

    key_exists = rewrite

    filter.db.whitelist =
    filter.db.blacklist =
    filter.key.whitelist =
    filter.key.blacklist =
    filter.slot =
    filter.command.whitelist =
    filter.command.blacklist =
    filter.lua = false

    big_key_threshold = 524288000

    metric = true
    metric.print_log = false

    sender.size = 104857600
    sender.count = 4095
    sender.delay_channel_size = 65535

    keep_alive = 10

    scan.key_number = 50
    scan.special_cloud =
    scan.key_file =

    qps = 200000

    resume_from_break_point = false

    replace_hash_tag = false

### 执行迁移

redis-shake 工具包含在 mig-tools 容器中。
首次使用需要构建该容器的镜像：

    ./appctl.sh build mig-tools

运行以下启动该容器并登录到该容器中：

    ./appctl.sh start mig-tools
    ./appctl.sh attach mig-tools

运行以下命令进行迁移：

    ./redis-shake -conf redis-shake.conf -type sync

[1]: https://desktop.docker.com/mac/stable/amd64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=header
[2]: https://github.com/schnell18/play-redis.git
