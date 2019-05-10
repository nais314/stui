type
    #McicChannel* = Channel[tuple[val:int,chan:ptr Channel[int]]]
    MainChannelIntCheckedCodes* = enum #! OVERWRITE THIS
        mcicHello = 1,
        mcicQuit = int.high

var mainChannelIntChecked = getMcicChannel()
mainChannelIntChecked[].open()
proc handleMainChannelIntChecked()= #! OVERWRITE THIS
  block: #for iMsg in 0..1: #? anti flood
    var inbox = tryRecv( (mainChannelIntChecked[]) ) #tuple[dataAvailable: bool, msg: TMsg]
    if inbox.dataAvailable:
        inbox.msg.chan[].open()
        when defined(debugInfo_enabled): debugEcho "::: handleMainChannelIntChecked recv> ", inbox.msg.val
        case inbox.msg.val:
            of 1:
                echo "::: Hello MainChannelIntChecked!"
                
                inbox.msg.chan[].send(4)

            of int(mcicQuit): #"quit":
                quit()
                #inbox.msg.chan.send(0)
            else:
                when defined(debugInfo_enabled): debugEcho "::: handleMainChannelIntChecked> else"
                app.trigger($ inbox.msg.val)
    else: break
    sleep(0)