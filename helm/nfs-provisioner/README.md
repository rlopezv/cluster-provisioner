Install nfs server & clients

It's quite diferent for CentOS & Ubuntu

Ubuntu

Server Side

$ sudo apt update

$ sudo apt install nfs-kernel-server

$ sudo mkdir -p /mnt/nfs_kubernetes

$ sudo chown -R nobody:nogroup /mnt/nfs_kubernetes/

Edit /etc/exports and add shared volume

/mnt/nfs_kubernetes *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)

$ sudo exportfs -a
$ sudo systemctl restart nfs-kernel-server

Check shared

$ sudo exportfs -v

Check firewall status

Clien side

$ sudo apt update
$ sudo apt install nfs-common

Check access

$ sudo mkdir -p /mnt/nfs_kubernetes_share
$ sudo mount <server_ip>:/mnt/nfs_kubernetes  /mnt/nfs_kubernetes_share

Remove mount
$ sudo umount /mnt/nfs_kubernetes_share


CentOS

More or less the same using yum & user nfsnobody instead of nobody


Create namespace
```
$   kubectl create namespace cert-manager
```
Add repo to helm
```
$   helm repo add stable https://charts.helm.sh/stable --force-update
```

Update to get last revision
```
$   helm repo update
```

Generate values
```
$ helm show values stable/nfs-client-provisioner --version v1.2.11> values.yaml

```

Modify values



Check manifests
```
$ helm install \
  nfs-provisioner stable/nfs-client-provisioner \
  --namespace nfs-provisioner \
  --version v1.2.11 \
  -f values.yaml \
  --dry-run \
  --debug
```

Install cert manager helm chart
```
$ helm install \
  -f values.yaml \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.1.0 \
  --wait
  # --set installCRDs=true \

```

Check installation
```
kubectl create -f test

kubectl describe certificate -n cert-manager-test
```

Create a cluster-issuer (ca-cluster-issuer)
