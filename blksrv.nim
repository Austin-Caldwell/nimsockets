import net, times

proc getFormattedAck(): string =
  "\x02" & "12345^ACK^" & format(now(), "yyyyMMddhhmmss") & "\x03"

proc main(port : int) =
  var socket = newSocket()
  socket.bindAddr(Port(port))
  socket.listen()
  var client = new Socket
  var address = ""
  while true:
    echo("Waiting for connection...")
    socket.acceptAddr(client, address)
    echo("Client connected from: ", address)
    try:
        echo("Receiving...")
        var msg = ""
        var c : string
        while c != "" and c != "\x03":
          c = client.recv(1, 60000)
          msg &= c
        echo("Received: ", msg)
        if c == "": break
        echo("Sending...")
        var ack = getFormattedAck()
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
