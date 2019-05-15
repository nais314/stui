#import stui, terminal, colors, colors_extra, colors256, unicode, tables, os, locks
include "controll.inc.nim"

type Splash* = ref object of Controll
  charmap*: seq[string]
  colormap*: seq[int]
  colorMode*: int



proc draw*(this: Splash, updateOnly: bool = false)=
  if this.visible:
    acquire(this.app.termlock)

    setColors(this.app, this.activeStyle[])

    drawRect(this.leftX,
      this.topY,
      this.rightX,
      this.bottomY)
    #...
 
    #this.app.parkCursor()
    this.app.setCursorPos()

    release(this.app.termlock)
  

    
proc drawit(this: Controll, updateOnly: bool = false) =
  ## *MANDATORY* called by redraw or other Controll iterators
  draw(Splash(this), updateOnly)




proc focus(this: Controll)=
  this.prevStyle = this.activeStyle 
  this.activeStyle = this.styles["input:focus"]


proc blur(this: Controll)=
  if this.prevStyle != nil: this.activeStyle = this.prevStyle # prevstyle may not initialized

proc cancel(this: Controll)=discard

# made public to call if replaced - new method of event listener adding
proc onClick*(this: Controll, event:KMEvent)= discard

proc onDrag(this: Controll, event:KMEvent)= discard

proc onDrop(this: Controll, event:KMEvent)= discard

proc onKeyPress(this: Controll, event:KMEvent)= discard


proc newSplash*(win:Window): Splash =
  result = new Splash

  result.visible = false
  result.disabled = false


  result.app = win.app
  result.win = win
  result.listeners = @[]

  result.styles = newStyleSheets()

  var styleNormal: StyleSheetRef = new StyleSheetRef
  styleNormal.deepcopy win.app.styles["input"]
  result.styles.add("input",styleNormal)  
  result.activeStyle = result.styles["input"]
   
  var styleFocused: StyleSheetRef = new StyleSheetRef
  styleFocused.deepcopy win.app.styles["input:focus"]
  result.styles.add("input:focus",styleFocused)

  var styleDragged: StyleSheetRef = new StyleSheetRef
  styleDragged.deepCopy win.app.styles["input:drag"]
  result.styles.add("input:drag",styleDragged)

  var styleDisabled: StyleSheetRef = new StyleSheetRef
  styleDisabled.deepcopy win.app.styles["input:disabled"]
  result.styles.add("input:disabled", styleDisabled)

  result.drawit = drawit
  
  win.controlls.add(result) # typical finish line
