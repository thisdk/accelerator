# accelerator
maplestory accelerator

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name accelerator -p 8585:8585 -e TCN=wireguard -e TCP=51820 -e FEC=1:1,2:2,8:6,20:10 --cap-add NET_ADMIN -d ghcr.io/thisdk/accelerator:latest

### 环境变量

TCN : 目标容器名称

TCP : 目标容器端口

FEC : UDP加速FEC参数
