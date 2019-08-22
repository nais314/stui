## template for appbase library
## copy-paste, save-as, customize :-)

import stui/appbase/appbase # this comes from pkg
import appbase/myappbasetypes # this comes from users subdir
import threadpool, tables, os
## on appbase/myappbasetypes: here, appbase is the subdirectory, not the pkg!

when defined logger_enabled:
  #! it declares a logger - override it as needed <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  include "appbase/inc/logger.nim"

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#! ADD imports HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

import stui, terminal, colors, threadpool, os, tables, locks, parsecfg

import stui/[colors_extra, terminal_extra, kmloop]
import stui/[ui_textbox, ui_button, ui_textarea, ui_stringlistbox]

import strformat, unicode, strutils, parseutils, random, times

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#! app init defaults <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

var app: MyApp ## (i) from your myappbasetypes
app = newApp(splitPath(currentSourcePath()).head ) # (path to themes)

app.threadId = 0  ## convention.
                  ## replaced getThreadId(), because a Thread does not knows it, 
                  ## and app is not GCsafe to get it from...

app.quit = proc(errorcode: int = QuitSuccess) =
  withLock app.termlock: # don't write on terminal
    app.flags[int(quitFlag)] = 1 # thread loop break
    sleep(100) # grace time
    system.quit(errorcode)

proc appQuit() =
  app.quit(QuitSuccess)
#...............................................................................    

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

var 
  rT:TimedAction=(
    name:"termresize",
    interval: 2.float,
    action: nil, #O.o: adding checkTerminalResized here results error
    lastrun:epochTime()
    )

rT.action = checkTerminalResized
app.timers.add(rT)

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#! INITIALIZE EVENT HANDLERS HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#!  appbase.mainloop calls Channels handlers see appbase folder for templates
#!  SIMPLE InterCom - thread to main communication:

when defined mainChannelString_enabled: include "appbase/inc/mainChannelString.nim"
#-------------------------------------------------------------------------------
when defined mainChannelInt_enabled: include "appbase/inc/mainChannelInt.nim"
#-------------------------------------------------------------------------------
when defined mainChannelIntChecked_enabled: include "appbase/inc/mainChannelIntChecked.nim"
#-------------------------------------------------------------------------------
when defined mainChannelIntTalkback_enabled: include "appbase/inc/mainChannelIntTalkback.nim"
#-------------------------------------------------------------------------------
#!  INTERCOM - inter-thread capable communication:
when defined mainChannelJsonChecked_enabled: 
  import json
  include "appbase/inc/mainChannelJson.nim"

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#! INCLUDE GUI INIT HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
include "main.inc.nim"

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#! a good place to add some tests ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#! end of a good place to add some tests ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#! RUN ☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰
#! terminal init and app starts to run here
#! create gui controlls BEFORE this

app.initTerminal()
app.recalc()
app.draw()

#! MAIN LOOP--------------------------------------------------------------------

var inputLoopEvent: InputLoopEvent #! (i) from myappbasetypes
var inputLoopEventFlowVar: FlowVar[InputLoopEvent]

#! MAIN LOOP STARTS HERE:
when defined inputEventLoop_enabled:
  inputLoopEventFlowVar = spawn kmLoop() #! REPLACE PROC WITH YOURS #1/2 <<<<<<<

app.mainLoop:
  ##! 'here' appbase.mainloop calls Channels handlers see above ^ 
  ## ...........................................................................
  ##! GET EVENT OBJECT: (only runs if inputLoopEventFlowVar.isReady)
  inputLoopEvent = InputLoopEvent(^inputLoopEventFlowVar) # it stops here anyway...

  #! PROCESS MESSAGE HERE -- case inputLoopEvent, of x: etc

  case inputLoopEvent.evType:
    of KMEventKind.Click,KMEventKind.Release,KMEventKind.Drag,KMEventKind.Drop, KMEventKind.ScrollUp,KMEventKind.ScrollDown, KMEventKind.DoubleClick:
      app.mouseEventHandler(inputLoopEvent)

    of KMEventKind.FnKey,KMEventKind.CtrlKey, KMEventKind.Char: # vscode terminal middle mouse click triggers this too...
      # KeyPgUp, KeyPgDown trigger controlls cb first then apps
      if inputLoopEvent.key in [KeyPgUp, KeyPgDown]:
        if app.activeControll != nil and app.activeControll.onKeypress != nil:
          app.activeControll.onKeypress(app.activeControll, inputLoopEvent)
        elif app.onKeypress != nil: 
          discard app.onKeypress(app, inputLoopEvent)
      else: # trigger apps cb first, then controlls
        if app.onKeypress != nil and app.onKeypress(app, inputLoopEvent) == false:
          # if app not handles this, then try controlls
          if app.activeControll != nil and app.activeControll.onKeypress != nil:
            app.activeControll.onKeypress(app.activeControll, inputLoopEvent)

    of KMEventKind.Exit:
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

  ##! RESTART LOOP:
  inputLoopEventFlowVar = spawn kmLoop() #! REPLACE PROC WITH YOURS #2/2 <<<<<<<
