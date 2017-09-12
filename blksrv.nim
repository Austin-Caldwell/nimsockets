import net

const ack = "\x0212345^ACK^20170912145323\x03"

proc main(port : int) =
  var socket = newSocket()
  socket.bindAddr(Port(port))
  socket.listen()
  var client = newSocket()
  var address = ""
  while true:
    echo("Waiting for connection...")
    socket.acceptAddr(client, address)
    echo("Client connected from: ", address)
    try:
      while true:
        echo("Receiving...")
        var msg = ""
        var c : string
        while c != "" and c != "\x03":
          c = client.recv(1, 60000)
          msg &= c
        echo("Received: ", msg)
        if c == "": break
        echo("Sending...")
        client.send(ack)
        echo("Sent: ", ack)
    finally:
      client.close() # Necessary so we can send another request

when isMainModule:
  import os
  from strutils import parseInt
  if paramCount() > 0:
    let x = paramStr(1)
    main(parseInt(x))
  else:
    stderr.writeLine("Exported parameter: port")
