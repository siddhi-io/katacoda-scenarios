This section provides instructions on testing the stateful Siddhi Apps that's deployed in the previous step.

### Sending Events 

Use the following cURL command to send multiple HTTP requests. 

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

### Viewing Logs 

The App logs messages once every 30 seconds if the total power consumed within the last 1 minute is greater than `10000`W.

Run the following command to view the logs from pod `power-consume-app-0`. 

`kubectl logs $(kubectl get pods | awk '{ print $1 }' | grep ^power-consume-app-0) | tail -n 10`{{execute}}

The processed events will be logged similar to the following log segment.

```
...
[2019-08-02 11:46:40,171]  INFO {io.siddhi.core.stream.output.sink.LogSink} - LOGGER : Event{timestamp=1564746370967, data=[dryer, 100000], isExpired=false}
```

Based on the deployed Siddhi App, as the events are logged once every 30 seconds.

**Congratulations on successfully completing the scenario!**