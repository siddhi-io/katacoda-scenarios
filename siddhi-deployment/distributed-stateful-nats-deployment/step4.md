Siddhi operator divides the given Siddhi app into two partial Siddhi apps and deploys both apps in two kubernetes deployments. Those two apps are,

1. Passthrough app (power-consume-app-0)
1. Process app  (power-consume-app-1)

Passthrough app receives HTTP requests and redirects those requests to the NATS streaming cluster. Process app receives events from NATS, execute the logic, and logs the output.

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

`kubectl logs $(kubectl get pods | awk '{ print $1 }' | grep ^power-consume-app-1) | tail -n 10`{{execute}}

The event should be logged as below.

```
...
[2019-08-02 10:54:59,109]  INFO {io.siddhi.core.stream.output.sink.LogSink} - LOGGER : Event{timestamp=1564743269232, data=[dryer, 100000], isExpired=false}
```