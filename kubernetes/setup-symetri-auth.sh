#!/bin/bash

set -e

echo "Setting up Symetri Kubernetes Authentication..."

# Apply resources
kubectl apply -f symetri-sa.yaml
kubectl apply -f symetri-role.yaml
kubectl apply -f symetri-rolebinding.yaml
kubectl apply -f symetri-token-secret.yaml

# Wait for token generation
sleep 5

# Get permanent token
TOKEN=$(kubectl get secret symetri-sa-token -n symetri-ns -o jsonpath='{.data.token}' | base64 -d)

# Get cluster info
CLUSTER_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CLUSTER_CA=$(kubectl config view --minify --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')

# Create kubeconfig
cat > symetri-kubeconfig.yaml << EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${CLUSTER_CA}
    server: ${CLUSTER_SERVER}
  name: symetri-cluster
contexts:
- context:
    cluster: symetri-cluster
    user: symetri-sa
  name: symetri-context
current-context: symetri-context
users:
- name: symetri-sa
  user:
    token: ${TOKEN}
EOF

echo "Setup complete! Use symetri-kubeconfig.yaml in Symetri platform."