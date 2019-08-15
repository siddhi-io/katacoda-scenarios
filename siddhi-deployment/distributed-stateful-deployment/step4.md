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

The deployed Siddhi App (`power-consume-app-1`) will log the messages once every 30 seconds if the total power consumed within the last 1 minute is greater than `10000`W.

Following command can be used to view the logs from pod `power-consume-app-1`. 

`kubectl logs $(kubectl get pods | awk '{ print $1 }' | grep ^power-consume-app-1) | tail -n 10`{{execute}}

The processed events will be logged once every 30 seconds similar to the following log segment.

```
...
[2019-07-31 10:25:52,485]  INFO {io.siddhi.core.stream.output.sink.LogSink} - LOGGER : Event{timestamp=1564568739939, data=[dryer, 100000], isExpired=false}
```

Based on the deployed Siddhi App, as the events are logged once every 30 seconds, at times, please wait for a couple of seconds to view the processed logs.

**Congratulations on successfully completing the scenario!**