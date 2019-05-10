
################################################################################
################################################################################
################################################################################
################################################################################
#
#      ███╗   ███╗ █████╗ ██╗███╗   ██╗██╗      ██████╗  ██████╗ ██████╗ 
#      ████╗ ████║██╔══██╗██║████╗  ██║██║     ██╔═══██╗██╔═══██╗██╔══██╗
#      ██╔████╔██║███████║██║██╔██╗ ██║██║     ██║   ██║██║   ██║██████╔╝
#      ██║╚██╔╝██║██╔══██║██║██║╚██╗██║██║     ██║   ██║██║   ██║██╔═══╝ 
#      ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║███████╗╚██████╔╝╚██████╔╝██║     
#      ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝     
#                                                                  
################################################################################
################################################################################
################################################################################
################################################################################                            

import times

app.initTerminal()
app.recalc()
release(app.termlock)
app.draw()
#-------------------------------------------------------------------------------    

proc checkTerminalResized()=
  ## used as/via TimedAction action
  ## used internally
  if app.terminalHeight != terminalHeight() or app.terminalWidth != terminalWidth():
    app.terminalHeight = terminalHeight()
    app.terminalWidth  = terminalWidth()
    app.recalc()
    for iws in app.workSpaces:
      for it in iws.tiles:
        for iw in it.windows:
          if iw.currentPage > iw.pages.high: iw.currentPage = iw.pages.high
    app.draw()
#.............

var 
  rT:TimedAction=(
    name:"termresize",
    interval: 2.float,
    action: nil, #O.o: adding checkTerminalResized here results error
    lastrun:epochTime()
    )

rT.action = checkTerminalResized
app.timers.add(rT)
#-------------------------------------------------------------------------------

var mainChannel : Channel[string]
mainChannel.open()

app.itc = addr mainChannel

proc runChannels()=
  for iMsg in 0..2: # anti flood
    var inbox = tryRecv( (mainChannel) ) #tuple[dataAvailable: bool, msg: TMsg]
    if inbox.dataAvailable:
      case inbox.msg:
        of "redraw":
          app.redraw()
        of "quit":
          quit()
        else:
          app.trigger(inbox.msg)
    else: break
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------

var kmloopFlowVar = spawn kmLoop() #KMEvent
var kmEvent: KMEvent
  while true:

    app.runTimers()
    #......

    runChannels()
    #......

    if kmloopFlowVar.isReady(): #! it consumes LOT of cpu | req by: app.runTimers()

      kmEvent = KMEvent(^kmloopFlowVar) # it stops here anyway...

      case kmEvent.evType:
        of "Click","Release","Drag","Drop", "ScrollUp","ScrollDown", "DoubleClick":
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
              break # == quit
          else:
            break # == quit
        else: discard

      kmloopFlowVar = spawn kmLoop() #KMEvent

    sleep(0)


app.closeTerminal()

################################################################################
################################################################################
################################################################################
################################################################################