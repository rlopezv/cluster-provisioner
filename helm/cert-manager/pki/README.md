
# Generate private CA & Certificate

https://scriptcrunch.com/create-ca-tls-ssl-certificates-keys/

https://www.golinuxcloud.com/tutorial-pki-certificates-authority-ocsp/


## Generate Self Signed Certificate

### Generate key
openssl genrsa -out self_signed.key 2048

## Generate request
openssl req -new -key self_signed.key -out self_signed.csr -config self_signed.conf


## Generate certificate
openssl x509 -req -days 365 -in self_signed.csr -signkey self_signed.key -extensions req_ext -extfile self_signed.conf -out self_signed.crt

## Check values
openssl rsa -noout -text -in self_signed.key
openssl req -noout -text -in self_signed.csr
openssl x509 -noout -text -in self_signed.crt

## Generate CA

### Generate key
openssl genrsa -out ca.key 2048

## Generate request
openssl req -new -key ca.key -out ca.csr -config ca.conf

## Generate ca certificate
openssl x509 -req -days 365 -in ca.csr -signkey ca.key -extensions req_ext -extfile -out ca.crt


### Generate server key
openssl genrsa -out signed.key 2048

## Generate server request
openssl req -new -key signed.key -out signed.csr -config signed.conf


## Generate CA Signed certificate

openssl x509 -req -days 365 -in signed.csr -CA ca.crt -CAkey ca.key -CAcreateserial -extensions req_ext -extfile self_signed.conf -out ca_signed.crt



request_extensions includes additional attributes including if it¡s a CA or the expedted usage of the certificate

Include parameters in generation:
-extensions
-extfile

## Generate PEM
cat ca.crt ca.key > ca.pem

## Bundle crt
cat your_domain.crt intermediate.crt root.crt >> ssl-bundle.crt

# Install cert-manager


# Helm v3+
$ helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.1.0 \
  # --set installCRDs=true


watch kubectl get all --namespace cert-manager

Generar isuser (selfsigned):
kubectl create -f selfsigned.yaml -n cert-manager

Generar certificado
kubectl create -f selfsigned.cert.yaml -n cert-manager

Comprobar
kubectl describe certificate -n cert-manager





