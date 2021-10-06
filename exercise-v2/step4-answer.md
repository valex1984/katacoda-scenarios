При решении задачи необходимо помнить, что масштбируемость приложения, исполняемого в Kubernetes обеспечивается объектами Deployment и ReplicaSet. Чтобы устранить соответствующие нарушения стандарта, проделайте следующие действия.

Удалите проблемные объекты Pod

`kubectl -n bookinfo delete pod details-main ; kubectl -n bookinfo delete pod details-secondary`{{execute T1}}

Создайте файл дескриптора Deployment

`touch /root/exercise/deployment.yaml`{{execute T1}}

Пример конфигурации объекта Deployment, перенесите ее в созданный файл.

<pre class="file" data-filename="deployment.yaml" data-target="replace">apiVersion: apps/v1
kind: Deployment
metadata:
  name: details-v1
  labels:
    app: details
    version: v1
spec:
  replicas: 2
  selector:
    matchLabels:
      app: details
      version: v1
  template:
    metadata:
      labels:
        app: details
        version: v1
    spec:
      serviceAccountName: bookinfo-details
      containers:
      - name: details
        image: docker.io/istio/examples-bookinfo-details-v1:1.16.2
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 9080
</pre>

Примените конфигурацию

`kubectl -n bookinfo apply -f /root/exercise/deployment.yaml`{{execute T1}}
