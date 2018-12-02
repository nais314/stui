include "controll.inc.nim"


type
    MaximizableControll* = ref object of Controll
        prev_x1*,prev_y1*,prev_x2*,prev_y2*, prev_width*,prev_heigth*:int # incl margins & borders!

        prev_width_unit*: string # used (by Tile) to store width unit: %, auto, ch(aracter)
        prev_width_value*:int # used (by Tile) for responsive width calc
        #heigth_unit*: string #? heigth unit is percent.
        prev_heigth_value*: int # stores % value in int 0-100
        prev_recalc*:       proc(this_elem: Controll):void # if not nil called by Window.recalc()

        prev_visible*:    bool # if `value=` fires draw(), decide if not to draw - Window.draw()

        isMaximized*: bool # if not maximized, draw label, else why do it?


proc unMaximize*(this:MaximizableControll):void=
    this.x1 = this.prev_x1
    this.x2 = this.prev_x2
    this.y1 = this.prev_y1
    this.y2 = this.prev_y2
    this.width = this.prev_width
    this.heigth = this.prev_heigth
    this.width_unit = this.prev_width_unit
    this.width_value = this.prev_width_value
    this.heigth_value = this.prev_heigth_value
    this.recalc = this.prev_recalc
    this.visible = this.prev_visible
    this.width_value = this.prev_width_value
    this.heigth_value = this.prev_heigth_value

    this.isMaximized = false

    this.app.activeTile.windows.del(this.app.activeTile.windows.high)
    #this.app.activeWindow.draw()
    this.app.redraw()

proc maximize*(this: MaximizableControll)=
    ## maximize a maximization-enabled Controll
    ## code xtracted from ui_fileselect

    ## create new window in current tile:
    var parentWin = this.app.activeWindow
    var win = this.app.activeTile.newWindow()
    #var page = win.newPage()

    win.x1 = parentWin.x1
    win.y1 = parentWin.y1 + 1 # +1 cascade
    win.x2 = parentWin.x2
    win.y2 = parentWin.y2
    win.width = parentWin.width
    win.heigth = win.y2 - win.y1

    var styleNormal: StyleSheetRef = new StyleSheetRef
    styleNormal.deepcopy win.app.styles["dock"]
    win.styles["window"] = styleNormal
    win.activeStyle = win.styles["window"]

    win.label = this.label
    this.isMaximized = true

    #.................................................

    #prepare
    this.prev_x1 = this.x1
    this.prev_x2 = this.x2
    this.prev_y1 = this.y1
    this.prev_y2 = this.y2
    this.prev_width = this.width
    this.prev_heigth = this.heigth
    this.prev_width_unit = this.width_unit
    this.prev_width_value = this.width_value
    this.prev_heigth_value = this.heigth_value
    this.prev_recalc = this.recalc
    this.recalc = nil
    this.prev_visible = this.visible
    #this.visible = true

    this.width_value = 100
    this.heigth_value = 100


    ## add controlls
    win.controlls.add(this)


    win.addEventListener("menu", proc(c:Controll) = unMaximize(this))


    this.app.redraw()
    #this.visible = true
    #this.drawit(this,false)
    #this.app.activate(this)
