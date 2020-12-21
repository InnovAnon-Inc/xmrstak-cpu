#! /usr/bin/env bash
set -euxo pipefail
(( ! $# ))
(( ! $UID ))

# fix dkms cc version mismatch
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 40

# install cuda
sudo ./NVIDIA-Linux-x86_64-390.138.run

sudo update-initramfs -u
nvidia-smi -a

# install nvidia-enabled docker
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey |
sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list |
sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
sudo apt install nvidia-docker2
sudo systemctl restart docker

docker run --name nvidia-driver -d --privileged --pid=host -v /run/nvidia:/run/nvidia:shared -v /var/log:/var/log --restart=unless-stopped nvidia/driver:396.37-ubuntu16.04

docker run --rm --gpus all nvidia/cuda:9.0-base nvidia-smi

#nvidia-visual-profiler nvidia-opencl-dev nvidia-cuda-dev

