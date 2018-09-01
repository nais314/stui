include "controll.inc.nim"

#[

]#

type
    StringListBox* = ref object of Controll
        label*:string
        offset*:int # num-lines scrolled down
        options*: seq[ tuple[name:string, action:proc():void]  ]
        #win*:Window
        cursor:int

        prevActiveControll*: Controll
        #multiSelect*:bool


proc writeFromOffset(this: StringListBox)=
    ## draw content from scroll offset (linenum)

    var
        currentLine, currentY: int

    currentLine = this.offset
    currentY = this.topY() + 1 # +1 label


    block PRINT:
 
        while currentY <= this.bottomY() and currentLine <= this.options.high:
            # todo: style: even,odd,highlight
            if this.cursor == currentLine and this.app.activeControll == this: #! todo
                setColors(this.app, this.styles["input:focus"])
                this.app.cursorPos.y = currentY # patch for scroll issues
            elif currentLine mod 2 == 0:
                setColors(this.app, this.styles["input:even"])
            else:
                setColors(this.app, this.styles["input:odd"])

            setCursorPos(this.leftX, currentY )

            if this.options[currentLine].name.runeLen() == this.width:
                stdout.write(this.options[currentLine].name)
            elif this.options[currentLine].name.runeLen() <= this.width:
                stdout.write(this.options[currentLine].name)
                stdout.write " " * (this.width - this.options[currentLine].name.runeLen())
            else:
                stdout.write this.options[currentLine].name.runeSubStr(0,this.width)

            currentLine += 1
            currentY += 1



method draw*(this: StringListBox, updateOnly:bool=false){.base.}=
    if this.visible:
        acquire(this.app.termlock)

        if not updateOnly :
            setColors(this.app, this.win.activeStyle[])
            terminal.setCursorPos(this.x1 + this.activeStyle.margin.left,
                                this.y1 + this.activeStyle.margin.top)
            stdout.write this.label


            # draw border
            drawBorder(this.activeStyle.border,
                this.x1 + this.activeStyle.margin.left,
                this.y1 + this.activeStyle.margin.top + 1,
                this.x2 - this.activeStyle.margin.right,
                this.y2 - this.activeStyle.margin.bottom
                )
            #...

        this.writeFromOffset()
        #this.app.setCursorPos()
        release(this.app.termlock)

### MANDATORY ###
proc drawit(this: Controll, updateOnly:bool=false) =
    draw(StringListBox(this),updateOnly)




proc focus(this: Controll)=
    this.prevStyle = this.activeStyle
    this.activeStyle = this.styles["input:focus"]

    this.app.cursorPos.y = this.topY + 1
    this.app.cursorPos.x = this.leftX
    this.app.setCursorPos()

    hideCursor()





proc blur(this: Controll)=
    if this.prevStyle != nil: # prevstyle may not initialized
        this.activeStyle = this.prevStyle

    this.app.activeControll = this.win #! patch for draw if this == activecontroll

    StringListBox(this).draw()
    this.app.parkCursor()

    if this.prevActiveControll != nil:
        this.app.activate(this.prevActiveControll)




proc cancel(this:Controll)=
    var slistbox = StringListBox(this)
    slistbox.blur(this)
    slistbox.draw()
#[     chooser.app.activeTile.windows.del(chooser.app.activeTile.windows.high)
    chooser.app.activeWindow.draw()
    if chooser.prevActiveControll.cancel != nil : chooser.prevActiveControll.cancel(chooser.prevActiveControll)
    chooser.app.activeControll = chooser.prevActiveControll ]#



proc onClick(this:Controll, event:KMEvent)=
    StringListBox(this).draw()

    if not this.disabled:
        var slistbox = StringListBox(this)

        case event.btn:
            of 0:
                if clickedInside(this,event):
                    let selected = (event.y - (slistbox.topY + 1)) + slistbox.offset

                    # visuals:
                    slistbox.cursor = selected
                    slistbox.draw()
                    sleep(100)

                    if slistbox.options[selected].action != nil:
                        slistbox.options[selected].action()
            else: 
                #slistbox.draw()
                discard


proc onKeyUp(this: StringListBox) =
    #echo "keyuppppp"
    if this.cursor > 0:
        this.cursor -= 1
        if this.app.cursorPos.y == this.topY + 1:
            this.offset -= 1
        else:
            this.app.cursorPos.y -= 1

        #this.app.setCursorPos()
        this.draw(true)

proc onKeyDown(this: StringListBox) =
    #echo "keydooooown"
    if this.cursor < this.options.high:
        this.cursor += 1
        if this.app.cursorPos.y == this.bottomY:
            this.offset += 1
        else:
            this.app.cursorPos.y += 1
        
        #this.app.setCursorPos()
        this.draw()

proc onPgUp(this: StringListBox) =
    block LOOP:
        for i in 0..(this.heigth - 1):
            if this.offset > 0:
                this.offset -= 1
                this.cursor -= 1
                this.draw(true)
            else: break LOOP

proc onPgDown(this: StringListBox) =
    block LOOP:
        for i in 0..(this.heigth - 1): 
            if this.offset < this.options.len - (this.heigth - 1): # label
                this.offset += 1
                this.cursor += 1
                this.draw(true)
            else: break LOOP


proc onKeypress(this:Controll, event:KMEvent)=
    if not this.disabled:
        let slistbox = StringListBox(this)

        if event.evType == "FnKey": #.....FnKey.....FnKey.....FnKey.....FnKey...
            case event.key:
                of KeyDown:
                    onKeyDown(slistbox)
                    #[ if slistbox.cursor < slistbox.options.high:
                        slistbox.cursor += 1
                        if slistbox.app.cursorPos.y == slistbox.bottomY:
                            slistbox.offset += 1
                        else:
                            slistbox.app.cursorPos.y += 1

                        slistbox.draw(true) ]#

                of KeyUP:
                    onKeyUp(StringListBox(this))
                    #[ if slistbox.cursor > 0:
                        slistbox.cursor -= 1
                        if slistbox.app.cursorPos.y == this.topY + 1:
                            slistbox.offset -= 1
                        else:
                            slistbox.app.cursorPos.y -= 1

                        slistbox.draw(true) ]#


proc onScroll(this:Controll, event:KMEvent)=
    case event.evType:
        of "ScrollUp": StringListBox(this).onPgUp()
        of "ScrollDown": StringListBox(this).onPgDown()
        else: discard




########        #    # ###### #    #
########        ##   # #      #    #
########        # #  # #####  #    #
########        #  # # #      # ## #
########        #   ## #      ##  ##
########        #    # ###### #    #

proc newStringListBox*(win:Window, label: string, width:int=20, heigth:int=20): StringListBox =
    result = new StringListBox
    result.disabled = false

    result.label = label

    result.width = width
    result.heigth = heigth

    result.options = @[]

    result.styles = newStyleSheets()

    var styleNormal: StyleSheetRef = new StyleSheetRef
    styleNormal.deepcopy win.app.styles["input"]
    styleNormal.border="none"
    #styleNormal.setTextStyle("styleUnderline") #! disabled because border draw
    result.styles.add("input",styleNormal)
    result.activeStyle = result.styles["input"]

    var styleEven: StyleSheetRef = new StyleSheetRef
    styleEven.deepcopy win.app.styles["input:even"]
    styleEven.setTextStyle("styleUnderline") #!
    result.styles.add("input:even",styleEven)

    var styleOdd: StyleSheetRef = new StyleSheetRef
    styleOdd.deepcopy win.app.styles["input:odd"]
    styleOdd.setTextStyle("styleUnderline") #!
    result.styles.add("input:odd",styleOdd)


    var styleFocused: StyleSheetRef = new StyleSheetRef
    styleFocused.deepcopy win.app.styles["input:focus"]
    #styleFocused.setTextStyle("styleUnderline") #! disabled because border draw
    result.styles.add("input:focus",styleFocused)

    var styleDragged: StyleSheetRef = new StyleSheetRef
    styleDragged.deepCopy win.app.styles["input:drag"]
    styleDragged.setTextStyle("styleUnderline") #!
    result.styles.add("input:drag",styleDragged)

    #???
    var styleDisabled: StyleSheetRef = new StyleSheetRef
    styleDisabled.deepcopy win.app.styles["input:disabled"]
    styleDisabled.setTextStyle("styleUnderline") #!
    result.styles.add("input:disabled", styleDisabled)

    result.drawit = drawit
    result.blur = blur
    result.focus = focus
    result.onClick = onClick
    #result.onDrag = onDrag
    #result.onDrop = onDrop
    result.cancel = cancel
    result.onKeypress = onKeyPress
    result.onScroll = onScroll

    result.app = win.app
    result.win = win
    result.listeners = @[]

    win.controlls.add(result)


proc newStringListBox*(win:Window, label: string, width:string, heigth:string): StringListBox =
    result = newStringListBox(win, label)
    discard width.parseInt(result.width_value)
    discard heigth.parseInt(result.heigth_value)