import net

const keepa = "\x0212345^KEEPA^20170912145323\x03"

proc main(port : int) =
  var client = newSocket()
  client.connect("localhost", Port(port))
  try:
    while true:
      echo("Sending...")
      client.send(keepa)
      echo("Sent: ", keepa)
      echo("Receiving...")
      var msg = ""
      var c : string
      while c != "" and c != "\x03":
        c = client.recv(1, 60000)
        msg &= c
      echo("Received: ", msg)
      if c == "": break
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
