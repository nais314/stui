var mainChannelString = getMcsChannel()
mainChannelString[].open()

proc handleMainChannelString()=
  block: #for iMsg in 0..2: #? anti flood
      var inbox = tryRecv( (mainChannelString[]) ) #tuple[dataAvailable: bool, msg: TMsg]
      if inbox.dataAvailable:
          when defined(debugInfo_enabled): debugEcho repr(inbox)
          case inbox.msg:
              of "hello":
                  echo "     $$$ handleMainChannelString recived> "
              of "quit":
                  quit()
              else:
                  app.trigger(inbox.msg)
      else: break