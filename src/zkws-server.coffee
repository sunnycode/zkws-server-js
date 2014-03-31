
_      = require 'underscore'
util   = require 'util'
os     = require 'os'
zookeeper     = require 'node-zookeeper-client'

io     = require('socket.io').listen(parseInt(process.argv[2] || '8080'))
zkCfg  = process.argv[3] || 'localhost:2181'

# start ZooKeeper client
zkc = ->
  zk = {}
  zk.client = zookeeper.createClient zkCfg
  zk.client.once 'connected', -> console.log 'Connected to the ZK server.'
  zk.client.connect()
  zk.watch = (path, socket) ->
    finish     = (err, data) -> socket.emit 'update', {path:path,value:data.toString()}
    notify     = -> zk.client.getData path, notify, finish
    getAndSend = -> zk.client.getData path, notify, finish
    getAndSend()
  zk

client = zkc()

# hook up server events
io.sockets.on 'connection', (socket) ->
  console.log 'client connected'
  socket.on 'watch', (data) ->
    console.log 'client subscribe', arguments
    client.watch(data.path, socket)
  socket.on 'disconnect', (socket) ->
    console.log 'client disconnected', arguments

