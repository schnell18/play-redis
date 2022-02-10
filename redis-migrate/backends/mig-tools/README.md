# Introduction

Docker image with collection of tools to migrate redis cluster.

## run migration

    /tools/redis-shake -conf /work/redis-shake.conf -type=sync

## run redis check

    /tools/redis-full-check -s '[2001:b48:a406::fe:46f6:b7af]:6379' -p **************** -t '[2001:a49:a406::fe:1111:b7aa]:6379' -a ******

## build image

    docker buildx build --platform linux/amd64 --push --tag schnell18/redis-mig-tool:latest .

## dependencies

This image requires:

- [Redis][1]
- [RedisShake][2]
- [RedisFullCheck][3]

[1]: https://redis.io/
[2]: https://github.com/schnell18/RedisShake
[3]: https://github.com/schnell18/RedisFullCheck
