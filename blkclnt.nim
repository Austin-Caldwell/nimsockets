import net

proc main(port : int) =
  var client = newSocket()
  client.connect("localhost", Port(port))
  client.send("\x02" & stdin.readLine() & "\x03\c\L")
  echo("Receiving...")
  echo("Received:", client.recv(1, 10000))
  echo("Done receiving.")
  client.close() # Necessary so we can send another request

when isMainModule:
  import os
  from strutils import parseInt
  if paramCount() > 0:
    let x = paramStr(1)
    main(parseInt(x))
  else:
    stderr.writeLine("Exported parameter: port")
