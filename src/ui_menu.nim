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
        workSpace* : WorkSpace
        prevWorkSpace* : WorkSpace
        rootNode*, currentNode* : MenuNode
        prevActiveControll*:Controll
        prevCursorPos*: tuple[x,y:int]
        childLoader*:proc(menuNode: MenuNode) # use for loadnig childs on demand
        #app*:App
        #label*:string
        
        
#...............................................................................



proc recalc(this:Controll)=
    #[ this.x1 = this.app.availRect.x1 + this.activeStyle.padding.left + this.activeStyle.margin.left + this.borderWidth()

    this.y1 = this.app.availRect.y1 + 1 + this.activeStyle.padding.top + this.activeStyle.margin.top + this.borderWidth()

    this.x2 = this.app.availRect.x2 - this.activeStyle.padding.right - this.activeStyle.margin.right - this.borderWidth()

    this.y2 = this.app.availRect.y2 - this.activeStyle.padding.bottom - this.activeStyle.margin.bottom - this.borderWidth() ]#

    this.x1 = this.app.availRect.x1

    this.y1 = this.app.availRect.y1 #?+ 1

    this.x2 = this.app.availRect.x2

    this.y2 = this.app.availRect.y2

    #[ this.width = this.x2 - this.x1 #+ 1
    this.heigth = this.y2 - this.y1 #+ 1 ]#

    this.width = this.rightX - this.leftX - 
        this.activeStyle.padding.left - this.activeStyle.padding.right + 1

    this.heigth = this.bottomY - this.topY -
        this.activeStyle.padding.top - this.activeStyle.padding.bottom + 1





proc draw*(this: Menu, updateOnly:bool=false)=

    var
        currentLine: int
        currentY: int

    currentLine = this.currentNode.offset
    currentY = this.topY()


    block PRINT:
 
        while currentY <= this.bottomY() and currentLine <= this.currentNode.childs.high:
            #echo currentLine
            # todo: style: even,odd,highlight
            if this.currentNode.currentChild == currentLine and this.app.activeControll == this: #! todo
                setColors(this.app, this.styles["input:focus"])
                this.app.cursorPos.y = currentY #! patch for scroll issues
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

            #debug:
            #this.win.setTitle(this.currentNode.childs[this.currentNode.currentChild].name)
            #[ if this.currentNode.parent != nil:
                this.win.setTitle(this.currentNode.parent.name) ]#
            #this.win.setTitle(this.currentNode.name)


proc drawit(this: Controll, updateOnly:bool=false)=
    Menu(this).draw()

#...............................................................................







#...............................................................................

proc show*(this: Menu)=
    this.visible = true
    # SAVE STATE - maybe should create proc saveState(app) ?
    this.prevActiveControll = this.app.activeControll
    this.prevWorkSpace = this.app.activeWorkSpace
    this.prevCursorPos = this.app.cursorPos

    this.app.setActiveWorkSpace(this.workSpace)

    #this.app.recalc()
    #this.app.redraw()
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


proc cancel(this:Controll) = 
    Menu(this).hide()


proc focus(this: Controll) =
    discard

proc blur(this: Controll) = 
    discard
    #Menu(this).hide()

#...............................................................................

proc onPgUp(menu:Menu)=
    if menu.currentNode.offset > 0:
        if menu.currentNode.offset > menu.heigth:
            menu.currentNode.offset -= menu.heigth
            menu.currentNode.currentChild = menu.currentNode.offset #-= menu.heigth
        else:
            menu.currentNode.offset = 0
            menu.currentNode.currentChild = 0
        menu.draw(true)

proc onPgDown(menu:Menu)=
    if menu.currentNode.offset < menu.currentNode.childs.high - menu.heigth + 1:
        if menu.currentNode.offset + menu.heigth < menu.currentNode.childs.high - menu.heigth  + 1:
            menu.currentNode.offset += menu.heigth
            menu.currentNode.currentChild = menu.currentNode.offset #+= menu.heigth
        else:
            menu.currentNode.offset = menu.currentNode.childs.high - menu.heigth + 1
            menu.currentNode.currentChild = menu.currentNode.childs.high - menu.heigth + 1
    else: 
        menu.currentNode.offset = menu.currentNode.childs.high - menu.heigth + 1
        menu.currentNode.currentChild = menu.currentNode.childs.high

    menu.draw(true)

proc onScroll(this:Controll, event:KMEvent)= 

    case event.evType:
        of "ScrollUp":
            onPgUp(Menu(this))

        of "ScrollDown":
            onPgDown(Menu(this))

        else: discard
        

proc onKeyLeft(menu:Menu)=
    if menu.currentNode.parent != nil:
        menu.currentNode = menu.currentNode.parent

        var newTitle : string = ""
        var cursor = menu.currentNode #!.childs[menu.currentNode.currentChild]
        while cursor != menu.rootNode:
            newTitle = cursor.name & "\\" & newTitle
            cursor = cursor.parent

        if newTitle.runeLen <= menu.width - 6:
            menu.win.setTitle(newTitle)
        else:
            menu.win.setTitle("…" & newTitle.
                runeSubStr(newTitle.runeLen - (menu.width - 7)) )


        menu.draw(true)


proc onEnter(menu:Menu)=
    # if NO action and NO childs: load childs via childLoader()
    if menu.currentNode.childs[menu.currentNode.currentChild].action == nil and
        menu.currentNode.childs[menu.currentNode.currentChild].childs.len == 0:
            if menu.childLoader != nil:
                # todo: use id to load childs
                menu.childLoader(menu.currentNode.childs[menu.currentNode.currentChild])

    # if action and no childs: run action()
    elif menu.currentNode.childs[menu.currentNode.currentChild].action != nil :
        # and menu.currentNode.childs[menu.currentNode.currentChild].childs.len > 0
        menu.hide()
        menu.currentNode.childs[menu.currentNode.currentChild].action()

    # if NO action and childs LOADED: 
    elif menu.currentNode.childs[menu.currentNode.currentChild].action == nil and
        menu.currentNode.childs[menu.currentNode.currentChild].childs.len > 0:
            var newTitle : string = ""
            var cursor = menu.currentNode.childs[menu.currentNode.currentChild]
            while cursor != menu.rootNode:
                newTitle = cursor.name & "\\" & newTitle
                cursor = cursor.parent

            if newTitle.runeLen <= menu.width - 6:
                menu.win.setTitle(newTitle)
            else:
                menu.win.setTitle("…" & newTitle.
                    runeSubStr(newTitle.runeLen - (menu.width - 7)) )
            
            menu.currentNode = menu.currentNode.childs[menu.currentNode.currentChild]

            menu.app.draw()

    
proc onKeypress(this:Controll, event:KMEvent)=

    let menu = Menu(this)

    if not this.disabled:
        #let menu = Menu(this)

        if event.evType == "FnKey": #.....FnKey.....FnKey.....FnKey.....FnKey...
            case event.key:

                of KeyLeft:
                    onKeyLeft(menu)
                    #[ if menu.currentNode.parent != nil:
                        menu.currentNode = menu.currentNode.parent

                        var newTitle : string = ""
                        var cursor = menu.currentNode #!.childs[menu.currentNode.currentChild]
                        while cursor != menu.rootNode:
                            newTitle = cursor.name & "\\" & newTitle
                            cursor = cursor.parent
        
                        if newTitle.runeLen <= this.width - 6:
                            menu.win.setTitle(newTitle)
                        else:
                            menu.win.setTitle("…" & newTitle.
                                runeSubStr(newTitle.runeLen - (this.width - 7)) )


                        menu.draw(true) ]#

                of KeyRight: onEnter(menu)


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

                of KeyPgUp:
                    onPgUp(Menu(this))

                of KeyPgDown:
                    onPgDown(Menu(this))

                else: discard

        elif event.evType == "CtrlKey":
            case event.ctrlKey:
                of 13: # ENTER, ctrl+M
                    onEnter(menu)

                else: discard
    



proc onClick(this:Controll, event:KMEvent)=
    let menu = Menu(this)
    if event.btn == 0:
        # get selected:
        if event.y <= menu.bottomY and event.y >= menu.topY and event.x <= menu.rightX and event.x >= menu.leftX:
            menu.currentNode.currentChild = menu.currentNode.offset + (event.y - menu.topY)
            menu.onEnter()
            #menu.draw(true)
    else:
        if menu.currentNode.parent != nil:
            onKeyLeft(menu)
        else:
            menu.hide()
                
                
                
#...............................................................................


proc addChild*(parent: MenuNode, 
        name: string,
        action: proc():void): MenuNode =
    
    var newNode = new MenuNode
    newNode.action = action
    newNode.name = name
    newNode.parent = parent
    newNode.childs = @[]
    parent.childs.add(newNode)
    return newNode
    #newNode = MenuNode(name: name, action: action, childs: @[], parent: parent)
    #parent.childs.add( MenuNode(name: name, action: action, childs: @[], parent: parent) )



proc newMenuNode*(name: string = "menu item"): MenuNode =
    result = new MenuNode
    result.name = name
    result.childs = @[]



proc newMenu*(app:App, label:string="Menu"): Menu =
    result = new Menu
    result.app = app
    result.label = label
    result.rootNode = newMenuNode("ROOT") #MenuNode(name : "ROOT")
    result.currentNode = result.rootNode
    result.prevWorkSpace = nil #...
    result.visible = true
    #result.width = 10
    #result.heigth = 10

    result.workSpace = result.app.newWorkSpace(result.label)
    discard result.workSpace.newTile("100%")

    result.win = result.workSpace.tiles[0].newWindow(result.label)
    var styleDock: StyleSheetRef = new StyleSheetRef
    styleDock.deepcopy app.styles["dock"]
    result.win.styles.add("dock", styleDock)
    result.win.activeStyle = result.win.styles["dock"]
    result.win.onClick = proc(c:Controll, e:KMEvent)= Menu(Window(c).controlls[0]).hide()
    
    discard result.workSpace.tiles[0].windows[0].newPage()
    result.workSpace.tiles[0].windows[0].controlls.add(result)
    result.workSpace.tiles[0].windows[0].pages[0].controlls.add(result)


    result.styles = newStyleSheets()

    var styleNormal: StyleSheetRef = new StyleSheetRef
    styleNormal.deepcopy app.styles["input"]
    styleNormal.border="none"
    #styleNormal.setTextStyle("styleUnderline") #! disabled because border draw
    result.styles.add("input",styleNormal)
    result.activeStyle = result.styles["input"]

    var styleEven: StyleSheetRef = new StyleSheetRef
    styleEven.deepcopy app.styles["input:even_dark"]
    #styleEven.setTextStyle("styleUnderline") #!
    result.styles.add("input:even",styleEven)

    var styleOdd: StyleSheetRef = new StyleSheetRef
    styleOdd.deepcopy app.styles["input:odd_dark"]
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