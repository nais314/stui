#import stui, terminal, colors, colors_extra, unicode, tables, locks
include "../controll_inc.nim"

#      ▶██◀

type Colorpicker256* = ref object of Controll
  #label*:string
  val*:int
  #preval*:string # undo

  #width*:int # of input
  #maxlength*:int

  offset_h*:int
  cursor_pos*:int

const colorBarWidth = 4


#! TOOLS •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

proc numpages(this:Colorpicker256):int=
  # max = (this.width div colorBarWidth)
  result = 0
  if ((this.width div colorBarWidth) * (this.height - 1)) < 255:
    if 255 mod ((this.width div colorBarWidth) * (this.height - 1)) > 0:
      result = 255 div ((this.width div colorBarWidth) * (this.height - 1)) + 1
    else:
      result = 255 div ((this.width div colorBarWidth) * (this.height - 1))





proc drawFromOffset(this: Colorpicker256)=
  var
    max = this.width div colorBarWidth
    first = max * this.offset_h
  var
    x = this.leftX
    y = this.topY + 1

  terminal_extra.setCursorPos(x,y)
  for color in first .. 255:

    if this.val == color:
      terminal_extra.setBright()
      colors_extra.setForegroundColor(Color16(37))
      stdout.write "▶"
      colors_extra.setForegroundColor(Color256(color))
      stdout.write "███"
    else:
      colors_extra.setForegroundColor(Color256(color))
      stdout.write " ███"
    if color > 0 and (color + 1) mod max == 0:
      if y == this.bottomY: break
      y += 1
      terminal_extra.setCursorPos(x,y)


proc draw*(this: Colorpicker256, updateOnly: bool = false) =
  if this.visible:
    acquire(this.app.termlock)

    if not updateOnly:
      setColors(this.app, this.win.activeStyle[])
      terminal_extra.setCursorPos(this.x1 + this.activeStyle.margin.left,
                this.y1 + this.activeStyle.margin.top)
      stdout.write this.label


      # draw border
      drawBorder(this.activeStyle.border,
        this.x1 + this.activeStyle.margin.left,
        this.y1 + this.activeStyle.margin.top + 1 #[label]#,
        this.x2 - this.activeStyle.margin.right,
        this.y2 - this.activeStyle.margin.bottom
        )
      #...

    # clear / background
    setColors(this.app, this.activeStyle[])
    drawRect(this.leftX(), this.topY() + 1 , this.rightX(), this.bottomY())

    drawFromOffset(this)

    this.app.setCursorPos()
    release(this.app.termlock)



###* MANDATORY *###
proc drawit(this: Controll, updateOnly: bool = false){.gcsafe.} =
  Colorpicker256(this).draw(updateOnly)




#[
proc `value=`*(this: Colorpicker256, str:string) =
  this.val = str
  if this.visible: this.draw()
  trigger(this, "change")

proc `value`*(this: Colorpicker256): string = this.val

# Textbox value and value2 same type as val : string
proc `value2=`*(this: Colorpicker256, str:string) =
  this.val = str
  if this.visible: this.draw()
  trigger(this, "change")

proc `value2`*(this: Colorpicker256): string = this.val
 ]#

proc innerXY(this: Controll, event: KMEvent): tuple[x,y:int]=
  result.x = (event.x - this.leftX)
  result.y = (event.y - (this.topY + 1))  # label
  if result.y < 0: result.y = 0


proc onClick(this: Controll, event: KMEvent):void=
  # get selected color
  var (x,y) = innerXY(this,event)
  let cp = Colorpicker256(this)

  cp.val = x div colorBarWidth # wich color column is pointed

  cp.val += y * (cp.width div colorBarWidth) +
    ((cp.width div colorBarWidth) * cp.offset_h)

  if cp.val > 255: cp.val = 0

  if not this.disabled:
    if event.btn == 0:
      trigger(this, "click")
    elif event.btn == 2:
      trigger(this, "rightclick")
    cp.draw()






proc onDrag(this: Controll, event: KMEvent)=
  if not this.disabled:
    this.activeStyle = this.styles["input:drag"]
    Colorpicker256(this).draw()


#proc focus(this: Controll)=



proc blur(this: Controll)=
  if this.prevStyle != nil: # prevstyle may not initialized
    this.activeStyle = this.prevStyle
    #this.prevStyle = nil

  Colorpicker256(this).offset_h = 0
  setCursorStyle(CursorStyle.steadyUnderline)
  hideCursor()
  trigger(this, "change")
  this.app.parkCursor()



proc cancel*(this: Controll)=
  #Colorpicker256(this).val = Colorpicker256(this).preval
  Colorpicker256(this).blur(this)
  Colorpicker256(this).draw()


proc onKeyDown(this:Colorpicker256)=
  var
    max = this.width div colorBarWidth

  if this.val + max <= 255:
    this.val += max


    this.draw(true)
    trigger(this, "click")


proc onKeyUp(this:Colorpicker256)=
  var
    max = this.width div colorBarWidth

  if this.val - max >= 0:
    this.val -= max
    this.draw(true)
    trigger(this, "click")


proc onKeyRight(this:Colorpicker256)=
  if this.val + 1 <= 255:
    this.val += 1
    this.draw(true)
    trigger(this, "click")


proc onKeyLeft(this:Colorpicker256)=
  if this.val - 1 >= 0:
    this.val -= 1
    this.draw(true)
    trigger(this, "click")


proc onKeyPgUp(this:Colorpicker256)=
  var
    max = this.width div colorBarWidth
  this.val -= max * (this.height - 1)
  if this.val < 0:
    this.val = 0
    this.offset_h = 0
  else:
    this.offset_h -= (this.height - 1)
  this.draw(true)
  trigger(this, "click")


proc onKeyPgDown(this:Colorpicker256)=
  var
    max = (this.width div colorBarWidth)
    #numpages:int

  #[ if 255 mod (max * (this.height - 1)) > 0:
    numpages = 255 div (max * (this.height - 1)) + 1
  else:
    numpages = 255 div (max * (this.height - 1)) ]#

  this.val += max * (this.height - 1)
  if this.val > 255:
    this.val = 255
    this.offset_h = (numpages(this) - 1) * (this.height - 1)
    #this.offset_h += (this.height - 1)
  else:
    this.offset_h += (this.height - 1)
  this.draw(true)
  trigger(this, "click")



proc onScroll(this:Controll, event:KMEvent)=
  case event.evType:
    of KMEventKind.ScrollUp: Colorpicker256(this).onKeyPgUp()
    of KMEventKind.ScrollDown: Colorpicker256(this).onKeyPgDown()
    else: discard



proc onKeyPress(this: Controll, event: KMEvent)=
  var tb = Colorpicker256(this)
  if not this.disabled:
    if event.evType == KMEventKind.FnKey: #.....FnKey.....FnKey.....FnKey.....FnKey
      case event.key:
        of KeyRight: # right
          onKeyRight(Colorpicker256(this))

        of KeyLeft: # left
          onKeyLeft(Colorpicker256(this))

        of KeyDown:
          onKeyDown(Colorpicker256(this))

        of KeyUp:
          onKeyUp(Colorpicker256(this))

        of KeyEnd: #End
          discard

        of KeyHome: #Home
          discard

        of KeyPgDown:
          onKeyPgDown(Colorpicker256(this))

        of KeyPgUp:
          onKeyPgUp(Colorpicker256(this))

        else: discard

    elif event.evType == KMEventKind.Char: #......Char......Char......Char......Char

        tb.draw()
        #tb.app.setCursorPos()

    elif event.evType == KMEventKind.CtrlKey: #.....CtrlKey.....CtrlKey.....CtrlKey
      case event.ctrlKey:
        of 13: # enter
          Colorpicker256(this).draw()

        else:
          discard
      #echo "ctrl"

  else: # if this.disabled:
    if event.evType == KMEventKind.CtrlKey:
      case event.ctrlKey:
        of 3:
          discard
          #CLIPBOARD
        else:
          discard







########    #    # ###### #  #
########    ##   # #      #  #
########    # #  # #####  #  #
########    #  # # #     # ## #
########    #   ## #     ##  ##
########    #    # ###### #  #

proc newColorpicker256*(win:Window, label: string = "colorpicker 256", width:int=20, height:int=20): Colorpicker256 =
  result = new Colorpicker256
  result.label=label
  #result.width=width
  result.offset_h = 0
  result.cursor_pos = 0
  result.visible = false
  result.disabled = false
  result.width = width
  result.height = height
  result.styles = newTable[string, StyleSheetRef](8)

  var styleNormal: StyleSheetRef = new StyleSheetRef
  styleNormal.deepcopy win.app.styles["input"]
  styleNormal.border="none"
  result.styles.add("input",styleNormal)
  result.activeStyle = result.styles["input"]

  result.changeBGColor("input","black")

  #[ var styleFocused: StyleSheetRef = new StyleSheetRef
  styleFocused.deepcopy win.app.styles["input:focus"]
  result.styles.add("input:focus",styleFocused) ]#

  #[ var styleDragged: StyleSheetRef = new StyleSheetRef
  styleDragged.deepCopy win.app.styles["input:drag"]
  result.styles.add("input:drag",styleDragged) ]#

  var styleDisabled: StyleSheetRef = new StyleSheetRef
  styleDisabled.deepcopy win.app.styles["input:disabled"]
  result.styles.add("input:disabled", styleDisabled)

  result.drawit = drawit
  #result.blur = blur
  #result.focus = focus
  result.onClick = onClick
  result.onDrag = onDrag
  #result.onDrop = onDrop
  #result.cancel = cancel
  result.onKeypress = onKeyPress
  result.onScroll = onScroll

  result.app = win.app
  result.win = win
  result.listeners = @[]

  win.controlls.add(result)


proc newColorpicker256*(win:Window, label: string = "colorpicker", width:string, height:int=20): Colorpicker256 =
  result = newColorpicker256(win, label, width=0, height)
  #(result.width_unit, result.width_value) = parseSizeStr(width)
  #result.parseSizeStr(width)
  discard width.parseInt(result.width_value)

proc newColorpicker256*(win:Window, label: string = "colorpicker", width:string, height:string): Colorpicker256 =
  result = newColorpicker256(win, label)
  discard width.parseInt(result.width_value)
  discard height.parseInt(result.height_value)