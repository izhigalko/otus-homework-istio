IMAGE_NAME = "bento/ubuntu-18.04"

Vagrant.configure("2") do |config|
  config.vm.box = IMAGE_NAME
  config.vm.provider "virtualbox" do |v|
    v.memory = 4192
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

  SCRIPT

  config.vm.define "k8s-master" do |master|
    master.vm.box = IMAGE_NAME
    master.vm.network "private_network", ip: "10.0.0.10"
    master.vm.hostname = "k8s-master"

    master.vm.provision "file", source: "istio", destination: "istio"
    master.vm.provision "file", source: "app", destination: "app"
    master.vm.provision "file", source: "manage-traffic", destination: "manage-traffic"
    master.vm.provision "file", source: "proxy-config", destination: "proxy-config"

    config.vm.network "forwarded_port", guest: 32080, host: 32080
    config.vm.network "forwarded_port", guest: 32081, host: 32081
    config.vm.network "forwarded_port", guest: 32082, host: 32082
    config.vm.network "forwarded_port", guest: 32083, host: 32083
    config.vm.network "forwarded_port", guest: 1433, host: 1433

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

    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
    curl https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list > /etc/apt/sources.list.d/mssql-server.list
    curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/msprod.list
    apt-get update
    apt-get install -y mssql-server
    sudo MSSQL_PID=Developer ACCEPT_EULA=Y MSSQL_SA_PASSWORD='Psd1234%' /opt/mssql/bin/mssql-conf -n setup
    sudo ACCEPT_EULA=y apt-get install -y mssql-tools
    sudo wget -nv -P /opt/mssql-tools https://github.com/eugeniyas/otus-lab12/raw/master/SqlScripts.tar.gz 
    sudo tar --directory=/opt/mssql-tools/ -xvvf /opt/mssql-tools/SqlScripts.tar.gz
     /opt/mssql-tools/bin/sqlcmd -S 10.0.0.10 -U sa -P Psd1234% -i /opt/mssql-tools/SqlScripts/CreateAttachmentDb.sql
     /opt/mssql-tools/bin/sqlcmd -S 10.0.0.10 -U sa -P Psd1234% -i /opt/mssql-tools/SqlScripts/CreateHematologyDb.sql
     /opt/mssql-tools/bin/sqlcmd -S 10.0.0.10 -U sa -P Psd1234% -i /opt/mssql-tools/SqlScripts/CreateMedExaminationDb.sql
     /opt/mssql-tools/bin/sqlcmd -S 10.0.0.10 -U sa -P Psd1234% -i /opt/mssql-tools/SqlScripts/CreateOperationDb.sql
     /opt/mssql-tools/bin/sqlcmd -S 10.0.0.10 -U sa -P Psd1234% -i /opt/mssql-tools/SqlScripts/CreateRegistryDb.sql
     sudo curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
     sudo iptables -t nat -A PREROUTING --dst 10.0.0.10 -p tcp --dport 20001 -j DNAT --to-destination 127.0.0.1
     
    SHELL
  end
end