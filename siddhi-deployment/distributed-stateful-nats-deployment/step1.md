[Siddhi](http://siddhi.io) is a cloud-native, scalable, Streaming and Complex Event Processing System capable of building real-time applications.

In this scenario, we will see how we can deploy a Siddhi application that runs distributed with high availability preserving its internal states. Here we will demonstrate how to use an external user-defined NATS messaging system to connect all partial Siddhi apps.
We will be deploying the following `PowerConsumptionSurgeDetection` app.

```programming
@App:name("PowerConsumptionSurgeDetection")

@App:description("Consumes power consumption events from HTTP on JSON format `{ 'deviceType': 'dryer', 'power': 6000 }`, and alerts the user if the power consumption in last 1 minute is greater than or equal to 10000W by logging a message once every 30 seconds.")

@source(type='http', receiver.url='${RECEIVER_URL}',
  basic.auth.enabled='false', @map(type='json'))
define stream DevicePowerStream(deviceType string, power int);

@sink(type='log', prefix='LOGGER') 
define stream PowerSurgeAlertStream(deviceType string, powerConsumed long);

@info(name='surge-detector')  
from DevicePowerStream#window.time(1 min)
select deviceType, sum(power) as powerConsumed
group by deviceType
having powerConsumed > 10000
output every 30 sec
insert into PowerSurgeAlertStream;
```

The above query consumes events from `HTTP` as a `JSON` message of `{ 'deviceType': 'dryer', 'power': 6000 }` format, and inserts the events into `DevicePowerStream`. From which using the query `surge-detector`, it generates an event once every 30 seconds and inserts into the `PowerSurgeAlertStream`, if the total power consumption in the last 1 minute is greater than or equal to 10000W. The events pushed to the `PowerSurgeAlertStream` will be then logged to the console.

This app is stateful because it needs to preserve the running sum of power consumption even during failures and restarts.

Prerequisites on deploying this app:

- NATS - For internal messaging between distributed Siddhi Apps.
- NATS Streaming - To preserve messages for reply upon failure.
- Ingress - As Siddhi uses NGINX ingress controller to receive HTTP/HTTPS requests.
- Persistence Volume - To preserve the periodic snapshots produced by Siddhi 
- Siddhi Operator - For deploying and managing distributed Siddhi Apps.

The following section explains how we can install the prerequisites.
