include "controll_inc.nim"
import uiext_maximize

type
  ScrollableControll* = ref object of MaximizableControll
    scrollX*,scrollY*:int
    drawScrollBarX*, drawScrollBarY*:bool

proc drawScrollBarX*(this:MaximizableControll)=
  terminal_extra.setCursorPos(this.rightX, this.topY)
  setColors(this.app, this.win.activeStyle[])
  setReversed()
  stdout.write("▲")

  #calc pos