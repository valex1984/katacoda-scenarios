#!/bin/bash

OPENFAAS_DONE=/tmp/dashboard_installed
REGISTRY_DONE=/tmp/registry_installed
INGRESS_DONE=/tmp/ingress_installed

spinner() {
  local i sp n
  sp='/-\|'
  n=${#sp}
  printf ' '
  while sleep 0.2; do
    printf "%s\b" "${sp:i++%n:1}"
  done
}

function prepare_env() {

  kubectl create ns openfaas --dry-run=client -o yaml | kubectl apply -f -
  kubectl create ns openfaas-fn --dry-run=client -o yaml | kubectl apply -f -
  echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >~/envs
  echo "export OPENFAAS_URL=http://$(hostname):31112" >>~/envs
  echo "export REGISTRY=$(hostname):32500" >>~/envs
  echo "export OPENFAAS_PREFIX=$(hostname):32500/sbercode" >>~/envs
  . ~/envs

}

function install_openfaas() {

  echo -e "\n[INFO] Installing openfaas"

  if [ ! -f "$OPENFAAS_DONE" ]; then
    helm repo add nexus http://nexus:8081/repository/helm-hosted
    test $? -eq 1 && echo "[ERROR] cannot add helm repo" && kill "$!" && exit 1

    helm upgrade openfaas --install nexus/openfaas \
      --namespace openfaas \
      --set functionNamespace=openfaas-fn \
      --set generateBasicAuth=true \
      --set gateway.image=openfaas/gateway:0.21.1 \
      --set basicAuthPlugin.image=openfaas/basic-auth:0.21.1 \
      --set faasnetes.image=openfaas/faas-netes:0.14.1 \
      --set queueWorker.image=openfaas/queue-worker:0.12.2

    curl -Ls http://nexus:8081/repository/binaries/openfaas/faas-cli/0.13.15/faas-cli -o /usr/local/bin/faas-cli && chmod +x /usr/local/bin/faas-cli

    echo "waiting for openfaas system pods ready"
    kubectl -n openfaas wait --for=condition=ContainersReady --timeout=5m --all pods
    test $? -eq 1 && echo "[ERROR] openfaas pods not ready" && kill "$!" && exit 1
    echo "done"
    touch $OPENFAAS_DONE
  else
    echo already installed
  fi
}

function install_registry() {

  echo -e "\n[INFO] Installing registry"

  if [ ! -f "$REGISTRY_DONE" ]; then
    cat <<EOF >/tmp/registry.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: container-registry
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: registry-claim
  namespace: container-registry
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-path
  resources:
    requests:
      storage: 5Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: registry
  name: registry
  namespace: container-registry
spec:
  replicas: 1
  selector:
    matchLabels:
      app: registry
  template:
    metadata:
      labels:
        app: registry
    spec:
      containers:
        - name: registry
          image: registry:2.7.1
          env:
            - name: REGISTRY_HTTP_ADDR
              value: :5000
            - name: REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY
              value: /var/lib/registry
            - name: REGISTRY_STORAGE_DELETE_ENABLED
              value: "yes"
          ports:
            - containerPort: 5000
              name: registry
              protocol: TCP
          volumeMounts:
            - mountPath: /var/lib/registry
              name: registry-data
      volumes:
        - name: registry-data
          persistentVolumeClaim:
            claimName: registry-claim
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: registry
  name: registry
  namespace: container-registry
spec:
  type: NodePort
  selector:
    app: registry
  ports:
    - name: "registry"
      port: 5000
      targetPort: 5000
      nodePort: 32500
EOF

    kubectl apply -f /tmp/registry.yaml
    echo "waiting for container registry pod ready"
    kubectl -n container-registry wait --for=condition=ContainersReady --timeout=5m --all pods
    test $? -eq 1 && echo "[ERROR] registry pod not ready" && kill "$!" && exit 1
    echo -e "\n[[registry]]\nlocation = \"$REGISTRY\"\ninsecure = true" | tee -a /etc/containers/registries.conf
    echo "done"
    touch $REGISTRY_DONE
  else
    echo already installed
  fi
}

function login_openfaas() {

      PASSWORD=$(kubectl -n openfaas get secret basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode) && echo $PASSWORD | faas-cli login --username admin -s >/dev/null
}

# wait for cluster readiness
launch.sh

spinner &
prepare_env
install_openfaas
install_registry
login_openfaas
#stop spinner
kill "$!"
