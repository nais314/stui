var mainChannelString = getMcsChannel()
mainChannelString[].open()

proc handleMainChannelString()=
  var inbox = tryRecv( (mainChannelString[]) ) #tuple[dataAvailable: bool, msg: TMsg]
  if inbox.dataAvailable:
    case inbox.msg:
    of "hello":
        when defined(logger_enabled): debug  "   $$$ handleMainChannelString recived> "
    of "quit":
        app.quit()
    else:
        app.trigger(inbox.msg)
