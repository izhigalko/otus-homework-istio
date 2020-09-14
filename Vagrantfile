IMAGE_NAME = "bento/ubuntu-18.04"

Vagrant.configure("2") do |config|
  config.vm.box = IMAGE_NAME
  config.vm.network "forwarded_port", guest: 30000, host: 80, protocol: "tcp"
  config.vm.provider "virtualbox" do |v|
    v.memory = 6144
    v.cpus = 2
  end

  config.vm.provision "shell", privileged: true, inline: <<-SCRIPT
      sudo swapoff -a
      sudo sed -i '/swap/d' /etc/fstab
      sudo apt-get update
      sudo apt-get install -y docker.io apt-transport-https curl
      sudo systemctl start docker
      sudo systemctl enable docker
      sudo apt-get update
      sudo apt-get install -y apt-transport-https wget
      curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
      sudo touch /etc/apt/sources.list.d/kubernetes.list
      echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
      sudo apt-get update
      sudo apt-get install -y kubeadm
      
      curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -      
      echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
      sudo apt-get update
      sudo apt-get install helm
  SCRIPT

  config.vm.define "k8s-master" do |master|
    master.vm.box = IMAGE_NAME
    master.vm.network "private_network", ip: "10.0.0.10"
    master.vm.hostname = "k8s-master"

    config.vm.synced_folder "istio/", "/home/vagrant/istio"
    config.vm.synced_folder "eshop-chart/", "/home/vagrant/eshop-chart"
    config.vm.synced_folder "pv/", "/home/vagrant/pv"

    master.vm.provision "shell", inline: <<-SHELL
      sudo kubeadm init --apiserver-advertise-address=10.0.0.10 --pod-network-cidr=10.244.0.0/16
      mkdir -p $HOME/.kube
      sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      sudo chown $(id -u):$(id -g) $HOME/.kube/config

      kubectl taint node k8s-master node-role.kubernetes.io/master:NoSchedule-
      kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
      wget -nv https://github.com/istio/istio/releases/download/1.6.4/istioctl-1.6.4-linux-amd64.tar.gz
      tar xvvf istioctl-1.6.4-linux-amd64.tar.gz
      sudo cp istioctl /usr/local/bin/

      mkdir -p /home/vagrant/.kube
      sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
      sudo chown -Rf $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube

      istioctl manifest apply -f istio/istio-manifest.yaml
      
      kubectl apply -f pv/pv.yaml
            
      kubectl create namespace eshop            
      kubectl apply -f istio/namespace.yaml -f istio/inbound-http-metrics.yaml  
      
      kubectl create secret generic kiali -n istio-system --from-literal=username=admin --from-literal=passphrase=admin    
      
      helm install eshop ./eshop-chart --namespace=eshop   
      SHELL
  end
end