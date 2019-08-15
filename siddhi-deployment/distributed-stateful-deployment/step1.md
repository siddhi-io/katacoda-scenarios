[Siddhi](http://siddhi.io) is a cloud-native, scalable, Streaming and Complex Event Processing System capable of building real-time analytics, data integration, notification and surveillance usecases.

This scenario presents how to deploy a distributed stateful Siddhi Application on Kubernetes providing high availability by automatically configuring NATS. 

This use case is implemented using the `PowerConsumptionSurgeDetection` app presented below.

```sql
@App:name("PowerConsumptionSurgeDetection")
@App:description("Consumes HTTP messages in JSON format, and alerts by logging a message once every 30 seconds, if the total power consumption in the last 1 minute is greater than or equal to 10000W.")

@source( type='http', 
         receiver.url='${RECEIVER_URL}',
         basic.auth.enabled='false', 
         @map(type='json'))
define stream DevicePowerStream(
              deviceType string, power int);

@sink(type='log', prefix='LOGGER')  
define stream PowerSurgeAlertStream(
              deviceType string, power int);

@info(name='surge-detector')  
from DevicePowerStream#window.time(1 min) 
select deviceType, sum(power) as powerConsumed
group by deviceType
having powerConsumed > 10000
output every 30 sec
insert into PowerSurgeAlertStream;
```

The above app consumes `JSON` messages via http sink in the format `{ 'deviceType': 'dryer', 'power': 6000 }`, and inserts them into `DevicePowerStream` stream. From which the `surge-detector` query calculates the total power consumed in the last 1 minute, and if the total value is greater than or equal to `10000`W, it generates an event once every 30 seconds, and inserts into the `PowerSurgeAlertStream` stream. The `PowerSurgeAlertStream` then logs them on the console using a log sink.

This app is stateful as it has a window of 1 minute and it needs to preserve the running sum of power consumption during failures and restarts.

For more information in developing Siddhi Apps, refer the [Siddhi Documentation](http://siddhi.io/redirect/docs).

**Prerequisites for deploying the app**

- NATS - As an internal messaging layer allowing the distributed Siddhi Apps to communicate with each other.
- NATS Streaming - To preserve the messages for reply upon failure.
- Ingress - As the App consumes events via HTTP, and Siddhi uses NGINX ingress controller to receive HTTP/HTTPS requests.
- Persistence Volume - To preserve the periodic state snapshots of Siddhi. 
- Siddhi Operator - For deploying and managing Siddhi Apps on Kubernetes.

The next section provides instructions on installing the prerequisites.
