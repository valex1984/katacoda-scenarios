This environment has a `launch.sh`{{execute}}

<pre class="file" data-filename="./pod.yaml" data-target="replace">
apiVersion: v1
kind: Pod
metadata:
  name: hello-demo
  labels:
    app: hello-demo
spec:
  containers:
  - name: hello-demo
    image: schetinnikov/hello-app:v1
    ports:
      - containerPort: 80
</pre>

```
kubectl apply -f pod.yaml
```{{execute}}


```
watch kubectl get pods
```{{execute}}
