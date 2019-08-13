This section provides instructions on deploying the stateless Siddhi App that was discussed in the Introduction section.

### Deploy Siddhi App

Retrieve a prewritten SiddhiProcess YAML, with the earlier discussed `PowerSurgeDetection` Siddhi App, using the following command.

`wget https://raw.githubusercontent.com/siddhi-io/katacoda-scenarios/master/siddhi-deployment/stateless-deployment/power-surge-app.yaml`{{execute}}

Run the following command to view the SiddhiProcess YAML.

`cat power-surge-app.yaml`{{execute}}

Here the given Siddhi App is parametrized to retrieve the `RECEIVER_URL` from environment variables, and configured to be deployed using the docker image `siddhiio/siddhi-runner-ubuntu:5.1.0-m2`.

Deploy the Siddhi SiddhiProcess using the below command.

`kubectl apply -f power-surge-app.yaml`{{execute}}

### Validate the deployment

Validate the deployment by running the following command.

`kubectl get deploy`{{execute}}

Results similar to the following will be generated, make sure the `power-surge-app-0` is up and running. 

```sh
$ kubectl get deploy
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
power-surge-app-0   1/1     1            1           2m
siddhi-operator     1/1     1            1           5m
```

**Note:** The Siddhi operator parses and validates Siddhi Apps before deploying them. This is done by temporarily deploying a parser with the SiddhiProcess name such as `power-surge-app-parser`, and removing it after parsing.

The status of the `SiddhiProcess` can be viewed using the following commands.

`kubectl get siddhi`{{execute}}

The generate results will be similar to the following. 

```sh
$ kubectl get siddhi

NAME              STATUS    READY    AGE
power-surge-app   Running   1/1      5m
```

The next section provides information on testing the stateless Siddhi App.
