## the simplest channel - int.
## deeply copied, fire and forget ;)
##
## import appbase/intchannelutils
## var msg = unpackIntMsg(inbox.msg.uint) returns an array[0..3, uint]
## so, you have a 4 level message tree if you like/see so
## like app functions (1), shop functions (11), shop fun category (x), shop fun (243)
## levels based on int size, see src

var mainChannelInt = getMciChannel()
mainChannelInt[].open()

type mainChannelIntCodes = enum
  mciHello = 1,
  mciQuit = int.high - 1

proc handleMainChannelInt()=
  var inbox = tryRecv( (mainChannelInt[]) ) #tuple[dataAvailable: bool, msg: TMsg]
  if inbox.dataAvailable:
    case inbox.msg:
      of 1: #"redraw":
        when defined(logger_enabled): debug "+++++++ Hello MainChannelInt!"
        discard
      of int(mciQuit): #"quit":
        app.quit()
      else:
        app.trigger($ inbox.msg)
