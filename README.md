# accelerator
maplestory accelerator

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name accelerator -p 8585:8585/udp -e MODE=udp --cap-add NET_ADMIN -d ghcr.io/thisdk/accelerator:latest-server

docker run --restart=always --network bridge -e TZ=Asia/Shanghai --name accelerator -p 8588:8588 -e SERVER=xx.xx.xx.xx:xxx -e MODE=udp --cap-add NET_ADMIN -d ghcr.io/thisdk/accelerator:latest-client

SERVER : 这里填入服务器IP与端口

MODE : udp2raw 的 raw mode , 默认 faketcp 

