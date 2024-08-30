# accelerator
maplestory accelerator

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name accelerator -p 8585:8585 --cap-add NET_ADMIN --device=/dev/net/tun -d ghcr.io/thisdk/accelerator:latest

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name accelerator -p 8388:8388 -p 8388:8388/udp -e SIP=xxx.xxx.xxx.xxx --cap-add NET_ADMIN --device=/dev/net/tun -d ghcr.io/thisdk/accelerator:latest

SIP : 设置该值就是客户端模式,这里填入服务器IP,不设置就是服务器模式

FEC : UDP加速FEC参数
