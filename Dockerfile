FROM alpine:latest

ARG UDP2RAW_VERSION="20230206.0"
ARG TINYVPN_VERSION="20230206.0"
ARG TINYMAPPER_VERSION="20200818.0"

ARG UDP2RAW_URL="https://github.com/wangyu-/udp2raw/releases/download/${UDP2RAW_VERSION}/udp2raw_binaries.tar.gz"
ARG TINYVPN_URL="https://github.com/wangyu-/tinyfecVPN/releases/download/${TINYVPN_VERSION}/tinyvpn_binaries.tar.gz"
ARG TINYMAPPER_URL="https://github.com/wangyu-/tinyPortMapper/releases/download/${TINYMAPPER_VERSION}/tinymapper_binaries.tar.gz"

COPY ./entrypoint.sh /usr/bin/entrypoint.sh

RUN set -ex \
    && apk add --no-cache tzdata iptables ip6tables supervisor \
    && wget -O ~/udp2raw.tar.gz ${UDP2RAW_URL} && tar -zxvf ~/udp2raw.tar.gz udp2raw_amd64_hw_aes -C /tmp/ && mv /tmp/udp2raw_amd64_hw_aes /usr/bin/udp2raw && rm -f ~/udp2raw.tar.gz \
    && wget -O ~/tinyvpn.tar.gz ${TINYVPN_URL} && tar -zxvf ~/tinyvpn.tar.gz tinyvpn_amd64 -C /tmp/ && mv /tmp/tinyvpn_amd64 /usr/bin/tinyvpn && rm -f ~/tinyvpn.tar.gz \
    && wget -O ~/tinymapper.tar.gz ${TINYMAPPER_URL} && tar -zxvf ~/tinymapper.tar.gz tinymapper_amd64 -C /tmp/ && mv /tmp/tinymapper_amd64 /usr/bin/tinymapper && rm -f ~/tinymapper.tar.gz \
    && mkdir -p /etc/supervisor/conf.d/ && chmod +x /usr/bin/entrypoint.sh

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf.backup

EXPOSE 8686

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
