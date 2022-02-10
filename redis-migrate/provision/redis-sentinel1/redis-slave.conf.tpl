port @REDIS_PORT@
protected-mode no
appendonly yes
slaveof @MASTER_IP@ @MASTER_PORT@
pidfile /var/run/redis.pid
masterauth abc123
requirepass abc123

