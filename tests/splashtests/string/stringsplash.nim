import threadpool, locks, os,  tables
import stui, stui/kmloop
import terminal, stui/terminal_extra,  colors, stui/colors_extra

import stui/ui_menu


proc newSimpleApp(): App =
    # Basic App init
    result = newApp(splitPath(currentSourcePath()).head ) # (path to themes)
    # at start, set activeWorkspace & activeTile manually!
    result.activeWorkSpace = result.newWorkSpace("WorkSpace1")
    result.activeTile = result.activeWorkSpace.newTile("auto")
    discard result.activeTile.newWindow("Window1")
    result.activeWindow.styles["window"].padding.left = 1
    result.activeWindow.styles["window"].padding.top = 1

var app = newSimpleApp()

# MENU -------------------------------------------------------------------------
var menu1 = app.newMenu()
menu1.setMargin("all",2)
discard menu1.currentNode.addChild("Quit",proc() = quit())
app.activeWindow.addEventListener("menu", proc(c:Controll) = menu1.show())


################################################################################
################################################################################
# INCLUDE YOUR LINES HERE: -----------------------------------------------------



import stui/ui_splash

var splash = app.activeWindow.newSplash("""
███████╗████████╗██╗   ██╗██╗
██╔════╝╚══██╔══╝██║   ██║██║
███████╗   ██║   ██║   ██║██║
╚════██║   ██║   ██║   ██║██║
███████║   ██║   ╚██████╔╝██║
╚══════╝   ╚═╝    ╚═════╝ ╚═╝""")

#...............................................................................


import stui/ui_button

var splashBtn = app.activeWindow.newButton("SPLASH",2,2)
splashBtn.setMargin("top", 1)

proc splashBtnClick(this:Controll)=
  splash.drawit(splash, true)
  sleep(1000)
  splash.app.recalc()
  splash.app.draw()

splashBtn.addEventListener("click", splashBtnClick)



var quitBtn = app.activeWindow.newButton("quit",1,1)
quitBtn.setMargin("top", 1)

proc quitBtnClick(this:Controll)=
  this.app.quit(QuitSuccess)

quitBtn.addEventListener("click", quitBtnClick)



################################################################################
################################################################################



#! RUN ☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰
#! terminal init and app starts to run here
#! create gui controlls BEFORE this

app.initTerminal()

splash.draw()
sleep(1000)

app.recalc()
app.draw()


#! MAIN LOOP--------------------------------------------------------------------

var inputLoopEvent: KMEvent #! (i) from myappbasetypes
var inputLoopEventFlowVar: FlowVar[KMEvent]

#! MAIN LOOP STARTS HERE:
inputLoopEventFlowVar = spawn kmLoop() #! REPLACE PROC WITH YOURS #1/2 <<<<<<<

while true:
  inputLoopEvent = KMEvent(^inputLoopEventFlowVar) # it stops here anyway...

  #! PROCESS MESSAGE HERE -- case inputLoopEvent, of x: etc

  case inputLoopEvent.evType:
    of "Click","Release","Drag","Drop", "ScrollUp","ScrollDown", "DoubleClick":
      app.mouseEventHandler(inputLoopEvent)

    of "FnKey","CtrlKey", "Char": # vscode terminal middle mouse click triggers this too...
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

  ##! RESTART LOOP:
  inputLoopEventFlowVar = spawn kmLoop() #! REPLACE PROC WITH YOURS #2/2 <<<<<<<


################################################################################
################################################################################
