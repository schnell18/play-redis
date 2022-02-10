# Introduction

This file records tricks to make redis run faster.
Check [redis offical document on latency][2]

## Avoid using transparent huge page

[Transparent Huge Page][1] is a technology to manage bigger memeory by
increasing memory page size. Using THP will worsen fork latency as the child
process has more to copy. This will cause redis DoS during fork process to
save RDB or rewrite AOF. If you run BGSAVE for BGAOFREWRITE, you run the risk
to turn redis out of service for a few seconds.

To turn off THP, you run:

    sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled

## Avoid using swap

Swap worsen redis latency. To check if redis experienced swap:

- find redis PID: `redis-cli info | grep process_id`
- `cd /proc/$PID` and find the `smaps` file
- run `cat smaps | grep 'Swap:'`


[1]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/performance_tuning_guide/s-memory-transhuge
[2]: https://redis.io/topics/latency
