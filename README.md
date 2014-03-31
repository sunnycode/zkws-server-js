# WebSocket bridge for ZooKeeper

Used for fast failover and dynamic configuration.

Point this server at a ZooKeeper cluster. Point
UpdateClient instances at this server instance.

Clients will receive data values upon connecting,
as well as after any disconnect/reconnect operations.

# Usage

```node lib/zkws-server.js 8080 'localhost:2181'```

* The first argument is the port to listen on
* The second argument is the zookeeper connection string

