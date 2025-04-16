# accelerator
maplestory accelerator

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name accelerator -p 8585:8585 --cap-add NET_ADMIN -d ghcr.io/thisdk/accelerator:latest

docker run --restart=always --network bridge -e TZ=Asia/Shanghai --name accelerator -p 8588:8588 -e SIP=xx.xx.xx.xx --cap-add NET_ADMIN -d ghcr.io/thisdk/accelerator:latest

SIP : 设置该值就是客户端模式,这里填入服务器IP,不设置就是服务器模式

