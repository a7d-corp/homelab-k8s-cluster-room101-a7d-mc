# homelab-k8s-cluster-room101-a7d-mc

This repo manages a Kubernetes cluster (`room101-a7d-mc`) which is used as a ClusterAPI Management Cluster to manage other Workload Clusters.

## Managing secrets

Sensitive configuration can be {en,de}crypted using a Vault instance.

Decryption:

```bash
vault write transit/decrypt/tf-encryption-key -format=json ciphertext=$(cat backend-config.enc) | jq -r .data.plaintext | base64 -d > backend-config
```

Encryption:

```bash
vault write transit/encrypt/tf-encryption-key -format=json plaintext=$(cat backend-config | base64 -w 0) | jq -r .data.ciphertext > backend-config.enc
```
