import net, times

proc main(port : int) =
  var client = newSocket()
  client.connect("localhost", Port(port))
  try:
    while true:
      echo("Send what? ('keepa' or 'deformed')")
      var toSend : string;
      case stdin.readLine()
      of "", "keepa":
        toSend = "\x02" & "12345^KEEPA^" & format(now(), "yyyyMMddhhmmss") & "\x03"
      of "deformed":
        toSend = "\x02" & "12345^KEEPA^" & format(now(), "yyyyMMddhhmmss")
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
