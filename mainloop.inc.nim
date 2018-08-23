
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

#[ resetAttributes()
echo "\ec\e[0m" # ? reset
echo "\e[?1002h\e[?1006h" # mouse
echo "\e%G" # ? set UTF8
echo "\e[7l" # dont wrap ]#
app.initTerminal()
app.recalc()
release(app.termlock)
app.draw()


#...........................................        
import times

proc checkTerminalResized()=
    if app.terminalHeight != terminalHeight() or app.terminalWidth != terminalWidth():
        app.terminalHeight = terminalHeight()
        app.terminalWidth  = terminalWidth()
        app.recalc()
        app.draw()
        # todo: trigger on resize app.listeners -> "resize"


#.............

var 
    #[ tA:TimedAction = (
        name:"test",
        interval:1.float,
        action:(proc(){.closure.}=
            for a in 0..1000000:
                discard)
        ,lastrun:epochTime()) ]#

    rT:TimedAction=(
        name:"termresize",
        interval: 2.float,
        action: nil, #O.o: adding checkTerminalResized here results error
        lastrun:epochTime()
        )

rT.action = checkTerminalResized

#app.timers.add(tA)
app.timers.add(rT)

#..........................................
var kmloopFlowVar = spawn kmLoop() #KMEvent
var kmEvent: KMEvent
block LOOP:
    while true:

        app.runTimers()
        #......

        if kmloopFlowVar.isReady(): #! it consumes LOT of cpu | req by: app.runTimers()

            kmEvent = KMEvent(^kmloopFlowVar) # it stops here anyway...

            case kmEvent.evType:
                of "Click","Release","Drag","Drop", "ScrollUp","ScrollDown":
                    app.mouseEventHandler(kmEvent)


                of "FnKey","CtrlKey", "Char": # vscode terminal middle mouse click triggers this too...
                    # KeyPgUp, KeyPgDown trigger controlls cb first then apps
                    if kmEvent.key in [KeyPgUp, KeyPgDown]:
                        if app.activeControll != nil and app.activeControll.onKeypress != nil:
                            app.activeControll.onKeypress(app.activeControll, kmEvent)
                        else:
                            if app.onKeypress != nil: 
                                discard app.onKeypress(app, kmEvent)
                    else: # trigger apps cb first, then controlls
                        if app.onKeypress != nil and app.onKeypress(app, kmEvent) == false: #! changed

                            if app.activeControll != nil and app.activeControll.onKeypress != nil:
                                app.activeControll.onKeypress(app.activeControll, kmEvent)

                of "EXIT":
                    if app.activeControll != nil:
                        try:
                            if app.activeControll.cancel != nil:
                                app.activeControll.cancel(app.activeControll)
                            app.activeControll = nil
                        except:
                            break LOOP
                    else:
                        break LOOP
                else: discard

            kmloopFlowVar = spawn kmLoop() #KMEvent

        sleep(0)


app.closeTerminal()
#............
#var a = stdin.readLine()
################################################################################
################################################################################
################################################################################
################################################################################