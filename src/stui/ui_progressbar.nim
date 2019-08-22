include "controll_inc.nim"
#import stui, terminal, colors, colors_extra, unicode, tables, parseutils, locks

type ProgressBar* = ref object of Controll
    #label*:string
    val*:int
    preval*:int # undo

    #size*:int # of input
    showValue*:bool

    runeBlock*, runeEmpty*:string # what will be printed on screen





proc draw*(this: ProgressBar, updateOnly: bool = false) =
    if this.visible:
        acquire(this.app.termlock)

        #stdout.write "\e[?25l"
        hideCursor()

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

        stui.setColors(this.app, this.activeStyle[])
        terminal_extra.setCursorPos(this.leftX(), 
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
            stdout.write this.runeBlock * size #"▓" * size
            stdout.write this.runeEmpty * (this.width - size) #" " * (this.width - size)
            stdout.write '\n'
        else:
            #stdout.write $size
            stdout.write " " * this.width
            stdout.write '\n'


        if this.showValue :
            terminal_extra.setCursorPos(this.x2 - this.activeStyle.margin.right - 4,
                                this.y1 + this.activeStyle.margin.top)

            stdout.write "████" # clear prev value
            terminal_extra.setCursorPos(this.x2 - this.activeStyle.margin.right - 4,
                                this.y1 + this.activeStyle.margin.top)

            terminal_extra.setReversed()
            
            if this.val < 10:
                terminal_extra.cursorForward(2)
            elif this.val < 100 :
                terminal_extra.cursorForward(1)

            stdout.write $this.val & "%"

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
    

proc onClick(this: Controll, event: KMEvent):void=
    if not this.disabled:
        trigger(this, "click")
        ProgressBar(this).draw()
#[ 
proc onKeyPress(this: Controll, event: KMEvent)=
    discard





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
                      
proc newProgressBar*(win:Window, label: string, width:int=20, showValue: bool = false): ProgressBar =
    result = new ProgressBar
    result.label=label
    result.showValue = showValue
    result.runeBlock = "▓"
    result.runeEmpty = " "

    result.visible = false
    result.disabled = false

    result.width = width
    result.height = 2
    result.styles = newStyleSheets() #newTable[string, StyleSheetRef](8)

    var styleNormal: StyleSheetRef = new StyleSheetRef
    styleNormal.deepcopy win.app.styles["input:inverse"]
    result.styles.add("input",styleNormal)
   
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
    

proc newProgressBar*(win:Window, label: string, width:string, showValue: bool = false): ProgressBar =
    result = newProgressBar(win, label, width = 0, showValue)
    discard width.parseInt(result.width_value)