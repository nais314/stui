#import stui, terminal, colors, colors_extra, unicode, tables, locks
include "controll.inc.nim"

type TextBox* = ref object of Controll
  #label*:string
  val*:string
  preval*:string # undo

  #width*:int # of input
  maxlength*:int 
  
  offset_h*:int
  cursor_pos*:int







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
      #...

      # echo input area

    setColors(this.app, this.activeStyle[])
    terminal_extra.setCursorPos(leftX(this), 
                bottomY(this))

    if this.val.runeLen > 0 :
      if this.val.runeLen < this.width:
        stdout.write this.val
        stdout.write " " * (this.width - this.val.runeLen)
      else:
        # text longer even w offset
        if this.offset_h + (this.width - 1) < this.val.runeLen:
          stdout.write this.val.runeSubStr(this.offset_h, this.width)
        else:
          var used = (this.val.runeLen - this.offset_h)
          stdout.write this.val.runeSubStr(this.offset_h, used)
          stdout.write " " * (this.width - used)
    else:
      stdout.write " " * this.width

    this.app.setCursorPos()
    release(this.app.termlock)


###* MANDATORY *###
proc drawit(this: Controll, updateOnly: bool = false){.gcsafe.} =
  TextBox(this).draw(updateOnly)





proc `value=`*(this: TextBox, str:string) =
  this.val = str
  if this.visible: this.draw()
  trigger(this, "change")

proc `value`*(this: TextBox): string = this.val

# Textbox value and value2 same type as val : string
proc `value2=`*(this: TextBox, str:string) =
  this.val = str
  if this.visible: this.draw()
  trigger(this, "change")

proc `value2`*(this: TextBox): string = this.val




proc onClick(this: Controll, event: KMEvent):void=
  if not this.disabled:
    trigger(this, "click")
    TextBox(this).draw()

  ### MEMOS ###
  #cast[ptr Textbox](event.target).val = "KLIKK" & $cast[ptr Textbox](event.target).y1 & " " & $cast[ptr Textbox](event.target).y2 
  #draw(cast[ptr Textbox](event.target)[])
  #[ cast[ptr Textbox](event.target.app.activeControll)[].val = "Klikkkkk"
  cast[ptr Textbox](event.target.app.activeControll)[].draw() ]#

  

proc onDrop(this: Controll, event: KMEvent):void=
  #this.focus(this) # focus is done in stui.mouseeventhandler
  if not this.disabled:
    if event.source of TextBox:
      TextBox(this).val=Textbox(event.source).val
      #TextBox(this).focus(this)
      
      #of "[F": #End:  
      if TextBox(this).val.runeLen > TextBox(this).width:
        TextBox(this).offset_h = TextBox(this).val.runeLen - TextBox(this).width + 1
        terminal_extra.setCursorPos(TextBox(this).rightX(), TextBox(this).bottomY())
        this.app.cursorPos.x = TextBox(this).rightX()
        this.app.cursorPos.y = TextBox(this).bottomY()
      else:
        terminal_extra.setCursorPos(TextBox(this).leftX() + TextBox(this).val.runeLen, TextBox(this).bottomY())
        this.app.cursorPos.x = TextBox(this).leftX() + TextBox(this).val.runeLen
        this.app.cursorPos.y = TextBox(this).bottomY()
    
      TextBox(this).cursor_pos = TextBox(this).val.runeLen
      TextBox(this).draw()

  

proc onDrag(this: Controll, event: KMEvent)=
  #[ if this.app.activeControll != this:
    this.app.activate(this) ]#
  if not this.disabled:
    this.activeStyle = this.styles["input:drag"]
    TextBox(this).draw()


proc focus(this: Controll)=
  this.prevStyle = this.activeStyle 
  this.activeStyle = this.styles["input:focus"]
  
  ##editing mode
  #move curs to end
  #if longer than width - offset
  #handle input
  var tb = TextBox(this)
  tb.preval = tb.val # for undo

  if tb.val.runeLen >= tb.width:
    tb.offset_h = tb.val.runeLen - tb.width + 1  
    this.app.setCursorPos(this.rightX(), this.bottomY() )
  else:
    this.app.cursorPos.x = this.leftX() + tb.val.runeLen
    this.app.cursorPos.y = this.bottomY()

  tb.cursor_pos = tb.val.runeLen 

  setCursorStyle(CursorStyle.steadyBlock)
  showCursor()


proc blur(this: Controll)=
  if this.prevStyle != nil: # prevstyle may not initialized
    this.activeStyle = this.prevStyle 
    #this.prevStyle = nil

  TextBox(this).offset_h = 0
  setCursorStyle(CursorStyle.steadyUnderline)
  hideCursor()
  trigger(this, "change")
  this.app.parkCursor()



proc cancel*(this: Controll)=
  TextBox(this).val = TextBox(this).preval
  TextBox(this).blur(this)
  TextBox(this).draw()
  



proc onKeyPress(this: Controll, event: KMEvent)=
  var tb = TextBox(this)
  if not this.disabled:
    if event.evType == KMEventKind.FnKey: #.....FnKey.....FnKey.....FnKey.....FnKey
      case event.key:
        of "[C": # right
          if tb.cursor_pos < tb.val.runeLen:
            tb.cursor_pos += 1
            # if right edge
            if tb.app.cursorPos.x == tb.rightX(): #tb.x1 + tb.width - 1 : 
              tb.offset_h += 1
              tb.draw()
              #tb.app.setCursorPos()
            else:
              tb.app.cursorPos.x += 1 
              tb.app.setCursorPos()

        of "[D": # left
          if tb.cursor_pos > 0:
            tb.cursor_pos -= 1
            # if left edge
            if tb.app.cursorPos.x == tb.leftX():
              tb.offset_h -= 1
              tb.draw()
              #tb.app.setCursorPos()
            else:
              tb.app.cursorPos.x -= 1 
              tb.app.setCursorPos()

        of "[F": #End
        
          if tb.val.runeLen > tb.width:
            tb.offset_h = tb.val.runeLen - tb.width + 1
            terminal_extra.setCursorPos(tb.rightX(), tb.bottomY())
            this.app.cursorPos.x = tb.rightX()
            this.app.cursorPos.y = tb.bottomY()
          else:
            terminal_extra.setCursorPos(tb.leftX() + tb.val.runeLen, tb.bottomY())
            this.app.cursorPos.x = tb.leftX() + tb.val.runeLen
            this.app.cursorPos.y = tb.bottomY()
        
          tb.cursor_pos = tb.val.runeLen
          tb.draw()
          #tb.app.setCursorPos()


        of "[H": #Home
          tb.offset_h = 0
          tb.cursor_pos = 0
          this.app.cursorPos.x = tb.leftX()
          this.app.cursorPos.y = tb.bottomY()
          tb.draw()
          #tb.app.setCursorPos()

        else: discard

    elif event.evType == KMEventKind.Char: #......Char......Char......Char......Char
      if tb.maxlength == 0 or tb.maxlength >= tb.val.runeLen :
        # add to begin or insert at point
        if tb.cursor_pos > 0 :
          tb.val = tb.val.runeSubStr(0, tb.cursor_pos ) & event.key & tb.val.runeSubStr(tb.cursor_pos , tb.val.runeLen)
        elif tb.cursor_pos == 0:
          tb.val = event.key & tb.val
        elif tb.cursor_pos == tb.val.runeLen:
          tb.val &= event.key

        tb.cursor_pos += 1
        
        # insert: scrolls text
        if #[ tb.offset_h > 0 or ]# this.app.cursorPos.x == tb.rightX(): 
          tb.offset_h += 1

        #[ elif this.app.cursorPos.x < tb.rightX():  
          tb.app.cursorPos.x += 1 ]#
        else:
          tb.app.cursorPos.x += 1


        tb.draw()
        #tb.app.setCursorPos()

    elif event.evType == KMEventKind.CtrlKey: #.....CtrlKey.....CtrlKey.....CtrlKey 
      case event.ctrlKey:
        of 13: # enter
          this.blur(this)
          TextBox(this).draw()
        of 127: # del
          if tb.cursor_pos > 0 : # if something to delete
            tb.val = tb.val.runeSubStr(0, tb.cursor_pos - 1 ) & tb.val.runeSubStr(tb.cursor_pos)
            
            tb.cursor_pos -= 1

            if tb.val.runeLen < tb.width: # if no pageing
              this.app.cursorPos.x = this.leftX() + tb.cursor_pos
              tb.offset_h = 0 #!
            else: # if long text
              if tb.offset_h > 0 : # if offsetted move offset
                tb.offset_h -= 1
                #[ setCursorPos(4,1)
                echo tb.offset_h ]#
              else: # set cursor pos
                this.app.cursorPos.x = this.leftX() + tb.cursor_pos
          else: echo " -impossible- "
              

          tb.draw()
          #tb.app.setCursorPos()
          
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



  


            
########    #  # ###### #  # 
########    ##   # #    #  # 
########    # #  # #####  #  # 
########    #  # # #    # ## # 
########    #   ## #    ##  ## 
########    #  # ###### #  # 
            
proc newTextBox*(win:Window, label: string, width:int=20, maxlength:int=20): TextBox =
  result = new TextBox
  result.label=label
  #result.width=width
  result.maxlength=maxlength
  result.offset_h = 0
  result.cursor_pos = 0
  result.visible = false
  result.disabled = false
  result.width = width
  result.heigth = 2
  result.styles = newTable[string, StyleSheetRef](8)

  var styleNormal: StyleSheetRef = new StyleSheetRef
  styleNormal.deepcopy win.app.styles["input"]
  styleNormal.border="none"
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
  result.blur = blur
  result.focus = focus
  result.onClick = onClick
  result.onDrag = onDrag
  result.onDrop = onDrop
  result.cancel = cancel
  result.onKeypress = onKeyPress

  result.app = win.app
  result.win = win
  result.listeners = @[]
  
  win.controlls.add(result)
  

proc newTextBox*(win:Window, label: string, width:string, maxlength:int=20): TextBox =
  result = newTextBox(win, label, width=0, maxlength)
  (result.width_unit, result.width_value) = parseSizeStr(width)