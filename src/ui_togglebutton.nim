#import stui, terminal, colors, colors_extra, colors256, unicode, tables, os, locks
include "controll.inc.nim"

type ToggleButton* = ref object of Controll
    ## no border or padding style
    ## use paddingH, paddingV: int in
    ##   proc newButton*(win:Window, label: string, paddingH: int = 0, paddingV:int = 0 ): Button =
    ## addEventListener("click", proc(source:Controll):void) for action

    #label*:string
    paddingH, paddingV: int
    val*, onValue*, offValue*: string


proc `value`*(this:ToggleButton): string =
    ## return this.val as string - SQL etc likes this
    this.val

proc `value2`*(this:ToggleButton): bool =
    ## return this.val as string - SQL etc likes this
    if this.val == this.onValue:
        return true
    else:
        return false

proc `value=`*(this:ToggleButton, newVal:string) =
    if newVal == this.onValue:
        this.val = this.onValue
    else:
        this.val = this.offValue

proc `value2=`*(this:ToggleButton, newVal:bool) =
    if newVal :
        this.val = this.onValue
    else:
        this.val = this.offValue

proc toggle*(this:ToggleButton)=
    if this.val == this.onValue:
        this.val = this.offValue
    else:
        this.val = this.onValue



proc setPaddingV*(this:ToggleButton, padding:int)=
    this.paddingV = padding
    this.heigth = 2 + (padding * 2)

proc setPaddingH*(this:ToggleButton, padding:int)=
    this.paddingH = padding
    this.width = this.label.runeLen() + (this.paddingH * 2)

proc draw*(this: ToggleButton, updateOnly: bool = false)=
    if this.visible:
        acquire(this.app.termlock)

        setColors(this.app, this.win.activeStyle[])

        drawBorder(this.activeStyle.border,
            this.x1 + this.activeStyle.margin.left,
            this.y1 + this.activeStyle.margin.top,
            this.x2 - this.activeStyle.margin.right,
            this.y2 - this.activeStyle.margin.bottom
            )

        if this.val == this.onValue:
            setColors(this.app, this.activeStyle[])

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
                stdout.write(" " * (this.width - this.label.runeLen - this.paddingH))#(this.width - this.label.runeLen - (this.paddingH * 2)) )
            else: # exactly:
                terminal_extra.setCursorPos(this.leftX, cLine )
                stdout.write(" " * this.paddingH)
                stdout.write(this.label)
                stdout.write(" " * this.paddingH)

            cLine += 1
            for iP in 1..this.paddingV + 1:
                terminal_extra.setCursorPos(this.leftX, cLine )
                stdout.write(" " * this.width)
                cLine += 1

        else:
            setColors(this.app, this.win.activeStyle[])
            var cLine = this.topY
            for iP in 1..((this.paddingV * 2) + 1):
                terminal_extra.setCursorPos(this.leftX, cLine )
                stdout.write(" " * this.width)
                cLine += 1
                
            cLine = this.bottomY
            terminal_extra.setCursorPos(this.leftX, cLine )

            if this.width_value != 0:
                this.paddingH = (this.width - this.label.runeLen) div 2

            stdout.write(" " * this.paddingH)
            stdout.write(this.label)
            stdout.write(" " * this.paddingH)#(this.width - this.label.runeLen - (this.paddingH * 2)) )

        #this.app.parkCursor()
        this.app.setCursorPos()

        release(this.app.termlock)



proc drawit(this: Controll, updateOnly: bool = false) =
    draw(ToggleButton(this), updateOnly)




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
        ToggleButton(this).toggle()

        var c: char
        if event.evType != "CtrlKey": # mouseClick flush Release event
            while c != 'm':
                c = getch()

        this.blur(this)
        drawit(this)


proc onDrag(this: Controll, event:KMEvent)=discard

proc onDrop(this: Controll, event:KMEvent)=discard

proc onKeyPress(this: Controll, event:KMEvent)=
    # todo: focusFWD on KeyLeft ?
    if not this.disabled:
        if event.evType == "CtrlKey":
            case event.ctrlKey:
                of 13:
                    this.onClick(this, event)
                else:
                    discard


proc newToggleButton*(win:Window, label, onValue, offValue: string, paddingH: int = 0, paddingV:int = 0, toggled:bool = false): ToggleButton =
    result = new ToggleButton
    result.label=label
    result.heigth = 2 + (paddingV * 2)
    result.width = label.runeLen() + (paddingH * 2) # padding
    result.visible = false
    result.disabled = false
    result.paddingH = paddingH
    result.paddingV = paddingV

    result.onValue = onValue
    result.offValue = offValue
    if toggled:
        result.val = onValue
    else:
        result.val = offValue

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

    result.setBorder("solid")

    win.controlls.add(result) # typical finish line

proc newToggleButton*(win:Window, label, onValue, offValue: string, width:string, paddingV:int = 0): ToggleButton =
    result = newToggleButton(win, label, onValue, offValue, 0, paddingV)
    discard width.parseInt(result.width_value)
    #discard heigth.parseInt(result.heigth_value)