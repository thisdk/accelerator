# Stage 1: Build udp2raw
FROM alpine:latest AS udpBuilder
WORKDIR /build
RUN apk add --no-cache --virtual .build-deps \
    git \
    build-base \
    linux-headers && \
    git clone --depth 1 https://github.com/wangyu-/udp2raw.git && \
    cd udp2raw && \
    make dynamic && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*

# Stage 2: Build kcptun
FROM golang:1.21.0-alpine3.18 as kcpBuilder
ENV GO111MODULE=on \
    CGO_ENABLED=0
WORKDIR /build
RUN apk add --no-cache git && \
    git clone --depth 1 https://github.com/xtaci/kcptun.git && \
    cd kcptun && \
    go build -mod=vendor -trimpath -ldflags "-s -w -X main.VERSION=$(date -u +%Y%m%d)" -o /client github.com/xtaci/kcptun/client && \
    go build -mod=vendor -trimpath -ldflags "-s -w -X main.VERSION=$(date -u +%Y%m%d)" -o /server github.com/xtaci/kcptun/server && \
    rm -rf /build /root/.cache/go-build

# Final stage
FROM alpine:latest
WORKDIR /

# Install runtime dependencies
RUN apk add --no-cache \
    tzdata \
    iptables \
    supervisor \
    bind-tools && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /etc/supervisor/conf.d

# Copy binaries
COPY --from=udpBuilder /build/udp2raw/udp2raw_dynamic /usr/bin/udp2raw
COPY --from=kcpBuilder /client /usr/bin/kcp_client
COPY --from=kcpBuilder /server /usr/bin/kcp_server

# Copy configs
COPY ./entrypoint.sh /usr/bin/entrypoint.sh
COPY ./supervisord-server.conf /etc/supervisor/conf.d/supervisord-server.conf.backup
COPY ./supervisord-client.conf /etc/supervisor/conf.d/supervisord-client.conf.backup

# Set permissions
RUN chmod +x /usr/bin/entrypoint.sh && \
    chmod +x /usr/bin/udp2raw && \
    chmod +x /usr/bin/kcp_client && \
    chmod +x /usr/bin/kcp_server

# Security hardening
RUN adduser -D -u 1000 appuser && \
    chown -R appuser:appuser /etc/supervisor

USER appuser
EXPOSE 8585
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
