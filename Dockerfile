FROM alpine:latest AS builder

WORKDIR ~/

RUN set -ex \
    && apk add --no-cache git build-base linux-headers \
    && git clone https://github.com/wangyu-/udp2raw.git \
    && cd udp2raw \
    && make

FROM alpine:latest

RUN set -ex \
    && apk add --no-cache tzdata iptables supervisor bind-tools

COPY --from=builder ~/udp2raw/udp2raw /usr/bin/

ENTRYPOINT [ "/bin/udp2raw" ]
