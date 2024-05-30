# accelerator
maplestory accelerator

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name accelerator -p 8686:8686 --cap-add NET_ADMIN --device=/dev/net/tun -d ghcr.io/thisdk/accelerator:latest
