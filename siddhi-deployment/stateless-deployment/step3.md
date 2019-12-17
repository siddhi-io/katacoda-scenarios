This section provides instructions on deploying the stateless Siddhi App that was discussed in the Introduction section.

### Deploy Siddhi App

Retrieve a prewritten SiddhiProcess YAML, with the earlier discussed `PowerSurgeDetection` Siddhi App, using the following command.

`wget https://raw.githubusercontent.com/siddhi-io/katacoda-scenarios/master/siddhi-deployment/stateless-deployment/power-surge-app.yaml`{{execute}}

Run the following command to view the SiddhiProcess YAML.

`cat power-surge-app.yaml`{{execute}}

This app is parametrized to retrieve `RECEIVER_URL` from environment variables, and configured to be deployed using `siddhiio/siddhi-runner-ubuntu:5.1.2` docker image.

Deploy the Siddhi SiddhiProcess using the below command.

`kubectl apply -f power-surge-app.yaml`{{execute}}

### Validate the deployment

The status of the `SiddhiProcess` can be viewed using the following commands.

`kubectl get siddhi`{{execute}}

The generated results will be similar to the following. 

```sh
$ kubectl get siddhi

NAME              STATUS    READY    AGE
power-surge-app   Ready     1/1      5m
```

Make sure the `power-surge-app` is in `Ready` state. Here, the `Ready` state indicates that the Siddhi App is deployed correctly and ready to consume external requests.

**Note:** The Siddhi Operator parses and validates Siddhi Apps before deploying them. This is done by temporarily deploying a parser with the SiddhiProcess name such as `power-surge-app-parser`, and it will be removed after parsing.

The next section provides information on testing the stateless Siddhi App.
