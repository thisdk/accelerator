# accelerator
maplestory accelerator

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name accelerator -p 8383:8383 -p 8585:8585 -d ghcr.io/thisdk/accelerator:latest

docker run --restart=always --network jason -e TZ=Asia/Shanghai --name accelerator -p 8388:8388 -p 8588:8588/udp -e SIP=xxx.xxx.xxx.xxx -d ghcr.io/thisdk/accelerator:latest

SIP : 设置该值就是客户端模式,这里填入服务器IP,不设置就是服务器模式

