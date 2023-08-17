# Shell-install-k8s
Shell script install k8s cri-docker

**Importante:** este é um trabalho em andamento.

**Ainda mais importante:** Se você realmente planeja usar isso, não se esqueça de editar os arquivos de configuração de acordo com suas necessidades (arquivos de serviço, arquivos de configuração YAML, etc.). Os arquivos de configuração fornecidos aqui são apenas arquivos genéricos.

Este script baixa os arquivos no diretório atual. Você poderia mudar isso.

Quaisquer sugestões e contribuições são bem-vindas.

Após utilizar o SH você tera duas opções, iniciar o cluster ou entrar em um cluster existente.

# Iniciar cluster.

* sudo kubeadm init  --cri-socket unix:///var/run/cri-dockerd.sock

# Obter infos do cluster.

* kubeadm token create --print-join-command
  
# Entrar no cluster.
* kubeadm join (infos do cluster) --cri-socket unix:///var/run/cri-dockerd.sock

## Instalação completa

A instalação completa instalará o seguinte:

* Cluster k8s
