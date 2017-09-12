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
    var line : string
    while line != "EOM" and line != "":
      line = client.recvLine()
      echo("Received:", line)
      if line != "":
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
