import stui, terminal, colors, colors_extra, colors256, unicode, tables, os, locks

type Button* = ref object of Controll
    label*:string


#[ proc leftX(this: Controll) : int = 
    this.x1 + this.activeStyle.margin.left + this.borderWidth()

proc bottomY(this: Controll) : int =
    #this.y2 - this.activeStyle.margin.bottom - this.borderWidth()
    this.y1 + this.activeStyle.margin.top + this.borderWidth() ]#


proc draw*(this: Button, updateOnly: bool = false)=
    if this.visible:
        acquire(this.app.termlock)

        setColors(this.app, this.activeStyle[])

        # draw border
        drawBorder(this.activeStyle.border, 
            this.x1 + this.activeStyle.margin.left,
            this.y1 + this.activeStyle.margin.top,
            this.x2 - this.activeStyle.margin.right,
            this.y2 - this.activeStyle.margin.bottom
            )
        #...

        terminal.setCursorPos(this.leftX(), this.bottomY() )
        stdout.write(" " * this.activeStyle.padding.left)
        stdout.write(this.label)
        stdout.write(" " * this.activeStyle.padding.right)

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
    #this.focus(this)
    this.drawit(this, false)
    var c: char
    if event.evType != "CtrlKey": # mouseClick flush Release event
        while c != 'm':
            c = getch()
    sleep(100)
    this.blur(this)
    drawit(this)
    trigger(this,"click")

proc onDrag(this: Controll, event:KMEvent)=discard

proc onDrop(this: Controll, event:KMEvent)=discard

proc onKeyPress(this: Controll, event:KMEvent)=
    if event.evType == "CtrlKey":
        case event.ctrlKey:
            of 13:
                this.onClick(this, event)
            else:
                discard


#[ proc `heigth`(this: Controll):int=
    2 + this.activeStyle.padding.top + this.activeStyle.padding.bottom ]#

proc newButton*(win:Window, label: string, size:int=0): Button =
    result = new Button
    result.label=label
    result.heigth = 1 # todo: padding
    result.width = label.runeLen()
    result.visible = false
    result.disabled = false

    result.app = win.app
    result.win = win
    result.listeners = @[]

    result.styles = newStyleSheets()

    #result.styles.add("input", win.app.styles["input"])
    var styleNormal: StyleSheetRef = new StyleSheetRef
    styleNormal.deepcopy win.app.styles["input"]
    styleNormal.border="none"
    result.styles.add("input",styleNormal)    
    result.activeStyle = result.styles["input"]

    #result.heigth = 1 #+ result.activeStyle.padding.top + result.activeStyle.padding.bottom

    var styleFocused: StyleSheetRef = new StyleSheetRef
    styleFocused.deepcopy result.styles["input"]
    styleFocused.bgColor[2]=222
    styleFocused.bgColor[3] = int(packRGB(255,215,95))
    styleFocused.textStyle.incl(styleUnknown)
    styleFocused.border="none"
    result.styles.add("input:focus",styleFocused)

    var styleDragged: StyleSheetRef = new StyleSheetRef
    styleDragged.deepCopy result.styles["input"]
    styleDragged.bgColor[2]=128
    styleDragged.bgColor[3] = int(packRGB(175,0,215))
    styleDragged.textStyle.incl(styleBlink)
    styleDragged.border="none"
    result.styles.add("input:drag",styleDragged)

    result.drawit = drawit
    result.blur = blur
    result.focus = focus
    result.onClick = onClick
    result.onDrag = onDrag
    result.onDrop = onDrop
    result.cancel = cancel
    result.onKeypress = onKeyPress
    
    win.controlls.add(result) # typical finish line
        
