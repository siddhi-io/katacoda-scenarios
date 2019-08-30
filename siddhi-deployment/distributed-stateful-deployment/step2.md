This section provides instructions to install the prerequisites needed for the distributed stateful Siddhi App to run.

### Enable NGINX ingress

Siddhi Operator by default uses NGINX ingress controller to receive HTTP/HTTPS requests. 
Hence to [enable ingress](https://kubernetes.github.io/ingress-nginx/deploy/) in Minikube Kubernetes cluster run the following command.

`minikube addons enable ingress`{{execute}}

Minikube uses the minikube IP as the external IP of the ingress, and the Siddhi Operator uses hostname called `siddhi` to receive external traffic. 

Therefore to allow Siddhi to consume events from outside, add an entry in the `/etc/hosts` file mapping the minikube IP to `siddhi` host by running the following command.

``` echo " `minikube ip` siddhi" >> /etc/hosts ```{{execute}}

### Install NATS and NATS Streaming Operators

In the distributed mode, as the Siddhi Operator splits the Siddhi Apps into partial apps, it uses NATS and NATS Streaming systems to communicate with each other. 

Use the following commands to install the NATS and NATS Streaming systems.

`kubectl apply -f https://github.com/nats-io/nats-operator/releases/download/v0.5.0/00-prereqs.yaml`{{execute}}

`kubectl apply -f https://github.com/nats-io/nats-operator/releases/download/v0.5.0/10-deployment.yaml`{{execute}}

`kubectl apply -f https://github.com/nats-io/nats-streaming-operator/releases/download/v0.2.2/default-rbac.yaml`{{execute}}

`kubectl apply -f https://github.com/nats-io/nats-streaming-operator/releases/download/v0.2.2/deployment.yaml`{{execute}}

### Setup Persistence Volume

Stateful Siddhi Apps need Kubernetes persistence volume to preserve their state. A sample persistence volume specification for Minikube can be download as follows.

`wget https://raw.githubusercontent.com/siddhi-io/siddhi-operator/v0.2.0-alpha/deploy/examples/example-pv.yaml`{{execute}}

Run the following command to view the persistence volume YAML file.

`cat example-pv.yaml`{{execute}}

Deploy the persistence volume using the following command.

`kubectl apply -f example-pv.yaml`{{execute}}

Siddhi-runner docker image executes under the user `siddhi_user` belonging to the user group `siddhi_io`. Therefore, the ownership of the `/home/siddhi_user/` directory, mounted via the persistence volume, should be given to the user `siddhi_user` of user group `siddhi_io`.

First, create a user group `siddhi_io` and add a user `siddhi_user` to it by executing the following commands.

`sudo /usr/sbin/addgroup --system -gid 802 siddhi_io`{{execute}}

`sudo /usr/sbin/adduser --system -gid 802 -uid 802 siddhi_user`{{execute}}

Now, change the ownership of the directory to `siddhi_user` using the following command.

`sudo chown siddhi_user:siddhi_io /home/siddhi_user/`{{execute}}

### Install Siddhi Operator

Deploy the necessary Siddhi Operator prerequisite such as CRD, service accounts, roles, and role bindings using the following command.

`kubectl apply -f https://github.com/siddhi-io/siddhi-operator/releases/download/v0.2.0-alpha/00-prereqs.yaml`{{execute}}

Now deploy Siddhi Operator using the below command.

`kubectl apply -f https://github.com/siddhi-io/siddhi-operator/releases/download/v0.2.0-alpha/01-siddhi-operator.yaml`{{execute}}

### Validate the Environment

To ensure that all necessary pods and persistence volume are available in the cluster, execute the following commands.

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
