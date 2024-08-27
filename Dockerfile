FROM alpine:latest AS udp2raw

WORKDIR /

RUN set -ex \
    && apk add --no-cache git build-base linux-headers \
    && git clone https://github.com/wangyu-/udp2raw.git \
    && cd udp2raw \
    && make \
    && ls

FROM alpine:latest AS tinyvpn

WORKDIR /

RUN set -ex \
    && apk add --no-cache git build-base linux-headers \
    && it clone --recursive https://github.com/wangyu-/tinyfecVPN.git \
    && cd tinyfecVPN \
    && make \
    && ls


FROM alpine:latest

RUN set -ex && apk add --no-cache tzdata iptables supervisor bind-tools

COPY --from=udp2raw /udp2raw/udp2raw /usr/bin/
COPY --from=tinyvpn /tinyfecVPN/tinyvpn /usr/bin/

