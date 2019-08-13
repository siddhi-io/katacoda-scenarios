Here we will deploy a stateful Siddhi app that we have discussed in the introduction section.

A SiddhiProcess YAML to deploy the application can be retrieved as below.

`wget https://raw.githubusercontent.com/siddhi-io/siddhi-operator/v0.2.0-m2/deploy/examples/example-stateful-distributed-nats-app.yaml`{{execute}}

View the SiddhiProcess YAML as following.

`cat example-stateful-distributed-nats-app.yaml`{{execute}}

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
define stream PowerSurgeAlertStream(deviceType string, powerConsumed long);
```

The execution logic of the Siddhi app defined by the following query.

```programming
@info(name='surge-detector')
from DevicePowerStream#window.time(1 min)
select deviceType, sum(power) as powerConsumed
group by deviceType
having powerConsumed > 10000
output every 30 sec
insert into PowerSurgeAlertStream;
```

Above query executes the following tasks.
1. Retains events arrived in last 1 minute period
1. Group all the events by the electronic device type and calculate the total power consumption
1. Select all the devices which exceed 1000W power consumption
1. Output aggregated events once in each 30 seconds

The YAML file specifying the configurations of the messaging system that you created previously like below. From that, Siddhi operator parses NATS configurations to the partial Siddhi apps. Those partial Siddhi apps will individually connect to the NATS from those configurations.

```yaml
messagingSystem:
  type: nats
  config: 
    bootstrapServers: 
      - "nats://nats-siddhi:4222"
    clusterID: stan-siddhi
```

Now you can deploy the Stateful Siddhi App.

`kubectl apply -f example-stateful-distributed-nats-app.yaml`{{execute}}

Validate the app is deployed correctly by running.

`kubectl get deploy`{{execute}}

```sh
$ kubectl get deploy
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
power-consume-app-0   1/1     1            1           5m
power-consume-app-1   1/1     1            1           5m
siddhi-operator       1/1     1            1           10m
```

**Note that** here Siddhi operator starts a parser deployment for Siddhi apps as `power-consume-app-parser`. It will automatically be removed by the operator. The actual deployments of the Siddhi app are `power-consume-app-0` and `power-consume-app-1`. You have to wait until `power-surge-app-0` and `power-consume-app-1` deployments up and running.


You can view the `SiddhiProcess` using the following commands.

`kubectl get sp`{{execute}}

```sh
$ kubectl get sp

NAME                STATUS    READY     AGE
power-consume-app   Running   2/2       5m
```

