This section provides instructions on testing the stateless Siddhi Apps that's deployed in the previous step.

### Sending Events 

Use the following cURL command to send multiple HTTP requests. 

`
    curl -X POST \
    http://siddhi/power-surge-app-0/8080/checkPower \
    -H 'Accept: */*' \
    -H 'Content-Type: application/json' \
    -H 'Host: siddhi' \
    -d '{
          "deviceType": "dryer",
          "power": 600
        }'
`{{execute}}

The deployed Siddhi App will log the messages if the device type is `dryer` and power is greater than or equals to `600`W.

### Viewing Logs 

Following command can be used to view the logs from `power-surge-app-0` pod. 

`kubectl logs $(kubectl get pods | awk '{ print $1 }' | grep ^power-surge-app-0) | tail -n 10`{{execute}}

The event logs will be something similar to the following.

```
...
[2019-08-02 05:13:07,008]  INFO {io.siddhi.core.stream.output.sink.LogSink} - LOGGER : Event{timestamp=1564722787005, data=[dryer, 600], isExpired=false}
```