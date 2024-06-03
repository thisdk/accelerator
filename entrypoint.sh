#!/bin/sh

sleep 3

: ${TCN:=sing-box}

: ${TCP:=8585}

: ${FEC:=1:3,2:4,8:6,20:10}

TARGET_IP=$(dig +short $TCN)

iptables -t nat -A PREROUTING -p tcp --dport $TCP -j DNAT --to-destination $TARGET_IP:$TCP

iptables -t nat -A POSTROUTING -d $TARGET_IP -p tcp --dport $TCP -j MASQUERADE

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

sed -i "s#FEC#$FEC#g" /etc/supervisor/conf.d/supervisord.conf

exec "$@"
