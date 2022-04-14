source provision/global/libs/functions.sh

function generateRedisConf {
    port=$1
    file=$2
    hostip=$(getHostIP)
    cat ./provision/redis-cluster2/redis.conf.tpl | \
        sed "s/@REDIS_PORT@/$port/g" | \
        sed "s/@CLUSTER_ANNOUNCE_IP@/$hostip/g" > $file
}

function generateRedisClusterScript {
    port1=$1
    port2=$2
    port3=$3
    file=$4
    hostip=$(getHostIP)
    cat ./provision/redis-cluster2/create-cluster.sh.tpl | \
        sed "s/@REDIS_PORT1@/$port1/g" | \
        sed "s/@REDIS_PORT2@/$port2/g" | \
        sed "s/@REDIS_PORT3@/$port3/g" | \
        sed "s/@CLUSTER_ANNOUNCE_IP@/$hostip/g" > $file
}

if [[ ! -d .state/redis-cluster2/data ]]; then
    mkdir -p .state/redis-cluster2/data/{node1,node2,node3}
fi

if [[ ! -d .state/redis-cluster2/conf ]]; then
    mkdir -p .state/redis-cluster2/conf/{node1,node2,node3}
fi

# generate redis config file and use host IP
generateRedisConf 7701 .state/redis-cluster2/conf/node1/redis.conf
generateRedisConf 7702 .state/redis-cluster2/conf/node2/redis.conf
generateRedisConf 7703 .state/redis-cluster2/conf/node3/redis.conf

if [[ ! -d .state/redis-cluster2/bin ]]; then
    mkdir -p .state/redis-cluster2/bin
fi


# remove nodes files to work around IP change
# rm -fr .state/redis-cluster2/data/node1/*
# rm -fr .state/redis-cluster2/data/node2/*
# rm -fr .state/redis-cluster2/data/node3/*

touch .state/redis-cluster2/bin/create-cluster.sh
chmod +x .state/redis-cluster2/bin/create-cluster.sh
# generate redis cluster creation script use host IP
generateRedisClusterScript 7701 7702 7703 .state/redis-cluster2/bin/create-cluster.sh
