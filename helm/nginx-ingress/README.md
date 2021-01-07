Create namespace
```
$   kubectl create namespace cert-manager
```
Add repo to helm
```
$   helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```

Update to get last revision
```
$   helm repo update
```

Generate values
```
$ helm show values ingress-nginx/ingress-nginx --version v3.13.0 > values.yaml
```

In baremetal verify hostport

Check manifests

```
$ helm install \
  ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --version v3.13.0 \
  -f values.yaml \
  --dry-run \
  --debug
```

Install cert manager helm chart
```
$ helm install \
  -f values.yaml \
  ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --version v1.1.0 \
  --wait

```

Check installation
```
kubectl create -f test


