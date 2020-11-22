TODO
ansible

TODO
En controller:
process known_hosts
allow remote passwordless login
ssh-keygen
ssh-copy-id <user>@<server>


Kubespray

https://github.com/kubernetes-sigs/kubespray

# clone the remote repository
$ git clone https://github.com/kubernetes-sigs/kubespray.git
$git checkout tags/v2.14.2

# switch to the specific tag
$ git checkout tags/v2.14.2

# Install dependencies from ``requirements.txt``
sudo pip3 install -r requirements.txt

# Copy ``inventory/sample`` as ``inventory/mycluster``
cp -rfp inventory/sample inventory/cluster

# Update Ansible inventory file with inventory builder
declare -a IPS=(192.168.50.11 192.168.50.101 192.168.50.102)
CONFIG_FILE=inventory/cluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# Review and change parameters under ``inventory/mycluster/group_vars``
cat inventory/cluster/group_vars/all/all.yml
cat inventory/cluster/group_vars/k8s-cluster/k8s-cluster.yml

# Deploy Kubespray with Ansible Playbook - run the playbook as root
# The option `--become` is required, as for example writing SSL keys in /etc/,
# installing packages and interacting with various systemd daemons.
# Without --become the playbook will fail to run!
ansible-playbook -i inventory/cluster/hosts.yaml  --become --become-user=root cluster.yml


cp kubespray/inventory/cluster/artifacts/admin.conf ~/.kube/config


Rancher
https://rancher.com/docs/rancher/v2.x/en/installation/

Notas:
Para permitir a chrome que acceda a localhost con autocertificado
chrome://flags/#allow-insecure-localhost

Obtener token de acceso para el usario creado para poder acceder al dashboard instalado por defecto
kubectl get secret -n kube-system $(kubectl get serviceaccount admin-user -n kube-system -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode
