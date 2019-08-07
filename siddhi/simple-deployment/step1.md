[Siddhi](http://siddhi.io) is a cloud-native, scalable, Streaming and Complex Event Processing System capable of building real-time applications.

In this scenario, we will see how we can deploy a simple Siddhi Application that receives HTTP request and log those requests. We will be deploying the following `PowerSurgeDetection` app.

```programming
@App:name("PowerSurgeDetection")
@App:description("App consumes events from HTTP as a JSON message of { 'deviceType': 'dryer', 'power': 6000 } format and inserts the events into DevicePowerStream, and alerts the user if the power level is greater than or equal to 600W by printing a message in the log.")
/*
    Input: deviceType string and powerConsuption int(Watt)
    Output: Alert user from printing a log, if there is a power surge in the dryer. In other words, notify when power is greater than or equal to 600W.
*/

@source(
  type='http',
  receiver.url='${RECEIVER_URL}',
  basic.auth.enabled='false',
  @map(type='json')
)
define stream DevicePowerStream(deviceType string, power int);
@sink(type='log', prefix='LOGGER')  
define stream PowerSurgeAlertStream(deviceType string, power int);

@info(name='power-filter')  
from DevicePowerStream[deviceType == 'dryer' and power >= 600] 
select deviceType, power  
insert into PowerSurgeAlertStream;
```

The above query consumes events from `HTTP` as a `JSON` message of `{ 'deviceType': 'dryer', 'power': 6000 }` format, and inserts the events into `DevicePowerStream`. From which using the query `surge-detector`, it receives all the HTTP events from `DevicePowerStream`. If the given HTTP event has device type as dryer and the power consumption is greater than or equals to 600W, then that event will be inserted into the `PowerSurgeAlertStream`. The `PowerSurgeAlertStream` simply log the received event.

This app is stateless because it just receives HTTP events, filter those events, and log it.

Prerequisites on deploying this app:

- Ingress - As Siddhi uses NGINX ingress controller to receive HTTP/HTTPS requests.
- Siddhi Operator - For deploying and managing Siddhi Apps.

The following section explains how we can install the prerequisites.
