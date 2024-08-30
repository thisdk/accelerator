#!/bin/sh

: ${SIP:=SERVER}
: ${FEC:=1:1,2:2,8:6,20:10}

# 根据 TYPE 变量的值执行不同的操作
if [ "$TYPE" = "SERVER" ]; then
    sleep 3
    TIP=$(dig +short sing-box)
    iptables -t nat -A PREROUTING -p tcp --dport 8388 -j DNAT --to-destination $TIP:8388
    iptables -t nat -A PREROUTING -p udp --dport 8388 -j DNAT --to-destination $TIP:8388
    iptables -t nat -A POSTROUTING -d $TIP -p tcp --dport 8388 -j MASQUERADE
    iptables -t nat -A POSTROUTING -d $TIP -p udp --dport 8388 -j MASQUERADE
    cp -f /etc/supervisor/conf.d/supervisord-server.conf.backup /etc/supervisor/conf.d/supervisord.conf
else
    iptables -t nat -A PREROUTING -p tcp --dport 8388 -j DNAT --to-destination 10.18.38.1:8388
    iptables -t nat -A PREROUTING -p udp --dport 8388 -j DNAT --to-destination 10.18.38.1:8388
    cp -f /etc/supervisor/conf.d/supervisord-client.conf.backup /etc/supervisor/conf.d/supervisord.conf
    sed -i "s#SIP#$SIP#g" /etc/supervisor/conf.d/supervisord.conf
fi

sed -i "s#FEC#$FEC#g" /etc/supervisor/conf.d/supervisord.conf

exec "$@"
