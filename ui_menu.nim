include "controll.inc.nim"


type
    MenuNode* = ref object of TTUI
        name*: string
        action*: proc():void
        parent*: MenuNode
        childs*: seq[MenuNode]
        currentChild*:int # cursor item
        offset*:int # num-lines scrolled down

    Menu* = ref object of Controll
        #windows*:seq[Window]
        workSpace* : WorkSpace
        prevWorkSpace* : WorkSpace
        rootNode*, currentNode* : MenuNode
        prevActiveControll*:Controll
        prevCursorPos*: tuple[x,y:int] 
        #app*:App
        #label*:string
        
        
#...............................................................................



proc recalc(this:Controll)=
    this.x1 = this.app.availRect.x1 + this.activeStyle.padding.left
    this.y1 = this.app.availRect.y1 + 1 + this.activeStyle.padding.top
    this.x2 = this.app.availRect.x2 - this.activeStyle.padding.right
    this.y2 = this.app.availRect.y2 - this.activeStyle.padding.bottom
    this.width = this.x2 - this.x1 + 1
    this.heigth = this.y2 - this.y1 + 1




proc draw*(this: Menu, updateOnly:bool=false)=

    var
        currentLine: int
        currentY: int

    currentLine = this.currentNode.offset
    currentY = this.topY()

    #[ echo " DRAWW ", currentY, " - ", this.bottomY, "\n",
        currentLine, " / ", this.currentNode.childs.high

    echo this.currentNode.childs.len ]#
    #discard stdin.readLine()

    #[ echo this.app.availRect.x1, " x1\n ",
        this.app.availRect.y1, " y1\n ",
        this.app.availRect.x2, " x2\n ",
        this.app.availRect.y2, " y2\n "

    echo this.x1, " x1\n ",
        this.y1 + 1," y1\n ",
        this.x2, " x2\n ",
        this.y2, " y2\n " ]#

    block PRINT:
 
        while currentY <= this.bottomY() and currentLine <= this.currentNode.childs.high:
            #echo currentLine
            # todo: style: even,odd,highlight
            if this.currentNode.currentChild == currentLine and this.app.activeControll == this: #! todo
                setColors(this.app, this.styles["input:focus"])
                this.app.cursorPos.y = currentY # patch for scroll issues
            elif currentLine mod 2 == 0:
                setColors(this.app, this.styles["input:even"])
            else:
                setColors(this.app, this.styles["input:odd"])

            setCursorPos(this.leftX, currentY )

            if this.currentNode.childs[currentLine].name.runeLen() == this.width:
                stdout.write(this.currentNode.childs[currentLine].name)
            elif this.currentNode.childs[currentLine].name.runeLen() <= this.width:
                stdout.write(this.currentNode.childs[currentLine].name)
                stdout.write " " * (this.width - this.currentNode.childs[currentLine].name.runeLen())
            else:
                stdout.write this.currentNode.childs[currentLine].name.runeSubStr(0,this.width)

            currentLine += 1
            currentY += 1


proc drawit*(this: Controll, updateOnly:bool=false)=
    Menu(this).draw()

#...............................................................................







#...............................................................................

proc show*(this: Menu)=
    # SAVE STATE - maybe should create proc saveState(app) ?
    this.prevActiveControll = this.app.activeControll
    this.prevWorkSpace = this.app.activeWorkSpace
    this.prevCursorPos = this.app.cursorPos

    # create new WS for menu ...
    this.workSpace = this.app.newWorkSpace()
    this.app.activeWorkSpace = this.workSpace
    discard this.workSpace.newTile("100%")
    
    discard this.workSpace.tiles[0].newWindow(this.label)
    this.workSpace.tiles[0].windows[0].setMargin("all",1)
    this.workSpace.tiles[0].windows[0].controlls.add(this)
    discard this.workSpace.tiles[0].windows[0].newPage()
    this.workSpace.tiles[0].windows[0].pages[0].controlls.add(this)
    # ...

    #this.app.activeControll = this

    hideCursor()

    this.app.redraw()
    this.app.activate(this)


proc hide*(this: Menu)=
    ## hide menu
    ## RESTORE APP STATE 
    #? maybe should create proc restoreState(app) ?
    this.app.activeWorkSpace = this.prevWorkSpace
    this.app.workSpaces.del(this.app.workSpaces.high)
    this.app.cursorPos = this.prevCursorPos
    this.app.activeControll = this.prevActiveControll

    this.app.draw()


proc cancel(this:Controll) = Menu(this).hide()


proc focus(this: Controll) = discard
    #Menu(this).show()

proc blur(this: Controll) = discard
    #Menu(this).hide()

#...............................................................................

proc onClick(this:Controll, event:KMEvent)=
    let menu = Menu(this)
    echo "CLICK"



proc onKeypress(this:Controll, event:KMEvent)=
    if not this.disabled:
        let menu = Menu(this)

        if event.evType == "FnKey": #.....FnKey.....FnKey.....FnKey.....FnKey...
            case event.key:
                of KeyDown:
                    if menu.currentNode.currentChild < menu.currentNode.childs.high:
                        menu.currentNode.currentChild += 1
                
                        if menu.app.cursorPos.y < menu.bottomY():
                            menu.app.cursorPos.y += 1
                
                        elif (menu.currentNode.offset + 
                                ((menu.bottomY() - menu.topY()) - 1)) < menu.currentNode.childs.high : # -1 label
                            menu.currentNode.offset += 1

                        menu.draw(true)

                of KeyUP:
                    if menu.currentNode.currentChild > 0 :
                        menu.currentNode.currentChild -= 1
                
                        if menu.app.cursorPos.y > menu.topY():
                            menu.app.cursorPos.y -= 1
                
                        else:
                            menu.currentNode.offset -= 1
                            
                        menu.draw(true)

                of KeyEnd:
                    if menu.currentNode.childs.high > (menu.heigth): # -1 label
                        menu.currentNode.offset = menu.currentNode.childs.high - (menu.heigth) + 1 # +1 next row
                    menu.currentNode.currentChild = menu.currentNode.childs.high

                    this.app.cursorPos.y = if menu.currentNode.childs.high > (menu.heigth) : 
                        menu.bottomY() else : menu.topY() + menu.currentNode.childs.high + 1 #+1 label

                    menu.draw(true)

                of KeyHome:
                    menu.currentNode.offset = 0
                    menu.currentNode.currentChild = 0
                    menu.app.cursorPos.y = this.topY
                    menu.draw(true)

                else: discard

        elif event.evType == "CtrlKey":
            case event.ctrlKey:
                of 13: # ENTER, ctrl+M
                    discard

                else: discard
    
proc onScroll(this:Controll, event:KMEvent)= discard
    #[ case event.evType:
        of "ScrollUp": TextArea(this).onPgUp()
        of "ScrollDown": TextArea(this).onPgDown()
        else: discard ]#
        
#...............................................................................


proc addChild*(parent: MenuNode, 
        name: string,
        action: proc():void) =
    
    #var newNode: MenuNode
    #newNode = MenuNode(name: name, action: action, childs: @[], parent: parent)
    parent.childs.add( MenuNode(name: name, action: action, childs: @[], parent: parent) )



proc newMenuNode*(name: string = "menu item"): MenuNode =
    result = new MenuNode
    result.childs = @[]



proc newMenu*(app:App, label:string="Menu"): Menu =
    result = new Menu
    result.app = app
    result.label = label
    result.rootNode = newMenuNode("ROOT") #MenuNode(name : "ROOT")
    result.currentNode = result.rootNode
    result.prevWorkSpace = nil #...


    result.styles = newStyleSheets()

    var styleNormal: StyleSheetRef = new StyleSheetRef
    styleNormal.deepcopy app.styles["input"]
    styleNormal.border="none"
    #styleNormal.setTextStyle("styleUnderline") #! disabled because border draw
    result.styles.add("input",styleNormal)
    result.activeStyle = result.styles["input"]

    var styleEven: StyleSheetRef = new StyleSheetRef
    styleEven.deepcopy app.styles["input:even"]
    #styleEven.setTextStyle("styleUnderline") #!
    result.styles.add("input:even",styleEven)

    var styleOdd: StyleSheetRef = new StyleSheetRef
    styleOdd.deepcopy app.styles["input:odd"]
    #styleOdd.setTextStyle("styleUnderline") #!
    result.styles.add("input:odd",styleOdd)


    var styleFocused: StyleSheetRef = new StyleSheetRef
    styleFocused.deepcopy app.styles["input:focus"]
    #styleFocused.setTextStyle("styleUnderline") #! disabled because border draw
    result.styles.add("input:focus",styleFocused)

    var styleDragged: StyleSheetRef = new StyleSheetRef
    styleDragged.deepCopy app.styles["input:drag"]
    #styleDragged.setTextStyle("styleUnderline") #!
    result.styles.add("input:drag",styleDragged)

    #???
    var styleDisabled: StyleSheetRef = new StyleSheetRef
    styleDisabled.deepcopy app.styles["input:disabled"]
    #styleDisabled.setTextStyle("styleUnderline") #!
    result.styles.add("input:disabled", styleDisabled)

    result.drawit = drawit
    result.blur = blur
    result.focus = focus
    result.onClick = onClick
    #result.onDrag = onDrag
    #result.onDrop = onDrop
    result.cancel = cancel
    result.onKeypress = onKeyPress
    result.onScroll = onScroll
    result.recalc = recalc

    #result.app = app
    #result.win = win
    #result.listeners = @[]

    #controlls.add(result)