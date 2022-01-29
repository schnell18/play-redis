# panic at flush

Occurs at end full sync rdb dump. Seems to connection to target is lost.

    [error]: EOF
    [stack]:
        3   github.com/alibaba/RedisShake/redis-shake/common/utils.go:367
                github.com/alibaba/RedisShake/redis-shake/common.flushAndCheckReply
        2   github.com/alibaba/RedisShake/redis-shake/common/utils.go:723
                github.com/alibaba/RedisShake/redis-shake/common.restoreBigRdbEntry
        1   github.com/alibaba/RedisShake/redis-shake/common/utils.go:854
                github.com/alibaba/RedisShake/redis-shake/common.RestoreRdbEntry
        0   github.com/alibaba/RedisShake/redis-shake/dbSync/syncRDB.go:71
                github.com/alibaba/RedisShake/redis-shake/dbSync.(*DbSyncer).syncRDBFile.func1.1
            ... ...
    2022/01/28 19:31:16 [PANIC] flush command to redis failed
    [error]: EOF
    [stack]:
        3   github.com/alibaba/RedisShake/redis-shake/common/utils.go:367
                github.com/alibaba/RedisShake/redis-shake/common.flushAndCheckReply
        2   github.com/alibaba/RedisShake/redis-shake/common/utils.go:723
                github.com/alibaba/RedisShake/redis-shake/common.restoreBigRdbEntry
        1   github.com/alibaba/RedisShake/redis-shake/common/utils.go:854
                github.com/alibaba/RedisShake/redis-shake/common.RestoreRdbEntry
        0   github.com/alibaba/RedisShake/redis-shake/dbSync/syncRDB.go:71
                github.com/alibaba/RedisShake/redis-shake/dbSync.(*DbSyncer).syncRDBFile.func1.1
            ... ...
