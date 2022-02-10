FROM schnell18/golang-build:1.17-alpine AS builder-shake

ENV BUILD_DIR /build/redis-shake


WORKDIR ${BUILD_DIR}
COPY RedisShake .
RUN make build

# FROM schnell18/golang-build:1.17-alpine AS builder-fullcheck
# RUN apk add sqlite

# ENV BUILD_DIR /build/redis-fullcheck
# WORKDIR ${BUILD_DIR}

# COPY RedisFullCheck .

# RUN bash build.sh

FROM redis:4.0.14-alpine

WORKDIR /tools

COPY README.md README.md
COPY --from=builder-shake /build/redis-shake/bin/redis-shake.linux /tools/redis-shake
COPY --from=builder-shake /build/redis-shake/bin/redis-shake.conf /tools/redis-shake.conf.sample
# COPY --from=builder-fullcheck /build/redis-fullcheck/bin/redis-full-check.linux /tools/redis-full-check
# RUN chmod +x /tools/redis-shake /tools/redis-full-check
RUN chmod +x /tools/redis-shake

ENTRYPOINT []
