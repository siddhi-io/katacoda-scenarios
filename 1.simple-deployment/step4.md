Send an event using an HTTP request. You can send multiple HTTP requests. The Siddhi app will print the log if the device type is dryer and power is greater than or equals to 600W.

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

Use the following command to view logs. Logs will print in every 30 seconds, therefore please wait for a couple of seconds to view the logs.

`kubectl logs $(kubectl get pods | awk '{ print $1 }' | grep ^power-surge-app-0) | tail -n 10`{{execute}}

The event should be logged as below.

```
...
[2019-08-02 05:13:07,008]  INFO {io.siddhi.core.stream.output.sink.LogSink} - LOGGER : Event{timestamp=1564722787005, data=[dryer, 600], isExpired=false}
```