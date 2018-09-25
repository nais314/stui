import threadpool, locks, os,  tables
import stui, kmloop
import terminal, terminal_extra,  colors, colors_extra

import ui_menu


proc newSimpleApp(): App =
    # Basic App init
    result = newApp()
    # at start, set activeWorkspace & activeTile manually!
    result.activeWorkSpace = result.newWorkSpace("WorkSpace1")
    result.activeTile = result.activeWorkSpace.newTile("auto")
    discard result.activeTile.newWindow("Window1")
    result.activeWindow.styles["panel"].padding.left = 1
    result.activeWindow.styles["panel"].padding.top = 1

var app = newSimpleApp()

# MENU -------------------------------------------------------------------------
var menu1 = app.newMenu()
menu1.setMargin("all",2)
discard menu1.currentNode.addChild("Quit",proc() = quit())
app.activeWindow.addEventListener("menu", proc(c:Controll) = menu1.show())


################################################################################
################################################################################
# INCLUDE YOUR LINES HERE: -----------------------------------------------------





################################################################################
################################################################################


include "mainloop.inc.nim"


################################################################################
################################################################################
