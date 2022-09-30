sudo apt-get update
sudo apt-get dist-upgrade -y 
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo addgroup aka docker

#------------------

sudo nano /etc/docker/daemon.json >> 
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}

sudo systemctl restart docker
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo nano /etc/fstab # remove swap
sudo reboot 
docker login
git config --global user.name "akadon"
git config --global user.email "akaxdon@gmail.com"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash 

#----

sudo kubeadm init --pod-network-cidr=192.168.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f website/settings
kubectl apply -f website/app

#----

sudo apt install npm -y 
npm install /home/aka/website/code/backend/nodejs

#----
sudo apt-get install ruby-full
sudo apt install ruby-railties
sudo apt  install ruby-bundler

#---

curl -L https://istio.io/downloadIstio | sh -
export PATH=$PWD/bin:$PATH/istio-1.9.2
istioctl install -y
kubectl label namespace default istio-injection=enabled
kubectl apply -f website/settings//istio

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
export INGRESS_HOST=192.168.178.38
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

istioctl dashboard kiali
