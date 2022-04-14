source provision/global/libs/functions.sh

function generateRedisConf {
    port=$1
    file=$2
    hostip=$(getHostIP)
    cat ./provision/redis-standalone/redis.conf.tpl | \
        sed "s/@REDIS_PORT@/$port/g" > $file
}

if [[ ! -d .state/redis-standalone/data ]]; then
    mkdir -p .state/redis-standalone/data
fi

if [[ ! -d .state/redis-standalone/conf ]]; then
    mkdir -p .state/redis-standalone/conf
fi

# generate redis config file and use host IP
generateRedisConf 6479 .state/redis-standalone/conf/redis.conf
