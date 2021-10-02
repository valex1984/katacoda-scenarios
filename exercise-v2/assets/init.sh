#!/bin/bash

ensure_label() {
    while [ "$(kubectl -n $2 wait --for=condition=ContainersReady --timeout=5m pods -l $1 2>&1)" = "error: no matching resources found" ]; do
        echo "No pod with label $1 found. Retry..."
        sleep 20
    done
}

launch.sh

kubectl create ns bookinfo
kubectl create ns kubeinvaders
kubectl label ns kubeinvaders istio-injection=enabled

prefix=$(cat /usr/local/etc/sbercode-prefix)

kubectl -n bookinfo apply -f /tmp/bookinfo.yaml

cat <<EOF | kubectl -n kubeinvaders apply -f -
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kubeinvaders
  labels:
    app: kubeinvaders
---
# Source: kubeinvaders/templates/rbac.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: kubeinvaders
  labels:
    app: kubeinvaders
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "watch", "list", "delete"]
- apiGroups: ["batch", "extensions"]
  resources: ["jobs"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "watch", "list"]
---
# Source: kubeinvaders/templates/rbac.yaml
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: kubeinvaders
  labels:
    app: kubeinvaders
subjects:
- kind: ServiceAccount
  name: kubeinvaders
  namespace: kubeinvaders
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kubeinvaders
---
# Source: kubeinvaders/templates/rbac-role.yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: kubeinvaders-role
  namespace: kubeinvaders
  labels:
    app: kubeinvaders
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log", "jobs"]
  verbs: ["get", "list", "delete", "create"]
---
# Source: kubeinvaders/templates/rbac-role.yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: kubeinvaders-rolebinding
  namespace: kubeinvaders
  labels:
    app: kubeinvaders
subjects:
- kind: ServiceAccount
  name: kubeinvaders
  namespace: kubeinvaders
roleRef:
  kind: Role
  name: kubeinvaders-role
  apiGroup: rbac.authorization.k8s.io
---
# Source: kubeinvaders/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: kubeinvaders
  labels:
    app.kubernetes.io/name: kubeinvaders
    helm.sh/chart: kubeinvaders-1.7
    app.kubernetes.io/instance: kubeinvaders
    app.kubernetes.io/managed-by: Helm
spec:
  ports:
    - port: 8080
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: kubeinvaders
    app.kubernetes.io/instance: kubeinvaders
---
# Source: kubeinvaders/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubeinvaders
  labels:
    app.kubernetes.io/name: kubeinvaders
    helm.sh/chart: kubeinvaders-1.7
    app.kubernetes.io/instance: kubeinvaders
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: kubeinvaders
      app.kubernetes.io/instance: kubeinvaders
  template:
    metadata:
      labels:
        app.kubernetes.io/name: kubeinvaders
        app.kubernetes.io/instance: kubeinvaders
      annotations:
    spec:
      serviceAccountName: kubeinvaders
      containers:
        - env:
          - name: ENDPOINT
            value: sbercode.pcbltools.ru\/$prefix-80\/invaders
          - name: NAMESPACE
            value: bookinfo
          name: kubeinvaders
          image: "webngt/kubeinvaders:0.0.2"
          imagePullPolicy: Always
          ports:
            - name: http
              containerPort: 8080
              protocol: TCP
          resources:
            {}
---
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: istio-gateway
  namespace: kubeinvaders
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: kubeinvaders
spec:
  hosts:
  - "*"
  gateways:
  - istio-gateway
  http:
  - match:
    - uri:
        prefix: /$prefix-80/invaders/
    rewrite:
      uri: /
    route:
    - destination:
        host: kubeinvaders
        port:
          number: 8080
EOF

echo "Waiting for kube invaders...."
ensure_label "app.kubernetes.io/name=kubeinvaders" "kubeinvaders"