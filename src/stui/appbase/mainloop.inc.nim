
################################################################################
################################################################################
################################################################################
################################################################################
#  
#  ███▄ ▄███▓ ▄▄▄       ██▓ ███▄    █     ██▓     ▒█████   ▒█████   ██▓███  
#  ▓██▒▀█▀ ██▒▒████▄    ▓██▒ ██ ▀█   █    ▓██▒    ▒██▒  ██▒▒██▒  ██▒▓██░  ██▒
#  ▓██    ▓██░▒██  ▀█▄  ▒██▒▓██  ▀█ ██▒   ▒██░    ▒██░  ██▒▒██░  ██▒▓██░ ██▓▒
#  ▒██    ▒██ ░██▄▄▄▄██ ░██░▓██▒  ▐▌██▒   ▒██░    ▒██   ██░▒██   ██░▒██▄█▓▒ ▒
#  ▒██▒   ░██▒ ▓█   ▓██▒░██░▒██░   ▓██░   ░██████▒░ ████▓▒░░ ████▓▒░▒██▒ ░  ░
#  ░ ▒░   ░  ░ ▒▒   ▓▒█░░▓  ░ ▒░   ▒ ▒    ░ ▒░▓  ░░ ▒░▒░▒░ ░ ▒░▒░▒░ ▒▓▒░ ░  ░
#  ░  ░      ░  ▒   ▒▒ ░ ▒ ░░ ░░   ░ ▒░   ░ ░ ▒  ░  ░ ▒ ▒░   ░ ▒ ▒░ ░▒ ░     
#  ░      ░     ░   ▒    ▒ ░   ░   ░ ░      ░ ░   ░ ░ ░ ▒  ░ ░ ░ ▒  ░░       
#         ░         ░  ░ ░           ░        ░  ░    ░ ░      ░ ░           
################################################################################
################################################################################
################################################################################
################################################################################                                                      

import os, locks, times, threadpool

var app: AppBase

#! ADD APP INIT HERE
app = new AppBase

#-------------------------------------------------------------------------------        
#import times

proc sampleTimedAction()=
    sleep(200)


#.............

var 

    sTA:TimedAction=(
        name:"sampleTimedAction",
        interval: 2.float,
        action: nil, #? O.o: adding checkTerminalResized here results error
        lastrun:epochTime()
        )

sTA.action = sampleTimedAction

app.timers.add(sTA)



#-------------------------------------------------------------------------------
# SIMPLE InterCom
var mainChannelString : Channel[string]
mainChannelString.open()


proc handleMainChannelString()=
    for iMsg in 0..2: #? anti flood
        var inbox = tryRecv( (mainChannelString) ) #tuple[dataAvailable: bool, msg: TMsg]
        if inbox.dataAvailable:
            case inbox.msg:
                of "redraw":
                    discard #app.redraw()
                of "quit":
                    quit()
                else:
                    app.trigger(inbox.msg)
        else: break
#-------------------------------------------------------------------------------
# SIMPLE INT InterCom -- maybe int is the fastest?
# enum to int for readability?

var mainChannelInt : Channel[int]
mainChannelInt.open()


proc handleMainChannelInt()=
    for iMsg in 0..2: #? anti flood
        var inbox = tryRecv( (mainChannelInt) ) #tuple[dataAvailable: bool, msg: TMsg]
        if inbox.dataAvailable:
            case inbox.msg:
                of 1: #"redraw":
                    discard #app.redraw()
                of int.high: #"quit":
                    quit()
                else:
                    app.trigger($ inbox.msg)
        else: break
#-------------------------------------------------------------------------------
# Thread Json InterCom
#   bChannel = Channel[string] -- ok,err,stb
#   MsgFeed = table[thId, bChannel]
#   TJIcom = Table[string, MsgFeed]
#   TJIcom["name"].subscribe(tuple(thId, bChannel))
#   TJIcom["name"].broadcast(typ:int,msg:string Json)

#-------------------------------------------------------------------------------
# FLAGS
# array[5, int] :-)
#    type
#        Flags = enum
#            guiFlag,
#            debugFlag,
#            maintFlag
#    
#    var
#        rumba: array[Flags, int]
#    
#    rumba[maintFlag] = 5

#-------------------------------------------------------------------------------


#! var kmloopFlowVar = spawn kmLoop() #KMEvent
#! var kmEvent: EventRoot
block LOOP:
    while true:

        app.runTimers()
        #......
        when defined mainChannelInt_enabled: handleMainChannelInt()
        when defined mainChannelString_enabled: handleMainChannelString()
        
        #......

        if inputLoopEventFlowVar.isReady(): #! it consumes LOT of cpu | req by: app.runTimers()

            inputLoopEvent = EventRoot(^inputLoopEventFlowVar) # it stops here anyway...

            # PROCESS MESSAGE HERE

            inputLoopEventFlowVar = spawn inputEventLoop() #EventRoot

        sleep(0) #! cpuRelax


#app.close()
#............
################################################################################
################################################################################
################################################################################
################################################################################