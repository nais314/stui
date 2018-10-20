include "controll.inc.nim"
#import stui, terminal, colors, colors_extra, unicode, tables, locks
#import strutils, parseutils
#import ui_chooser
import ui_textbox, ui_menu, ui_button
#import algorithm
from algorithm import sort
import sequtils

# %userprofile%

type 
    
    FileSelect* = ref object of Controll
        ## uses ui_textbox, ui_menu.inlineMenu
        ## triggers "change" on blur or chooser change
        ## label*:string
        val*:string # for store path&filename
        text*:string # for display
        path*,filename*:string
        #options*: OptionListRef # seq[ tuple[name, value:string, selected:bool]  ]
        preval*:  string # undo
        
        #multiSelect:bool # an advanced table/tree controll will be used instead

        #width*:int # of input
        
        offset_h*:int
        #cursor_pos*:int
        

#[ proc `value=`*(this: FileSelect, str:string) =
    this.val = str
    if this.visible: this.draw() ]#


proc draw*(this: FileSelect, updateOnly: bool = false) #FWD


proc `value`*(this:FileSelect): string =
    ## returns string 
    return this.val

proc `value=`*(this:FileSelect, val:string) =
    this.val = val

proc `value2`*(this:FileSelect): string = `value`(this)


#----------------------------------

proc basename*(file: string): string =
    result = file.runeSubStr(0,file.rfind(DirSep) - 1) # -1 DirSep

proc filename*(file: string): string =
    result = file.runeSubStr(file.rfind(DirSep) + 1) # +1 DirSep

proc prevDir*(path:string): string {.inline.} =
    # /
    # ""
    # /foo/bar
    # foo/bar
    # /foo/bar/ foo/bar/

    if path.runeSubStr(path.runeLen - 1) == $DirSep :
        result = path.runeSubStr(0, -2)

    result = result.runeSubStr(0, result.rfind(DirSep) - 1)

proc enterDir*(path, subdir: string): string {.inline.} =
    return path & DirSep & subdir



proc draw*(this: FileSelect, updateOnly: bool = false) =
    if this.visible:
        acquire(this.app.termlock)

        if not updateOnly:
            setColors(this.app, this.win.activeStyle[])
            terminal_extra.setCursorPos(this.x1 + this.activeStyle.margin.left,
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
        terminal_extra.setCursorPos(this.leftX(), 
                              this.bottomY())

        let btnLen = 3

        if this.text.runeLen > 0 :
            if this.text.runeLen < (this.width - btnLen):
                stdout.write this.text
                stdout.write " " * ((this.width - btnLen) - this.text.runeLen) & "⏏" # ◼ ☰ ▶▸► ◢ ◣ ❱ ➔ ➤ ⏏ ✔ 	✔
            else:
                if this.offset_h + (this.width - btnLen) < this.text.runeLen:
                    stdout.write this.text.runeSubStr(this.offset_h, (this.width - btnLen) - 1) & "…⏏" # -1 for …
                else:
                    var used = (this.text.runeLen - this.offset_h - 1)
                    stdout.write this.text.runeSubStr(this.offset_h, used)
                    stdout.write " " * ((this.width - btnLen) - used) & "⏏"
        else:
            stdout.write " " * (this.width - btnLen) & "⏏"


        this.app.setCursorPos()
        release(this.app.termlock)

### MANDATORY ###
proc drawit(this: Controll, updateOnly: bool = false) =
    draw(FileSelect(this), updateOnly)




proc focus(this: Controll)=
    this.prevStyle = this.activeStyle
    this.activeStyle = this.styles["input:focus"]
    this.drawit(this,false)

proc blur(this: Controll)=
    if this.prevStyle != nil: this.activeStyle = this.prevStyle # prevstyle may not initialized
    trigger(this, "change")

proc cancel(this: Controll)=
    FileSelect(this).val = FileSelect(this).preval
    trigger(this, "change")


#-------------------------------------------------------------------------------

    

proc fileMenuRecalc(this:Controll)=

    this.x1 = this.win.x1

    this.y1 = this.win.y1 + 5

    this.x2 = this.win.x2

    this.y2 = this.win.y2 - 7


    this.width = this.rightX - this.leftX + 1

    this.heigth = this.bottomY - this.topY + 1

    #echo "fileMenuRecalc\nfileMenuRecalc2\nfileMenuRecalc3\nfileMenuRecalc4\nfileMenuRecalc5"




proc fsNodeLoader(cwd:string, menuNode:MenuNode )=
    tryit:
        var fileNodes, dirNodes: MenuNode
        fileNodes = new MenuNode
        dirNodes = new MenuNode

        for kind, path in walkDir(cwd):
            #echo path
            # todo if path == /

            case kind : 
                of PathComponent.pcFile: 
                    var nCh = fileNodes.addChild(" " & filename(path), filename(path), nil)
                    nCh.customType = int(PathComponent.pcFile)

                of PathComponent.pcLinkToFile: 
                    var nCh =  fileNodes.addChild("↦" & filename(path), filename(path), nil) # ^
                    nCh.customType = int(PathComponent.pcLinkToFile)
                of PathComponent.pcDir: 
                    var nCh =  dirNodes.addChild("├" & filename(path) & DirSep, filename(path), nil) # "\\"
                    nCh.customType = int(PathComponent.pcDir)
                of PathComponent.pcLinkToDir: 
                    var nCh =  dirNodes.addChild("⇒" & filename(path), filename(path), nil)
                    nCh.customType = int(PathComponent.pcLinkToDir)

        fileNodes.childs.sort(system.cmp)
        dirNodes.childs.sort(system.cmp)

        if cwd != $DirSep : # aka ROOT, then add prev dir:
            menuNode.childs = @[]
            discard menuNode.addChild("↖..", "..", nil)
        menuNode.childs = menuNode.childs.concat(dirNodes.childs) #dirNodes.childs
        menuNode.childs = menuNode.childs.concat(fileNodes.childs)

        for nC in menuNode.childs:
            nC.parent = menuNode

        #if menuNode.childs.len == 0 : echo "--\n--ERR\n--ERR\n", cwd 


proc childLoader(menu: Menu, menuNode: MenuNode) =
    
    let fs = FileSelect(menu.prevActiveControll)
    #withLock menu.app.termlock : echo "childLoader", fs.path, "\n"

    if menuNode.value == "..":
        ## see ui_menu onKeyLeft:

        fs.path = fs.path.runeSubStr(0, fs.path.rfind(DirSep) )
        if fs.path == "": fs.path = $DirSep

        menu.currentNode.childs = @[]

        if isNil(menu.currentNode.parent):
            var newNode = newMenuNode(fs.path)
            newNode.value = filename(fs.path)

            fsNodeLoader(fs.path, newNode)

            menu.currentNode = newNode
            menu.rootNode = newNode
        else:
            menu.currentNode = menu.currentNode.parent

        TextBox(fs.app.activeWindow.controlls[0]).value= fs.path 
        TextBox(fs.app.activeWindow.controlls[2]).value= ""
        fs.filename = ""

    elif menuNode.customType == int(PathComponent.pcFile) or
        menuNode.customType == int(PathComponent.pcLinkToFile):
        TextBox(fs.app.activeWindow.controlls[2]).value= menuNode.value
        fs.filename = menuNode.value

    else:
        fs.path = fs.path & DirSep & menuNode.value
        fsNodeLoader(fs.path, menuNode)
        TextBox(fs.app.activeWindow.controlls[0]).value= fs.path
        fs.filename = ""
        
        #echo fs.path, "\n"



proc childUnLoader(menu: Menu, menuNode: MenuNode) =
    #echo "childUnLoader\nchildUnLoader\nchildUnLoader\nchildUnLoader\n"

    let fs = FileSelect(menu.prevActiveControll)
    fs.path = fs.path.runeSubStr(0, fs.path.rfind(DirSep))#(0, (fs.path.high - (menuNode.value.runeLen + 1)) )

    menuNode.childs = @[]

    TextBox(fs.app.activeWindow.controlls[0]).value= fs.path #menu.currentNode.parent.value
    TextBox(fs.app.activeWindow.controlls[2]).value= ""
    fs.filename = ""
    #[ var parent = menuNode.parent
    parent.childs.del(menuNode)
    GC_unref menuNode ]#



#-------------------------------------------------------------------------------







proc commit(this_elem: Controll)=
    ## path and filename are committed on the fly
    ## trigger change for text recalc
    trigger(Menu(this_elem.win.controlls[1]).prevActiveControll, "change")

    this_elem.app.activeTile.windows.del(this_elem.app.activeTile.windows.high)
    this_elem.app.activeWindow.draw()
    this_elem.app.activeControll = Menu(this_elem.win.controlls[1]).prevActiveControll



proc cancelClick(this_elem: Controll)=
    TextBox(this_elem.win.controlls[0]).cancel(this_elem.win.controlls[0])
    TextBox(this_elem.win.controlls[2]).cancel(this_elem.win.controlls[2])
    FileSelect(Menu(this_elem.win.controlls[1]).prevActiveControll).path = TextBox(this_elem.win.controlls[0]).val
    FileSelect(Menu(this_elem.win.controlls[1]).prevActiveControll).filename = TextBox(this_elem.win.controlls[2]).val

    Menu(this_elem.win.controlls[1]).prevActiveControll.cancel(Menu(this_elem.win.controlls[1]).prevActiveControll)


    this_elem.app.activeTile.windows.del(this_elem.app.activeTile.windows.high)
    this_elem.app.activeWindow.draw()
    this_elem.app.activeControll = Menu(this_elem.win.controlls[1]).prevActiveControll






proc onClick(this:Controll, event:KMEvent)=
    ## used @:
    ##  blur() = trigger(this, "change") =
    ##  chooser.app.activeControll.trigger("change")
    if not this.disabled:
        let fs = FileSelect(this)
        
        if event.btn > 0:
            fs.val = ""
            fs.preval = ""
            fs.path = getEnv("HOME")
            fs.filename = ""
            trigger(this, "change")


        else:

            fs.preval = fs.val

            var parentWin = fs.app.activeWindow
            var win = fs.app.activeTile.newWindow()
            var page = win.newPage()
            
            win.x1 = parentWin.x1
            win.y1 = parentWin.y1 + 1 # +1 cascade
            win.x2 = parentWin.x2
            win.y2 = parentWin.y2
            win.width = parentWin.width # win.x2 - win.x1
            win.heigth = win.y2 - win.y1
            
            #[ win.styles["window"].bgColor[2]=235
            win.styles["window"].bgColor[3] = int(packRGB(38,38,38)) ]#

            var styleNormal: StyleSheetRef = new StyleSheetRef
            styleNormal.deepcopy win.app.styles["dock"]
            win.styles["window"] = styleNormal    
            win.activeStyle = win.styles["window"]

            win.label = fs.label

            var pathTB = win.newTextBox("Path:", "100")
            pathTB.setMargin("all", 1)
            page.controlls.add(pathTB)
            pathTB.value = fs.path
            pathTB.preval = fs.path

            #var fileMenu : Menu
            var fileMenu = win.newInlineMenu( label = "Menu", width = win.width, heigth = (win.heigth - 8))
            fileMenu.recalc = fileMenuRecalc
            fileMenu.childLoader = ui_fileselect.childLoader
            fileMenu.childUnLoader = ui_fileselect.childUnLoader
            fileMenu.prevActiveControll = fs # this bond leads to path variable :)))
            fileMenu.rootNode.name = filename(fs.path)
            fileMenu.rootNode.value = filename(fs.path)
            fileMenu.cancel = cancelClick
            #page.controlls.add(fileMenu)
            #discard fileMenu.currentNode.addChild("test-", nil)
            #fileMenu.currentNode.name = fs.path #deprecated


            fsNodeLoader(fs.path, fileMenu.rootNode)


            var filenameTB = win.newTextBox("File:", "100")
            page.controlls.add(filenameTB)
            filenameTB.setMargin("all", 1)
            filenameTB.value = fs.filename
            filenameTB.preval = fs.filename

            
            let cancelBtn = win.newButton("cancel")
            cancelBtn.setMargin("left", 2)
            addEventListener(Controll(cancelBtn), "click", cancelClick)

            discard win.newColumnBreak()
            
            let okBtn = win.newButton("OK")
            okBtn.setMargin("left", 2)
            Controll(okBtn).addEventListener("click", commit)


            fs.app.redraw()
            #echo  win.pages[win.currentPage].controlls[0].activeStyle.bgColor[3]
            #fs.app.activeControll = fileMenu
            fs.app.activate(fileMenu)
            fs.preval = fs.val


# ⎡
# ⎢
# ⎣
proc fileSelectOnChange*(this: Controll)= # …✔✖ ⚯ ⚮ ⚭ ⚬ 🂱
    ## recalc .text

    FileSelect(this).text = FileSelect(this).filename
    FileSelect(this).val = FileSelect(this).path & DirSep & FileSelect(this).filename

    FileSelect(this).draw()
    #echo "CHANGE"




proc onKeyPress(this: Controll, event:KMEvent)=
    if not this.disabled:
        if event.evType == "CtrlKey":
            case event.ctrlKey:
                of 13:
                    this.onClick(this, event)
                else:
                    discard


proc newFileSelect*(win:Window, label: string, width:int=20): FileSelect =
    result = new FileSelect
    result.label=label
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
    result.addEventListener("change", fileSelectOnChange)
  
    var styleFocused: StyleSheetRef = new StyleSheetRef
    styleFocused.deepcopy win.app.styles["input:focus"]
    result.styles.add("input:focus",styleFocused)

    var styleDragged: StyleSheetRef = new StyleSheetRef
    styleDragged.deepCopy win.app.styles["input:drag"]
    result.styles.add("input:drag",styleDragged)

    result.drawit = drawit

    #result.options = new OptionListRef
    #result.options[] = @[]
    #result.options[].add((name:"☓" , value: "", selected:false))
    #result.chooser = newChooser(win,result.options, multiSelect)

    result.onClick = ui_fileselect.onClick
    result.onKeypress = onKeyPress
    result.focus = focus
    result.blur = blur
    result.cancel = ui_fileselect.cancel

    result.path = getEnv("HOME") #InitialDir # todo new....

    
    win.controlls.add(result)


proc newFileSelect*(win:Window, label: string, width:string): FileSelect =
    result = newFileSelect(win, label, width = 0)
    discard width.parseInt(result.width_value)


