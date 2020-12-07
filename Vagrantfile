require "yaml"
require "vagrant-hosts"

VAGRANTFILE_API_VERSION = "2"

$settings = YAML.load_file "settings.yaml"

IMAGE_NAME = $settings['os']
NUM_MASTERS = $settings['num-masters']
NUM_WORKERS = $settings['num-nodes']
CONTROLLER = $settings['controller']

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.ssh.insert_key = false

    config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 2
    end
      
    (1..NUM_MASTERS).each do |i|
        config.vm.define "master-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.box_check_update = false
            node.vm.network "private_network", ip: "192.168.50.#{i+10}"
            node.vm.hostname = "master-#{i}"
            if Vagrant.has_plugin?("vagrant-hosts")
                node.vm.provision :hosts, :sync_hosts => true, :add_local_hostnames => false
            end
            node.vm.provision "ansible" do |ansible|
                 ansible.playbook = "ansible/master-playbook.yml"
                 ansible.extra_vars = {
                     node_ip: "192.168.50.#{i + 10}",
                 }
            end
        end
    end

    # config.vm.define "master" do |master|
    #     master.vm.box = IMAGE_NAME
    #     master.vm.network "private_network", ip: "192.168.50.10"
    #     master.vm.hostname = "k8s-master"
    #     master.vm.provision "ansible" do |ansible|
    #         ansible.playbook = "ansible/master-playbook.yml"
    #         ansible.extra_vars = {
    #             node_ip: "192.168.50.10",
    #         }
    #     end
    # end

    (1..NUM_WORKERS).each do |i|
        config.vm.define "worker-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "192.168.50.#{i + 100}"
            node.vm.hostname = "worker-#{i}"
            if Vagrant.has_plugin?("vagrant-hosts")
                node.vm.provision :hosts, :sync_hosts => true, :add_local_hostnames => false
            end
            node.vm.provision "ansible" do |ansible|
                 ansible.playbook = "ansible/node-playbook.yml"
                 ansible.extra_vars = {
                     node_ip: "192.168.50.#{i + 100}",
                 }
            end
        end
    end

    if CONTROLLER
        config.vm.define "controller" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "192.168.50.100"
            node.vm.hostname = "controller"
            if Vagrant.has_plugin?("vagrant-hosts")
                node.vm.provision :hosts, :sync_hosts => true, :add_local_hostnames => false
            end
        node.vm.provision "ansible" do |ansible|
             ansible.playbook = "ansible/controller-playbook.yml"
             ansible.extra_vars = {
                 node_ip: "192.168.50.100",
             }
        end
        node.vm.provision "shell",
            path: "script/provision.sh"
        end
    end
end