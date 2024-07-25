#!/bin/sh

sleep 3

: ${IPV:=0.0.0.0}
: ${TCN:=sing-box}
: ${TCP:=8388}
: ${FEC:=1:1,2:2,8:6,20:10}

TIP=$(dig +short $TCN)

iptables -t nat -A PREROUTING -p tcp --dport $TCP -j DNAT --to-destination $TIP:$TCP
iptables -t nat -A PREROUTING -p udp --dport $TCP -j DNAT --to-destination $TIP:$TCP
iptables -t nat -A POSTROUTING -d $TIP -p tcp --dport $TCP -j MASQUERADE
iptables -t nat -A POSTROUTING -d $TIP -p udp --dport $TCP -j MASQUERADE

cp -f /etc/supervisor/conf.d/supervisord.conf.backup /etc/supervisor/conf.d/supervisord.conf

sed -i "s#IPV#$IPV#g" /etc/supervisor/conf.d/supervisord.conf
sed -i "s#FEC#$FEC#g" /etc/supervisor/conf.d/supervisord.conf

exec "$@"
