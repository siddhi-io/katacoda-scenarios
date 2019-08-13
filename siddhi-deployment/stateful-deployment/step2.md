## Enabling NGINX ingress

As Siddhi operator by default uses NGINX ingress controller to receive HTTP/HTTPS requests. Hence [enable ingress](https://kubernetes.github.io/ingress-nginx/deploy/) in your minikube kubernetes cluster using the following command.

`minikube addons enable ingress`{{execute}}

Minikube uses the minikube IP as the ingress external IP, and since Siddhi operator uses hostname called `siddhi` to receive all external traffic we need to add the siddhi entry to the `/etc/hosts` file using the below command.

``` echo " `minikube ip` siddhi" >> /etc/hosts ```{{execute}}

## Setup Persistence Volume

The stateful Siddhi app deployment needs a Kubernetes persistence volume to preserve the state of the Siddhi app. To do that in minikube first you have to download this YAML file that contains the K8s persistence volume specification.

`wget https://raw.githubusercontent.com/siddhi-io/siddhi-operator/v0.2.0-m2/deploy/examples/example-pv.yaml`{{execute}}

You can see the persistence volume YAML using the following command.

`cat example-pv.yaml`{{execute}}

Now you can deploy the persistence volume using the following command.

`kubectl apply -f example-pv.yaml`{{execute}}

Siddhi runner docker image runs by a user called `siddhi_user`. The `siddhi_user` belongs to the `siddhi_io` user group. Here we mount `/home/siddhi_user/` directory as the persistence volume. Hence we need to change the ownership of that director to the `siddhi_user` in the `siddhi_io` user group.

You have to create the `siddhi_user` and the `siddhi_group` using the following commands.

`sudo /usr/sbin/addgroup --system -gid 802 siddhi_io`{{execute}}

`sudo /usr/sbin/adduser --system -gid 802 -uid 802 siddhi_user`{{execute}}

After that change the ownership of the directory using the following command.

`sudo chown siddhi_user:siddhi_io /home/siddhi_user/`{{execute}}


## Install Siddhi operator

Deploy the necessary prerequisite such as  CRD, service accounts, roles, and role bindings using the following command.

`kubectl apply -f https://github.com/siddhi-io/siddhi-operator/releases/download/v0.2.0-m2/00-prereqs.yaml`{{execute}}

`kubectl apply -f https://github.com/siddhi-io/siddhi-operator/releases/download/v0.2.0-m2/01-siddhi-operator.yaml`{{execute}}

## Validate the Environment

Ensure that all necessary prerequisites in the cluster up and running using the following commands.

`kubectl get pods`{{execute}}

`kubectl get pv`{{execute}}

Make sure the all prerequisites are correctly configured.

```sh
$ kubectl get pods
NAME                                       READY     STATUS        RESTARTS   AGE
siddhi-operator-6f7d8f7556-j9j89           1/1       Running       0          2m

$ kubectl get pv
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM     STORAGECLASS   REASON    AGE
siddhi-pv   1Gi        RWO            Recycle          Available             standard                 2m
```

The next section provides information on Deploying Stateful Siddhi App.
