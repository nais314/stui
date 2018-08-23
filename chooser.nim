import stui, terminal, colors, colors_extra, unicode

type
    Chooser* = ref object of Controll
        options*: OptionListRef # seq[ tuple[name, value:string, selected:bool]  ]
        #win*:Window
        cursor:int
        prevActiveControll*: Controll
        multiSelect*:bool




method draw*(this: Chooser, updateOnly:bool=false){.base.}=
    var 
        firstSelected:int= 0
        cursor:int
        writeY:int

    proc writeOptionName(id:int)=
        stdout.write(this.options[id].name)
        if this.options[id].selected: # ☐☑☒☓⟦⟧⟰⦗⦘
            stdout.write("☒")
        else:
            stdout.write("☐")  

    if this.cursor == -1:
        for i in 0..this.options[].high:
            if this.options[i].selected:
                firstSelected = i
                this.cursor = i
    else:
        firstSelected = this.cursor

    var middleY = this.y1 + int((this.y2 - this.y1) / 2) - 1 #!
    var writeX = this.x1 + int((this.width - this.options[firstSelected].name.len) / 2)
    setColors(this.app, this.win.activeStyle[])
    terminal.setCursorPos(writeX - 4, middleY)
    stdout.write("░▒▓█")
    terminal.setStyle(stdout, {terminal.styleReverse})
    #[ stdout.write(this.options[firstSelected].name)
    if this.options[firstSelected].selected: # ☐☑☒☓⟦⟧⟰⦗⦘
        stdout.write("☒")
    else:
        stdout.write("☐")  ]#
    writeOptionName(firstSelected)  
    terminal.resetAttributes()
    setColors(this.app, this.win.activeStyle[])
    stdout.write("█▓▒░")

    cursor = firstSelected
    if firstSelected < this.options[].high:
        writeY = middleY + 1
        cursor = cursor + 1
        while writeY <= this.y2 and cursor <= this.options[].high:
            writeX = this.x1 + int((this.width - this.options[cursor].name.len) / 2)
            terminal.setCursorPos(writeX, writeY)
            stdout.write(this.options[cursor].name)
            if this.options[cursor].selected: # ☐☑☒☓⟦⟧⟰⦗⦘
                stdout.write("☒")
            else:
                stdout.write("☐")
            cursor = cursor + 1
            writeY = writeY + 1

    cursor = firstSelected
    if firstSelected > 0:
        writeY = middleY - 1
        cursor = cursor - 1
        while writeY >= this.y1 and cursor >= 0:
            writeX = this.x1 + int((this.width - this.options[cursor].name.len) / 2)
            terminal.setCursorPos(writeX, writeY)
            stdout.write(this.options[cursor].name)
            if this.options[cursor].selected: # ☐☑☒☓⟦⟧⟰⦗⦘
                stdout.write("☒")
            else:
                stdout.write("☐")            
            cursor = cursor - 1
            writeY = writeY - 1

### MANDATORY ###
proc drawit(this: Controll, updateOnly:bool=false) =
    draw(Chooser(this),updateOnly)

proc `heigth`*(this:Chooser):int=
    this.win.heigth - 1








proc cancel(this:Controll)=
    var chooser = Chooser(this)
    chooser.app.activeTile.windows.del(chooser.app.activeTile.windows.high)
    chooser.app.activeWindow.draw()
    if chooser.prevActiveControll.cancel != nil : chooser.prevActiveControll.cancel(chooser.prevActiveControll)
    chooser.app.activeControll = chooser.prevActiveControll

proc commit(this:Controll)=
    var chooser = Chooser(this)
    chooser.app.activeTile.windows.del(chooser.app.activeTile.windows.high)
    chooser.app.activeWindow.draw()
    chooser.app.activeControll = chooser.prevActiveControll
    chooser.app.activeControll.trigger("change")










proc onKeypress(this:Controll, event:KMEvent)=
    var chooser = Chooser(this)
    if event.evType == "FnKey": #,"CtrlKey", "Char":
        case event.key:
            of KeyUp:
                if chooser.cursor > 0 :
                    chooser.cursor = chooser.cursor - 1
                    chooser.app.activeWindow.draw()

            of KeyDown:
                if chooser.cursor < chooser.options[].high :
                    chooser.cursor = chooser.cursor + 1
                    chooser.app.activeWindow.draw()

            else: discard

    if event.evType == "CtrlKey":
        case event.ctrlKey:
            of 13: # ENTER, ctrl+M
                #chooser.options[chooser.cursor].selected = true
                commit(this)
            else: discard

    if event.evType == "Char":
        case event.key:
            of " ":
                if chooser.multiSelect == false or chooser.cursor == 0:
                    for i in 0..chooser.options[].high:
                        chooser.options[i].selected = false

                #[ if chooser.cursor != 0:
                    chooser.options[0].selected = false ]#
                chooser.options[chooser.cursor].selected = not chooser.options[chooser.cursor].selected

                var b:bool=true
                for i in 1..chooser.options[].high:
                    if chooser.options[i].selected: b = false
                chooser.options[0].selected = b                    

                chooser.app.activeWindow.draw()
            else: discard



proc onClick(this:Controll, event:KMEvent)=
    var chooser = Chooser(this)

    #if event.btn > 0: cancel(this)

    case event.btn:
        of 0:

            var middleY = this.y1 + int((this.y2 - this.y1) / 2) - 1 #!

            if event.y > middleY:
                if chooser.cursor + (event.y - middleY) <= chooser.options[].high:
                    chooser.cursor = chooser.cursor + (event.y - middleY)

                    if chooser.multiSelect == false or chooser.cursor == 0:
                        for i in 0..chooser.options[].high:
                            chooser.options[i].selected = false

                    #[ if chooser.cursor != 0:
                        chooser.options[0].selected = false ]#
                    chooser.options[chooser.cursor].selected = not chooser.options[chooser.cursor].selected

                    var b:bool=true
                    for i in 1..chooser.options[].high:
                        if chooser.options[i].selected: b = false
                    chooser.options[0].selected = b

                    chooser.app.activeWindow.draw()
                else:
                    cancel(this)


            elif event.y < middleY:
                if chooser.cursor - (middleY - event.y) >= 0:
                    chooser.cursor = chooser.cursor - (middleY - event.y)

                    if chooser.multiSelect == false or chooser.cursor == 0:
                        for i in 0..chooser.options[].high:
                            chooser.options[i].selected = false

                    #[ if chooser.cursor != 0:
                        chooser.options[0].selected = false ]#

                    chooser.options[chooser.cursor].selected = not chooser.options[chooser.cursor].selected

                    var b:bool=true
                    for i in 1..chooser.options[].high:
                        if chooser.options[i].selected: b = false
                    chooser.options[0].selected = b

                    chooser.app.activeWindow.draw()
                else:
                    cancel(this)

            elif event.y == middleY:
                if chooser.multiSelect == false or chooser.cursor == 0:
                    for i in 0..chooser.options[].high:
                        chooser.options[i].selected = false

                if chooser.cursor != 0:
                    chooser.options[0].selected = false

                chooser.options[chooser.cursor].selected = true
                chooser.app.activeWindow.draw()  
        
        else:
            cancel(this)


proc newChooser*(win:Window, options:OptionListRef, multiSelect:bool=false):Chooser=
    result = new Chooser
    result.disabled = false
    result.win = win
    result.app = win.app
    result.options = options
    result.multiSelect = multiSelect
    result.cursor = 0
    result.onKeypress = onKeypress
    result.cancel = cancel
    result.onClick = onClick
    result.drawit = drawit

    #win.controlls.add(result)