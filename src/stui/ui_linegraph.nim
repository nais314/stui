import uiext_maximize
include "controll_inc.nim"
import math, typetraits

# todo:

# styles: input & reverse + focused
# pos: mark & bar
# neg: mark & bar

## styles:
##   graph:positive
##   graph:negative
##   graph:selected
##   mark:positive
##   mark:negative

const
    ScalerWidth = 14

type
    Dataset2D*[T] = ref object of RootObj
        selected*:int
        maxItems*:int
        values*: seq[tuple[name:string, value:T]] #name for visuals,detail,, like date, time
        maxValue*, minValue*: T # todo proc add
        conditionalStyler*: proc (this: Dataset2D[T], val: T){.gcsafe.}
        lock*: Lock


# todo? add time to values? or either time or name?
#proc dummy_conditionalStyler_F(this: Dataset2D[float], val: float) = discard
#proc dummy_conditionalStyler_I(this: Dataset2D[int], val: int) = discard
proc dummy_conditionalStyler[T](this: Dataset2D[T], val: T){.gcsafe.} = discard


proc `[]`*[T](dataset:Dataset2D[T], i: Natural): T =
    dataset.values[i].value

proc selected*[T](dataset:Dataset2D[T]): tuple[name:string, value:T] =
    return dataset.values[dataset.selected]

proc high*[T](dataset:Dataset2D[T]): int =
    dataset.values.high



proc add*[T](this: Dataset2D[T], val: tuple[name:string, value:T] ): bool = #? bool for Future
    withLock this.lock:
        this.values.add(val)
        if this.maxValue < val.value : this.maxValue = val.value
        if this.minValue > val.value : this.minValue = val.value

        if this.selected == this.values.high - 1 : this.selected = this.values.high #? =) lock on last item, END, rightReading
        if this.selected == 1 : this.selected = 0 # lock on HOME - leftReading

        if this.maxItems < this.values.len and this.maxItems > 0: 
            this.values.delete(0)
            if this.selected != 0 and this.selected != this.values.high: this.selected -= 1 # lock on selected


type LineGraph*[T] = ref object of MaximizableControll
    offset*:int # num-lines scrolled
    cursor_pos*:int
    scale*: int # zoom-zoom

    showMarks*, showScale*, showDetail*:bool #for draw
    marklen*:int # if showMarks, the length of marks
    scaleControllsY*: int # to handle onclicks 'faster' ◀ 1/99▶┈▲1X▼
    lockOnNew*:bool # always show last item, no scroll, doubleclick to change

    rightReading*:bool

    dataSet*: Dataset2D[T]
    floatPrecision*: int # number of decimal places for display
    yLineHeight*: float


    graphHeight*, graphWidth*: int # will be calculated
    prevGraphHeight*, prevGraphWidth*: int # speed up redraw
    posGraphHeight*, negGraphHeight*: int # store to speed up redraw

    tickMarkRune* : string # = "├"
    tickLineRune* : string # ┈
    fullLineRune* : string #= "┃"
    halfLineRune* : string #= "╻"
    negativeFullLineRune* : string
    negativeHalfLineRune* : string #= "╹"





import parsecfg
proc loadStylesFromFile(this: LineGraph, filename: string) =
    var
        lineGraphTss = loadConfig(filename)

    this.styles.del("mark:positive")
    this.styles.del("mark:negative")
    this.styles.del("graph:positive")
    this.styles.del("graph:negative")
    this.styles.del("graph:selected")

    this.styles.add("mark:positive", styleSheetRef_fromConfig(lineGraphTss,"mark-positive"))
    this.styles.add("mark:negative", styleSheetRef_fromConfig(lineGraphTss,"mark-negative"))
    this.styles.add("graph:positive", styleSheetRef_fromConfig(lineGraphTss,"graph-positive"))
    this.styles.add("graph:negative", styleSheetRef_fromConfig(lineGraphTss,"graph-negative"))
    this.styles.add("graph:selected", styleSheetRef_fromConfig(lineGraphTss,"graph-selected"))







####      ########  ########     ###    ##      ##
####      ##     ## ##     ##   ## ##   ##  ##  ##
####   ## ##     ## ##     ##  ##   ##  ##  ##  ##
####   ## ##     ## ########  ##     ## ##  ##  ##
####   ## ##     ## ##   ##   ######### ##  ##  ##
####      ##     ## ##    ##  ##     ## ##  ##  ##
####      ########  ##     ## ##     ##  ###  ###


proc drawFromOffset_floatDataset[T](this: LineGraph[T], updateOnly: bool = false){.gcsafe.}=
    ## offset is independent of zoom/scale
    ## but must be dividable by zoom/scale

    block MAIN: # DEPRECATED block for break
        withLock this.dataSet.lock:

            if updateOnly == false:

                this.prevGraphHeight = this.graphHeight #!

                # calc number of lines for positive and negative side
                if this.graphHeight == 1:
                    discard #todo
                else:

                    this.yLineHeight = (this.dataSet.maxValue.float + abs(this.dataSet.minValue.float)) / this.graphHeight.float

                    if this.yLineHeight == 0: break MAIN #todo

                    this.posGraphHeight = int(ceil(this.dataSet.maxValue.float / this.yLineHeight))
                    this.negGraphHeight = int(ceil(abs(this.dataSet.minValue).float / this.yLineHeight))

                    # make sure we fit into the area...:
                    while this.posGraphHeight + this.negGraphHeight > this.graphHeight:
                        this.yLineHeight = this.yLineHeight * 1.05 #? 1.05 ?
                        this.posGraphHeight = int(ceil(this.dataSet.maxValue.float / this.yLineHeight))
                        this.negGraphHeight = int(ceil(abs(this.dataSet.minValue).float / this.yLineHeight))




            # MARKS

            #    #   ##   #####  #    #  ####  
            ##  ##  #  #  #    # #   #  #      
            # ## # #    # #    # ####    ####  
            #    # ###### #####  #  #        # 
            #    # #    # #   #  #   #  #    # 
            #    # #    # #    # #    #  ####  

            if this.graphHeight == 1:
                ## no room for negative values.. or maybe there is... ╵│
                discard #todo
            else:
                #terminal_extra.setCursorPos(this.leftX, cline)

                # what is the widest mark?
                if this.dataSet.maxValue.float.formatFloat(ffDecimal, this.floatPrecision).len >
                    this.dataSet.minValue.float.formatFloat(ffDecimal, this.floatPrecision).len:
                        this.marklen = this.dataSet.maxValue.float.formatFloat(ffDecimal, this.floatPrecision).len
                else:
                    this.marklen = this.dataSet.minValue.float.formatFloat(ffDecimal, this.floatPrecision).len

                #!
                this.graphWidth = if this.showMarks: this.width - (this.marklen + 1) else: this.width
                this.prevGraphWidth  = this.graphWidth #!


                var cline = (this.topY + 1) + this.posGraphHeight#! line cursor - cline
                                        

                                                
                if this.showMarks and this.graphWidth > 0: #this.showMarks and this.width > 4: #? 4?
                    #positive...........................
                    #style:
                    if this.styles.hasKey("mark:positive"):
                        setColors(this.app, this.styles["mark:positive"])
                    else:
                        terminal_extra.setDimmed() # not working on RGB :[
                    #draw:
                    for li in 1 .. this.posGraphHeight :
                        cline -= 1
                        terminal_extra.setCursorPos(this.leftX, cline)
                        stdout.write unicode.align((this.yLineHeight * li.float).formatFloat(ffDecimal, this.floatPrecision),this.marklen)
                        stdout.write this.tickMarkRune
                        stdout.write this.tickLineRune * (this.width - this.marklen - 1)

                    #negative...........................
                    #style:
                    if this.styles.hasKey("mark:negative"):
                        setColors(this.app, this.styles["mark:negative"])
                    else:
                        terminal_extra.setReversed()
                        terminal_extra.setDimmed()
                    #draw:
                    cline = (this.topY + 1) + this.posGraphHeight - 1#!
                    for li in 1..this.negGraphHeight :
                        cline += 1
                        terminal_extra.setCursorPos(this.leftX, cline)
                        stdout.write unicode.align((0 - (this.yLineHeight * li.float)).formatFloat(ffDecimal, this.floatPrecision), this.marklen)
                        stdout.write this.tickMarkRune
                        stdout.write this.tickLineRune * (this.width - this.marklen - 1)




                else: # no marks, horizontal lines only:
                    #style:
                    if this.styles.hasKey("mark:positive"):
                        setColors(this.app, this.styles["mark:positive"])
                    #draw:
                    cline = (this.topY + 1) #!
                    for li in 0..this.posGraphHeight - 1:
                        terminal_extra.setCursorPos(this.leftX, cline)
                        stdout.write this.tickLineRune * this.width
                        cline += 1
                    #style:
                    if this.styles.hasKey("mark:negative"):
                        setColors(this.app, this.styles["mark:negative"])
                    else:
                        terminal_extra.setReversed()
                    #draw:
                    for li in 1..this.negGraphHeight :
                        terminal_extra.setCursorPos(this.leftX, cline)
                        stdout.write this.tickLineRune * this.width
                        cline += 1


                #-----graph ready to be drawed------#

                if this.lockOnNew:
                    if this.scale == 1:
                        if this.dataSet.values.len > this.graphWidth:
                            this.offset = this.dataSet.values.len - this.graphWidth
                    else:
                        if this.dataSet.values.len > this.scale * this.graphWidth:
                            this.offset = this.dataSet.values.len -
                                (this.graphWidth * this.scale)


                var
                    cx: int # = if this.showMarks: this.leftX + this.marklen + 1 else: this.leftX
                    graphLeftX = if this.showMarks: this.leftX + this.marklen + 1 else: this.leftX
                    cy = this.topY + 1
                    cval:T=0 # for draw
                    #cvalMin, cvalMax :float=0 # for draw scaled # not implemented
                    cursor = this.offset # to walk
                    lineLen = 0

                if this.rightReading:
                    cx = this.rightX
                else:
                    cx = graphLeftX

                # from offset, step=scale
                                
                #####  #####    ##   #    # 
                #    # #    #  #  #  #    # 
                #    # #    # #    # #    # 
                #    # #####  ###### # ## # 
                #    # #   #  #    # ##  ## 
                #####  #    # #    # #    # ####################
                                
                while cx <= this.rightX and cx >= graphLeftX and
                    cursor <= this.dataSet.values.high:

                    lineLen = 0 # amount of | , RESET
                    #style
                    if this.styles.hasKey("graph:positive"):
                        setColors(this.app, this.styles["graph:positive"])
                    else:
                        setColors(this.app, this.activeStyle[]) # style reset


                    #draw------------------------------------------

                    if this.scale == 1:
                        cval = this.dataSet[cursor]
                    else: # calc avg if scaled
                        if (cursor + this.scale - 1) < this.dataSet.values.high:
                            for cv in cursor .. (cursor + this.scale - 1):
                                cval += this.dataSet[cv]
                            
                            cval = T(cval.float / this.scale.float)

                            if cval > this.dataSet.maxValue: cval = this.dataSet.maxValue
                            if cval < this.dataSet.minValue: cval = this.dataSet.minValue
                        else:
                            cval = this.dataSet.values[this.dataSet.values.high].value

                        #[ if (cursor + this.scale - 1) < this.dataSet.values.high:
                            for cv in cursor .. (cursor + this.scale - 1):
                                if abs(this.dataSet[cv]) > cval:
                                    cval = this.dataSet[cv] ]#

                    #style
                    if cval > 0:
                        if this.styles.hasKey("graph:positive"):
                            setColors(this.app, this.styles["graph:positive"])
                    elif cval < 0:
                        if this.styles.hasKey("graph:negative"):
                            setColors(this.app, this.styles["graph:negative"])
                        else:
                            terminal_extra.setReversed() #!

                    #conditional styling hook
                    #[ if not this.dataSet.conditionalStyler.isNil :
                        this.dataSet.conditionalStyler(this.dataSet, cval) ]#
                    #! the approach will be dummy procs vs isNil testing: for GC safety
                    this.dataSet.conditionalStyler(this.dataSet, cval)

                    #style of selected
                    if this.scale == 1:
                        if cursor == this.dataSet.selected:
                            #colors_extra.setForegroundColor("orange")
                            if this.styles.hasKey("graph:selected"):
                                setColors(this.app, this.styles["graph:selected"])
                            else:
                                setColors(this.app, this.styles["input:focus"])
                                terminal_extra.setReversed()
                    else:
                        if this.dataSet.selected in cursor .. (cursor + this.scale - 1) and
                            ( cursor + (this.scale - 1) < this.dataSet.values.high or
                            cursor == this.dataSet.values.high):
                                #colors_extra.setForegroundColor("orange")
                                if this.styles.hasKey("graph:selected"):
                                    setColors(this.app, this.styles["graph:selected"])
                                else:
                                    setColors(this.app, this.styles["input:focus"])
                                    terminal_extra.setReversed()

                    #stderr.write cval
                    if cval != 0: # something to show
                        if cval > 0: # ------ POSITIVE VALUE -------

                            cy = (this.topY ) + this.posGraphHeight # y first line

                            if cval.float < this.yLineHeight / 2:
                                terminal_extra.setCursorPos(cx, cy)
                                stdout.write "_"
                            else:

                                lineLen = int(cval.float / this.yLineHeight)

                                for i in 1..lineLen:
                                    terminal_extra.setCursorPos(cx, cy)
                                    stdout.write(this.fullLineRune)
                                    cy -= 1

                                #if lineLen.float * this.yLineHeight < cval: # :)
                                #[ if cval - lineLen.float * this.yLineHeight >= this.yLineHeight / 4 :
                                    terminal_extra.setCursorPos(cx, cy)
                                    stdout.write(",") ]#
                                if cval.float - lineLen.float * this.yLineHeight >= this.yLineHeight / 2 :
                                    terminal_extra.setCursorPos(cx, cy)
                                    stdout.write(this.halfLineRune)


                        elif cval < 0: # ------ NEGATIVE VALUE -------

                            cy = (this.topY ) + this.posGraphHeight + 1 # y first negative line

                            if abs(cval.float) < this.yLineHeight / 2:
                                terminal_extra.setCursorPos(cx, cy - 1)
                                stdout.write "_"
                            else:

                                lineLen = int(abs(cval.float) / this.yLineHeight)

                                for i in 1..lineLen:
                                    terminal_extra.setCursorPos(cx, cy)
                                    stdout.write(this.negativeFullLineRune)
                                    cy += 1

                                #if lineLen.float * this.yLineHeight < cval: # :)
                                #[ if abs(cval + lineLen.float * this.yLineHeight) >= this.yLineHeight / 4 :
                                    terminal_extra.setCursorPos(cx, cy)
                                    stdout.write("'") ]#
                                if abs(cval.float + lineLen.float * this.yLineHeight) >= this.yLineHeight / 2 :
                                    terminal_extra.setCursorPos(cx, cy)
                                    stdout.write(this.negativeHalfLineRune)


                    else: # cval == 0
                        cy = (this.topY ) + this.posGraphHeight
                        terminal_extra.setCursorPos(cx, cy)
                        stdout.write "_"


                    if this.scale == 1:
                        cursor += 1
                    else:
                        if this.scale + cursor > this.dataSet.values.high and
                            cursor != this.dataSet.values.high:
                            echo "."
                            #break
                            cursor = this.dataSet.values.high
                        else:
                            cursor += this.scale

                    #end draw------------------------------------------

                    # next row:
                    cx = if this.rightReading: cx - 1 else: cx + 1
                #ENDWHILE-----------------------------------------------------------


                #echo "\e[0m"

                if this.showScale and this.width > ScalerWidth: # 14 = scaler width
                    cline += 1

                    if this.styles.hasKey("mark:negative"):
                        setColors(this.app, this.styles["mark:negative"])
                    else:
                        setColors(this.app, this.activeStyle[])
                    terminal_extra.setReversed()

                    this.scaleControllsY = cline # cache linu number for onclicks

                    terminal_extra.setCursorPos(this.leftX, cline)
                    #echo "◀ 1/99▶ ▲1X▼"

                    stdout.write "◀"

                    var cpage = int(this.offset / this.graphWidth) + 1 # +1 to omit 0
                    stdout.write if cpage < 10: " " & $cpage else: $cpage
                    stdout.write "/"

                    var numpages = int(this.dataSet.values.len / this.graphWidth) + 1 # +1 to omit 0
                    if numpages < 10:
                        stdout.write " ", $numpages
                    elif numpages < 100:
                        stdout.write $numpages
                    else:
                        stdout.write " ∞"

                    stdout.write "▶ ▼"
                    if this.scale < 10:
                        stdout.write "  " , $this.scale, "X▲"
                    elif this.scale < 100:
                        stdout.write " " , $this.scale, "X▲"
                    else :
                        stdout.write $this.scale, "X▲"

                    #fill line
                    if this.width > 14: stdout.write " " * (this.width - 14)

                else: this.scaleControllsY = this.topy + this.graphHeight + 1






                #  ####  #    #  ####  #    #    #####  ###### #####   ##   # #       ####
                # #      #    # #    # #    #    #    # #        #    #  #  # #      #
                #  ####  ###### #    # #    #    #    # #####    #   #    # # #       ####
                #      # #    # #    # # ## #    #    # #        #   ###### # #           #
                # #    # #    # #    # ##  ##    #    # #        #   #    # # #      #    #
                #  ####  #    #  ####  #    #    #####  ######   #   #    # # ######  ####

                if this.showDetail and this.height > 4:
                    setColors(this.app, this.activeStyle[])

                    terminal_extra.setUnderline()
                    terminal_extra.setDimmed()

                    cline += 1
                    terminal_extra.setCursorPos(this.leftX, cline)
                    
                    
                    # NAME ...........................................
                    
                    if this.scale == 1:
                        if selected(this.dataSet).name.runeLen <= this.width - 2: # "‧"
                            stdout.write "⒩ ",
                                selected(this.dataSet).name,
                                " " * ((this.width - 2) - selected(this.dataSet).name.runeLen)
                        else:
                            stdout.write "⒩ ",
                                "[", runeSubStr(selected(this.dataSet).name, 0, this.width - 4), "]"
                    else:
                        var name: string
                        # if-else for boundaries checks
                        if this.dataSet.selected + this.scale <= this.dataSet.values.high:
                            for si in this.dataSet.selected .. (this.dataSet.selected + this.scale - 1):
                                if si <= this.dataSet.values.high:
                                    name &= this.dataSet.values[si].name & " "

                            if name.runeLen <= this.width - 2:
                                stdout.write "⒩ ",
                                    name,
                                    " " * ((this.width - 2) - name.runeLen)
                            else:
                                stdout.write "⒩ ",
                                    runeSubStr(name, 0, this.width - 3), "…"

                        else:
                            for si in this.dataSet.values.high - (this.scale - 1) .. this.dataSet.values.high:
                                if si <= this.dataSet.values.high:
                                    name &= this.dataSet.values[si].name & " "

                            if name.runeLen <= this.width - 2:
                                stdout.write "⒩ ",
                                    name,
                                    " " * ((this.width - 2) - name.runeLen)
                            else:
                                stdout.write "⒩ ",
                                    runeSubStr(name, 0, this.width - 3), "…"



                    # VALUE ...........................................
                    #echo "[avg:               ]"
                    #terminal_extra.setCursorPos(this.leftX, cline + 3)
                    #echo "[max:               ]"
                    #terminal_extra.setCursorPos(this.leftX, cline + 4)
                    #echo "[min:               ] \e[0m"
                    cline += 1
                    terminal_extra.setCursorPos(this.leftX, cline)
                    var value: string
                    if this.scale == 1:
                        value = $(selected(this.dataSet).value)
                        if len(value) <= this.width - 2:
                            stdout.write "⒱ ",
                                value,
                                " " * ((this.width - 2) - len(value))
                        else:
                            stdout.write "⒱ ",
                                value.runeSubStr(0, this.width - 3), "…"


                    else: # IF SCALED -----------------------
                        if this.dataSet.selected + this.scale - 1 <= this.dataSet.values.high:
                            var 
                                min, max : T
                                avg: float

                            min = selected(this.dataSet).value
                            max = min

                            for si in this.dataSet.selected .. (this.dataSet.selected + this.scale - 1):
                                avg += this.dataSet[si].float
                                if min > this.dataSet[si]:
                                    min = this.dataSet[si]
                                elif max < this.dataSet[si]:
                                    max = this.dataSet[si]
                            avg = avg / this.scale.float


                            #cline += 1
                            terminal_extra.setCursorPos(this.leftX, cline)
                            value = $(avg)
                            if len(value) <= this.width - 2:
                                stdout.write "⒜ ",
                                    value,
                                    " " * ((this.width - 2) - len(value))
                            else:
                                stdout.write "⒜ ",
                                    value.runeSubStr(0, this.width - 3), "…"

                            cline += 1
                            terminal_extra.setCursorPos(this.leftX, cline)
                            value = $(min)
                            if len(value) <= this.width - 2:
                                stdout.write "⒧ ",
                                    value,
                                    " " * ((this.width - 2) - len(value))
                            else:
                                stdout.write "⒧ ",
                                    value.runeSubStr(0, this.width - 3), "…"

                            cline += 1
                            terminal_extra.setCursorPos(this.leftX, cline)
                            value = $(max)
                            if len(value) <= this.width - 2:
                                stdout.write "⒣ ",
                                    value,
                                    " " * ((this.width - 2) - len(value))
                            else:
                                stdout.write "⒣ ",
                                    value.runeSubStr(0, this.width - 3), "…"
                    # END VALUE  ...........................................











########
########         #####  #####    ##   #    #
########         #    # #    #  #  #  #    #
########         #    # #    # #    # #    #
########         #    # #####  ###### # ## #
########         #    # #   #  #    # ##  ##
########         #####  #    # #    # #    #
########


proc draw*[T](this: LineGraph[T], updateOnly: bool = false){.gcsafe.} =
    if this.visible:
        acquire(this.app.termlock)

        if not updateOnly:
            setColors(this.app, this.win.activeStyle[])
            if not this.isMaximized:
                terminal_extra.setCursorPos(this.x1 + this.activeStyle.margin.left,
                                    this.y1 + this.activeStyle.margin.top)
                if this.lockOnNew: stdout.write "🔒" # Ⓛ Ⓡ
                stdout.write this.label, "  "


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

            # if window resized:
            if this.height > 0:
                if not this.isMaximized:
                    this.graphHeight = this.height - 1 #label
                else:
                    this.graphHeight = this.win.height - 1 #this.height + 1
                    this.y1 = this.win.y1
                    
                if this.showScale and (this.graphHeight > 1) and this.height > 4: this.graphHeight -= 1
                if this.showDetail and (this.graphHeight > 4) and this.scale == 1 and this.height > 4: this.graphHeight -= 2
                elif this.showDetail and (this.graphHeight > 4) and this.height > 4: this.graphHeight -= 4

        #setColors(this.app, this.activeStyle[])

        drawFromOffset_floatDataset(this, updateOnly)

        this.app.setCursorPos()
        release(this.app.termlock)

        if not updateOnly:
            if this.isMaximized:
                if this.lockOnNew: 
                    this.win.label = "🔒" & this.label
                else:
                    this.win.label = this.label
                this.win.drawTitle()


### MANDATORY ###
proc drawit(this: Controll, updateOnly: bool = false) =
    #draw(LineGraph(this), updateOnly)
    #var lg : LineGraph[float] = cast[LineGraph[float]](this)
    if this.genericType == "float": draw(LineGraph[float](this), updateOnly)
    if this.genericType == "int"  : draw(LineGraph[int](this), updateOnly)
    #echo "\n\n", $this.type, " : ", this.genericType



##   ###### #    # ###### #    # #####    #    #   ##   #    # #####  #      ###### #####   ####
##   #      #    # #      ##   #   #      #    #  #  #  ##   # #    # #      #      #    # #
##   #####  #    # #####  # #  #   #      ###### #    # # #  # #    # #      #####  #    #  ####
##   #      #    # #      #  # #   #      #    # ###### #  # # #    # #      #      #####       #
##   #       #  #  #      #   ##   #      #    # #    # #   ## #    # #      #      #   #  #    #
##   ######   ##   ###### #    #   #      #    # #    # #    # #####  ###### ###### #    #  ####


proc onEnd[T](this: LineGraph[T]) =
    discard

proc onHome[T](this: LineGraph[T]) =
    discard

proc onPgUp[T](this: LineGraph[T]) =
    #[ this.offset += this.graphWidth
    if this.offset > this.dataSet.high:
        this.offset = this.dataSet.high - this.graphWidth + 1
    if this.offset < 0: this.offset = 0 #! ]#
    if this.offset + this.graphWidth < this.dataSet.high:
        this.offset += this.graphWidth

    this.draw(false)

proc onPgDown[T](this: LineGraph[T]) =
    this.offset -= this.graphWidth

    if this.offset < 0: this.offset = 0

    this.draw(false)

proc scaleUp[T](this: LineGraph[T]) =
    this.scale += 1
    this.draw(false)

proc scaleDown[T](this: LineGraph[T]) =
    if this.scale > 1:
        this.scale -= 1
        this.draw(false)




#######      #######  ##    ##     ######  ##       ####  ######  ##    ##
#######     ##     ## ###   ##    ##    ## ##        ##  ##    ## ##   ##
#######     ##     ## ####  ##    ##       ##        ##  ##       ##  ##
#######     ##     ## ## ## ##    ##       ##        ##  ##       #####
#######     ##     ## ##  ####    ##       ##        ##  ##       ##  ##
#######     ##     ## ##   ###    ##    ## ##        ##  ##    ## ##   ##
#######      #######  ##    ##     ######  ######## ####  ######  ##    ##

proc onClickHelper[T](this: LineGraph[T], event: KMEvent) =
    
        if event.btn == 0:
            #"◀ 1/99▶ ▲  1X▼"
            if event.y == this.scaleControllsY:
                if event.x == this.leftX: # >:) maybe a good idea?
                    if this.rightReading:
                        onPgUp(this)
                    else:
                        onPgDown(this)
                elif event.x == this.leftX + 6:
                    if this.rightReading:
                        onPgDown(this)
                    else:
                        onPgUp(this)
                elif event.x == this.leftX + 8: scaleDown(this)
                elif event.x == this.leftX + 13: scaleUp(this)

            #if a bar clicked .................................
            if event.y < this.scaleControllsY and
                event.x >= this.rightX - this.graphWidth:

                    if this.scale == 1:
                        if this.rightReading:
                            this.dataSet.selected = this.offset + (this.rightX - event.x)
                        else:
                            this.dataSet.selected = this.offset + (event.x - (this.leftX + this.markLen + 1))

                        if this.dataSet.selected > this.dataSet.values.high:
                            this.dataSet.selected = this.dataSet.values.high
                        this.draw(false)
                    else: # SCALED --------------------------
                        if this.rightReading:
                            this.dataSet.selected = this.offset +
                                ((this.rightX - event.x) * this.scale)
                            echo this.dataSet.selected, " / ", this.dataSet.values.high
                        else:
                            this.dataSet.selected = this.offset +
                                ((event.x - (this.leftX + this.markLen + 1)) * this.scale)

                        if this.dataSet.selected > this.dataSet.values.high:
                            this.dataSet.selected = this.dataSet.values.high


                        this.draw(false)


        elif event.btn == 2: # right click
            ## maximize
            if not this.isMaximized:
                maximize(this)
            else:
                unMaximize(this)




proc onClick(this_elem: Controll, event: KMEvent) =
    if this_elem.genericType == "float": onClickHelper(LineGraph[float](this_elem), event)
    if this_elem.genericType == "int"  : onClickHelper(LineGraph[int](this_elem), event)

            


proc onDoubleClickHelper[T](this: LineGraph[T], event: KMEvent):void =
    this.lockOnNew = not this.lockOnNew


proc onDoubleClick(this_elem: Controll, event: KMEvent) =
    if this_elem.genericType == "float": onDoubleClickHelper(LineGraph[float](this_elem), event)
    if this_elem.genericType == "int"  : onDoubleClickHelper(LineGraph[int](this_elem), event)


####      ######   ######  ########   #######  ##       ##
####     ##    ## ##    ## ##     ## ##     ## ##       ##
####     ##       ##       ##     ## ##     ## ##       ##
####      ######  ##       ########  ##     ## ##       ##
####           ## ##       ##   ##   ##     ## ##       ##
####     ##    ## ##    ## ##    ##  ##     ## ##       ##
####      ######   ######  ##     ##  #######  ######## ########

proc onScrollHelper[T](this:LineGraph[T], event:KMEvent)=

    case event.evType:
        of KMEventKind.ScrollUp:
            if this.rightReading:
                this.onPgDown()
            else:
                this.onPgUp()

        of KMEventKind.ScrollDown:
            if this.rightReading:
                this.onPgUp()
            else:
                this.onPgDown()
        else: discard

proc onScroll(this_elem: Controll, event: KMEvent) =
    if this_elem.genericType == "float": onScrollHelper(LineGraph[float](this_elem), event)
    if this_elem.genericType == "int"  : onScrollHelper(LineGraph[int](this_elem), event)


##    ## ######## ##    ## ########  ########  ########  ######   ######
##   ##  ##        ##  ##  ##     ## ##     ## ##       ##    ## ##    ##
##  ##   ##         ####   ##     ## ##     ## ##       ##       ##
#####    ######      ##    ########  ########  ######    ######   ######
##  ##   ##          ##    ##        ##   ##   ##             ##       ##
##   ##  ##          ##    ##        ##    ##  ##       ##    ## ##    ##
##    ## ########    ##    ##        ##     ## ########  ######   ######

proc onKeyPressHelper[T](this: LineGraph[T], event: KMEvent)=

    if not this.disabled:
        if event.evType == KMEventKind.FnKey:
            case event.key:
                of KeyRight: # right "[C"
                    discard

                of KeyLeft: # left "[D"
                    discard

                of KeyUp:
                    discard

                of KeyDown:
                    discard


                of KeyEnd: #End
                    discard


                of KeyHome: #Home
                    discard

                of KeyPgDown:
                    this.onPgDown()

                of KeyPgUp:
                    this.onPgUp()

                else: discard




        elif event.evType == KMEventKind.Char:
            #......Char......Char......Char......Char
            discard




        elif event.evType == KMEventKind.CtrlKey: #.....CtrlKey.....CtrlKey.....CtrlKey
            case event.ctrlKey:
                of 13: # enter
                    discard

                of 127: # del
                    discard
                else:
                    discard
            #echo "ctrl"

    else: # if this.disabled:
        if event.evType == KMEventKind.CtrlKey:
            case event.ctrlKey:
                of 3:
                    discard
                    #CLIPBOARD
                else:
                    discard
                    

proc onKeyPress(this_elem: Controll, event: KMEvent)=
    if this_elem.genericType == "float": onKeyPressHelper(LineGraph[float](this_elem), event)
    if this_elem.genericType == "int"  : onKeyPressHelper(LineGraph[int](this_elem), event)




#           ##    ## ######## ##      ##
#           ###   ## ##       ##  ##  ##
#           ####  ## ##       ##  ##  ##
#   ####### ## ## ## ######   ##  ##  ## #######
#           ##  #### ##       ##  ##  ##
#           ##   ### ##       ##  ##  ##
#           ##    ## ########  ###  ###

proc newLineGraph*[T]( win: Window,
                    label:string,
                    width:int=20, height:int=20,
                    showMarks:bool=true,
                    showScale:bool= true,
                    showDetail:bool= true,
                    dataType:char= 'f',
                    floatPrecision:int = 2,
                    rightReading:bool=false,
                    tickMarkRune:string = "├",
                    tickLineRune:string = "┈",
                    fullLineRune:string = "┃", # █
                    halfLineRune:string = "╻", # ▄
                    negativeFullLineRune:string = "┃", # █ │
                    negativeHalfLineRune:string = "╹", # ▀ ╵
                    maxItems:int = 0,
                    lockOnNew:bool=false
                    ): LineGraph[T] =

    result = new LineGraph[T]
    result.win = win
    result.app = win.app
    result.offset = 0
    result.cursor_pos = 0
    result.scale = 1
    result.lockOnNew = lockOnNew

    result.label = label
    result.tickMarkRune = tickMarkRune
    result.tickLineRune = tickLineRune
    result.fullLineRune = fullLineRune
    result.halfLineRune = halfLineRune
    result.negativeFullLineRune = negativeFullLineRune
    result.negativeHalfLineRune = negativeHalfLineRune

    result.visible = false
    result.disabled = false
    result.width = width
    result.height = height
    result.showMarks = showMarks
    result.showScale = showScale
    result.showDetail = showDetail
    result.rightReading = rightReading


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
    result.onClick = onClick
    result.onDoubleClick = onDoubleClick
    result.onKeyPress = onKeyPress
    result.onScroll = onScroll

    result.floatPrecision = floatPrecision

    result.dataSet = new Dataset2D[T]
    result.genericType = result.dataSet.maxValue.type.name
    result.dataSet.conditionalStyler = dummy_conditionalStyler

    result.dataSet.maxItems = maxItems

    result.height = height
    if height > 0:
        result.graphHeight = height
        if showScale and (result.graphHeight > 1): result.graphHeight -= 1
        if showDetail and (result.graphHeight > 4): result.graphHeight -= 4

    win.controlls.add(result)



### RELATIVE W ###
proc newLineGraph*[T]( win: Window,
    label:string,
    width:string, height:int=20,
    showMarks:bool=true,
    showScale:bool= true,
    showDetail:bool= true,
    dataType:char= 'f',
    floatPrecision:int = 2,
    rightReading:bool=false,
    tickMarkRune:string = "├",
    tickLineRune:string = "┈",
    fullLineRune:string = "┃", # █
    halfLineRune:string = "╻", # ▄
    negativeFullLineRune:string = "┃", # █ │
    negativeHalfLineRune:string = "╹", # ▀ ╵
    maxItems:int = 0,
    lockOnNew:bool=false
    ): LineGraph[T] =

    result = newLineGraph[T]( win,
        label,
        width = 0, height,
        showMarks,
        showScale,
        showDetail,
        dataType,
        floatPrecision,
        rightReading,
        tickMarkRune,
        tickLineRune,
        fullLineRune,
        halfLineRune ,
        negativeFullLineRune,
        negativeHalfLineRune,
        maxItems,
        lockOnNew
        )

    discard width.parseInt(result.width_value)





### RELATIVE W,H ###
proc newLineGraph*[T]( win: Window,
    label:string,
    width:string, height:string,
    showMarks:bool=true,
    showScale:bool= true,
    showDetail:bool= true,
    dataType:char= 'f',
    floatPrecision = 2,
    rightReading:bool=false,
    tickMarkRune = "├",
    tickLineRune = "┈",
    fullLineRune = "┃", # █
    halfLineRune = "╻", # ▄
    negativeFullLineRune = "┃", # █ │
    negativeHalfLineRune = "╹", # ▀ ╵
    maxItems:int = 0,
    lockOnNew:bool=false
    ): LineGraph[T] =

    result = newLineGraph[T]( win,
        label,
        width = 0, height = 0,
        showMarks, showScale, showDetail,
        dataType,
        floatPrecision,
        rightReading,
        tickMarkRune, tickLineRune,
        fullLineRune, halfLineRune ,
        negativeFullLineRune, negativeHalfLineRune,
        maxItems,
        lockOnNew
        )

    discard width.parseInt(result.width_value)
    discard height.parseInt(result.height_value)

