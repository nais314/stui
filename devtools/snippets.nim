import stui, terminal, colors, colors_extra, colors256 unicode, tables




proc draw*(this: TextBox, updateOnly: bool = false) =
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


    setColors(this.app, this.activeStyle[])
    terminal_extra.setCursorPos(leftX(this), 
                bottomY(this))



    this.app.setCursorPos()
    release(this.app.termlock)


###* MANDATORY *###
proc drawit(this: Controll, updateOnly: bool = false){.gcsafe.} =
  TextBox(this).draw(updateOnly)


proc focus(this: Controll)=
  this.activeStyle = this.styles["input:focus"]

proc blur(this: Controll)=
  this.activeStyle = this.styles["input"]

proc cancel(this: Controll)=discard

proc onClick(this: Controll, event: KMEvent):void=
  if not this.disabled:
    trigger(this, "click")
    this.drawit(this)
    #TextArea(this).draw()

proc onClick(this: Controll, event:KMEvent)=discard

proc onDrag(this: Controll, event:KMEvent)=discard

proc onDrop(this: Controll, event:KMEvent)=discard

proc onKeyPress(this: Controll, event:KMEvent)=discard

proc onKeyPress(this: Controll, event:KMEvent)=
  if not this.disabled:
    case event.evType:
    of KMEventKind.FnKey, KMEventKind.Char: #.....FnKey.....FnKey.....FnKey.....FnKey
      this.trigger(event.key):
    of KMEventKind.CtrlKey:
      this.trigger($ event.ctrlKey)





proc basename*(file: string): string =
  if file.rfind(DirSep) == -1 or file.rfind(DirSep) == 0 :
    result = file
  else:
    result = file.substr(0,file.rfind(DirSep) - 1) # -1 DirSep

proc filename*(file: string): string =
  if file.rfind(DirSep) == -1 :
    result = file
  else:
    result = file.substr(file.rfind(DirSep) + 1) # +1 DirSep



proc getMin*[T](args: varargs[T]):T=
  result = T.high
  for arg in args:
    if arg < result:
      result = arg

proc getMax*[T](args: varargs[T]):T=
  for arg in args:
    if arg > result:
      result = arg


iterator countUp*(x,y,step:float):float=
  var r = x
  while r + step < y:
    yield r
    r += step



proc getCluster*(x:float, divider:int=10, max:float=1.0):int=
  ## classifier function
  ## for RGB HUE best values are 14, 8, 16
  var counter: int
  for c in countUp(max / divider.float, max, max / divider.float):
    if x <= c: 
      return counter
    counter += 1
  return counter



proc is_odd*(x:int): bool = return if (x and 1) == 1: true else: false

template is_even*(x:int): bool =
  return not is_odd(x)



proc `*`*(s:string, i:int):string=
  result = ""
  for a in 0..i-1:
    result = result & s



template tryit*(fun: untyped)=
    try:
      fun
    except:
      let
        e = getCurrentException()
        msg = getCurrentExceptionMsg()
      echo "Got exception ", repr(e), " with message ", msg
      discard stdin.readLine()



proc `div`(x,y:float):float=
  var i:int=0
  while y * i.float < x:
    i += 1
  return i.float




proc count_set_bits(x: uint):uint=
  var y=x
  result = 0
  while y != 0:
    result += 1
    y = y and (y - 1)
    #echo result, " ", y

echo count_set_bits(0b01110110011)