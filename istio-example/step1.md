Теперь создадим объекты istio  и проверим доступ к сервису

Введите строки ниже в файл istio-gateway.yaml. Вы можете сделать это вручную или нажав кнопку "Copy to Editor".

<pre class="file" data-filename="istio-gateway.yaml" data-target="replace">
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: istio-gateway
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
</pre>

Создадим объкт в kubernetes командой

```
kubectl apply -f istio-gateway.yaml
```{{execute}}

Далее сгенерируем описание объекта istio типа [virtualservice](https://istio.io/latest/docs/reference/config/networking/virtual-service/) для доступа к сервису

```
cat <<EOF >vs.yaml
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: prometheus
spec:
  hosts:
  - "*"
  gateways:
  - istio-gateway
  http:
  - match:
    - uri:
        prefix: /$(cat /usr/local/etc/sbercode-prefix)-80
    route:
    - destination:
        host: prometheus.default.svc.cluster.local
        port:
          number: 80
EOF
```{{execute}}

и применим его в кластер

```
kubectl apply -f vs.yaml
```{{execute}}

Проверить доступ можно по ссылке на дашборд. Дашборд Prometheus доступен [здесь](https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/)

