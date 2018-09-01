import stui, terminal, colors, colors_extra, unicode, tables, parseutils, locks

type FineProgressBar* = ref object of Controll
    #label*:string
    val*:int # 0..100  (%)
    preval*:int # undo

    levels*: tuple[normal, warning:int]
    levelStyles*: tuple[normal, warning, error:StyleSheetRef]

    #size*:int # of input




proc draw*(this: FineProgressBar, updateOnly: bool = false) =
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

        if this.val <= this.levels.normal:
            setColors(this.app, this.activeStyle[])
        elif this.val <= this.levels.warning:
            setColors(this.app, this.styles["input:warning"])
        else:
            setColors(this.app, this.styles["input:error"])

            

        terminal.setCursorPos(this.leftX(), 
                              this.bottomY())
        # █ ▓ ░
        #U+2588	█	e2 96 88
        #U+2589	▉	e2 96 89
        #U+258a	▊	e2 96 8a
        #U+258b	▋	e2 96 8b

        #U+258c	▌	e2 96 8c
        #U+258d	▍	e2 96 8d
        #U+258e	▎	e2 96 8e
        #U+258f	▏
        let 
            onePc: float = (this.width / 100)
            hBarCharset = ["","▏","▎","▍","▌", "▋","▊","▉","█"]
        var 
            size = int( onePc * float(this.val) )
            rem  = int( ((onePc * float(this.val)) - size.float) / (1/8) )

        #!  about '\n':
        #!      Stream	Type	Behavior
        #!      stdin	input	line-buffered
        #!      stdout (TTY)	output	line-buffered
        #!      stdout (not a TTY)	output	fully-buffered
        #!      stderr	output	unbuffered

        if size > 0 :
            #stdout.write $size
            if rem > 0:
                stdout.write ("▓" * size) & hBarCharset[rem]
                stdout.write " " * (this.width - size - rem)
            else:
                stdout.write ("▓" * size)
                stdout.write " " * (this.width - size)

            stdout.write '\n' #!
        else:
            #stdout.write $size
            stdout.write " " * this.width
            stdout.write '\n' #!

        #this.app.parkCursor()
        this.app.setCursorPos()
        #stdout.write "\e[?25h"
        showCursor()
        release(this.app.termlock)


### MANDATORY ###
proc drawit(this: Controll, updateOnly: bool = false) =
    draw(FineProgressBar(this), updateOnly)





proc `value=`*(this: FineProgressBar, str:string) =
    discard parseInt(str, this.val)
    if this.val > 100: this.val = 100
    if this.visible: this.draw()
    trigger(this, "change")

proc `value`*(this: FineProgressBar): string = $this.val

# Textbox value and value2 same type as val : string
proc `value2=`*(this: FineProgressBar, val:int) =
    this.val = val
    if this.val > 100: this.val = 100
    if this.visible: this.draw()
    trigger(this, "change")

proc `value2`*(this: FineProgressBar): int = this.val





proc focus(this: Controll)=
    this.prevStyle = this.activeStyle 
    this.activeStyle = this.styles["input:focus"]



proc blur(this: Controll)=
    if this.prevStyle != nil: # prevstyle may not initialized
        this.activeStyle = this.prevStyle 




proc cancel(this: Controll)=
    FineProgressBar(this).val = 0
    FineProgressBar(this).blur(this)
    FineProgressBar(this).draw()
    


#[ 
proc onKeyPress(this: Controll, event: KMEvent)=
    discard


proc onClick(this: Controll, event: KMEvent):void=
    FineProgressBar(this).draw()


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
                      
proc newFineProgressBar*(win:Window, label: string, width:int=20): FineProgressBar =
    result = new FineProgressBar
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

    var styleWarning: StyleSheetRef = new StyleSheetRef
    styleWarning.deepcopy win.app.styles["input:inverse"]
    styleWarning.fgColor[0] = fgYellow.int
    styleWarning.fgColor[1] = fgYellow.int
    styleWarning.fgColor[2] = parseColor("gold",2)
    styleWarning.fgColor[3] = parseColor("gold",3)

 #[    styleWarning.bgColor[0] = bgRed.int
    styleWarning.bgColor[1] = bgRed.int
    styleWarning.bgColor[2] = parseColor("maroon",2)
    styleWarning.bgColor[3] = parseColor("maroon",3) ]#
    result.styles.add("input:warning",styleWarning)

    var styleError: StyleSheetRef = new StyleSheetRef
    styleError.deepcopy win.app.styles["input:inverse"]
    styleError.fgColor[0] = fgRed.int
    styleError.fgColor[1] = fgRed.int
    styleError.fgColor[2] = parseColor("red",2)
    styleError.fgColor[3] = parseColor("red",3)

    styleError.bgColor[0] = bgYellow.int
    styleError.bgColor[1] = bgYellow.int
    styleError.bgColor[2] = parseColor("maroon",2)
    styleError.bgColor[3] = parseColor("maroon",3)

    styleError.setTextStyle("styleBlink")
    result.styles.add("input:error",styleError)

    result.levels.normal = 100
    result.levels.warning = 100

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
    

proc newFineProgressBar*(win:Window, label: string, width:int=20, 
    levels: tuple[normal, warning:int]): FineProgressBar =

    result = newFineProgressBar(win, label, width)
    result.levels = levels
     

proc newFineProgressBar*(win:Window, label: string, width:int=20, 
    levels: tuple[normal, warning:int],
    levelStyles: tuple[warning, error:StyleSheetRef]): FineProgressBar =

    result = newFineProgressBar(win, label, width)
    result.levels = levels

    result.styles["input:warning"].copyColorsFrom(levelStyles.warning)
    result.styles["input:error"].copyColorsFrom(levelStyles.error)
     