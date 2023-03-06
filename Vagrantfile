# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Set the default image and provider to use
  default_image = "rockylinux/9"
  default_version = "1.0.0"
  default_provider = "virtualbox"
  # Choose a different image and provider for macOS
  if RUBY_PLATFORM =~ /darwin/
    default_image = "marcinbojko/rockylinux9_arm64"
    default_version = "9.1.1"
    default_provider = "parallels"
  end
  # Choose a different image and provider for Linux
  if RUBY_PLATFORM =~ /linux/
    default_provider = "libvirt"
  end
  # Run Ansible Playbook
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "./ansible/playbooks/kube.yml"
    ansible.inventory_path = "./ansible/inventory"
  end
  config.vm.boot_timeout = 600
  # Configure the first node as a worker node
  config.vm.define "worker.local" do |node|
    node.vm.box = default_image
    node.vm.box_version = default_version
    node.vm.hostname = "worker.local"
    node.vm.provider default_provider do |vb|
      vb.name = "worker.local"
      vb.memory = "2048"
      vb.cpus = "4"
    end
  end

  # Configure the second node as a nas node
  config.vm.define "nas.local" do |node|
    node.vm.box = default_image
    node.vm.box_version = default_version
    node.vm.hostname = "nas.local"
    node.vm.provider default_provider do |vb|
      vb.name = "nas.local"
      vb.memory = "2048"
      vb.cpus = "4"
    end
  end

  # Configure the third node as the control plane
  config.vm.define "control-plane.local" do |node|
    node.vm.box = default_image
    node.vm.box_version = default_version
    node.vm.hostname = "control-plane.local"
    node.vm.provider default_provider do |vb|
      vb.name = "control-plane.local"
      vb.memory = "4096"
      vb.cpus = "8"
    end
    # Initialize the control plane and generate a token
    node.vm.provision "shell", inline: <<-SHELL
      sudo kubeadm init --pod-network-cidr=10.244.0.0/16
      mkdir -p /home/vagrant/.kube
      sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
      sudo cp -i /etc/kubernetes/admin.conf /vagrant/admin.conf
      sudo chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config
      kubeadm token create --print-join-command > /vagrant/.kube-join-command.sh
      chmod +x /vagrant/.kube-join-command.sh
    SHELL
  end
end