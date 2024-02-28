FROM alpine:latest

ARG UDP2RAW_VERSION="20230206.0"
ARG SPEEDER_VERSION="20230206.0"

ARG UDP2RAW_URL="https://github.com/wangyu-/udp2raw/releases/download/${UDP2RAW_VERSION}/udp2raw_binaries.tar.gz"
ARG SPEEDER_URL="https://github.com/wangyu-/UDPspeeder/releases/download/${SPEEDER_VERSION}/speederv2_binaries.tar.gz"

COPY ./entrypoint.sh /usr/bin/entrypoint.sh

RUN set -ex \
    && apk add --no-cache tzdata iptables ip6tables supervisor bind-tools \
    && wget -O ~/udp2raw.tar.gz ${UDP2RAW_URL} && tar -zxvf ~/udp2raw.tar.gz udp2raw_amd64_hw_aes -C /tmp/ && mv /tmp/udp2raw_amd64_hw_aes /usr/bin/udp2raw && rm -f ~/udp2raw.tar.gz \
    && wget -O ~/speeder.tar.gz ${SPEEDER_URL} && tar -zxvf ~/speeder.tar.gz speederv2_amd64 -C /tmp/ && mv /tmp/speederv2_amd64 /usr/bin/speederv2 && rm -f ~/speeder.tar.gz \
    && mkdir -p /etc/supervisor/conf.d/ && chmod +x /usr/bin/entrypoint.sh

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf.backup

EXPOSE 8585

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
