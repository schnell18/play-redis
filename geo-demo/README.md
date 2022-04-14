# Introduction

Explore geo functions in redis.

## start redis

You may conduct this experiment using docker as follows:

    cd <project_root_dir>
    ./infractl.sh start redis-standalone

## prepare data

Prepare some locations using command as follows:

    cat<<EOF | xargs redis-cli -a abc123 -p 6479 geoadd company
    116.48105 39.996794 juejin
    116.514203 39.905409 ireader
    116.489033 40.007669 meituan
    116.562108 39.787602 jd
    116.334255 40.027400 xiaomi
    EOF

To remove the data:

    cat<<EOF | cut -d' ' -f3 | xargs redis-cli -a abc123 -p 6479 geoadd company
    116.48105 39.996794 juejin
    116.514203 39.905409 ireader
    116.489033 40.007669 meituan
    116.562108 39.787602 jd
    116.334255 40.027400 xiaomi
    EOF

You may also run the following command individually inside redis-cli shell:

    geoadd company 116.48105 39.996794 juejin
    geoadd company 116.514203 39.905409 ireader
    geoadd company 116.489033 40.007669 meituan
    geoadd company 116.562108 39.787602 jd
    geoadd company 116.334255 40.027400 xiaomi


## calculate distance

To get distance between `juejin` and `ireader`, run command in redis-cli:

    geodist company juejin ireader


## get longitude/latitude coordinate

To get lon/lat coordinate of `ireader`, run command in redis-cli:

    geopos company ireader

## get geohash

To get geohash of `ireader`, run command in redis-cli:

    geohash company ireader

You may access location on map using geohash by visiting:

    https://geohash.org/wx4g52e1ce0


## get nearby members

You can get nearby members within certain distance by:

    georadiusbymember company ireader 20 km count 3 asc

Or use coordinate as reference point:

    georadius company 116.5142020583152771 39.90540918662494363 20 km count 3 asc


## performance test

Insert 1 mimillion positions using lua scirpt in `test-data.lua` as follows:

    redis-cli -a abc123 -p 7002 -c --eval test-data.lua

Measure the duration by:

    multi
    time
    georadiusbymember company company018502 100 m withdist count 10 asc
    time
    exec

It takes about 355 micro seconds on MacBook Air M1 2020 8GB w/ macOS Big Sur 11.2.2.
