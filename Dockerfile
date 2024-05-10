FROM alpine:latest

ARG UDP2RAW_VERSION="20230206.0"
ARG KCPTUN_VERSION="20240107"
ARG SHADOWSOCKS_VERSION="1.18.3"

ARG UDP2RAW_URL="https://github.com/wangyu-/udp2raw/releases/download/${UDP2RAW_VERSION}/udp2raw_binaries.tar.gz"
ARG KCPTUN_URL="https://github.com/xtaci/kcptun/releases/download/v${KCPTUN_VERSION}/kcptun-linux-amd64-${KCPTUN_VERSION}.tar.gz"
ARG SHADOWSOCKS_URL="https://github.com/shadowsocks/shadowsocks-rust/releases/download/v${SHADOWSOCKS_VERSION}/shadowsocks-v${SHADOWSOCKS_VERSION}.x86_64-unknown-linux-musl.tar.xz"

COPY ./entrypoint.sh /usr/bin/entrypoint.sh

RUN set -ex \
    && apk add --no-cache tzdata iptables ip6tables supervisor bind-tools \
    && wget -O ~/udp2raw.tar.gz ${UDP2RAW_URL} && tar -zxvf ~/udp2raw.tar.gz udp2raw_amd64_hw_aes -C /tmp/ && mv /tmp/udp2raw_amd64_hw_aes /usr/bin/udp2raw && rm -f ~/udp2raw.tar.gz \
    && wget -O ~/kcptun.tar.gz ${KCPTUN_URL} && tar -zxvf ~/kcptun.tar.gz server_linux_amd64 -C /tmp/ && mv /tmp/server_linux_amd64 /usr/bin/kcptun && rm -f ~/kcptun.tar.gz \
    && wget -O ~/shadowsocks.tar.xz ${SHADOWSOCKS_URL} && tar -xJvf ~/shadowsocks.tar.xz ssserver -C /tmp/ && mv /tmp/ssserver /usr/bin/shadowsocks && rm -f ~/shadowsocks.tar.xz \
    && mkdir -p /etc/supervisor/conf.d/ && chmod +x /usr/bin/entrypoint.sh

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf.backup


ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
