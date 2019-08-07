Here we will deploy a stateless Siddhi app that we have discussed in the introduction section.

A SiddhiProcess YAML to deploy the application can be retrieved as bellow.

`wget https://raw.githubusercontent.com/BuddhiWathsala/siddhi-operator/katacoda-0.2.0-m2/deploy/examples/example-stateless-log-app.yaml`{{execute}}

View the SiddhiProcess YAML as following.

`cat example-stateless-log-app.yaml`{{execute}}

This Siddhi application uses an HTTP source like below to receive events.

```programming
@source(
    type='http',
    receiver.url='${RECEIVER_URL}',
    basic.auth.enabled='false',
    @map(type='json')
)
define stream DevicePowerStream(deviceType string, power int);
```

And print events using the log sink.

```programming
@sink(type='log', prefix='LOGGER')  
define stream PowerSurgeAlertStream(deviceType string, power int);
```

The execution logic of the Siddhi app defined by the following query.

```programming
@info(name='surge-detector')  
from DevicePowerStream[deviceType == 'dryer' and power >= 600] 
select deviceType, power  
insert into PowerSurgeAlertStream;
```

Above query executes the following tasks.
1. Receive HTTP events.
1. Filter out all the HTTP events which have the device type as dryer and the power consumption greater than or equals to 600W.
1. Output the filtered events.

Now you can deploy the stateless Siddhi App.

`kubectl apply -f example-stateless-log-app.yaml`{{execute}}


Validate the app is deployed correctly by running.

`kubectl get deploy`{{execute}}

```sh
$ kubectl get deploy
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
power-surge-app-0   1/1     1            1           2m
siddhi-operator     1/1     1            1           5m
```

**Note that** here Siddhi operator starts a parser deployment for Siddhi apps as `power-surge-app-parser`. It will automatically be removed by the operator. The actual deployment of the Siddhi app starts as `power-surge-app-0`. You have to wait until `power-surge-app-0` deployment up and running.


You can view the `SiddhiProcess` using the following commands.

`kubectl get sp`{{execute}}

```sh
$ kubectl get sp

NAME              STATUS    READY    AGE
power-surge-app   Running   1/1      5m
```
