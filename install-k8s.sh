#!/bin/bash

# atualizando repositorios
sudo apt-get update

#instalando depencias k8s
sudo apt-get install -y apt-transport-https ca-certificates curl gpg build-essential docker.io

# criando pasta para gpg k8s
sudo mkdir -m 755 /etc/apt/keyrings

# download gpg key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# adicionando repositorios
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# atualizando repositorios
sudo apt-get update

# instalando modulos k8s
sudo apt-get install -y kubelet kubeadm kubectl

# mark hold modulos
sudo apt-mark hold kubelet kubeadm kubectl

# baixando golang
wget https://go.dev/dl/go1.19.4.linux-amd64.tar.gz

# instalando golang
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

# download e instalação cri-docker 
git clone https://github.com/Mirantis/cri-dockerd.git
cd cri-dockerd
make cri-dockerd
mkdir -p /usr/local/bin
install -o root -g root -m 0755 cri-dockerd /usr/local/bin/cri-dockerd
install packaging/systemd/* /etc/systemd/system
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable --now cri-docker.socket
