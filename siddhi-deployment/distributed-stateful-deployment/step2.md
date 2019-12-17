This section provides instructions to install the prerequisites needed for the distributed stateful Siddhi App to run.

### Enable NGINX ingress

Siddhi Operator by default uses NGINX ingress controller to receive HTTP/HTTPS requests. 
Hence to [enable ingress](https://kubernetes.github.io/ingress-nginx/deploy/) in this Minikube Kubernetes cluster run the following command.

`minikube addons enable ingress`{{execute}}

As Minikube uses `minikube ip` as the external ingress IP, and the Siddhi Operator uses `siddhi` as the hostname to receive external traffic. 
Add the following entry to the `/etc/hosts` file, mapping `minikube ip` to `siddhi`.

``` echo " `minikube ip` siddhi" >> /etc/hosts ```{{execute}}

### Install NATS and NATS Streaming Operators

In the distributed mode, as the Siddhi Operator splits the Siddhi Apps into partial apps, and uses NATS and NATS Streaming systems to connect each other, install the NATS and NATS Streaming Operators using the following commands,

`kubectl apply -f https://github.com/nats-io/nats-operator/releases/download/v0.5.0/00-prereqs.yaml`{{execute}}

`kubectl apply -f https://github.com/nats-io/nats-operator/releases/download/v0.5.0/10-deployment.yaml`{{execute}}

`kubectl apply -f https://github.com/nats-io/nats-streaming-operator/releases/download/v0.2.2/default-rbac.yaml`{{execute}}

`kubectl apply -f https://github.com/nats-io/nats-streaming-operator/releases/download/v0.2.2/deployment.yaml`{{execute}}

### Setup Persistence Volume

Stateful Siddhi Apps need Kubernetes persistence volume to preserve their states. A sample persistence volume specification for Minikube can be download as follows.

`wget https://raw.githubusercontent.com/siddhi-io/siddhi-operator/v0.2.2/deploy/examples/example-pv.yaml`{{execute}}

Run the following command to view the persistence volume YAML file.

`cat example-pv.yaml`{{execute}}

Deploy the persistence volume using the following command.

`kubectl apply -f example-pv.yaml`{{execute}}

As the Siddhi-runner docker image executes under the user `siddhi_user` in user group `siddhi_io`, the ownership of the `/home/siddhi_user/` directory, mounted via the persistence volume, should be given to that user.

First, create a user group `siddhi_io` and add a user `siddhi_user` to it.

`sudo /usr/sbin/addgroup --system -gid 802 siddhi_io`{{execute}}

`sudo /usr/sbin/adduser --system -gid 802 -uid 802 siddhi_user`{{execute}}

Now, change the ownership of the directory to `siddhi_user` as follows.

`sudo chown siddhi_user:siddhi_io /home/siddhi_user/`{{execute}}

### Install Siddhi Operator

Apply the necessary Siddhi Operator prerequisite such as CRD, service accounts, roles, and role bindings as follows.

`kubectl apply -f https://github.com/siddhi-io/siddhi-operator/releases/download/v0.2.2/00-prereqs.yaml`{{execute}}

Apply Siddhi Operator using the below command.

`kubectl apply -f https://github.com/siddhi-io/siddhi-operator/releases/download/v0.2.2/01-siddhi-operator.yaml`{{execute}}

### Validate the Environment

To ensure that all necessary pods and persistence volume are available, run the following commands.

`kubectl get pods`{{execute}}

`kubectl get pv`{{execute}}

Results similar to the following will be generated, make sure the Siddhi, NATS and NATS Streaming Operators are up and running, and the created persistence volume is available. 

```sh
$ kubectl get pods
NAME                                       READY     STATUS    RESTARTS   AGE
nats-operator-dd7f4945f-x4vf8              1/1       Running   0          10m
nats-streaming-operator-6fbb6695ff-9rmlx   1/1       Running   0          10m
siddhi-operator-6698d8f69d-w2kvj           1/1       Running   0          10m

$ kubectl get pv
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM     STORAGECLASS   REASON    AGE
siddhi-pv   1Gi        RWO            Recycle          Available             standard                 10m
```

The next section provides information on deploying a stateful Siddhi App in the distributed mode.
