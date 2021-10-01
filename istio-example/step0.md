Istio test1

Запустим Prometheus. Prometheus - это система мониторинга с открытым кодом, работающая по pull-модели сбора метрик. Prometheus также предоставляет возможность запрашивать данные с помощью языка запросов PromQL. 

Prometheus написан на go и распространяется в виде бинарного запускаемого файла.

Для начала проверим, что система готова к работе скриптом launch.sh. Для перехода к следующему шагу необходимо дождаться успешного завершения.

```
launch.sh
```{{execute}}

Включим [istio injection](https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/) командой

```
kubectl label namespace default istio-injection=enabled
```{{execute}}

Создадим yaml файл с конфигурацией, деплойментом и сервисом

```
cat <<EOF >prometheus.yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
data:
  prometheus.yml: |
    global:
      scrape_interval:     15s
    scrape_configs:
    - job_name: app
      metrics_path: '/metrics'
      static_configs:
        - targets: ['127.0.0.1:8000']
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  labels:
    app: prometheus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
      - name: prometheus
        image: prom/prometheus
        imagePullPolicy: IfNotPresent
        args:
          - '--storage.tsdb.path=/prometheus'
          - '--config.file=/etc/prometheus/prometheus.yml'
          - '--web.console.libraries=/usr/share/prometheus/console_libraries'
          - '--web.console.templates=/usr/share/prometheus/consoles'
          - "--web.route-prefix=$(cat /usr/local/etc/sbercode-prefix)-80/"
          - "--web.external-url=http://127.0.0.1/$(cat /usr/local/etc/sbercode-prefix)-80/"
        ports:
        - name: web
          containerPort: 9090
        volumeMounts:
        - name: config-volume
          mountPath: /etc/prometheus
        - name: data
          mountPath: /prometheus
      restartPolicy: Always
      securityContext: {}
      terminationGracePeriodSeconds: 30
      volumes:
      - name: config-volume
        configMap:
          name: prometheus-config
      - name: data
        emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus
spec:
  selector:
    app: prometheus
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9090
      name: http
EOF
```{{execute}}

применим конфигурацию командой 

```
kubectl apply -f prometheus.yaml
```{{execute}}

статус пода можно проверить командой 

```
kubectl get po
```{{execute}}
