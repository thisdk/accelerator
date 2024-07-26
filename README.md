# accelerator
maplestory accelerator

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name accelerator -p 8585:8585 -e TCN=sing-box -e TCP=8388 -e FEC=1:1,2:2,8:6,20:10 --cap-add NET_ADMIN --device=/dev/net/tun -d ghcr.io/thisdk/accelerator:latest

TCN : 目标容器名称

TCP : 目标容器端口

FEC : UDP加速FEC参数
