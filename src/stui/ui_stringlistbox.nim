include "controll_inc.nim"

type
    StringListBox_Options* = seq[ tuple[name:string, action:proc():void]  ]
    StringListBox* = ref object of Controll
        ## it is a "listview".
        ## the items are strings.
        ## onclick triggers the items.action:proc():void
        ## no events - as it has actions

        offset*:int # num-lines scrolled down
        options*: StringListBox_Options #seq[ tuple[name:string, action:proc():void]  ]
        #win*:Window
        cursor:int

        prevActiveControll*: Controll # it is here for more fun - but not yet demoed...


proc writeFromOffset(this: StringListBox)=
    ## draw content from scroll offset (linenum)

    var
        currentLine, currentY: int

    currentLine = this.offset
    currentY = this.topY() + 1 # +1 label


    while currentY <= this.bottomY() and currentLine <= this.options.high:
        # todo: style: even,odd,highlight
        if this.cursor == currentLine and this.app.activeControll == this: #! todo
            setColors(this.app, this.styles["input:focus"])
            this.app.cursorPos.y = currentY #! patch for scroll issues
        elif currentLine mod 2 == 0:
            setColors(this.app, this.styles["input:even"])
        else:
            setColors(this.app, this.styles["input:odd"])

        terminal_extra.setCursorPos(this.leftX, currentY )

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
            terminal_extra.setCursorPos(this.x1 + this.activeStyle.margin.left,
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
        setColors(this.app, this.styles["input"])
        drawRect(this.leftX, this.topY + 1, this.rightX, this.bottomY)
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

    if StringListBox(this).prevActiveControll != nil:
        this.app.activate(StringListBox(this).prevActiveControll)




proc cancel(this:Controll)=
    var slistbox = StringListBox(this)
    slistbox.blur(this)
    slistbox.draw()




proc onClick(this:Controll, event:KMEvent)=
    StringListBox(this).draw()

    if not this.disabled:
        var slistbox = StringListBox(this)

        case event.btn:
            of 0:
                if clickedInside(this,event):
                    if ((event.y - (slistbox.topY + 1)) + slistbox.offset) <= slistbox.options.high: # if not clicked on empty space
                        let selected = (event.y - (slistbox.topY + 1)) + slistbox.offset

                        # visuals:
                        slistbox.cursor = selected
                        slistbox.draw()
                        # action
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
    if this.offset > this.height - 1:
        this.offset -= (this.height - 1)
        this.cursor -= (this.height - 1)
    else:
        this.offset = 0
        this.cursor = 0
    this.draw(true)


proc onPgDown(this: StringListBox) =
    if this.options.len > this.height:
        if this.offset + (this.height - 1) < this.options.len - (this.height - 1):
            # jump a page down
            this.offset += (this.height - 1)
            this.cursor = this.offset
        else:
            if this.offset == this.options.len - (this.height - 1):
                this.cursor = this.options.high
                this.app.cursorPos.y = this.bottomY
            else:
                this.offset = this.options.len - (this.height - 1)
                this.cursor = this.offset
        this.draw(true)


proc onHome(this: StringListBox)=
    this.offset = 0
    this.cursor = 0
    this.draw(true)

proc onEnd(this: StringListBox)=
    this.offset = this.options.len - (this.height - 1)
    this.cursor = this.options.high
    this.draw(true)  


proc onKeypress(this:Controll, event:KMEvent)=
    if not this.disabled:
        let slistbox = StringListBox(this)

        if event.evType == KMEventKind.FnKey: #.....FnKey.....FnKey.....FnKey.....FnKey...
            case event.key:
                of KeyDown:
                    onKeyDown(slistbox)

                of KeyUP:
                    onKeyUp(StringListBox(this))

                of KeyPgDown: onPgDown(StringListBox(this))
                of KeyPgUp: onPgUp(StringListBox(this))

                of KeyHome: onHome(StringListBox(this))
                of KeyEnd: onEnd(StringListBox(this))

                else: discard

        elif event.evType == KMEventKind.CtrlKey:
            case event.ctrlKey:
                of 13: # ENTER, ctrl+M
                    if slistbox.options[slistbox.cursor].action != nil:
                        slistbox.options[slistbox.cursor].action()

                else: discard


proc onScroll(this:Controll, event:KMEvent)=
    case event.evType:
        of KMEventKind.ScrollUp: StringListBox(this).onPgUp()
        of KMEventKind.ScrollDown: StringListBox(this).onPgDown()
        else: discard




########        #    # ###### #    #
########        ##   # #      #    #
########        # #  # #####  #    #
########        #  # # #      # ## #
########        #   ## #      ##  ##
########        #    # ###### #    #

proc newStringListBox*(win:Window, label: string, width:int=20, height:int=20): StringListBox =
    result = new StringListBox
    result.disabled = false

    result.label = label

    result.width = width
    result.height = height

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
    #styleEven.setTextStyle("styleUnderline") #!
    result.styles.add("input:even",styleEven)

    var styleOdd: StyleSheetRef = new StyleSheetRef
    styleOdd.deepcopy win.app.styles["input:odd"]
    #styleOdd.setTextStyle("styleUnderline") #!
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


proc newStringListBox*(win:Window, label: string, width:string, height:string): StringListBox =
    result = newStringListBox(win, label)
    discard width.parseInt(result.width_value)
    discard height.parseInt(result.height_value)