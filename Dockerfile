FROM alpine:latest AS udpBuilder

WORKDIR /

RUN set -ex \
    && apk add --no-cache git build-base \
    && git clone https://github.com/wangyu-/udp2raw.git \
    && cd /udp2raw && make

FROM golang:1.21.0-alpine3.18 as kcpBuilder
ENV GO111MODULE=on
RUN apk add git \
    && git clone https://github.com/xtaci/kcptun.git \
    && cd kcptun \
    && go build -mod=vendor -ldflags "-X main.VERSION=$(date -u +%Y%m%d) -s -w" -o /client github.com/xtaci/kcptun/client \
    && go build -mod=vendor -ldflags "-X main.VERSION=$(date -u +%Y%m%d) -s -w" -o /server github.com/xtaci/kcptun/server

FROM alpine:latest

COPY --from=udpBuilder /udp2raw/udp2raw /usr/bin/

COPY --from=kcpBuilder /client /usr/bin/kcp_client
COPY --from=kcpBuilder /server /usr/bin/kcp_server

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
COPY ./supervisord-server.conf /etc/supervisor/conf.d/supervisord-server.conf.backup
COPY ./supervisord-client.conf /etc/supervisor/conf.d/supervisord-client.conf.backup

RUN set -ex && apk add --no-cache tzdata iptables supervisor bind-tools && chmod +x /usr/bin/entrypoint.sh

EXPOSE 8585

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
