Send an event using an HTTP request. You can send multiple HTTP requests. The Siddhi app will print the log in every 30 seconds if the total power you send is greater than 10000W.

`
    curl -X POST \
    http://siddhi/power-consume-app-0/8080/checkPower \
    -H 'Accept: */*' \
    -H 'Content-Type: application/json' \
    -H 'Host: siddhi' \
    -d '{
    "deviceType": "dryer",
    "power": 100000
    }'
`{{execute}}

Use the following command to view logs. Logs will print in every 30 seconds, therefore please wait for a couple of seconds to view the logs.

`kubectl logs $(kubectl get pods | awk '{ print $1 }' | grep ^power-consume-app-0) | tail -n 10`{{execute}}

The event should be logged as below.

```
...
[2019-08-02 11:46:40,171]  INFO {io.siddhi.core.stream.output.sink.LogSink} - LOGGER : Event{timestamp=1564746370967, data=[dryer, 100000], isExpired=false}
```