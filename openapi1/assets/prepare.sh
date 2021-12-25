#!/bin/bash

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



function install_ingress() {
  echo -e "\n[INFO] Installing nginx ingress controller"
  if [ ! -f "$INGRESS_DONE" ]; then
    kubectl apply -f /usr/local/etc/nginx-ingress-deploy.yaml
    kubectl -n ingress-nginx wait --for=condition=available --timeout=3m deployment/ingress-nginx-controller
    test $? -eq 1 && echo "[ERROR] Ingress controller not ready" && kill "$!" && exit 1
    kubectl -n ingress-nginx patch svc ingress-nginx-controller --patch \
      '{"spec": { "type": "NodePort", "ports": [ { "nodePort": 32100, "port": 80, "protocol": "TCP", "targetPort": 80 } ] } }'


cat <<EOF >/tmp/httpbin-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: httpbin-external
  annotations:
      kubernetes.io/ingress.class: "nginx"
      nginx.ingress.kubernetes.io/configuration-snippet: |
        etag on;
        proxy_pass_header ETag;
        sub_filter '<script src="/"' '<base href="/$(cat /usr/local/etc/sbercode-prefix)-32100/"';
        sub_filter_once off;
      nginx.ingress.kubernetes.io/rewrite-target: "/$1"
spec:
  rules:
  - http:
      paths:
      - pathType: Prefix
        path: /$(cat /usr/local/etc/sbercode-prefix)-32100/(.*)
        backend:
          service:
            name: httpbin
            port:
              number: 80
EOF
    kubectl apply -f /tmp/httpbin-ingress.yaml
    echo done
    touch $INGRESS_DONE
  else
    echo already installed
  fi
}



# wait for cluster readiness
launch.sh
spinner &
install_ingress
kill "$!"
