source provision/global/libs/functions.sh

function generateMasterRedisConf {
    port=$1
    file=$2
    cat ./provision/redis-sentinel1/redis.conf.tpl | \
        sed "s/@REDIS_PORT@/$port/g" > $file
}

function generateSlaveRedisConf {
    port=$1
    file=$2
    master_port=$3
    master_ip=$4
    cat ./provision/redis-sentinel1/redis-slave.conf.tpl | \
        sed "s/@REDIS_PORT@/$port/g" | \
        sed "s/@MASTER_IP@/$master_ip/g" | \
        sed "s/@MASTER_PORT@/$master_port/g" > $file
}

function generateSentinelConf {
    sentinel_port=$1
    file=$2
    master_port=$3
    hostip=$4
    masterip=$5
    cat ./provision/redis-sentinel1/sentinel.conf.tpl | \
        sed "s/@SENTINEL_PORT@/$sentinel_port/g" | \
        sed "s/@MASTER_IP@/$masterip/g" | \
        sed "s/@MASTER_PORT@/$master_port/g" | \
        sed "s/@SENTINEL_ANNOUNCE_IP@/$hostip/g" > $file
}

if [[ ! -d .state/redis-sentinel1/data ]]; then
    mkdir -p .state/redis-sentinel1/data/{node1,node2,node3}
fi

if [[ ! -d .state/redis-sentinel1/conf ]]; then
    mkdir -p .state/redis-sentinel1/conf/{node1,node2,node3,sentinel1,sentinel2,sentinel3}
fi

# generate redis config file and use host IP
generateMasterRedisConf 6379 .state/redis-sentinel1/conf/node1/redis.conf

hostip=$(getHostIP)
generateSlaveRedisConf 6380 .state/redis-sentinel1/conf/node2/redis.conf 6379 $hostip 
generateSlaveRedisConf 6381 .state/redis-sentinel1/conf/node3/redis.conf 6379 $hostip 

generateSentinelConf 5001 .state/redis-sentinel1/conf/sentinel1/sentinel.conf 6379 $hostip $hostip
generateSentinelConf 5002 .state/redis-sentinel1/conf/sentinel2/sentinel.conf 6379 $hostip $hostip
generateSentinelConf 5003 .state/redis-sentinel1/conf/sentinel3/sentinel.conf 6379 $hostip $hostip

# remove nodes files to work around IP change
# rm -fr .state/redis-sentinel1/data/node1/*
# rm -fr .state/redis-sentinel1/data/node2/*
# rm -fr .state/redis-sentinel1/data/node3/*
