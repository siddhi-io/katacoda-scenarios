This section provides instructions to install the prerequisites needed for the stateless Siddhi App.

### Enable NGINX ingress

Siddhi Operator by default uses NGINX ingress controller to receive HTTP/HTTPS requests. 
Hence to [enable ingress](https://kubernetes.github.io/ingress-nginx/deploy/) in this Minikube Kubernetes cluster run the following command.

`minikube addons enable ingress`{{execute}}

As Minikube uses `minikube ip` as the external ingress IP, and the Siddhi Operator uses `siddhi` as the hostname to receive external traffic. 
Add the following entry to the `/etc/hosts` file, mapping `minikube ip` to `siddhi`.

``` echo " `minikube ip` siddhi" >> /etc/hosts ```{{execute}}

### Install Siddhi Operator

Deploy the necessary Siddhi Operator prerequisite such as CRD, service accounts, roles, and role bindings as follows.

`kubectl apply -f https://github.com/siddhi-io/siddhi-operator/releases/download/v0.2.1/00-prereqs.yaml`{{execute}}

Deploy Siddhi Operator using the below command.

`kubectl apply -f https://github.com/siddhi-io/siddhi-operator/releases/download/v0.2.1/01-siddhi-operator.yaml`{{execute}}

### Validate the environment

To ensure that all necessary pods are up and running, run the following command.

`kubectl get pods`{{execute}}

Results similar to the following will be generated, make sure the Siddhi Operator is up and running. 

```sh
$ kubectl get pods

NAME                                 READY     STATUS    RESTARTS   AGE
siddhi-operator-6f7d8f7556-j9j89     1/1       Running   0          2m
```

The next section provides information on deploying a stateless Siddhi App.
