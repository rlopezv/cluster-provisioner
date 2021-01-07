Create namespace
```
$   kubectl create namespace postgres
```
Add repo to helm
```
$   helm repo add bitnami https://charts.bitnami.com/bitnami
```

Update to get last revision
```
$   helm repo update
```

Generate values
```
$ helm show values bitnami/postgresql --version v10.1.2 > values.yaml
```

In baremetal verify hostport

Check manifests

```
$ helm install \
  postgres bitnami/postgresql \
  --namespace postgres \
  --version v10.1.2 \
  -f values.yaml \
  --dry-run \
  --debug
```

Install helm chart
```
$ helm install \
  postgres bitnami/postgresql \
  --namespace postgres \
  --version v10.1.2 \
  -f values.yaml \
  --wait

```

Check installation
```
To get the password for "postgres" run:

    export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)

To connect to your database run the following command:

    kubectl run postgres-postgresql-client --rm --tty -i --restart='Never' --namespace postgres --image docker.io/bitnami/postgresql:11.10.0-debian-10-r21 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgres-postgresql -U postgres -d postgres -p 5432

