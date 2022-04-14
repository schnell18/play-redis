# Introduction

本虚拟开发环境提供了两个集群模式的 redis 和两个哨兵模式的 redis 集群。

## 环境设置

本项目开发环境在 MacOS 和 Manjaro Linux 测试验证过，理论上也可以在其它 Linux 及 Windows 运行。
使用本项目需安装 Docker Desktop 3.5 或以上。[MacOS 版本下载地址][1]
此外，为方便使用命令行工具，请安装配置好以下工具：

- redis-cli
- git
- jq
- yq
- curl
- xxd


以上步骤完成后请克隆 [play-redis 项目 git 库][2]，命令如下：

    cd ~/work
    git clone --recurse-submodule https://github.com/schnell18/play-redis.git

## Catalog

| sub-directory      | comment                                             |
| ------------------ | ----------------------------------------------------|
| [redis-migrate][2] | redis migration w/ [RedisShake][1]                  |
| [geo-demo][3]      | redis geo function demononstration                  |

[1]: https://github.com/alibaba/RedisShake
[2]: https://github.com/schnell18/play-redis/tree/master/redis-migrate#introduction
[3]: https://github.com/schnell18/play-redis/tree/master/geo-demo#introduction
