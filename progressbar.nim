import stui, terminal, colors, colors_extra, unicode, tables, parseutils, locks

type ProgressBar* = ref object of Controll
    label*:string
    val*:int
    preval*:int # undo

    size*:int # of input



#[ proc leftX(this: Controll) : int = 
    this.x1 + this.activeStyle.margin.left + this.borderWidth()

#[ proc rightX(this: Controll) : int =
    (this.x2 - this.activeStyle.margin.right - this.borderWidth()) ]#

proc bottomY(this: Controll) : int =
    this.y2 - this.activeStyle.margin.bottom - this.borderWidth() ]#


proc draw*(this: ProgressBar, updateOnly: bool = false) =
    if this.visible:
        acquire(this.app.termlock)

        #stdout.write "\e[?25l"
        hideCursor()

        if not updateOnly:
            setColors(this.app, this.win.activeStyle[])
            terminal.setCursorPos(this.x1 + this.activeStyle.margin.left,
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

        stui.setColors(this.app, this.activeStyle[])
        terminal.setCursorPos(this.leftX(), 
                              this.bottomY())
        # █ ▓ ░
        var size: int = int((this.width / 100) * float(this.val))

        #!    about '\n':
        #!        Stream	Type	Behavior
        #!        stdin	input	line-buffered
        #!        stdout (TTY)	output	line-buffered
        #!        stdout (not a TTY)	output	fully-buffered
        #!        stderr	output	unbuffered

        if size > 0 :
            #stdout.write $size
            stdout.write "▓" * size
            stdout.write " " * (this.width - size)
            stdout.write '\n'
        else:
            #stdout.write $size
            stdout.write " " * this.width
            stdout.write '\n'

        #this.app.parkCursor()
        this.app.setCursorPos()
        #stdout.write "\e[?25h"
        showCursor()
        release(this.app.termlock)


### MANDATORY ###
proc drawit(this: Controll, updateOnly: bool = false) =
    draw(ProgressBar(this), updateOnly)





proc `value=`*(this: ProgressBar, str:string) =
    discard parseInt(str, this.val)
    if this.visible: this.draw()
    trigger(this, "change")

proc `value`*(this: ProgressBar): string = $this.val

# Textbox value and value2 same type as val : string
proc `value2=`*(this: ProgressBar, val:int) =
    this.val = val
    if this.visible: this.draw()
    trigger(this, "change")

proc `value2`*(this: ProgressBar): int = this.val





proc focus(this: Controll)=
    this.prevStyle = this.activeStyle 
    this.activeStyle = this.styles["input:focus"]



proc blur(this: Controll)=
    if this.prevStyle != nil: # prevstyle may not initialized
        this.activeStyle = this.prevStyle 




proc cancel(this: Controll)=
    ProgressBar(this).val = 0
    ProgressBar(this).blur(this)
    ProgressBar(this).draw()
    


#[ 
proc onKeyPress(this: Controll, event: KMEvent)=
    discard


proc onClick(this: Controll, event: KMEvent):void=
    ProgressBar(this).draw()


proc onDrop(this: Controll, event: KMEvent):void=
    discard
   

proc onDrag(this: Controll, event: KMEvent)=
    discard
 ]#


    


                      
########        #    # ###### #    # 
########        ##   # #      #    # 
########        # #  # #####  #    # 
########        #  # # #      # ## # 
########        #   ## #      ##  ## 
########        #    # ###### #    # 
                      
proc newProgressBar*(win:Window, label: string, width:int=20): ProgressBar =
    result = new ProgressBar
    result.label=label

    result.visible = false
    result.disabled = false

    result.width = width
    result.heigth = 2
    result.styles = newTable[string, StyleSheetRef](8)

    var styleNormal: StyleSheetRef = new StyleSheetRef
    styleNormal.deepcopy win.app.styles["input:inverse"]
    result.styles.add("input",styleNormal)
    #[ styleNormal.deepcopy win.app.styles["input"]
    result.styles.add("input",styleNormal)
    styleNormal.fgColor = styleNormal.bgColor
    styleNormal.bgColor = win.app.styles["panel"].bgColor ]#
   
    var styleFocused: StyleSheetRef = new StyleSheetRef
    styleFocused.deepcopy win.app.styles["input:focus"]
    result.styles.add("input:focus",styleFocused)

    var styleDragged: StyleSheetRef = new StyleSheetRef
    styleDragged.deepCopy win.app.styles["input:drag"]
    result.styles.add("input:drag",styleDragged)

    var styleDisabled: StyleSheetRef = new StyleSheetRef
    styleDisabled.deepcopy win.app.styles["input:disabled"]
    result.styles.add("input:disabled", styleDisabled)

    result.activeStyle = result.styles["input"]


    result.drawit = drawit
    result.blur = blur
    result.focus = focus
    result.cancel = cancel
    #[ result.onClick = onClick
    result.onDrag = onDrag
    result.onDrop = onDrop
    result.onKeypress = onKeyPress ]#

    result.app = win.app
    result.win = win
    result.listeners = @[]
    
    win.controlls.add(result)
    