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
  mciQuit = int.high

proc handleMainChannelInt()=
  block: #for iMsg in 0..2: #? anti flood
      var inbox = tryRecv( (mainChannelInt[]) ) #tuple[dataAvailable: bool, msg: TMsg]
      if inbox.dataAvailable:
          #when defined(debugInfo_enabled): debugEcho repr(inbox)
          case inbox.msg:
              of 1: #"redraw":
                  echo "+++++++ Hello MainChannelInt!"
              of int(mciQuit): #"quit":
                  quit()
              else:
                  app.trigger($ inbox.msg)
      else: break
      sleep(0)