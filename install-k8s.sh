#!/bin/bash

# Instalação dos módulos do kernel
sudo modprobe overlay
sudo modprobe br_netfilter

# Configurando parametros sysctl

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

# Instalando e configurando pacotes K8S
sudo apt-get install gnupg
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
mkdir /etc/apt/keyrings
wget -O- https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor >kubernetes-archive-keyring.gpg
mv kubernetes-archive-keyring.gpg /etc/apt/trusted.gpg.d/
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Instalando e configurando GO
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -xf go1.21.0.linux-amd64.tar.gz -C /usr/local
export PATH=$PATH:/usr/local/go/bin
go version

# Instalando e configurando cri-docker
apt install -y git make
git clone https://github.com/Mirantis/cri-dockerd.git
cd cri-dockerd
make cri-dockerd
mkdir -p /usr/local/bin
install -o root -g root -m 0755 cri-dockerd /usr/local/bin/cri-dockerd
install packaging/systemd/* /etc/systemd/system
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable cri-docker.service
systemctl enable --now cri-docker.socket

# Iniciando cluster
kubeadm init

# configurando kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Gerando o comando join e executando nos nodes
kubeadm token create --print-join-command
