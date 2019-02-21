import net, times

proc main(port : int) =
  var client = newSocket()
  client.connect("localhost", Port(port))
  while true:
    try:
        var currentTime = format(now(), "yyyyMMddhhmmss")
        echo("Enter Tote LPN: ")
        var toteLpn : string;
        toteLpn = stdin.readLine()
        echo("Send what? ('DIVERTED', 'QUERY', 'SHIPCOMPLETE', 'ENTER')")
        var toSend : string;
        case stdin.readLine()
          of "DIVERTED":
            echo("Enter Divert Zone: ")
            var divertZone : string;
            divertZone = stdin.readLine()
            toSend = "\x02" & "12345^DIVERTED^" & currentTime & "^DIVERTED^" & currentTime & "^" & toteLpn & "^" & divertZone & "\x03"
          of "QUERY":
            toSend = "\x02" & "12345^QUERY^" & currentTime & "^QUERY^" & currentTime & "^" & toteLpn & "\x03"
          of "SHIPCOMPLETE":
            echo("Enter Weight: ")
            var weight : string;
            weight = stdin.readLine()
            echo("Enter Divert Lane (Ship1-Ship9): ")
            var divertLane : string;
            divertLane = stdin.readLine()
            toSend = "\x02" & "12345^SHIPCOMPLETE^" & currentTime & "^SHIPCOMPLETE^" & currentTime & "^" & toteLpn & "^" & weight & "^" & divertLane & "\x03"
          of "ENTER":
            toSend = "\x02" & "12345^ENTER^" & currentTime & "^ENTER^" & currentTime & "^" & toteLpn & "\x03"
          else:
            toSend = ""
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
