This section provides instructions on deploying the stateless Siddhi Apps that was discussed in the Introduction section.

### Deploy Siddhi App

Retrieve a prewritten A SiddhiProcess YAML to with the `PowerSurgeDetection` Siddhi App as follows.

`wget https://raw.githubusercontent.com/siddhi-io/katacoda-scenarios/master/siddhi/siddhi-deployment/stateless-deployment/power-surge-app.yaml`{{execute}}

Run the following command to view the SiddhiProcess YAML.

`cat power-surge-app.yaml`{{execute}}

Here the given Siddhi App is parametrized to retrieve the `RECEIVER_URL` from environment variables, and configured to be deployed in the docker image `siddhiio/siddhi-runner-ubuntu:5.1.0-m2`.

Deploy the Siddhi App using the below command.

`kubectl apply -f example-stateless-log-app.yaml`{{execute}}

### Validate Siddhi App deployment

Validate the deployed by running the following.

`kubectl get deploy`{{execute}}

Results similar to the following will be generated, make sure the `power-surge-app-0` is up and running. 

```sh
$ kubectl get deploy
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
power-surge-app-0   1/1     1            1           2m
siddhi-operator     1/1     1            1           5m
```

**Note:** The Siddhi operator parses and validates the Siddhi Apps before deploying them. This is done by temporarily deploying a parser with the SiddhiProcess name such as `power-surge-app-parser`, and removing it after parsing.

The status of the `SiddhiProcess` can be viewed using the following commands.

`kubectl get siddhi`{{execute}}

This generate results similar to the following. 

```sh
$ kubectl get siddhi

NAME              STATUS    READY    AGE
power-surge-app   Running   1/1      5m
```

The next section provides information on testing the Stateless Siddhi App.
