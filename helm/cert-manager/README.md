Create namespace
```
$   kubectl create namespace cert-manager
```
Add repo to helm
```
$   helm repo add jetstack https://charts.jetstack.io
```

Update to get last revision
```
$   helm repo update
```

Generate values
```
$ helm show values jetstack/cert-manager --values v1.1.0> values.yaml
```

Include CRDs installation

Check manifests
```
$ helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.1.0 \
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

Create a cluster-issuer
