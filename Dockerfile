FROM alpine:latest

ARG UDP2RAW_VERSION="20230206.0"
ARG KCPTUN_VERSION="20240107"
ARG SINGBOX_VERSION="1.8.5"

ARG UDP2RAW_URL="https://github.com/wangyu-/udp2raw/releases/download/${UDP2RAW_VERSION}/udp2raw_binaries.tar.gz"
ARG KCPTUN_URL="https://github.com/xtaci/kcptun/releases/download/v${KCPTUN_VERSION}/kcptun-linux-amd64-${KCPTUN_VERSION}.tar.gz"
ARG SINGBOX_URL="https://github.com/SagerNet/sing-box/releases/download/v${SINGBOX_VERSION}/sing-box-${SINGBOX_VERSION}-linux-amd64.tar.gz"

RUN set -ex \
    && apk add --no-cache bash tzdata iptables ip6tables supervisor \
    && wget -O ~/udp2raw.tar.gz ${UDP2RAW_URL} && tar -zxvf ~/udp2raw.tar.gz udp2raw_amd64_hw_aes -C /tmp/ && mv /tmp/udp2raw_amd64_hw_aes /usr/bin/udp2raw && rm -f ~/udp2raw.tar.gz \
    && wget -O ~/kcptun.tar.gz ${KCPTUN_URL} && tar -zxvf ~/kcptun.tar.gz server_linux_amd64 -C /tmp/ && mv /tmp/server_linux_amd64 /usr/bin/kcptun && rm -f ~/kcptun.tar.gz \
    && wget -O ~/sing-box.tar.gz ${SINGBOX_URL} && tar -zxvf ~/sing-box.tar.gz sing-box-${SINGBOX_VERSION}-linux-amd64/sing-box -C /tmp/ && mv /tmp/sing-box-${SINGBOX_VERSION}-linux-amd64/sing-box /usr/bin/sing-box && rm -f ~/sing-box.tar.gz \
    && mkdir /etc/sing-box/ && mkdir /etc/supervisor/ && mkdir /etc/supervisor/conf.d/

COPY ./sing-box.json /etc/sing-box/config.json
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
