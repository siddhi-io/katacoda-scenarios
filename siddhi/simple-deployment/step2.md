## Enabling NGINX ingress

As Siddhi operator by default uses NGINX ingress controller to receive HTTP/HTTPS requests. Hence [enable ingress](https://kubernetes.github.io/ingress-nginx/deploy/) in your minikube kubernetes cluster using the following command.

`minikube addons enable ingress`{{execute}}

Minikube uses the minikube IP as the ingress external IP, and since Siddhi operator uses hostname called `siddhi` to receive all external traffic we need to add the siddhi entry to the `/etc/hosts` file using the below command.

``` echo " `minikube ip` siddhi" >> /etc/hosts ```{{execute}}

## Install Siddhi operator

Deploy the necessary prerequisite such as  CRD, service accounts, roles, and role bindings using the following command.

`kubectl apply -f https://github.com/siddhi-io/siddhi-operator/releases/download/v0.2.0-m2/00-prereqs.yaml`{{execute}}

`kubectl apply -f https://github.com/siddhi-io/siddhi-operator/releases/download/v0.2.0-m2/01-siddhi-operator.yaml`{{execute}}

## Validate the Environment

Ensure that all necessary pods in the cluster up and running using the following command.

`kubectl get pods`{{execute}}

Make sure the Siddhi operator is up and running.

```sh
$ kubectl get pods

NAME                                 READY     STATUS    RESTARTS   AGE
siddhi-operator-6f7d8f7556-j9j89     1/1       Running   0          2m
```

The next section provides information on Deploying Stateless Siddhi App.
