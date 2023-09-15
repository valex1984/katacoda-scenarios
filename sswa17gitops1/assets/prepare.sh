#!/bin/bash

INGRESS_DONE=/tmp/ingress_installed
GOGS_DONE=/tmp/gogs_installed
ARGO_DONE=/tmp/argo_installed
BASE_PATH="$(cat /usr/local/etc/sbercode-prefix)"
INGRESS_HOSTNAME_PLACEHOLDER="$(cat /usr/local/etc/sbercode-ingress)"
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

spinner() {
  local i sp n
  sp='/-\|'
  n=${#sp}
  printf ' '
  while sleep 0.2; do
    printf "%s\b" "${sp:i++%n:1}"
  done
}

# function prepare_env() {

#   kubectl create ns argocd --dry-run=client -o yaml | kubectl apply -f -
#   kubectl create ns gogs --dry-run=client -o yaml | kubectl apply -f -
#   echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >~/envs
#   echo "export GIT_URL=http://localhost:32100" >>~/envs
#   . ~/envs

# }


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

function install_gogs() {
   echo -e "\n[INFO] Installing gogs"

  if [ ! -f "$GOGS_DONE" ]; then
  sed -i "s#BASE_PATH#$BASE_PATH#g" /usr/local/etc/gogs.yaml
  sed -i "s#INGRESS_HOSTNAME_PLACEHOLDER#$INGRESS_HOSTNAME_PLACEHOLDER#g" /usr/local/etc/gogs.yaml
  kubectl create ns gogs --dry-run=client -o yaml | kubectl apply -f -
  kubectl apply -n gogs -f /usr/local/etc/gogs.yaml
  test $? -eq 1 && echo "[ERROR] cannot install gogs" && kill "$!" && exit 1
    kubectl -n gogs wait --for=condition=ContainersReady --timeout=5m --all pods
    test $? -eq 1 && echo "[ERROR] gogs not ready" && kill "$!" && exit 1
    echo done
    touch $GOGS_DONE
  else
    echo gogs already installed
  fi

}

function install_argo() {
   echo -e "\n[INFO] Installing argo"

  if [ ! -f "$ARGO_DONE" ]; then
  kubectl create ns argocd --dry-run=client -o yaml | kubectl apply -f -
  kubectl apply -n argocd -f /usr/local/etc/argocd.yaml
  test $? -eq 1 && echo "[ERROR] cannot install argo" && kill "$!" && exit 1
    kubectl -n argocd wait --for=condition=ContainersReady --timeout=5m --all pods
    test $? -eq 1 && echo "[ERROR] argo not ready" && kill "$!" && exit 1
    echo done
    touch $ARGO_DONE
  else
    echo argo already installed
  fi

}

# wait for cluster readiness
launch.sh

spinner &
# prepare_env
install_ingress
install_gogs
install_argo
#fix for gogs
rm -f /etc/gitconfig
#stop spinner
kill "$!"
