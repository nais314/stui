include "controll.inc.nim"
import math

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
    Dataset2D = ref object of RootObj
        selected*:int
        maxItems*:int


    IntDataset2D* = ref object of Dataset2D
        values*: seq[tuple[name:string, value:int]] #name for visuals,detail,, like date, time
        maxValue*, minValue*: int # todo proc add
        conditionalStyler*: proc (this: IntDataset2D, val: int)

    FloatDataset2D* = ref object of Dataset2D
        values*: seq[tuple[name:string, value:float]] #name for visuals,detail,, like date, time
        maxValue*, minValue*: float # todo proc add
        conditionalStyler*: proc (this: FloatDataset2D, val: float)


    # todo? add time to values? or either time or name?
proc dummy_conditionalStyler_F(this: FloatDataset2D, val: float) = discard
proc dummy_conditionalStyler_I(this: IntDataset2D, val: int) = discard


proc `[]`*(dataset:FloatDataset2D, i: Natural): float =
    return dataset.values[i].value

proc selected*(dataset:FloatDataset2D): tuple[name:string, value:float] =
    return dataset.values[dataset.selected]

proc high*(dataset:Dataset2D): int =
    if dataset of IntDataset2D:
        return IntDataset2D(dataset).values.high
    else:
        return FloatDataset2D(dataset).values.high


proc add*(this: FloatDataset2D, val: tuple[name:string, value:float] ): bool = # bool is a hassle, but maybe in the future..ahhh =)
    this.values.add(val)
    if this.maxValue < val.value : this.maxValue = val.value
    if this.minValue > val.value : this.minValue = val.value

    if this.selected == this.values.high - 1 : 
        this.selected = this.values.high #? =)
        #visuals:
        #scroll linegraph like perfmon

    if this.maxItems < this.values.len and this.maxItems > 0: this.values.delete(0)


type LineGraph* = ref object of Controll
    offset*:int # num-lines scrolled
    cursor_pos*:int
    scale*: int # zoom-zoom

    showMarks*, showScale*, showDetail*:bool #for draw
    marklen*:int # if showMarks, the length of marks
    scaleControllsY: int # to handle onclicks 'faster' ◀ 1/99▶┈▲1X▼
    lockOnNew*:bool # always show last item, no scroll, doubleclick to change

    rightReading*:bool

    dataSet*: Dataset2D
    floatPrecision*: int # number of decimal places for display
    yLineHeigth*: float


    graphHeigth*, graphWidth*: int # will be calculated
    prevGraphHeigth*, prevGraphWidth*: int # speed up redraw
    posGraphHeigth*, negGraphHeigth*: int # store to speed up redraw

    tickMarkRune* : string # = "├"
    fullLineRune* : string #= "┃"
    halfLineRune* : string #= "╻"
    negativeFullLineRune* : string
    negativeHalfLineRune* : string #= "╹"

    




####      ########  ########     ###    ##      ## 
####      ##     ## ##     ##   ## ##   ##  ##  ## 
####   ## ##     ## ##     ##  ##   ##  ##  ##  ## 
####   ## ##     ## ########  ##     ## ##  ##  ## 
####   ## ##     ## ##   ##   ######### ##  ##  ## 
####      ##     ## ##    ##  ##     ## ##  ##  ## 
####      ########  ##     ## ##     ##  ###  ###  


proc drawFromOffset_floatDataset(this: LineGraph, updateOnly: bool = false)=
    ## offset is independent of zoom/scale
    ## but must be dividable by zoom/scale

    block MAIN:
        var minMaxProportion: float

        #block RECALC:
        #if this.graphHeigth == 0 or this.graphHeigth != this.prevGraphHeigth : #cache
        if updateOnly == false:
            #block RECALC:

            this.prevGraphHeigth = this.graphHeigth #!

            # calc number of lines for positive and negative side
            if this.graphHeigth == 1:
                discard #todo
            else:
                #[ minMaxProportion = FloatDataset2D(this.dataSet).maxValue / abs(FloatDataset2D(this.dataSet).minValue) ]#

                this.yLineHeigth = (FloatDataset2D(this.dataSet).maxValue + abs(FloatDataset2D(this.dataSet).minValue)) / this.graphHeigth.float

                if this.yLineHeigth == 0: break MAIN #todo
            
                this.posGraphHeigth = int(ceil(FloatDataset2D(this.dataSet).maxValue / this.yLineHeigth))
                this.negGraphHeigth = int(ceil(abs(FloatDataset2D(this.dataSet).minValue) / this.yLineHeigth))

                # make sure we fit into the area...:
                while this.posGraphHeigth + this.negGraphHeigth > this.graphHeigth:
                    this.yLineHeigth = this.yLineHeigth * 1.05 #? 1.05 ?
                    this.posGraphHeigth = int(ceil(FloatDataset2D(this.dataSet).maxValue / this.yLineHeigth))
                    this.negGraphHeigth = int(ceil(abs(FloatDataset2D(this.dataSet).minValue) / this.yLineHeigth))




        # MARKS
        #var markLen: int

        if this.graphHeigth == 1:
            ## no room for negative values.. or maybe there is... ╵│
            discard #todo
        else:
            #terminal_extra.setCursorPos(this.leftX, cline)

            var dataset: FloatDataset2D = FloatDataset2D(this.dataSet)
        
            # what is the widest mark?
            if dataset.maxValue.formatFloat(ffDecimal, this.floatPrecision).len >
                dataset.minValue.formatFloat(ffDecimal, this.floatPrecision).len:
                    this.marklen = dataset.maxValue.formatFloat(ffDecimal, this.floatPrecision).len
            else:
                this.marklen = dataset.minValue.formatFloat(ffDecimal, this.floatPrecision).len

            #!
            this.graphWidth = if this.showMarks: this.width - (this.marklen + 1) else: this.width
            this.prevGraphWidth  = this.graphWidth #!


            var cline = (this.topY + 1) + this.posGraphHeigth#! 

            if this.showMarks and this.width > 4: #? 4?
                #positive...........................
                #style:
                if this.styles.hasKey("mark:positive"):
                    setColors(this.app, this.styles["mark:positive"])
                else:
                    terminal_extra.setDimmed()
                #draw:                    
                for li in 1 .. this.posGraphHeigth :
                    cline -= 1
                    terminal_extra.setCursorPos(this.leftX, cline)
                    stdout.write ( (this.yLineHeigth * li.float)).formatFloat(ffDecimal, this.floatPrecision).align(this.marklen)
                    stdout.write this.tickMarkRune
                    stdout.write "┈" * (this.width - this.marklen - 1) 

                #negative...........................
                #style:
                if this.styles.hasKey("mark:negative"):
                    setColors(this.app, this.styles["mark:negative"])
                else:
                    terminal_extra.setReversed()
                    terminal_extra.setDimmed()
                #draw:  
                cline = (this.topY + 1) + this.posGraphHeigth - 1#!
                for li in 1..this.negGraphHeigth : 
                    cline += 1
                    terminal_extra.setCursorPos(this.leftX, cline)
                    stdout.write (0 - (this.yLineHeigth * li.float)).formatFloat(ffDecimal, this.floatPrecision).align(this.marklen)
                    stdout.write this.tickMarkRune
                    stdout.write "┈" * (this.width - this.marklen - 1) 
                    
                    

            
            else: # no marks:
                #style:
                if this.styles.hasKey("mark:positive"):
                    setColors(this.app, this.styles["mark:positive"])
                #draw: 
                cline = (this.topY + 1) #!
                for li in 0..this.posGraphHeigth - 1:
                    terminal_extra.setCursorPos(this.leftX, cline)
                    stdout.write "┈" * this.width
                    cline += 1
                #style:
                if this.styles.hasKey("mark:negative"):
                    setColors(this.app, this.styles["mark:negative"])
                else:
                    terminal_extra.setReversed()
                #draw: 
                for li in 1..this.negGraphHeigth :
                    terminal_extra.setCursorPos(this.leftX, cline)
                    stdout.write "┈" * this.width
                    cline += 1


            #-----graph ready to be drawed------#

            if this.lockOnNew:
                if this.scale == 1:
                    if FloatDataset2D(this.dataSet).values.len > this.graphWidth:
                        this.offset = FloatDataset2D(this.dataSet).values.len - this.graphWidth
                else:
                    if FloatDataset2D(this.dataSet).values.len > this.scale * this.graphWidth:
                        this.offset = FloatDataset2D(this.dataSet).values.len - 
                            (this.graphWidth * this.scale)


            var 
                cx: int # = if this.showMarks: this.leftX + this.marklen + 1 else: this.leftX
                graphLeftX = if this.showMarks: this.leftX + this.marklen + 1 else: this.leftX
                cy = this.topY + 1
                cval:float=0 # for draw
                #cvalMin, cvalMax :float=0 # for draw scaled
                cursor = this.offset # to walk
                lineLen = 0

            if this.rightReading:
                cx = this.rightX
            else:
                cx = graphLeftX

            # from offset, step=scale
            while cx <= this.rightX and cx >= graphLeftX and 
                cursor <= FloatDataset2D(this.dataset).values.high:

                lineLen = 0 # amount of | , RESET
                #style
                if this.styles.hasKey("graph:positive"):
                    setColors(this.app, this.styles["graph:positive"])
                else:
                    setColors(this.app, this.activeStyle[]) # style reset

                
                #draw------------------------------------------

                if this.scale == 1:
                    cval = FloatDataset2D(this.dataset)[cursor]
                else: # calc avg if scaled
                    if (cursor + this.scale - 1) < FloatDataset2D(this.dataset).values.high:
                        for cv in cursor .. (cursor + this.scale - 1):
                            cval += FloatDataset2D(this.dataset)[cv]
                        cval = cval / this.scale.float
                        if cval > FloatDataset2D(this.dataset).maxValue: cval = FloatDataset2D(this.dataset).maxValue
                        if cval < FloatDataset2D(this.dataset).minValue: cval = FloatDataset2D(this.dataset).minValue
                    #[ if (cursor + this.scale - 1) < FloatDataset2D(this.dataset).values.high:
                        for cv in cursor .. (cursor + this.scale - 1):
                            if abs(FloatDataset2D(this.dataset)[cv]) > cval:
                                cval = FloatDataset2D(this.dataset)[cv] ]#

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
                #[ if not FloatDataset2D(this.dataset).conditionalStyler.isNil : 
                    FloatDataset2D(this.dataset).conditionalStyler(FloatDataset2D(this.dataset), cval) ]#
                FloatDataset2D(this.dataset).conditionalStyler(FloatDataset2D(this.dataset), cval) 
                
                #style of selected
                if this.scale == 1:
                    if cursor == FloatDataset2D(this.dataset).selected:
                        #colors_extra.setForegroundColor("orange")
                        if this.styles.hasKey("graph:selected"):
                            setColors(this.app, this.styles["graph:selected"])
                        else:
                            setColors(this.app, this.styles["input:focus"])
                            terminal_extra.setReversed()
                else:
                    if cursor in FloatDataset2D(this.dataset).selected .. (FloatDataset2D(this.dataset).selected + this.scale - 1):
                        #colors_extra.setForegroundColor("orange")
                        if this.styles.hasKey("graph:selected"):
                            setColors(this.app, this.styles["graph:selected"])
                        else:
                            setColors(this.app, this.styles["input:focus"])
                            terminal_extra.setReversed()

                #stderr.write cval
                if cval != 0: # something to show
                    if cval > 0: # ------ POSITIVE VALUE -------
                        
                        cy = (this.topY ) + this.posGraphHeigth # y first line

                        if cval < this.yLineHeigth / 2:
                            terminal_extra.setCursorPos(cx, cy)
                            stdout.write "_"
                        else:

                            lineLen = int(cval / this.yLineHeigth)

                            for i in 1..lineLen:
                                terminal_extra.setCursorPos(cx, cy)
                                stdout.write(this.fullLineRune)
                                cy -= 1

                            #if lineLen.float * this.yLineHeigth < cval: # :)
                            #[ if cval - lineLen.float * this.yLineHeigth >= this.yLineHeigth / 4 :
                                terminal_extra.setCursorPos(cx, cy)
                                stdout.write(",") ]#
                            if cval - lineLen.float * this.yLineHeigth >= this.yLineHeigth / 2 :
                                terminal_extra.setCursorPos(cx, cy)
                                stdout.write(this.halfLineRune)


                    elif cval < 0: # ------ NEGATIVE VALUE -------

                        cy = (this.topY ) + this.posGraphHeigth + 1 # y first negative line

                        if abs(cval) < this.yLineHeigth / 2:
                            terminal_extra.setCursorPos(cx, cy - 1)
                            stdout.write "_"
                        else:
                                                            
                            lineLen = int(abs(cval) / this.yLineHeigth)

                            for i in 1..lineLen:
                                terminal_extra.setCursorPos(cx, cy)
                                stdout.write(this.negativeFullLineRune)
                                cy += 1

                            #if lineLen.float * this.yLineHeigth < cval: # :)
                            #[ if abs(cval + lineLen.float * this.yLineHeigth) >= this.yLineHeigth / 4 :
                                terminal_extra.setCursorPos(cx, cy)
                                stdout.write("'") ]#
                            if abs(cval + lineLen.float * this.yLineHeigth) >= this.yLineHeigth / 2 :
                                terminal_extra.setCursorPos(cx, cy)
                                stdout.write(this.negativeHalfLineRune)

                
                else: # cval == 0
                    cy = (this.topY ) + this.posGraphHeigth
                    terminal_extra.setCursorPos(cx, cy)
                    stdout.write "_"

                
                if this.scale == 1:
                    cursor += 1
                else:
                    if this.scale + cursor > FloatDataset2D(this.dataSet).values.high:
                        echo "."
                        break
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

                var numpages = int(FloatDataset2D(this.dataSet).values.len / this.graphWidth) + 1 # +1 to omit 0
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

            else: this.scaleControllsY = this.topy + this.graphHeigth + 1
                




                                                                           
            #  ####  #    #  ####  #    #    #####  ###### #####   ##   # #       ####  
            # #      #    # #    # #    #    #    # #        #    #  #  # #      #      
            #  ####  ###### #    # #    #    #    # #####    #   #    # # #       ####  
            #      # #    # #    # # ## #    #    # #        #   ###### # #           # 
            # #    # #    # #    # ##  ##    #    # #        #   #    # # #      #    # 
            #  ####  #    #  ####  #    #    #####  ######   #   #    # # ######  ####  
                                                                           
            if this.showDetail and this.heigth > 4:
                setColors(this.app, this.activeStyle[])
                
                terminal_extra.setUnderline()
                terminal_extra.setDimmed()
                
                cline += 1
                terminal_extra.setCursorPos(this.leftX, cline)
                #echo LABEL ::::::::::
                if this.scale == 1:
                    if selected(FloatDataset2D(this.dataSet)).name.runeLen <= this.width - 2: # "‧"
                        stdout.write "⒩ ", 
                            selected(FloatDataset2D(this.dataSet)).name,
                            " " * ((this.width - 2) - selected(FloatDataset2D(this.dataSet)).name.runeLen)
                    else:
                        stdout.write "⒩ ",
                            "[", runeSubStr(selected(FloatDataset2D(this.dataSet)).name, 0, this.width - 4), "]"
                else:
                    var name: string
                    for si in FloatDataset2D(this.dataSet).selected .. (FloatDataset2D(this.dataSet).selected + this.scale - 1):
                        if si < FloatDataset2D(this.dataSet).values.high:
                            name &= FloatDataset2D(this.dataSet).values[si].name & " "

                    if name.runeLen <= this.width - 2: # "‧"
                        stdout.write "⒩ ", 
                            name,
                            " " * ((this.width - 2) - name.runeLen)
                    else:
                        stdout.write "⒩ ",
                            runeSubStr(name, 0, this.width - 3), "…"



                
                #echo VALUE ::::::::::::::::::::::::::::::::::::::::::::
                #echo "[avg:               ]"
                #terminal_extra.setCursorPos(this.leftX, cline + 3)
                #echo "[max:               ]"
                #terminal_extra.setCursorPos(this.leftX, cline + 4)
                #echo "[min:               ] \e[0m"
                cline += 1
                terminal_extra.setCursorPos(this.leftX, cline)
                var value: string
                if this.scale == 1:
                    value = $(selected(FloatDataset2D(this.dataSet)).value)
                    if len(value) <= this.width - 2:
                        stdout.write "⒱ ", 
                            value,
                            " " * ((this.width - 2) - len(value))
                    else:
                        stdout.write "⒱ ", 
                            value.runeSubStr(0, this.width - 3), "…"
                        

                else:
                    if FloatDataset2D(this.dataSet).selected + this.scale - 1 <= FloatDataset2D(this.dataSet).values.high:
                        var min, max, avg: float
                        min = selected(FloatDataset2D(this.dataSet)).value
                        max = min

                        for si in FloatDataset2D(this.dataSet).selected .. (FloatDataset2D(this.dataSet).selected + this.scale - 1):
                            avg += FloatDataset2D(this.dataSet)[si]
                            if min > FloatDataset2D(this.dataSet)[si]: 
                                min = FloatDataset2D(this.dataSet)[si]
                            elif max < FloatDataset2D(this.dataSet)[si]:
                                max = FloatDataset2D(this.dataSet)[si]
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


                
        #? setColors

        # write y marks, from max to min
        







########                                     
########         #####  #####    ##   #    # 
########         #    # #    #  #  #  #    # 
########         #    # #    # #    # #    # 
########         #    # #####  ###### # ## # 
########         #    # #   #  #    # ##  ## 
########         #####  #    # #    # #    # 
########


proc draw*(this: LineGraph, updateOnly: bool = false) =
    if this.visible:
        acquire(this.app.termlock)

        if not updateOnly:
            setColors(this.app, this.win.activeStyle[])
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
            if this.heigth > 0:
                this.graphHeigth = this.heigth - 1 #label
                if this.showScale and (this.graphHeigth > 1) and this.heigth > 4: this.graphHeigth -= 1
                if this.showDetail and (this.graphHeigth > 4) and this.scale == 1 and this.heigth > 4: this.graphHeigth -= 2
                elif this.showDetail and (this.graphHeigth > 4) and this.heigth > 4: this.graphHeigth -= 4

        #setColors(this.app, this.activeStyle[])

        if this.dataSet of IntDataset2D:
            discard
        else:
            drawFromOffset_floatDataset(this, updateOnly)

        this.app.setCursorPos()
        release(this.app.termlock)


### MANDATORY ###
proc drawit(this: Controll, updateOnly: bool = false) =
    draw(LineGraph(this), updateOnly)




                                                                                              
##   ###### #    # ###### #    # #####    #    #   ##   #    # #####  #      ###### #####   ####  
##   #      #    # #      ##   #   #      #    #  #  #  ##   # #    # #      #      #    # #      
##   #####  #    # #####  # #  #   #      ###### #    # # #  # #    # #      #####  #    #  ####  
##   #      #    # #      #  # #   #      #    # ###### #  # # #    # #      #      #####       # 
##   #       #  #  #      #   ##   #      #    # #    # #   ## #    # #      #      #   #  #    # 
##   ######   ##   ###### #    #   #      #    # #    # #    # #####  ###### ###### #    #  ####  
                                                                                              

proc onEnd(this: LineGraph) =
    discard

proc onHome(this: LineGraph) =
    discard    

proc onPgUp(this: LineGraph) =
    #[ this.offset += this.graphWidth
    if this.offset > this.dataSet.high:
        this.offset = this.dataSet.high - this.graphWidth + 1
    if this.offset < 0: this.offset = 0 #! ]#
    if this.offset + this.graphWidth < this.dataSet.high:
        this.offset += this.graphWidth

    this.draw(false)

proc onPgDown(this: LineGraph) =
    this.offset -= this.graphWidth

    if this.offset < 0: this.offset = 0

    this.draw(false)

proc scaleUp(this: LineGraph) =
    this.scale += 1
    this.draw(false)

proc scaleDown(this: LineGraph) =
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

proc onClick(this_elem: Controll, event: KMEvent) =
    let this = LineGraph(this_elem)

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
                
                if this.dataSet.selected > FloatDataset2D(this.dataSet).values.high:
                    this.dataSet.selected = FloatDataset2D(this.dataSet).values.high
                this.draw(false)
            else:
                if this.rightReading:
                    this.dataSet.selected = this.offset + 
                        ((this.rightX - event.x) * this.scale)
                else:
                    this.dataSet.selected = this.offset + 
                        ((event.x - (this.leftX + this.markLen + 1)) * this.scale)

                if this.dataSet.selected > FloatDataset2D(this.dataSet).values.high:
                    #echo this.dataSet.selected, " ", this.offset, ",", event.x
                    this.dataSet.selected = FloatDataset2D(this.dataSet).values.high - this.scale

                this.draw(false)
        


####      ######   ######  ########   #######  ##       ##       
####     ##    ## ##    ## ##     ## ##     ## ##       ##       
####     ##       ##       ##     ## ##     ## ##       ##       
####      ######  ##       ########  ##     ## ##       ##       
####           ## ##       ##   ##   ##     ## ##       ##       
####     ##    ## ##    ## ##    ##  ##     ## ##       ##       
####      ######   ######  ##     ##  #######  ######## ######## 

proc onScroll(this:Controll, event:KMEvent)=
    case event.evType:
        of "ScrollUp": 
            if LineGraph(this).rightReading: 
                LineGraph(this).onPgDown()
            else: 
                LineGraph(this).onPgUp()
        
        of "ScrollDown": 
            if LineGraph(this).rightReading: 
                LineGraph(this).onPgUp()
            else: 
                LineGraph(this).onPgDown()
        else: discard
    



##    ## ######## ##    ## ########  ########  ########  ######   ######  
##   ##  ##        ##  ##  ##     ## ##     ## ##       ##    ## ##    ## 
##  ##   ##         ####   ##     ## ##     ## ##       ##       ##       
#####    ######      ##    ########  ########  ######    ######   ######  
##  ##   ##          ##    ##        ##   ##   ##             ##       ## 
##   ##  ##          ##    ##        ##    ##  ##       ##    ## ##    ## 
##    ## ########    ##    ##        ##     ## ########  ######   ######  

proc onKeyPress(this: Controll, event: KMEvent)=
    let lg = LineGraph(this)
    if not this.disabled:
        if event.evType == "FnKey": 
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
                    lg.onPgDown()

                of KeyPgUp:
                    lg.onPgUp()

                else: discard




        elif event.evType == "Char":                    
            #......Char......Char......Char......Char
            discard




        elif event.evType == "CtrlKey": #.....CtrlKey.....CtrlKey.....CtrlKey 
            case event.ctrlKey:
                of 13: # enter
                    discard

                of 127: # del
                    discard                   
                else:
                    discard
            #echo "ctrl"

    else: # if this.disabled:
        if event.evType == "CtrlKey":
            case event.ctrlKey:
                of 3:
                    discard
                    #CLIPBOARD
                else:
                    discard






#           ##    ## ######## ##      ##         
#           ###   ## ##       ##  ##  ##         
#           ####  ## ##       ##  ##  ##         
#   ####### ## ## ## ######   ##  ##  ## ####### 
#           ##  #### ##       ##  ##  ##         
#           ##   ### ##       ##  ##  ##         
#           ##    ## ########  ###  ###          

proc newLineGraph*( win: Window,
                    label:string,
                    width:int=20, heigth:int=20,
                    showMarks:bool=true,
                    showScale:bool= true, 
                    showDetail:bool= true, 
                    dataType:char= 'f',
                    floatPrecision = 2,
                    rightReading:bool=false,
                    tickMarkRune = "├",
                    fullLineRune = "┃", # █
                    halfLineRune = "╻", # ▄
                    negativeFullLineRune = "┃", # █ │
                    negativeHalfLineRune = "╹", # ▀ ╵
                    maxItems:int = 0,
                    lockOnNew:bool=false
                    ): LineGraph =

    result = new LineGraph
    result.win = win
    result.app = win.app
    result.offset = 0
    result.cursor_pos = 0
    result.scale = 1
    result.lockOnNew = lockOnNew

    result.label = label
    result.tickMarkRune = tickMarkRune
    result.fullLineRune = fullLineRune
    result.halfLineRune = halfLineRune
    result.negativeFullLineRune = negativeFullLineRune
    result.negativeHalfLineRune = negativeHalfLineRune

    result.visible = false
    result.disabled = false
    result.width = width
    result.heigth = heigth
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
    result.onKeyPress = onKeyPress
    result.onScroll = onScroll



    result.floatPrecision = floatPrecision

    case dataType:
        of 'i': 
            result.dataSet = new IntDataset2D # IntDataset2D()
            IntDataset2D(result.dataSet).conditionalStyler = dummy_conditionalStyler_I
        of 'f': 
            result.dataSet = new FloatDataset2D #FloatDataset2D()
            FloatDataset2D(result.dataSet).conditionalStyler = dummy_conditionalStyler_F
        else: discard

    result.dataSet.maxItems = maxItems


    result.heigth = heigth
    if heigth > 0:
        result.graphHeigth = heigth
        if showScale and (result.graphHeigth > 1): result.graphHeigth -= 1
        if showDetail and (result.graphHeigth > 4): result.graphHeigth -= 4

    win.controlls.add(result)



### RELATIVE W ###
proc newLineGraph*( win: Window,
    label:string,
    width:string, heigth:int=20,
    showMarks:bool=true,
    showScale:bool= true, 
    showDetail:bool= true, 
    dataType:char= 'f',
    floatPrecision = 2,
    rightReading:bool=false,
    tickMarkRune = "├",
    fullLineRune = "┃", # █
    halfLineRune = "╻", # ▄
    negativeFullLineRune = "┃", # █ │
    negativeHalfLineRune = "╹", # ▀ ╵
    maxItems:int = 0,
    lockOnNew:bool=false
    ): LineGraph =

    result = newLineGraph( win,
        label,
        width = 0, heigth,
        showMarks,
        showScale, 
        showDetail, 
        dataType,
        floatPrecision,
        rightReading,
        tickMarkRune,
        fullLineRune, 
        halfLineRune ,
        negativeFullLineRune, 
        negativeHalfLineRune, 
        maxItems,
        lockOnNew
        )
    
    discard width.parseInt(result.width_value)





### RELATIVE W,H ###
proc newLineGraph*( win: Window,
    label:string,
    width:string, heigth:string,
    showMarks:bool=true,
    showScale:bool= true, 
    showDetail:bool= true, 
    dataType:char= 'f',
    floatPrecision = 2,
    rightReading:bool=false,
    tickMarkRune = "├",
    fullLineRune = "┃", # █
    halfLineRune = "╻", # ▄
    negativeFullLineRune = "┃", # █ │
    negativeHalfLineRune = "╹", # ▀ ╵
    maxItems:int = 0,
    lockOnNew:bool=false
    ): LineGraph =

    result = newLineGraph( win,
        label,
        width = 0, heigth = 0,
        showMarks,
        showScale, 
        showDetail, 
        dataType,
        floatPrecision,
        rightReading,
        tickMarkRune,
        fullLineRune, 
        halfLineRune ,
        negativeFullLineRune, 
        negativeHalfLineRune, 
        maxItems,
        lockOnNew
        )
    
    discard width.parseInt(result.width_value)
    discard heigth.parseInt(result.heigth_value)

