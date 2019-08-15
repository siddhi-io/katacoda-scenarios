This section provides instructions to install the prerequisites needed for the stateless Siddhi App to run.

### Enable NGINX ingress

Siddhi operator by default uses NGINX ingress controller to receive HTTP/HTTPS requests. 
Hence to [enable ingress](https://kubernetes.github.io/ingress-nginx/deploy/) in Minikube Kubernetes cluster run the following command.

`minikube addons enable ingress`{{execute}}

Minikube uses the minikube IP as the external IP of the ingress, and the Siddhi operator uses hostname called `siddhi` to receive external traffic. 

Therefore to allow Siddhi to consume events from outside, add an entry in the `/etc/hosts` file mapping the minikube IP to `siddhi` host by running the following command.

``` echo " `minikube ip` siddhi" >> /etc/hosts ```{{execute}}

### Install Siddhi operator

Deploy the necessary Siddhi operator prerequisite such as CRD, service accounts, roles, and role bindings using the following command.

`kubectl apply -f https://github.com/siddhi-io/siddhi-operator/releases/download/v0.2.0-m2/00-prereqs.yaml`{{execute}}

Now deploy Siddhi operator using the below command.

`kubectl apply -f https://github.com/siddhi-io/siddhi-operator/releases/download/v0.2.0-m2/01-siddhi-operator.yaml`{{execute}}

### Validate the environment

To ensure that all necessary pods are up and running in the cluster, run the following command.

`kubectl get pods`{{execute}}

Results similar to the following will be generated, make sure the Siddhi operator is up and running. 

```sh
$ kubectl get pods

NAME                                 READY     STATUS    RESTARTS   AGE
siddhi-operator-6f7d8f7556-j9j89     1/1       Running   0          2m
```

The next section provides information on deploying a stateless Siddhi App.
