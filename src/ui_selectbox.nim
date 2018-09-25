import stui, terminal, colors, colors_extra, unicode, tables, locks
import strutils, parseutils
import ui_chooser

type 
    
    SelectBox* = ref object of Controll
        ## uses Chooser controll to select value(s)
        ## triggers "change" on blur or chooser change
        #label*:string
        val*:string # for store
        text*:string # for display
        options*: OptionListRef # seq[ tuple[name, value:string, selected:bool]  ]
        preval*:  OptionList # undo
        
        multiSelect:bool

        #width*:int # of input
        
        offset_h*:int
        #cursor_pos*:int

        
        chooser*: Chooser

#[ proc `value=`*(this: SelectBox, str:string) =
    this.val = str
    if this.visible: this.draw() ]#

proc `value`*(this:SelectBox): string =
    result = ""
    for i in 1..this.options[].high:
        if this.options[i].selected:
            if result.len == 0:
                result.add(this.options[i].name)
            else:
                result.add("," & this.options[i].name)

proc `value=`*(this:SelectBox, val:string) =
    for word in split(val, ','):
        for i in 1..this.options[].high:
            if this.options[i].name == word: this.options[i].selected = true

proc `value2`*(this:SelectBox): seq[string] =
    result = @[]
    for i in 1..this.options[].high:
        if this.options[i].selected: result.add(this.options[i].name)

proc `value2=`*(this:SelectBox, selected: seq[string]) =
    for c in 0..selected.high:
        for i in 1..this.options[].high:
            if this.options[i].name == selected[c]: this.options[i].selected = true

proc deselectAll*(this:SelectBox)=
    for i in 0..this.options[].high:
        this.options[i].selected = false

#----------------------------------


method draw*(this: SelectBox, updateOnly: bool = false) {.base.} =
    #echo "TB"
    if this.visible:
        #echo "TV"
        acquire(this.app.termlock)

        if not updateOnly:
            setColors(this.app, this.win.activeStyle[])
            terminal.setCursorPos(this.x1 + this.activeStyle.margin.left,
                                this.y1 + this.activeStyle.margin.top)
            stdout.write this.label

            # draw border
            drawBorder(this.activeStyle.border, 
                       this.x1 + this.activeStyle.margin.left,
                       this.y1 + this.activeStyle.margin.top + 1 #[ +1 label]#,
                       this.x2 - this.activeStyle.margin.right,
                       this.y2 - this.activeStyle.margin.bottom
                       )
            #...

        setColors(this.app, this.activeStyle[])
        terminal.setCursorPos(this.leftX(), 
                              this.bottomY())
        if this.text.runeLen > 0 :
            if this.text.runeLen < (this.width - 1):
                stdout.write this.text
                stdout.write " " * ((this.width - 1) - this.text.runeLen)  & "▼"
            else:
                if this.offset_h + (this.width - 1) < this.text.runeLen:
                    stdout.write this.text.runeSubStr(this.offset_h, (this.width - 1) - 1)  & "…▼"
                else:
                    var used = (this.text.runeLen - this.offset_h - 1)
                    stdout.write this.text.runeSubStr(this.offset_h, used)
                    stdout.write " " * ((this.width - 1) - used)  & "▼"
        else:
            stdout.write " " * (this.width - 1) & "▼"


        #setColors(this.app, this.app.activeStyle[])
        #this.app.parkCursor()
        this.app.setCursorPos()
        release(this.app.termlock)

### MANDATORY ###
proc drawit(this: Controll, updateOnly: bool = false) =
    draw(SelectBox(this), updateOnly)




proc focus(this: Controll)=
    this.prevStyle = this.activeStyle
    this.activeStyle = this.styles["input:focus"]
    this.drawit(this,false)

proc blur(this: Controll)=
    if this.prevStyle != nil: this.activeStyle = this.prevStyle # prevstyle may not initialized
    trigger(this, "change")

proc cancel(this: Controll)=
    SelectBox(this).options[].deepCopy SelectBox(this).preval


    



proc selectBoxOnClick(this:Controll, event:KMEvent)=
    ## used @:
    ##  blur() = trigger(this, "change") =
    ##  chooser.app.activeControll.trigger("change")
    if not this.disabled:
        var sb = SelectBox(this)
        sb.preval.deepCopy sb.options[]

        var parentWin = sb.app.activeWindow
        var win = sb.app.activeTile.newWindow()
        win.controlls.add(sb.chooser)
        var page = win.newPage()
        page.controlls.add(sb.chooser)
        sb.chooser.visible = true
        win.x1 = parentWin.x1
        win.y1 = parentWin.y1 + 1
        win.x2 = parentWin.x2
        win.y2 = parentWin.y2
        win.width = parentWin.width # win.x2 - win.x1
        win.heigth = win.y2 - win.y1
        win.styles["panel"].bgColor[2]=235
        win.styles["panel"].bgColor[3] = int(packRGB(38,38,38))
        win.label = sb.label

        sb.chooser.win = win
        sb.chooser.x1 = win.x1
        sb.chooser.y1 = win.y1 + 1
        sb.chooser.x2 = win.x2
        sb.chooser.y2 = win.y2
        sb.chooser.width = sb.chooser.x2 - sb.chooser.x1
        sb.chooser.prevActiveControll = this

        for iC in 0..this.win.pages[this.win.currentPage].controlls.high :
            this.win.pages[this.win.currentPage].controlls[iC].visible = false
        win.draw()

        sb.app.activeControll = sb.chooser    
        # setfocus!!!!!!!!!


# ⎡
# ⎢
# ⎣
proc selectBoxOnChange(this: Controll)= # …✔✖ ⚯ ⚮ ⚭ ⚬ 🂱
    if SelectBox(this).multiSelect:
        SelectBox(this).text = ""
        SelectBox(this).val = ""

        for opt in SelectBox(this).options[] :
            if opt.selected :
                if SelectBox(this).val != "":
                    SelectBox(this).text = SelectBox(this).text & ","
                    SelectBox(this).val = SelectBox(this).val & ","

                SelectBox(this).text = SelectBox(this).text & (if opt.name == "☓": "" else: opt.name)#opt.name
                SelectBox(this).val = SelectBox(this).val & opt.value
    else:
        for opt in SelectBox(this).options[] :
            if opt.selected :
                SelectBox(this).text = (if opt.name == "☓": "" else: opt.name)
                SelectBox(this).val = opt.value

    SelectBox(this).draw()
    #echo "CHANGE"




proc onKeyPress(this: Controll, event:KMEvent)=
    if not this.disabled:
        if event.evType == "CtrlKey":
            case event.ctrlKey:
                of 13:
                    this.onClick(this, event)
                else:
                    discard


proc newSelectBox*(win:Window, label: string, multiSelect:bool=false, width:int=20): SelectBox =
    result = new SelectBox
    result.label=label
    result.multiSelect = multiSelect
    result.width=width
    result.offset_h = 0
    #result.cursor_pos = 0
    result.visible = false
    result.disabled = false
    #result.width = width
    result.heigth = 2
    result.styles = newTable[string, StyleSheetRef](8)
#[     result.styles.add("input",win.app.styles["input"])
    result.activeStyle = result.styles["input"] ]#
    var styleNormal: StyleSheetRef = new StyleSheetRef
    styleNormal.deepcopy win.app.styles["input"]
    styleNormal.border="none"
    result.styles.add("input",styleNormal)    
    result.activeStyle = result.styles["input"]
    
    result.app = win.app
    result.win = win

    result.listeners = @[]
    result.addEventListener("change", selectBoxOnChange)
  
    var styleFocused: StyleSheetRef = new StyleSheetRef
    styleFocused.deepcopy result.styles["input"]
    styleFocused.bgColor[2]=222
    styleFocused.bgColor[3] = int(packRGB(255,215,95))
    styleFocused.textStyle.incl(styleUnknown)
    result.styles.add("input:focus",styleFocused)

    var styleDragged: StyleSheetRef = new StyleSheetRef
    styleDragged.deepCopy result.styles["input"]
    styleDragged.bgColor[2]=128
    styleDragged.bgColor[3] = int(packRGB(175,0,215))
    styleDragged.textStyle.incl(styleBlink)
    result.styles.add("input:drag",styleDragged)

    result.drawit = drawit

    result.options = new OptionListRef
    result.options[] = @[]
    result.options[].add((name:"☓" , value: "", selected:false))
    result.chooser = newChooser(win,result.options, multiSelect)

    result.onClick = selectBoxOnClick
    result.onKeypress = onKeyPress
    result.focus = focus
    result.blur = blur
    result.cancel = cancel

    
    win.controlls.add(result)


proc newSelectBox*(win:Window, label: string, multiSelect:bool=false, width:string): SelectBox =
    result = newSelectBox(win, label, multiSelect, width = 0)
    discard width.parseInt(result.width_value)


