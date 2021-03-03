# AKS API server on proxy
This repo demonstrates automating solution to get predictable Kubernetes API server endpoints for AKS in order to be used for whitelisting on HTTP proxy in highly. secured environments.

First iteration is using connection over Internet. Second iteration will use private cluster and VPN/ER.

# Guide
First prepare DNS zone in order to get wildcard certificate from Let's encrypt.

```bash
# Configure your DNS zone
export TF_VAR_ZONE=aks.tomaskubica.net

# Deploy DNS zone only first
terraform apply -auto-approve -target azurerm_resource_group.dns -target azurerm_dns_zone.dns
```

Point your NS records towards Azure DNS.

Get wildcard certificate from Let's encrypt using DNS challenge.

```bash
sudo certbot certonly --manual --preferred-challenges dns -d '*.aks.tomaskubica.net'

sudo openssl pkcs12 -export -out cert.pfx \
    -inkey /etc/letsencrypt/live/aks.tomaskubica.net/privkey.pem \
    -in /etc/letsencrypt/live/aks.tomaskubica.net/cert.pem \
    -certfile /etc/letsencrypt/live/aks.tomaskubica.net/chain.pem

sudo cp /etc/letsencrypt/live/aks.tomaskubica.net/cert.pem ./proxycert.pem
```

Certificate is ready, we can deploy.

```bash
export TF_VAR_zone=aks.tomaskubica.net
export TF_VAR_pfxpassword=Azure12345678
terraform apply -auto-approve
```

Get kubeconfig and change endpoint and server certificate information.

```bash
az aks get-credentials -n aks-aks1 -g aks1-rg -f kube.config
```

Manualy change public certificate and hostname and test.

```bash
# Get public cert of proxy
cat proxycert.pem | base64 -w 0

# Modify kubeconfig and use
export KUBECONFIG=kube.config
kubectl get nodes
```

# Next steps
- Automate exporting patched kubeconfig
- Redesign to use less resources (currently one App Gw per cluster -> some shared model)
- Automate enrollment of public certificate
- Refactor App Gw to store certificate in Key Vault
- Add whitelisting on API server so only App Gw can access it
- Add NSG to specify source range of CI/CD agents or specific networks/IPs allowed to talk to gateway

