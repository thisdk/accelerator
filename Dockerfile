FROM alpine:latest AS builder

WORKDIR /

RUN set -ex \
    && apk add --no-cache git build-base linux-headers \
    && git clone https://github.com/wangyu-/udp2raw.git \
    && git clone https://github.com/wangyu-/UDPspeeder.git \
    && git clone --recursive https://github.com/wangyu-/tinyfecVPN.git \
    && cd /tinyfecVPN/UDPspeeder && git checkout branch_libev && git pull \
    && cd /udp2raw && make \
    && cd /UDPspeeder && make \
    && cd /tinyfecVPN && make

FROM alpine:latest

COPY --from=builder /udp2raw/udp2raw /usr/bin/
COPY --from=builder /UDPspeeder/speederv2 /usr/bin/
COPY --from=builder /tinyfecVPN/tinyvpn /usr/bin/

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
COPY ./supervisord-server.conf /etc/supervisor/conf.d/supervisord-server.conf.backup
COPY ./supervisord-client.conf /etc/supervisor/conf.d/supervisord-client.conf.backup

RUN set -ex && apk add --no-cache tzdata iptables supervisor bind-tools \
    && chmod +x /usr/bin/entrypoint.sh

EXPOSE 8388 8585

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
