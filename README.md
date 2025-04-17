# accelerator
maplestory accelerator

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name accelerator -p 8585:8585 --cap-add NET_ADMIN -d ghcr.io/thisdk/accelerator:latest-server

docker run --restart=always --network bridge -e TZ=Asia/Shanghai --name accelerator -p 8588:8588 -e SIP=xx.xx.xx.xx --cap-add NET_ADMIN -d ghcr.io/thisdk/accelerator:latest-client

SIP : 这里填入服务器IP

