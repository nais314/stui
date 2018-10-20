#import stui, terminal, colors, colors_extra, unicode, tables, locks, parseutils
include "controll.inc.nim"
type LineMetadata = seq[ tuple[line, width: int]]

type TextArea* = ref object of Controll
    #label*:string
    val*:string
    preval*:string # undo

    #width*:int   # of Controll
    #heigth*:int  # of Controll
    
    offset*:int # num-lines scrolled down
    cursor_pos*:int # current Rune pos
    lineMetadata*:LineMetadata
    currentLine*:int



proc buildLineMetadata(this: TextArea)= #? seq?
    ## count lines, line.len, formed from VISIBLE characters...Runes
    ## for cursor move calculations
    var 
        lineMetadata: LineMetadata = @[]#= this.lineMetadata
        lineCount, width:int=0

    for iR in 0..(this.val.runeLen() - 1):
        var ru = this.val.runeAtPos(iR)
        width += 1
        if (width == this.width) or ru == Rune('\n') or iR == (this.val.runeLen() - 1): #(ord(ru) == 10):
            lineMetadata.add((lineCount,width))
            width = 0
            lineCount += 1

    this.lineMetadata = lineMetadata




proc writeFromOffset(this: TextArea)=
    ## draw textarea content from scroll offset (linenum)
    ## from "x1,y1+label to x2,y2"

    block PRINT:
        var 
            cx,cy:int # hold cursor pos
        cx = leftX(this)
        cy = topY(this) + 1
        terminal_extra.setCursorPos(cx,cy)

        var firstRune: int
        if this.offset > 0:
            for i in 0..this.offset - 1:
                firstRune += this.lineMetadata[i].width

        for iR in firstRune..this.val.runeLen() - 1: # print from beginning
            var ru = this.val.runeAtPos(iR)

            if ord(ru) < 32 or ord(ru) == 127: # if control char
                case ord(ru):
                    of 10,13: # \c,\n
                        terminal.setStyle(stdout, {styleDim})
                        stdout.write("¶")

                        setColors(this.app, this.activeStyle[])

                        cy += 1
                        if cy > bottomY(this): # reach bottom
                            #cy = topY(this)
                            break PRINT
                        cx = leftX(this)
                        terminal_extra.setCursorPos(cx,cy) # reposition cursor
                    of 0: discard
                    else:
                        terminal.setStyle(stdout, {styleDim})
                        stdout.write " " #ru #"¶"
                        setColors(this.app, this.activeStyle[])
                        cx += 1

                if cx > rightX(this): # we reach edge
                    cx = leftX(this)
                    cy += 1
                    if cy > bottomY(this): # reach bottom
                        break PRINT
                    terminal_extra.setCursorPos(cx,cy) # reposition cursor



            else:
                #stdout.write("⬜")
                stdout.write ru #this.val.runeAtPos(iR)

                cx += 1
                if cx > rightX(this): # we reach edge
                    cx = leftX(this)
                    cy += 1
                    if cy > bottomY(this): # reach bottom
                        break PRINT
                    terminal_extra.setCursorPos(cx,cy) # reposition cursor


proc draw*(this: TextArea, updateOnly: bool = false) =
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

        writeFromOffset(this)

        this.app.setCursorPos()
        release(this.app.termlock)


### MANDATORY ###
proc drawit(this: Controll, updateOnly: bool = false) =
    draw(TextArea(this), updateOnly)





proc `value=`*(this: TextArea, str:string) =
    this.val = str
    this.buildLineMetadata()
    if this.visible: this.draw()
    trigger(this, "change")

proc `value`*(this: TextArea): string = this.val

# TextArea value and value2 same type as val : string
proc `value2=`*(this: TextArea, str:string) =
    this.val = str
    if this.visible: this.draw()
    trigger(this, "change")

proc `value2`*(this: TextArea): string = this.val




proc onClick(this: Controll, event: KMEvent):void=
    if not this.disabled:
        trigger(this, "click")
        TextArea(this).draw()


proc onDrop(this: Controll, event: KMEvent):void=
    #this.focus(this) # focus is done in stui.mouseeventhandler
    if not this.disabled:
        if event.source of TextArea:
            TextArea(this).val=TextArea(event.source).val
            TextArea(this).draw()
    

proc onDrag(this: Controll, event: KMEvent)=
    if not this.disabled:
        this.activeStyle = this.styles["input:drag"]
        TextArea(this).draw()



proc focus(this: Controll)=
    this.prevStyle = this.activeStyle 
    this.activeStyle = this.styles["input:focus"]

    var ta = TextArea(this)

    ta.preval = ta.val # for undo

    ta.currentLine = 0
    ta.cursor_pos = 0
    ta.offset = 0

    this.app.setCursorPos(this.leftX(), this.topY() + 1 )

    setCursorStyle(CursorStyle.steadyBlock)

    showCursor()



proc blur(this: Controll)=
    if this.prevStyle != nil: # prevstyle may not initialized
        this.activeStyle = this.prevStyle 
        #this.prevStyle = nil

    #TextArea(this).offset = 0 #?
    setCursorStyle(CursorStyle.steadyUnderline)
    hideCursor()
    trigger(this, "change")
    this.app.parkCursor()


proc cancel(this: Controll)=
    TextArea(this).val = TextArea(this).preval
    TextArea(this).currentLine = 0
    TextArea(this).cursor_pos = 0
    TextArea(this).offset = 0
    TextArea(this).blur(this)
    TextArea(this).draw()
    










proc cursorLeft(ta:TextArea){.inline.}=
    if ta.cursor_pos > 0:
        ta.cursor_pos -= 1
        # if left edge
        if ta.app.cursorPos.x == ta.leftX():
            if ta.app.cursorPos.y == ta.topY():# todo rewrite
                if ta.offset > ta.width:
                    ta.offset -= ta.width
                else: ta.offset = 0

            else:
                if ta.currentLine > 0:
                    ta.app.cursorPos.y -= 1
                    ta.currentLine -= 1
                    
                
            ta.app.cursorPos.x = ta.leftX() + ta.lineMetadata[ta.currentLine].width - 1
            ta.draw(true) #ta.app.setCursorPos()
        else:
            ta.app.cursorPos.x -= 1 
            ta.app.setCursorPos()


proc cursorRight(ta:TextArea){.inline.}=
    if ta.cursor_pos < ta.val.runeLen:
        ta.cursor_pos += 1
        # if right edge
        if ta.app.cursorPos.x == ta.rightX() or 
            ord(ta.val.runeAtPos(ta.cursor_pos - 1)) == 10 or # \n
            (ta.app.cursorPos.x - ta.leftX()) == ta.lineMetadata[ta.currentLine].width: 

            ta.app.cursorPos.x = ta.leftX()
            if ta.app.cursorPos.y != ta.bottomY():
                ta.app.cursorPos.y += 1
                ta.currentLine += 1
            else:
                if ta.offset < ta.lineMetadata.high:
                    ta.offset += 1
                    ta.currentLine += 1

            ta.draw(true)
            #ta.app.setCursorPos()
        else:
            ta.app.cursorPos.x += 1 
            ta.app.setCursorPos()


proc cursorDown(ta:TextArea){.inline.}=
    proc cursorDownHelper(ta:TextArea)=
        var column = (ta.app.cursorPos.x - ta.leftX())

        if column <= ta.lineMetadata[ta.currentLine ].width: #[ + 1 ]#
            ta.app.cursorPos.y += 1
            #ta.currentLine += 1
            ta.cursor_pos += column
            ta.cursor_pos += (ta.lineMetadata[ta.currentLine - 1].width - column)
            ta.app.setCursorPos()
            

        if column > ta.lineMetadata[ta.currentLine ].width: #[ + 1 ]#
            #ta.currentLine += 1
            ta.cursor_pos += (ta.lineMetadata[ta.currentLine - 1].width - column) + ta.lineMetadata[ta.currentLine].width - 1
            ta.app.cursorPos.y += 1
            ta.app.cursorPos.x = ta.leftX() + ta.lineMetadata[ta.currentLine].width - 1
            ta.app.setCursorPos()

    #..proc cursorDown()=............................
    if ta.currentLine < ta.lineMetadata.high:
        ta.currentLine += 1 #!

        if ta.app.cursorPos.y < ta.bottomY():
            cursorDownHelper(ta)

        elif (ta.offset + ((ta.bottomY() - ta.topY()) - 1)) < ta.lineMetadata.high: # -1 label
            ta.offset += 1
            ta.app.cursorPos.y -= 1 #cursorDownHelper steps down!
            cursorDownHelper(ta)
            ta.draw(true)

proc onPgDown(ta:TextArea)=
    if ta.offset < (ta.lineMetadata.high - (ta.heigth - 1) + 1):
        for i in countdown((ta.heigth - 1), 1): #dont go pass the end
            if ta.offset + i <= (ta.lineMetadata.high - (ta.heigth - 1) + 1):
                ta.offset += i
                ta.currentLine += i
                # calc cursor_pos
                ta.cursor_pos = 0
                for i in 0..ta.currentLine:
                    ta.cursor_pos += ta.lineMetadata[i].width
                ta.cursor_pos -= 1 # correction

                if ta.app.activeControll == ta:
                    # calc terminal cursor
                    ta.app.cursorPos.x = ta.leftX() + ta.lineMetadata[ta.currentLine].width - 1
                    ta.app.cursorPos.y = (ta.topY() + 1) + (ta.currentLine - ta.offset)
                break # done
        ta.draw(true)



proc onPgUp(ta:TextArea)=
    if ta.offset > 0:
        for i in countdown(ta.heigth, 1): #ta.heigth..1:
            if ta.offset - i >= 0:
                ta.offset -= i
                ta.currentLine -= i
                # calc cursor_pos
                ta.cursor_pos = 0
                for i in 0..ta.currentLine:
                    ta.cursor_pos += ta.lineMetadata[i].width
                ta.cursor_pos -= 1 # correction

                if ta.app.activeControll == ta:
                    # calc terminal cursor
                    ta.app.cursorPos.x = ta.leftX() + ta.lineMetadata[ta.currentLine].width - 1
                    ta.app.cursorPos.y = (ta.topY() + 1) + (ta.currentLine - ta.offset)
                break # done
        ta.draw(true)
        
        

proc onKeyPress(this: Controll, event: KMEvent)=
    var ta = TextArea(this)
    proc debug()=
        terminal_extra.setCursorPos(ta.x1, ta.y1)
        stdout.write "____________________"
        terminal_extra.setCursorPos(ta.x1, ta.y1)
        stdout.write  $ta.currentLine & " " & $ta.lineMetadata.high & " " & $ta.lineMetadata[ta.currentLine].width# [ta.currentLine].width
    if not this.disabled:
        var column = (ta.app.cursorPos.x - ta.leftX()) #!
        if event.evType == "FnKey": #.....FnKey.....FnKey.....FnKey.....FnKey
            case event.key:
                of KeyRight: # right "[C"
                    ta.cursorRight()

                of KeyLeft: # left "[D"
                    ta.cursorLeft()

                of KeyUp:
                    #debug()
                    if ta.app.cursorPos.y > ta.topY() + 1: #+1 label
                        if ta.currentLine > 0:
                            if column <= ta.lineMetadata[ta.currentLine - 1].width:
                                ta.app.cursorPos.y -= 1
                                ta.currentLine -= 1
                                ta.cursor_pos -= column + 
                                    (ta.lineMetadata[ta.currentLine].width - column)
                                #ta.app.setCursorPos()
                            else:
                                ta.currentLine -= 1
                                ta.app.cursorPos.y -= 1
                                ta.app.cursorPos.x = ta.leftX() + ta.lineMetadata[ta.currentLine].width - 1
                                ta.cursor_pos -= column + 1
                                #ta.app.setCursorPos()
                    elif ta.offset > 0:
                        var column = (ta.app.cursorPos.x - ta.leftX())
                        ta.currentLine -= 1 #!
                        ta.offset -= 1

                        if column <= ta.lineMetadata[ta.currentLine].width: #[ + 1 ]#
                            #ta.app.cursorPos.y -= 1
                            ta.cursor_pos -= column
                            ta.cursor_pos -= (ta.lineMetadata[ta.currentLine].width - column)
                            ta.app.setCursorPos()
                            
                        if column > ta.lineMetadata[ta.currentLine ].width: #[ + 1 ]#
                            ta.cursor_pos -= column
                            #ta.app.cursorPos.y -= 1
                            ta.app.cursorPos.x = ta.leftX() + ta.lineMetadata[ta.currentLine].width
                            ta.app.setCursorPos()

                    ta.draw(true)
                    #debug()

                of KeyDown:
                    cursorDown(ta)


                of "[F": #End
                    if ta.lineMetadata.high > (ta.heigth - 1): # -1 label
                        ta.offset = ta.lineMetadata.high - (ta.heigth - 1) + 1 # -1 label, +1 next row
                    ta.cursor_pos = ta.val.runeLen()
                    ta.currentLine = ta.lineMetadata.high
                    this.app.cursorPos.x = ta.leftX() + ta.lineMetadata[ta.lineMetadata.high].width
                    this.app.cursorPos.y = if ta.lineMetadata.high > (ta.heigth - 1) : # if val < textarea
                        ta.bottomY() else : ta.topY() + ta.lineMetadata.high + 1 #+1 label

                    ta.draw(true)


                of "[H": #Home
                    ta.offset = 0
                    ta.cursor_pos = 0
                    ta.currentLine = 0
                    this.app.cursorPos.x = ta.leftX()
                    this.app.cursorPos.y = ta.topY() + 1 #label
                    ta.draw(true)
                    #ta.app.setCursorPos()

                of KeyPgDown:
                    ta.onPgDown()

                of KeyPgUp:
                    ta.onPgUp()

                else: discard




        elif event.evType == "Char": #......Char......Char......Char......Char
            # add to begin or insert at point
            if ta.cursor_pos > 0 :
                ta.val = ta.val.runeSubStr(0, ta.cursor_pos ) & event.key & ta.val.runeSubStr(ta.cursor_pos , ta.val.runeLen)
            elif ta.cursor_pos == 0:
                ta.val = event.key & ta.val
            elif ta.cursor_pos == ta.val.runeLen:
                ta.val &= event.key
            
            ta.buildLineMetadata()
            ta.draw()
            ta.cursorRight()




        elif event.evType == "CtrlKey": #.....CtrlKey.....CtrlKey.....CtrlKey 
            case event.ctrlKey:
                of 13: # enter
                    # add to begin or insert at point
                    if ta.cursor_pos > 0 :
                        ta.val = ta.val.runeSubStr(0, ta.cursor_pos ) & "\n" & ta.val.runeSubStr(ta.cursor_pos , ta.val.runeLen)
                    elif ta.cursor_pos == 0:
                        ta.val ="\n" & ta.val
                    elif ta.cursor_pos == ta.val.runeLen:
                        ta.val &= "\n"
                    
                    ta.buildLineMetadata()
                    ta.draw()
                    ta.cursorRight()

                of 127: # del
                    if ta.cursor_pos > 0 : # if something to delete
                        ta.val = ta.val.runeSubStr(0, ta.cursor_pos - 1 ) & ta.val.runeSubStr(ta.cursor_pos)
                        
                        ta.buildLineMetadata()
                        ta.cursorLeft()
                            
                        ta.draw(true)                    
                else:
                    discard
            #echo "ctrl"

    else: # if this.disabled:
        if event.evType == "CtrlKey":
            case event.ctrlKey:
                of 3:
                    discard
                    #CLIPBOARD
                else:
                    discard


proc onScroll(this:Controll, event:KMEvent)=
    case event.evType:
        of "ScrollUp": TextArea(this).onPgUp()
        of "ScrollDown": TextArea(this).onPgDown()
        else: discard
    


                      
########        #    # ###### #    # 
########        ##   # #      #    # 
########        # #  # #####  #    # 
########        #  # # #      # ## # 
########        #   ## #      ##  ## 
########        #    # ###### #    # 

# todo : new adds value
                      
proc newTextArea*(win:Window, label: string, width:int=20, heigth:int=20): TextArea =
    result = new TextArea
    result.label=label
    result.lineMetadata = @[]

    result.offset = 0
    result.cursor_pos = 0
    result.visible = false
    result.disabled = false

    result.width = width
    result.heigth = heigth
    
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
    result.onScroll = onScroll

    result.app = win.app
    result.win = win
    result.listeners = @[]
    
    win.controlls.add(result)
    

proc newTextArea*(win:Window, label: string, width:string, heigth:int=20): TextArea =
    result = newTextArea(win, label, width=0, heigth)
    discard width.parseInt(result.width_value)

proc newTextArea*(win:Window, label: string, width:string, heigth:string): TextArea =
    result = newTextArea(win, label)
    discard width.parseInt(result.width_value)
    discard heigth.parseInt(result.heigth_value)