FROM alpine:latest AS builder

WORKDIR /

RUN set -ex \
    && apk add --no-cache git build-base linux-headers \
    && git clone https://github.com/wangyu-/udp2raw.git \
    && cd /udp2raw && make \
    && git clone https://github.com/wangyu-/UDPspeeder.git \
    && cd /UDPspeeder && make \
    && git clone --recursive https://github.com/wangyu-/tinyfecVPN.git \
    && cd /tinyfecVPN/UDPspeeder && git checkout branch_libev && git pull \
    && cd /tinyfecVPN && make

FROM alpine:latest

RUN set -ex && apk add --no-cache tzdata iptables supervisor bind-tools

COPY --from=builder /udp2raw/udp2raw /usr/bin/
COPY --from=builder /UDPspeeder/speederv2 /usr/bin/
COPY --from=builder /tinyfecVPN/tinyvpn /usr/bin/
