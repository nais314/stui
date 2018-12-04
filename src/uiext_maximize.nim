include "controll.inc.nim"


type
    MaximizableControll* = ref object of Controll
        prev_win*: Window
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
    this.win = this.prev_win

    this.isMaximized = false

    this.app.activeTile.windows.del(this.app.activeTile.windows.high)
    #this.app.activeWindow.draw()
    this.app.redraw()

proc maximize*(this: MaximizableControll)=
    ## maximize a maximization-enabled Controll
    ## code xtracted from ui_fileselect

    ## create new window in current tile:
    #var parentWin = this.app.activeWindow
    this.prev_win = this.win
    this.win = this.app.activeTile.newWindow()
    #var page = this.win.newPage()

    this.win.x1 = this.prev_win.x1
    this.win.y1 = this.prev_win.y1 + 1 # +1 cascade
    this.win.x2 = this.prev_win.x2
    this.win.y2 = this.prev_win.y2
    this.win.width = this.prev_win.width
    this.win.heigth = this.win.y2 - this.win.y1

    var styleNormal: StyleSheetRef = new StyleSheetRef
    styleNormal.deepcopy this.win.app.styles["dock"]
    this.win.styles["window"] = styleNormal
    this.win.activeStyle = this.win.styles["window"]

    this.win.label = this.label
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
    this.win.controlls.add(this)


    this.win.addEventListener("menu", proc(c:Controll) = unMaximize(this))


    this.app.redraw()
    #this.visible = true
    #this.drawit(this,false)
    #this.app.activate(this)
