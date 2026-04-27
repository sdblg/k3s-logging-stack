#!/bin/bash

NAMESPACE="CHANGE_MY_NAME_SPACE"
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# 1. Loki суулгах
echo "Installing Loki..."
helm upgrade --install loki grafana/loki -f manifests/loki/values.yaml -n $NAMESPACE

# 2. Grafana суулгах
echo "Installing Grafana..."
helm upgrade --install grafana grafana/grafana -f manifests/grafana/values.yaml -n $NAMESPACE

# 3. Alloy ConfigMap үүсгэх
echo "Creating Alloy Config..."
kubectl delete configmap custom-alloy-config -n $NAMESPACE --ignore-not-found
kubectl create configmap custom-alloy-config --from-file=config.alloy=manifests/alloy/config.river -n $NAMESPACE

# 4. Alloy суулгах
echo "Installing Alloy..."
helm upgrade --install alloy grafana/alloy \
  --set alloy.configMap.create=false \
  --set alloy.configMap.name=custom-alloy-config \
  --set alloy.configMap.key=config.alloy \
  --set controller.type=daemonset \
  --set rbac.create=true \
  -n $NAMESPACE

echo "Deployment complete!"