import net

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
    while socket.hasDataBuffered():
      echo("Receiving...")
      echo("Received:", socket.recv(1, 10000))
    echo("Done receiving.")
    echo("Enter response content: ")
    client.send("\x02" & stdin.readLine() & "\x03")
    client.close() # Necessary so we can send another request

when isMainModule:
  import os
  from strutils import parseInt
  if paramCount() > 0:
    let x = paramStr(1)
    main(parseInt(x))
  else:
    stderr.writeLine("Exported parameter: port")
