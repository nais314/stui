import stui, terminal, colors, colors_extra, colors256, unicode, tables, os, locks

type Button* = ref object of Controll
    #label*:string
    paddingH, paddingV: int


proc setPaddingV*(this:Button, padding:int)=
    this.paddingV = padding
    this.heigth = 1 + (padding * 2)

proc setPaddingH*(this:Button, padding:int)=
    this.paddingH = padding
    this.width = this.label.runeLen() + (this.paddingH * 2) 

proc draw*(this: Button, updateOnly: bool = false)=
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
            this.bottomY)
        #...
        var cLine = this.topY
        for iP in 1..this.paddingV:
            terminal.setCursorPos(this.leftX, cLine )
            stdout.write(" " * this.width)
            cLine += 1

        terminal.setCursorPos(this.leftX, cLine )
        stdout.write(" " * this.paddingV)
        stdout.write(this.label)
        stdout.write(" " * this.paddingV)

        cLine += 1
        for iP in 1..this.paddingV:
            terminal.setCursorPos(this.leftX, cLine )
            stdout.write(" " * this.width)
            cLine += 1        

        #this.app.parkCursor()
        this.app.setCursorPos()

        release(this.app.termlock)
    

        
proc drawit(this: Controll, updateOnly: bool = false) =
    draw(Button(this), updateOnly)




proc focus(this: Controll)=
    this.prevStyle = this.activeStyle 
    this.activeStyle = this.styles["input:focus"]


proc blur(this: Controll)=
    if this.prevStyle != nil: this.activeStyle = this.prevStyle # prevstyle may not initialized

proc cancel(this: Controll)=discard

# made public to call if replaced - new method of event listener adding
proc onClick*(this: Controll, event:KMEvent) =
    if not this.disabled:
        #this.focus(this)
        this.drawit(this, false)
        var c: char
        if event.evType != "CtrlKey": # mouseClick flush Release event
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
    if not this.disabled:
        if event.evType == "CtrlKey":
            case event.ctrlKey:
                of 13:
                    this.onClick(this, event)
                else:
                    discard


proc newButton*(win:Window, label: string, paddingH: int = 0, paddingV:int = 0 ): Button =
    result = new Button
    result.label=label
    result.heigth = 1 + (paddingV * 2) 
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
        
