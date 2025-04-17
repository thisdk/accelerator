# 公共构建阶段
FROM alpine:latest AS udpBuilder
WORKDIR /build
RUN apk add --no-cache git build-base linux-headers && \
    git clone --depth 1 https://github.com/wangyu-/udp2raw.git && \
    cd udp2raw && \
    make

FROM golang:1.21.0-alpine3.18 AS kcpBuilder
ENV GO111MODULE=on CGO_ENABLED=0
WORKDIR /build
RUN apk add --no-cache git && \
    git clone --depth 1 https://github.com/xtaci/kcptun.git && \
    cd kcptun && \
    go build -mod=vendor -trimpath -ldflags "-s -w" -o /server github.com/xtaci/kcptun/server && \
    go build -mod=vendor -trimpath -ldflags "-s -w" -o /client github.com/xtaci/kcptun/client

# 服务端专用镜像
FROM alpine:latest AS server
RUN apk add --no-cache tzdata iptables supervisor bind-tools && mkdir -p /etc/supervisor/conf.d
COPY --from=udpBuilder /build/udp2raw/udp2raw /usr/bin/udp2raw
COPY --from=kcpBuilder /server /usr/bin/kcptun
COPY ./supervisord-server.conf /etc/supervisor/conf.d/supervisord.conf.backup
COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh /usr/bin/udp2raw /usr/bin/kcptun
EXPOSE 8585
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# 客户端专用镜像
FROM alpine:latest AS client
RUN apk add --no-cache tzdata iptables supervisor
COPY --from=udpBuilder /build/udp2raw/udp2raw /usr/bin/udp2raw
COPY --from=kcpBuilder /client /usr/bin/kcptun
COPY ./supervisord-client.conf /etc/supervisor/conf.d/supervisord.conf.backup
COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh /usr/bin/udp2raw /usr/bin/kcptun
EXPOSE 8585
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
