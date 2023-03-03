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
  config.vm.boot_timeout = 600
  # Configure the first node as a worker node
  config.vm.define "worker" do |node|
    node.vm.box = default_image
    node.vm.box_version = default_version
    node.vm.hostname = "worker.local"
    node.vm.network "private_network", ip: "192.168.50.11"
    node.vm.provider default_provider do |vb|
      vb.name = "worker"
      vb.memory = "2048"
      vb.cpus = "4"
    end
    
    # Join the worker node to the cluster using the token generated by the control-plane node
    node.vm.provision "shell", inline: <<-SHELL
      mkdir -p /home/vagrant/.ssh
      echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLOC4iU08UmLx63PDvhMmUuZLQ1DNkGNACfdDtS6Cn2oz3aSHZuUAQGft8pSTHpFdoMKe9JyDjzdhwNMvvdk/8LPUTXES+nZNji/bcT6HISdF54LnQsJp585pb3gOS4rowYZwJi4OEiEYea3Z2cw5Sz3E1WX3HLgJSTRtOeaVdvLF1jV0l3/DGYyi8OlJ1xh/o3LQLm7hZmVLl5rrWv4yyBHTpnaJqp5Y107NXFPF9Qs9mLqXSZmWQycZ36zU7ZF6rAko+9wOQAdP314x7WHsn0W2DDMCQBxM3yyQ9HRVaAOrPalmXE0k+85aOjzzqk84Oco/L5p6tumrxsJ1s1qmRQ45K/Db54iknGv1McfWBgzZSPKaxYMuypb0dOI7EveVs9vHYThg4tH1vKdVzcm217XCiK8YxYmxHQSpg7V7vWog5/8Sn2CluWcyrs0tPkzpP4M8ZXnyJwElpXFOXFZZjMwxYA9gvP9MxtH6Y42Ba54F793qvRrkalN+V7CcdwQs=' >> /home/vagrant/.ssh/authorized_keys
    SHELL
  end

  # Configure the second node as a nas node
  config.vm.define "nas" do |node|
    node.vm.box = default_image
    node.vm.box_version = default_version
    node.vm.hostname = "nas.local"
    node.vm.network "private_network", ip: "192.168.50.12"
    node.vm.provider default_provider do |vb|
      vb.name = "nas"
      vb.memory = "2048"
      vb.cpus = "4"
    end
    
    # Join the nas node to the cluster using the token generated by the control-plane node
    node.vm.provision "shell", inline: <<-SHELL
      mkdir -p /home/vagrant/.ssh
      echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLOC4iU08UmLx63PDvhMmUuZLQ1DNkGNACfdDtS6Cn2oz3aSHZuUAQGft8pSTHpFdoMKe9JyDjzdhwNMvvdk/8LPUTXES+nZNji/bcT6HISdF54LnQsJp585pb3gOS4rowYZwJi4OEiEYea3Z2cw5Sz3E1WX3HLgJSTRtOeaVdvLF1jV0l3/DGYyi8OlJ1xh/o3LQLm7hZmVLl5rrWv4yyBHTpnaJqp5Y107NXFPF9Qs9mLqXSZmWQycZ36zU7ZF6rAko+9wOQAdP314x7WHsn0W2DDMCQBxM3yyQ9HRVaAOrPalmXE0k+85aOjzzqk84Oco/L5p6tumrxsJ1s1qmRQ45K/Db54iknGv1McfWBgzZSPKaxYMuypb0dOI7EveVs9vHYThg4tH1vKdVzcm217XCiK8YxYmxHQSpg7V7vWog5/8Sn2CluWcyrs0tPkzpP4M8ZXnyJwElpXFOXFZZjMwxYA9gvP9MxtH6Y42Ba54F793qvRrkalN+V7CcdwQs=' >> /home/vagrant/.ssh/authorized_keys
    SHELL
  end

  # Configure the third node as the control plane
  config.vm.define "control-plane" do |node|
    node.vm.box = default_image
    node.vm.box_version = default_version
    node.vm.hostname = "control-plane.local"
    node.vm.network "private_network", ip: "192.168.50.10"
    node.vm.provider default_provider do |vb|
      vb.name = "control-plane"
      vb.memory = "2048"
      vb.cpus = "8"
    end
    
    # Install Dependencies and SSH Authentication
    node.vm.provision "shell", inline: <<-SHELL
      sudo dnf install -y ansible git
      # Setup the public and private key for the vagrant user
      mkdir -p /home/vagrant/.ssh
      echo 'ssh-rsa /8LPUTXES+nZNji/bcT6HISdF54LnQsJp585pb3gOS4rowYZwJi4OEiEYea3Z2cw5Sz3E1WX3HLgJSTRtOeaVdvLF1jV0l3/DGYyi8OlJ1xh/o3LQLm7hZmVLl5rrWv4yyBHTpnaJqp5Y107NXFPF9Qs9mLqXSZmWQycZ36zU7ZF6rAko+9wOQAdP314x7WHsn0W2DDMCQBxM3yyQ9HRVaAOrPalmXE0k+85aOjzzqk84Oco/L5p6tumrxsJ1s1qmRQ45K/Db54iknGv1McfWBgzZSPKaxYMuypb0dOI7EveVs9vHYThg4tH1vKdVzcm217XCiK8YxYmxHQSpg7V7vWog5/8Sn2CluWcyrs0tPkzpP4M8ZXnyJwElpXFOXFZZjMwxYA9gvP9MxtH6Y42Ba54F793qvRrkalN+V7CcdwQs=' >> /home/vagrant/.ssh/authorized_keys
      echo 'LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFBQUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUJsd0FBQUFkemMyZ3RjbgpOaEFBQUFBd0VBQVFBQUFZRUF5emd1SWxOUEZKaThldHp3NzRUSmxMbVMwTlF6WkJqUUFuM1E3VXVncDlxTTkya2gyYmxBCkVCbjdmS1VreDZSWGFEQ252U2NnNDgzWWNEVEw3M1pQL0N6MUUxeEV2cDJUWTR2MjNFK2h5RW5SZWVDNTBMQ2FlZk9hVzkKNERrdUs2TUdHY0NZdURoSWhHSG10MmRuTU9Vczl4TlZsOXh5NENVazBiVG5tbFhieXhkWTFkSmQvd3htTW92RHBTZGNZZgo2TnkwQzV1NFdabFM1ZWE2MXIrTXNnUjA2WjJpYXFlV05kT3pWeFR4ZlVMUFppNmwwbVpsa01uR2QrczFPMlJlcXdKS1B2CmNEa0FIVDk5ZU1lMWg3SjlGdGd3ekFrQWNUTjhza1BSMFZXZ0RxejJwWmx4TkpQdk9Xam84ODZwUE9EbktQeSthZXJicHEKOGJDZGJOYXBrVU9PU3Z3MitlSXBKeHI5VEhIMWdZTTJVanltc1dETHNxVzlIVGlPeEwzbGJQYngyRTRZT0xSOWJ5blZjMwpKdHRlMXdvaXZHTVdKc1IwRXFZTzFlNzFxSU9mL0VwOWdwYmxuTXE3TkxUNU02VCtEUEdWNThpY0JKYVZ4VGx4V1dZek1NCldBUFlMei9UTWJSK21PTmdXdWVCZS9kNnIwYTVHcFRmbGV3bkhjRUxBQUFGb0JHUTFoUVJrTllVQUFBQUIzTnphQzF5YzIKRUFBQUdCQU1zNExpSlRUeFNZdkhyYzhPK0V5WlM1a3REVU0yUVkwQUo5ME8xTG9LZmFqUGRwSWRtNVFCQVorM3lsSk1lawpWMmd3cDcwbklPUE4ySEEweSs5MlQvd3M5Uk5jUkw2ZGsyT0w5dHhQb2NoSjBYbmd1ZEN3bW5uem1sdmVBNUxpdWpCaG5BCm1MZzRTSVJoNXJkblp6RGxMUGNUVlpmY2N1QWxKTkcwNTVwVjI4c1hXTlhTWGY4TVpqS0x3NlVuWEdIK2pjdEF1YnVGbVoKVXVYbXV0YS9qTElFZE9tZG9tcW5salhUczFjVThYMUN6Mll1cGRKbVpaREp4bmZyTlR0a1hxc0NTajczQTVBQjAvZlhqSAp0WWV5ZlJiWU1Nd0pBSEV6ZkxKRDBkRlZvQTZzOXFXWmNUU1Q3emxvNlBQT3FUemc1eWo4dm1ucTI2YXZHd25XeldxWkZECmprcjhOdm5pS1NjYS9VeHg5WUdETmxJOHByRmd5N0tsdlIwNGpzUzk1V3oyOGRoT0dEaTBmVzhwMVhOeWJiWHRjS0lyeGoKRmliRWRCS21EdFh1OWFpRG4veEtmWUtXNVp6S3V6UzArVE9rL2d6eGxlZkluQVNXbGNVNWNWbG1NekRGZ0QyQzgvMHpHMApmcGpqWUZybmdYdjNlcTlHdVJxVTM1WHNKeDNCQ3dBQUFBTUJBQUVBQUFHQkFJanl5anc5a2l4YUphSlNwRmQxVC9kVys3CmFaV2l5WmdBdzl4Mzh5bVFpbEFweDBqK2hPcS9wdDJBbU9yUE9STDRvNlI3L3p6M2xWTGdlbnZNc2FHeHJoSFNNMzZlZmUKL3dWMXZCMkoySWZHSDFHWC9RRERFc2NlUUNhcXZoUE5rUldyb2VEWTBQK09hbHB6cHZoNTN1dzFlYUF2TjlEems0THREWApyY0JYSGZDR1FrcU9JdVFPOGd3Y0hmTjlUQWVKNlBwUkd4bGhGamZ2Y0pmMTNhNWpETlNoQnBONXZTWmlyT0NLeWxvM3Y3CmV4THNXcmtvWWtlcGdvTXIwY3E5ZnM2bkNjOStRdlJVVGZ6YUhJdXVSYytBT1JTQVl2cUZ2TERQaCs3K0xoVXBEc3pIc3YKM2kyTnJnMElKOHdEZldvVFdFd1Zhd3VvYlI0VVVYeTVMbEk1V1I2UGhubjVEQWJ1djRhQytQeDl3Ym45emtGSk1rdjU2Mwo3Z0MxZjlKS3dDWUFsR0dZWS9GSnJIdks5V01pNUhjM3FJRHdaKzk3UmdodlZiQ2ZWL0VoMnlwMWI1UmtSUkFzOWduQmFpCi9uRnhFUzRMbG1PdllGYVV3QnJVVUNqcThDRTd4R1Z1OUV6OWFBcVgrQ3M5MjJtTG5FYllOVjVvQXJTYUJXWDVxbmdRQUEKQU1BWnlNZGNTUzFYN09WcEpoMHcvYnMyQXkyQ1NYV3lSb3B1MVZRemo0bGppTmxKT0oxb1Ywa2tCWnI4Wk8xWXJvc28rNQpNb0hNWlp3RVpuMm84ZGtHTlU0TnhkS1FRWUFHQlVkUlBRQndTaXAreDhTR0lYTWRaS2w3R2dGZ3E1YjdZWWxVVDEzUGdICmJGaUFlQm9FTytyS3Vad084M05OaTc1cDRyM3ZGaXFiaUZpVDB5T2dYRjhZUTR5ZENmUjFqdWJIZWpoSGYrTjFqYmMyVkEKRHEzdUFpVmJXSzB6alhWMnplYTN0RnBsQ2tPclp1L05ZYW5RcEt5MitjNFJaQ242MEFBQURCQVBHbFk5dmU4ZGNGYTAxRgo5NDdLcVZMbThEeWNJeFppK2RsaU1OV2ZVSEEzeERicXpKVGhiYklLelAxWWhkNjRsVExKTE13L3Ftd2dHZGlKOVFRRmloCnJVcERaRCt2dkppU3I3KzFkOEczcjVTNmRuV1pRQU5YTlRFU1oxRklHYVhMRnQ5YUxVRE5yOWs1eGlMc2ZqaTZXL1ZSUzEKZlFXVmtHNk5zVzFyZjN5OStHY3pRbjlCcjNLaU04Y3pvdXA0LzYrNjNtd0trKy9aU0VMemlIZjdxaXdkejVFZXQ3QXlUagpJZEtSR1cveXJ3QUlmRk1oSmJzTFE5ZkxYdVpHOGh3UUFBQU1FQTEwcHo5bEZJaVVHc3JrMFBSVlBkSzcyZ2xyVFVxZVJyCng0dHEvbFRlZVR4QVFldHVCZTgwcnhmRzR6VnZpek1Hd0xKaU5TNlQvZFFTY2RNY0hUUTBYY1cyaUFUa2UwREhZQW5RbjUKNlc2N1hCWHRZYXJ6UFBqRjI0cS95TlZ1NHJZMWFFNU5PSjFEZ2hDWitQMGV4VjdYNVRoUVJrWjBnNk1ta1hmWEh6MlRLKworRXJtVW5aU0s3TXp5VzA0T2VCelFZS05GalAvUUpJNVRiY1hHT2xpazBiY3ZVaTUzZURaKyt0S01JMnJLank3NGwyY1JrCkRIMDdSQWxGN3VzejNMQUFBQUpIUjZZV3R5WVdwelFGUm9iMjFoYzNOaFkxTjBkV1JwYnk1c2IyTmhiR1J2YldGcGJnRUMKQXdRRkJnPT0KLS0tLS1FTkQgT1BFTlNTSCBQUklWQVRFIEtFWS0tLS0tCg==' | base64 -d > /home/vagrant/.ssh/id_rsa
      sudo chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.ssh/id_rsa
      sudo chmod 600 /home/vagrant/.ssh/id_rsa
    SHELL
    
    # Clone the k8s-ansible repository and execute run.sh
    node.vm.provision "shell", inline: <<-SHELL
      sudo -i -u vagrant bash -c "git clone https://github.com/Cloud-Fortress/k8s-ansible.git"
      # run the playbook
      cd k8s-ansible
      ANSIBLE_HOST_KEY_CHECKING=False ./run.sh -i inventory/staging.yml playbooks/kube.yml
    SHELL
    
    # Initialize the control plane and generate a token
    node.vm.provision "shell", inline: <<-SHELL
      sudo kubeadm init --apiserver-advertise-address=192.168.50.10 --pod-network-cidr=10.244.0.0/16
      mkdir -p /home/vagrant/.kube
      sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
      sudo chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config
      kubeadm token create --print-join-command > /vagrant/.kube-join-command.sh
      chmod +x /vagrant/.kube-join-command.sh
    SHELL
  end
end