#!/bin/bash

INGRESS_DONE=/tmp/ingress_installed
GRAVITEE_DONE=/tmp/gravitee_installed
HTTPBIN_DONE=/tmp/httpbin_installed
BASE_PATH="$(cat /usr/local/etc/sbercode-prefix)"
INGRESS_HOSTNAME_PLACEHOLDER="$(cat /usr/local/etc/sbercode-ingress)"
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
pg_version="12.12.10"

spinner() {
  local i sp n
  sp='/-\|'
  n=${#sp}
  printf ' '
  while sleep 0.2; do
    printf "%s\b" "${sp:i++%n:1}"
  done
}

function install_ingress() {
  echo -e "\n[INFO] Installing nginx ingress controller"
  if [ ! -f "$INGRESS_DONE" ]; then
    kubectl apply -f /usr/local/etc/nginx-ingress-deploy.yaml
    kubectl -n ingress-nginx wait --for=condition=available --timeout=3m deployment/ingress-nginx-controller
    test $? -eq 1 && echo "[ERROR] Ingress controller not ready" && kill "$!" && exit 1
    kubectl -n ingress-nginx patch svc ingress-nginx-controller --patch \
      '{"spec": { "type": "NodePort", "ports": [ { "nodePort": 32100, "port": 80, "protocol": "TCP", "targetPort": 80 } ] } }'
    echo done
    touch $INGRESS_DONE
  else
    echo already installed
  fi
}

function install_es() {

  echo -e "\n[INFO] Installing elasticsearch"
  helm repo add nexus http://nexus:8081/repository/helm-hosted
  helm repo add bitnami http://nexus:8081/repository/bitnami/
  test $? -eq 1 && echo "[ERROR] cannot add bitnami proxy repo" && kill "$!" && exit 1
  kubectl create ns gravitee --dry-run=client -o yaml | kubectl apply -f -
  cat <<EOF >/tmp/es-values.yaml
replicas: 1
antiAffinity: "soft"
esJavaOpts: "-Xmx128m -Xms128m"
image: elasticsearch
imageTag: "7.13.4"
resources:
  requests:
    memory: "256Mi"
    cpu: "10m"
volumeClaimTemplate:
  accessModes: [ "ReadWriteOnce" ]
  resources:
    requests:
      storage: 2Gi
sysctlInitContainer:
  enabled: false      
extraEnvs:
 - name: discovery.type
   value: single-node
 - name: cluster.initial_master_nodes
   value: null
 - name: xpack.security.enabled
   value: "false"
 - name: xpack.monitoring.enabled
   value: "false"
EOF
  helm upgrade --install -n gravitee elasticsearch -f /tmp/es-values.yaml nexus/elasticsearch

}

function install_pg() {

   helm upgrade --install -n gravitee \
    --set auth.postgresPassword=postgres \
    --set auth.database=graviteeapim \
    --set persistence.size=2Gi \
    postgres-apim bitnami/postgresql --version $pg_version

}

function install_apim() {
  echo -e "\n[INFO] Installing gravitee"

  sed -i "s#BASE_PATH#$BASE_PATH#g" /tmp/gravitee.yaml
  sed -i "s#INGRESS_HOSTNAME_PLACEHOLDER#$INGRESS_HOSTNAME_PLACEHOLDER#g" /tmp/gravitee.yaml
  kubectl apply -n gravitee -f /tmp/gravitee.yaml
  test $? -eq 1 && echo "[ERROR] cannot install gravitee" && kill "$!" && exit 1
}

function install_gravitee() {

  if [ ! -f "$GRAVITEE_DONE" ]; then
    install_es
    install_pg
    install_apim
    kubectl -n gravitee wait --for=condition=ContainersReady --timeout=5m --all pods
    test $? -eq 1 && echo "[ERROR] gravitee not ready" && kill "$!" && exit 1
    echo done
    touch $GRAVITEE_DONE
  else
    echo gravitee already installed
  fi

}

function install_httpbin() {
   echo -e "\n[INFO] Installing httpbin"

  if [ ! -f "$HTTPBIN_DONE" ]; then
  cat <<EOF >/tmp/httpbin.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: httpbin
---
apiVersion: v1
kind: Service
metadata:
  name: httpbin
  labels:
    app: httpbin
    service: httpbin
spec:
  ports:
  - name: http
    port: 8000
    targetPort: 80
  selector:
    app: httpbin
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpbin
spec:
  replicas: 1
  selector:
    matchLabels:
      app: httpbin
      version: v1
  template:
    metadata:
      labels:
        app: httpbin
        version: v1
    spec:
      serviceAccountName: httpbin
      containers:
      - image: docker.io/kennethreitz/httpbin
        imagePullPolicy: IfNotPresent
        name: httpbin
        ports:
        - containerPort: 80
EOF
    kubectl apply -f /tmp/httpbin.yaml
    kubectl wait --for=condition=ContainersReady --timeout=5m --all pods
    test $? -eq 1 && echo "[ERROR] httpbin not ready" && kill "$!" && exit 1
    echo done
    touch $HTTPBIN_DONE
  else
    echo httpbin already installed
  fi

}

# wait for cluster readiness
launch.sh

spinner &
install_ingress
install_gravitee
install_httpbin
#stop spinner
kill "$!"
