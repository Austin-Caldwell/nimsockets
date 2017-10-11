import net

const keepa = "\x0212345^KEEPA^20170912145323\x03"
const deformed = "\x0212345^KEEPA^201709121453233"

proc main(port : int) =
  var client = newSocket()
  client.connect("localhost", Port(port))
  try:
    while true:
      echo("Send what?")
      var toSend : string;
      case stdin.readLine()
      of "", "keepa":
        toSend = keepa
      of "deformed":
        toSend = deformed
      else:
        break;
      echo("Sending...")
      client.send(toSend)
      echo("Sent: ", toSend)
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
    stderr.writeLine("Expected parameter: port")
