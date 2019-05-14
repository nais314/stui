var mainChannelString = getMcsChannel()
mainChannelString[].open()

proc handleMainChannelString()=
  var inbox = tryRecv( (mainChannelString[]) ) #tuple[dataAvailable: bool, msg: TMsg]
  if inbox.dataAvailable:
    #when defined(logger_enabled): debug  repr(inbox)
    case inbox.msg:
    of "hello":
        when defined(logger_enabled): notice  "   $$$ handleMainChannelString recived> "
    of "quit":
        withLock app.termlock: quit()
    else:
        app.trigger(inbox.msg)
