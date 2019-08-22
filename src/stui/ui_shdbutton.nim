include "controll_inc.nim"

type ShdButton* = ref object of Controll
    ## no border or padding style
    ## use paddingH, paddingV: int in
    ##   proc newButton*(win:Window, label: string, paddingH: int = 0, paddingV:int = 0 ): Button =
    ## addEventListener("click", proc(source:Controll):void) for action

    #label*:string
    paddingH, paddingV: int


proc setPaddingV*(this:ShdButton, padding:int)=
    this.paddingV = padding
    this.height = 2 + (padding * 2)

proc setPaddingH*(this:ShdButton, padding:int)=
    this.paddingH = padding
    this.width = this.label.runeLen() + (this.paddingH * 2)

proc draw*(this: ShdButton, updateOnly: bool = false)=
    if this.visible:
        acquire(this.app.termlock)

        setColors(this.app, this.activeStyle[])

        #if this.activeStyle.border != "" and this.activeStyle.border != "none":
        #[ drawRect(this.x1 + this.activeStyle.margin.left,
                 this.y1 + this.activeStyle.margin.top,
                 this.x2 - this.activeStyle.margin.right,
                 this.y2 - this.activeStyle.margin.bottom) ]#
        drawRect(this.leftX,
            this.topY,
            this.rightX,
            this.bottomY - 1)
        #...
        var cLine = this.topY
        for iP in 1..this.paddingV:
            terminal_extra.setCursorPos(this.leftX, cLine )
            stdout.write(" " * this.width)
            cLine += 1

        if this.width_value != 0: # relative width; width_value == 0 by default
            terminal_extra.setCursorPos(this.leftX, cLine )

            this.paddingH = (this.width - this.label.runeLen) div 2
            stdout.write(" " * this.paddingH)
            stdout.write(this.label)
            stdout.write(" " * (this.width - this.label.runeLen - (this.paddingH * 2)) )
        else: # exactly:
            terminal_extra.setCursorPos(this.leftX, cLine )
            stdout.write(" " * this.paddingH)
            stdout.write(this.label)
            stdout.write(" " * this.paddingH)

        cLine += 1
        for iP in 1..this.paddingV:
            terminal_extra.setCursorPos(this.leftX, cLine )
            stdout.write(" " * this.width)
            cLine += 1

        
        setColors(this.app, this.win.activeStyle[])
        case this.app.colorMode:
            of 0,1: colors_extra.setForegroundColor(Color16(90))
            of 2:   colors_extra.setForegroundColor(Color256(236))
            else #[ of 3 ]#:   colors_extra.setForegroundColor("dimgray")
            
        terminal_extra.setCursorPos(this.leftX, cLine )
        stdout.write("▝")
        stdout.write("▀" * (this.width - 1))
        stdout.write("▘")
        cLine = this.topY
        terminal_extra.setCursorPos(this.rightX + 1, cLine )
        stdout.write("▖")
        if this.height > 2:
            for iY in 1..this.height - 2:
                cLine += 1
                terminal_extra.setCursorPos(this.rightX + 1, cLine )
                stdout.write("▌")


        #this.app.parkCursor()
        this.app.setCursorPos()

        release(this.app.termlock)



proc drawit(this: Controll, updateOnly: bool = false) =
    draw(ShdButton(this), updateOnly)




proc focus(this: Controll)=
    this.prevStyle = this.activeStyle
    this.activeStyle = this.styles["input:focus"]


proc blur(this: Controll)=
    if this.prevStyle != nil: this.activeStyle = this.prevStyle # prevstyle may not initialized

proc cancel(this: Controll)=discard

# made public to call if replaced - new method of event listener adding
proc onClick*(this: Controll, event:KMEvent) =
    if not this.disabled:
        #this.focus(this) - it is already focused
        #drawit:
        withLock this.app.termlock:
            setColors(this.app, this.win.activeStyle[])
            colors_extra.setForegroundColor("orange")

            var cLine = this.topY
            terminal_extra.setCursorPos(this.leftX, cLine )
            stdout.write("▗")
            stdout.write("▄" * (this.width - 1))
            stdout.write("▖")

            if this.height > 2:
                for iY in 1..this.height - 2:
                    cLine += 1
                    terminal_extra.setCursorPos(this.leftX, cLine )
                    stdout.write("▐")
                    stdout.write("█" * (this.width - 1))
                    stdout.write("▌")

            cLine += 1
            terminal_extra.setCursorPos(this.leftX, cLine )
            stdout.write("▝")
            stdout.write("▀" * (this.width - 1))
            stdout.write("▘")

        var c: char
        if event.evType != KMEventKind.CtrlKey: # mouseClick flush Release event
            while c != 'm':
                c = getch()
        # visual feedback:
        sleep(100)
        this.blur(this)
        drawit(this)
        trigger(this,"click")

proc onDrag(this: Controll, event:KMEvent)=discard

proc onDrop(this: Controll, event:KMEvent)=discard

proc onKeyPress(this: Controll, event:KMEvent)=
    # todo: focusFWD on KeyLeft ?
    if not this.disabled:
        if event.evType == KMEventKind.CtrlKey:
            case event.ctrlKey:
                of 13:
                    this.onClick(this, event)
                else:
                    discard


proc newShdButton*(win:Window, label: string, paddingH: int = 0, paddingV:int = 0 ): ShdButton =
    result = new ShdButton
    result.label=label
    result.height = 2 + (paddingV * 2)
    result.width = label.runeLen() + (paddingH * 2) # padding
    result.visible = false
    result.disabled = false
    result.paddingH = paddingH
    result.paddingV = paddingV

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
    result.blur = blur
    result.focus = focus
    result.onClick = onClick
    result.onDrag = onDrag
    result.onDrop = onDrop
    result.cancel = cancel
    result.onKeypress = onKeyPress

    win.controlls.add(result) # typical finish line

proc newShdButton*(win:Window, label: string, width:string, paddingV:int = 0): ShdButton =
    result = newShdButton(win, label, 0, paddingV)
    discard width.parseInt(result.width_value)
    #discard height.parseInt(result.height_value)