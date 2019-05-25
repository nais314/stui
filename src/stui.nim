# stui
# Copyright István Nagy
# Simplified Terminal UI for ANSI terminals
#[
  Default Keyboard Shortcuts:
    F2: menu TODO
    F5: refresh screen
    F9: menu TODO
    F10: quit app

    TAB: - add focus to next gui Controll;
       - commit changes to Controll (pe:TextArea)

    ESC and ESC again: cancel editing, quit app

    PgUP/PgDown: on Window -> change Page; on TextArea: "scroll"

  Mouse:
    Wheel "Scrolls": Window->Page; TextArea
]#

#[
  Requires: Deja-Vu or other Font with good range of unicode character support (nerd fonts?)
]#

#[
  NEXT-NEXT:
    main loop poll consumes cpu

    TimedAction needs to be revised to be paralell

    force colorMode - xterm reports 8! but true color seems supported...

    multi-app support
]#


import unicode, terminal, colors, stui/[colors256, colors_extra, terminal_extra]
import os, osproc, locks, threadpool
import parseutils, parsecfg, strutils, strformat, unicode
import tables
import random, times

import stui/appbase/appbasetypes #! the new base types coming from






const
  KeyUp* = "[A"
  KeyDown* = "[B"
  KeyRight* = "[C"
  KeyLeft* = "[D"
  KeyEnd* = "[F"
  KeyHome* = "[H"
  KeyIns* = "[2~"
  KeyDel* = "[3~"
  KeyPgUp* = "[5~"
  KeyPgDown* = "[6~"
  KeyF1* = "OP"
  KeyF2* = "OQ"
  KeyF3* = "OR"
  KeyF4* = "OS"
  KeyF5* = "[15~"
  KeyF6* = "[17~"
  KeyF7* = "[18~"
  KeyF8* = "[19~"
  KeyF9* = "[20~"
  KeyF10* = "[21~"
  KeyF11* = "[23~"
  KeyF12* = "[24~"
  KeyApps* = "[29~"
  KeyWin* = "[34~"

  Ctrl2* = 0
  CtrlA* = 1
  CtrlB* = 2
  CtrlC* = 3
  CtrlD* = 4
  CtrlE* = 5
  CtrlF* = 6
  CtrlG* = 7
  CtrlH* = 8
  CtrlI* = 9
  CtrlJ* = 10
  CtrlK* = 11
  CtrlL* = 12
  CtrlM* = 13
  CtrlN* = 14
  CtrlO* = 15
  CtrlP* = 16
  CtrlQ* = 17
  CtrlR* = 18
  CtrlS* = 19
  CtrlT* = 20
  CtrlU* = 21
  CtrlV* = 22
  CtrlW* = 23
  CtrlX* = 24
  CtrlY* = 25
  CtrlZ* = 26
  Ctrl3* = 27
  Ctrl5* = 28
  Ctrl6* = 29
  Ctrl7* = 30










type
  StyleColor* = array[0..3, int]
  ## 0: 8color
  ## 1: 16color int(terminal.fgBlue)
  ## 2: 256 color int(colors256.Blue)
  ## 3: RGB int(colors.colBlue)or(colors_extras.PackedRGB)
  StyleSheet* = tuple[
    fgColor: StyleColor,
    bgColor: StyleColor,
    padding: tuple[left,top,right,bottom:int],
    margin: tuple[left,top,right,bottom:int],
    border: string,
    textStyle: set[terminal.Style]  ]

  StyleSheetRef* = ref StyleSheet
  StyleSheets* = TableRef[string, StyleSheetRef]

  CursorStyle* = enum
    blinkingBlock = 1,
    steadyBlock,
    blinkingUnderline,
    steadyUnderline

#............................

  Rect* = tuple
    x1,y1,x2,y2:int


  TTUI* = ref object of RootObj
    id*:string
    genericType*: string

#............................

  KMEventKind* {.pure.} = enum
    Click, Release, 
    LongClick,
    Drag, Drop,
    ScrollUp, ScrollDown,
    DoubleClick,

    FnKey,CtrlKey,Char,

    Exit

  Event* = ref object of RootObj

  KMEvent* = ref object of Event
    btn*, x*, y*: int
    c*: char
    source*, target*: Controll
    evType*: KMEventKind # FnKey, CtrlKey, Char - Custom

    key*: string # esc sequence or Rune - or Custom
    ctrlKey*: int


  Option = tuple[name, value:string, selected:bool]
  OptionList* = seq[Option]
  OptionListRef* = ref OptionList


  Listener = tuple[name:string, actions: seq[proc(source:Controll):void]]
  #Listener[T] = tuple[name:string, actions: seq[proc(source:T):void]]
  ListenerList = seq[Listener]

  Controll* = ref object of TTUI
    label*:string # displayed above controll
    x1*,y1*,x2*,y2*, width*,heigth*:int # incl margins & borders!

    width_unit*: string # used (by Tile) to store width unit: %, auto, ch(aracter)
    width_value*: int # used (by Tile) for responsive width calc
    #heigth_unit*: string #? heigth unit is percent.
    heigth_value*: int # stores % value in int 0-100
    recalc*: proc(this_elem: Controll):void # if not nil called by Window.recalc()

    visible*: bool # if `value=` fires draw(), decide if not to draw - Window.draw()
    disabled*: bool # only copy, no events

    onClick*: proc(this_elem: Controll, event: KMEvent):void
    onDoubleClick*: proc(this_elem: Controll, event: KMEvent):void
    onRelease*: proc(this_elem: Controll, event: KMEvent):void
    onScroll*: proc(this_elem: Controll, event: KMEvent):void
    onDrag*: proc(this_elem: Controll, event: KMEvent):void # set style
    onDrop*: proc(this_elem: Controll, event: KMEvent):void
    onKeypress*: proc(this_elem: Controll, event: KMEvent):void

    focus*: proc(this_elem: Controll):void # set style, no redraw
    blur*: proc(this_elem: Controll):void # set style, no redraw, trigger("change")
    cancel*: proc(this_elem: Controll):void # undo - preval, blur
    drawit*: proc(this_elem: Controll, updateOnly: bool):void # for focus, Cast(this).draw()
                         #updateOnly: bool = cache, and reduces flicker

    listeners*: ListenerList  # p.e.: add validation here via "change" event

    app*: App
    win*: Window
    styles*: StyleSheets   # TableRef[string, StyleSheetRef]
    activeStyle*: StyleSheetRef # for draw()
    prevStyle*: StyleSheetRef # for focus()/blur() not for drag!

    tabStop*: int

#............................


  Page* = ref object of Controll
    controlls*: seq[Controll]

  Window* = ref object of Controll
    tile*: Controll

    pages*: seq[Page]
    controlls*: seq[Controll]
    currentPage*: int

    fullScreen*: bool

  Tile* = ref object of Controll
    windows*: seq[Window]


  WorkSpace* = ref object of TTUI
    tiles*: seq[Tile]
    app: App
    #name*:string #?
    draw*: proc():void #todo app draw if not nil draw else as usual


  #App:------------------------------
  #TimedAction* = tuple[name:string,interval:float,action:proc():void,lastrun:float] # epochTime:float
  App* = ref object of AppBase
    colorMode*: int
    terminalWidth*: int
    terminalHeight*: int

    styles*: StyleSheets
    activeStyle*: StyleSheetRef

    workSpaces*: seq[WorkSpace]
    widgets*: seq[Controll] # TODO fixed controlls
    availRect*: Rect #terminal - widgets
    overlay*: Tile

    activeWorkSpace*: WorkSpace
    activeTile*: Tile
    activeControll*: Controll
    #currentPage*: proc
    #activeWindow*: proc

    #visibleControlls*: seq[Controll]

    dragSource*: Controll

    cursorPos*: tuple[x,y:int] # widgets will use it as storage - one variable fits all

    onKeypress*: proc(app:App, event: KMEvent):bool # bool needed, if no success, try controlls proc

    termlock*: Lock

    #listeners*: seq[tuple[name:string, actions: seq[proc():void]]]
    #timers*: seq[TimedAction] #seq[tuple[name:string,interval:float,action:proc()]]

    itc*: ptr Channel[string] # TODO inter thread comm to app




  PageBreak* = ref object of Controll
  ColumnBreak* = ref object of Controll








######   ####  #    # #####  #####   ####  #####  #####    ###### #    # #    #
######  #      #    # #    # #    # #    # #    #   #      #      #    # ##   #
######   ####  #    # #    # #    # #    # #    #   #      #####  #    # # #  #
######       # #    # #####  #####  #    # #####    #      #      #    # #  # #
######  #    # #    # #      #      #    # #   #    #      #      #    # #   ##
######   ####   ####  #      #       ####  #    #   #      #       ####  #    #

proc trigger*(controll:Controll, evtname:string ) #!FWD

#! import random
proc genId*(length: int = 5):string=
  ## may used for object unique id generation
  randomize()
  var
    A = ['A','B','C','D','E','F','G','H',
         'I','J','K','L','M','N','O','P','Q','R','S','W','V','Z','Y']

  result = $rand(A)
  while result.len < length:
    result &= $rand(9)

  # todo: append milli or nanosecond

#---------------------------------------------

# extrafun.nim :
proc `*`*(s:string, i:int):string=
  result = ""
  for a in 0..i-1:
    result = result & s

template tryit*(fun: untyped)=
    try:
      fun
    except:
      let
        e = getCurrentException()
        msg = getCurrentExceptionMsg()
      echo "Got exception ", repr(e), " with message ", msg
      discard stdin.readLine()

proc del*[T](x: var seq[T], y: T) =
  for i in 0..x.high:
    if x[i] == y:
      x.del(i)

proc is_odd*(x:int): bool = return if (x and 1) == 1: true else: false

template is_even*(x:int): bool =
  return not is_odd(x)

#---------------------------------------------
###        ######  ######## ##    ## ##       ########
###       ##    ##    ##     ##  ##  ##       ##
###       ##          ##      ####   ##       ##
###        ######     ##       ##    ##       ######
###             ##    ##       ##    ##       ##
###       ##    ##    ##       ##    ##       ##
###        ######     ##       ##    ######## ########
###
###
###         ######   #######  ##        #######  ########
###       ##    ## ##     ## ##       ##     ## ##     ##
###       ##       ##     ## ##       ##     ## ##     ##
###       ##       ##     ## ##       ##     ## ########
###       ##       ##     ## ##       ##     ## ##   ##
###       ##    ## ##     ## ##       ##     ## ##    ##
###        ######   #######  ########  #######  ##     ##


#moved to terminal_extra
#[ proc getColorMode*(): int =
    var str = getEnv("COLORTERM") #$execProcess("printenv COLORTERM")
    if str notin ["truecolor", "24bit"]:
        str = $execProcess("tput colors")

        case str:
            of   "8\n": result = 0
            of  "16\n": result = 1
            of "256\n": result = 2
            else: result = 1
    else:
        result = 3
 ]#

#[ #! DEPRECATED
proc resetColors*()=
    stdout.write "\e[0m" ]#


proc setForegroundColor*(app:App, style:StyleSheetRef)=
  #? should be in colors_extra, but that is more generic, and should be (?)
  case app.colorMode:
    of 0,1:
      colors_extra.setForegroundColor(Color16(style.fgColor[app.colorMode]))
    of 2:
      colors_extra.setForegroundColor(Color256(style.fgColor[app.colorMode]))
    of 3:
      colors_extra.setForegroundColor(PackedRGB(style.fgColor[3]))
    else: discard
  if style.textStyle.card() > 0:
    terminal.setStyle(stdout, style.textStyle)

# set uotput colors during Draw proc
proc setColors*(app:App, style:StyleSheet) =
  stdout.write "\e[0m"
  case app.colorMode:
    of 0,1:
      colors_extra.setBackgroundColor(Color16(style.bgColor[app.colorMode]))
      colors_extra.setForegroundColor(Color16(style.fgColor[app.colorMode]))
    of 2:
      colors_extra.setBackgroundColor(Color256(style.bgColor[app.colorMode]))
      colors_extra.setForegroundColor(Color256(style.fgColor[app.colorMode]))
    of 3:
      colors_extra.setBackgroundColor(PackedRGB(style.bgColor[3]))
      colors_extra.setForegroundColor(PackedRGB(style.fgColor[3]))
    else: discard
  if style.textStyle.card() > 0:
    terminal.setStyle(stdout, style.textStyle)

proc setColors*(app:App, style:StyleSheetRef)=setColors(app, style[])

proc setColors*(colorMode:int, style:StyleSheet) =
  stdout.write "\e[0m"
  case colorMode:
    of 0,1:
      colors_extra.setBackgroundColor(Color16(style.bgColor[colorMode]))
      colors_extra.setForegroundColor(Color16(style.fgColor[colorMode]))
    of 2:
      colors_extra.setBackgroundColor(Color256(style.bgColor[colorMode]))
      colors_extra.setForegroundColor(Color256(style.fgColor[colorMode]))
    of 3:
      colors_extra.setBackgroundColor(PackedRGB(style.bgColor[colorMode]))
      colors_extra.setForegroundColor(PackedRGB(style.fgColor[colorMode]))
    else: discard

#...................................


proc changeFGColor*(this: Controll, stylename: string, colors: StyleColor)=
  this.styles[stylename].fgColor = colors

proc changeFGColor*(this: Controll, stylename: string, colorname: string) =
  # TODO: 8/16 colors test
  for iCM in 0..1:    
    this.styles[stylename].fgColor[iCM] = colors_extra.parseColor("fg" & colorname, iCM)
  for iCM in 2..3:    
    this.styles[stylename].fgColor[iCM] = colors_extra.parseColor(colorname, iCM)


proc changeBGColor*(this: Controll, stylename: string, colors: StyleColor)=
  this.styles[stylename].bgColor = colors

proc changeBGColor*(this: Controll, stylename: string, colorname: string) =
  # TODO: 8/16 colors test
  for iCM in 0..1:    
    this.styles[stylename].bgColor[iCM] = colors_extra.parseColor("bg" & colorname, iCM)
  for iCM in 2..3:    
    this.styles[stylename].bgColor[iCM] = colors_extra.parseColor(colorname, iCM)


proc copyColorsFrom*(this, style: StyleSheetRef)=
  this.fgColor = style.fgColor
  this.bgColor = style.bgColor

proc swapFGBGColors*(style: StyleSheetRef)=
  var styleBuffer: StyleSheetRef = new StyleSheetRef

  styleBuffer.deepcopy style

  style.fgColor = style.bgColor

  # 8colors mode needs special care
  if style.fgColor[0] > 39:
    if style.fgColor[0] > 99:
      style.fgColor[0] -= (60 + 10)
    else:
      style.fgColor[0] -= 10

  if style.fgColor[1] > 39:
    if style.fgColor[1] > 99:
      style.fgColor[1] -= (60 + 10)
    else:
      style.fgColor[1] -= 10

  style.bgColor = styleBuffer.fgColor

  style.bgColor[0] += 10 # simpler than fgColor :)
  style.bgColor[1] += 10

#---------------------------------------------


proc setTextStyle*(style: StyleSheetRef, textStyleStr: string)=
  case textStyleStr:
    of "": discard
    of "styleBright", "styleBold": style.textStyle.incl(styleBright)
    of "styleDim": style.textStyle.incl(styleDim)
    of "styleUnknown", "styleItalic", "styleStandout": style.textStyle.incl(styleItalic)
    of "styleUnderscore", "styleUnderline": style.textStyle.incl(styleUnderscore)
    of "styleBlink": style.textStyle.incl(styleBlink)
    of "styleReverse", "styleInverse": style.textStyle.incl(styleReverse)
    of "styleHidden": style.textStyle.incl(styleHidden)


proc toggleBlink*(this:Controll, styleName:string="input")=
  if this.styles[styleName].textStyle.contains(styleBlink):
    this.styles[styleName].textStyle.excl(styleBlink)
  else:
    this.styles[styleName].textStyle.incl(styleBlink)

#---------------------------------------------

#[ #[  CursorStyle* = enum
    blinkingBlock = 1,
    steadyBlock,
    blinkingUnderline,
    steadyUnderline ]#
proc setCursorStyle*(Ps: CursorStyle)=
  stdout.write("\e[" & $int(Ps) & " q")
proc setCursorStyle*(Ps: int)=
  stdout.write("\e[" & $Ps & " q") ]#


#________________________________________________________________



proc newStyleSheets*(): StyleSheets =
  ## init controlls stylesheets
  newTable[string, StyleSheetRef](8)


proc styleSheetRef_fromConfig*(config: Config, section: string): StyleSheetRef =
  ## supports newApp. reads values from opened Config
  result = new StyleSheetRef
  var value: string

  # background
  value = config.getSectionValue(section,"bgColor16")
  if value.len < 3:
    discard parseInt(value, result.bgColor[0])
  else:
    result.bgColor[0] = colors_extra.parseColor(value, 0) #colorNames16[ searchColorTable(colorNames16, value) ][1]

  value = config.getSectionValue(section,"bgColor16")
  if value.len < 3:
    discard parseInt(value, result.bgColor[1])
    if result.bgColor[1] >= 90:
      result.bgColor[1] -= 60
      result.setTextStyle("styleBright")
  else:
    result.bgColor[1] = colors_extra.parseColor(value, 1) #colorNames16[ searchColorTable(colorNames16, value) ][1]
    if result.bgColor[1] >= 90:
      result.bgColor[1] -= 60
      result.setTextStyle("styleBright")

  value = config.getSectionValue(section,"bgColor256")
  if value.len < 4:
    discard parseInt(value, result.bgColor[2])
  else:
    result.bgColor[2] = colors_extra.parseColor(value, 2) #colorNames256[ searchColorTable(colorNames256, value) ][1]

  value = config.getSectionValue(section,"bgColorRGB")
  if value.find(',') != -1:
    result.bgColor[3] = int(packRGB(value.split({','})))
  else:
    echo "\n\n : ", value, " : \n\n"
    result.bgColor[3] = int(colors_extra.parseColor(value))

  #...................................................


  # background
  value = config.getSectionValue(section,"fgColor16")
  if value.len < 3:
    discard parseInt(value, result.fgColor[0])
  else:
    result.fgColor[0] = colors_extra.parseColor(value, 0) #colorNames16[ searchColorTable(colorNames16, value) ][1]

  value = config.getSectionValue(section,"fgColor16")
  if value.len < 3:
    discard parseInt(value, result.fgColor[1])
  else:
    result.fgColor[1] = colors_extra.parseColor(value, 1) #colorNames16[ searchColorTable(colorNames16, value) ][1]

  value = config.getSectionValue(section,"fgColor256")
  if value.len < 4:
    discard parseInt(value, result.fgColor[2])
  else:
    result.fgColor[2] = colors_extra.parseColor(value, 2) #colorNames256[ searchColorTable(colorNames256, value) ][1]

  value = config.getSectionValue(section,"fgColorRGB")
  if value.find(',') != -1:
    result.fgColor[3] = int(packRGB(value.split({','})))
  else:
    result.fgColor[3] = int(colors_extra.parseColor(value))

  #...................................................

  result.setTextStyle(config.getSectionValue(section,"textStyle"))

  result.border = config.getSectionValue(section,"border")
  if result.border == "": result.border = "none"



#________________________________________________________________






proc setPadding*(this:Controll,dir:string, size:int = 0)=
  for style in this.styles.values:
    case dir:
      of "top":
        style.padding.top = size
      of "bottom":
        style.padding.bottom = size
      of "left":
        style.padding.left = size
      of "right":
        style.padding.right = size
      of "all":
        style.padding.top = size
        style.padding.bottom = size
        style.padding.left = size
        style.padding.right = size
      else: discard
#.......................

proc setMargin*(this:Controll,dir:string, size:int = 0)=
  for style in this.styles.values:
    case dir:
      of "top":
        style.margin.top = size
      of "bottom":
        style.margin.bottom = size
      of "left":
        style.margin.left = size
      of "right":
        style.margin.right = size
      of "all":
        style.margin.top = size
        style.margin.bottom = size
        style.margin.left = size
        style.margin.right = size
      else: discard

proc setMargin*(this:Controll, args: varargs[string])=
  var i = 0
  while i < args.len:
    this.setMargin(args[i], parseInt(args[i+1]) )
    i += 2
#.......................

proc setMargin*(controlls: var seq[Controll],dir:string, size:int = 0)=
  for cont in controlls:
    cont.setMargin(dir, size)

proc setMargin*(controlls: var seq[Controll], args: varargs[string])=
  var i:int
  for cont in controlls:
    i = 0
    while i < args.len:
      cont.setMargin(args[i], parseInt(args[i+1]) )
      i += 2
#.......................

proc setMargin(style:StyleSheetRef,dir:string, size:int = 0)=
  case dir:
    of "top":
      style.margin.top = size
    of "bottom":
      style.margin.bottom = size
    of "left":
      style.margin.left = size
    of "right":
      style.margin.right = size
    of "all":
      style.margin.top = size
      style.margin.bottom = size
      style.margin.left = size
      style.margin.right = size
    else: discard

#------------------------

proc setBorder*(this:Controll, border:string = "none")=
  for style in this.styles.values:
    style.border = border


#------------------------


proc setDisabled*(this: Controll)=
  this.disabled = true
  this.activeStyle = this.styles["input:disabled"] #? change-all to disabled???
  this.drawit(this, true)


#------------------------


proc setControllsVisibility*(this: Window, setVisible: bool)=
  ## enable/disable draw for controlls
  ## if setVisible, the current pages controlls made visible again, not all
  ## else hide all of the windows controlls - currentpage or not
  if setVisible:
    for iC in 0..this.pages[this.currentPage].controlls.high :
      this.controlls[iC].visible = setVisible
  else:
    for iC in 0..this.controlls.high :
      this.controlls[iC].visible = setVisible
  #this.currentPage = 0 # disabled as it seems to cause more trouble than benefit

proc hideControlls*(this:Window)=
  this.setControllsVisibility(false)

proc hideControlls*(this:Tile)=
  ## disable draw for controlls
  for iW in 0..this.windows.high:
    setControllsVisibility(this.windows[iW], false)

proc hideControlls*(this:App)=
  ## disable draw for controlls
  for i_ws in 0..this.workSpaces.high :
    for iT in 0..this.workSpaces[i_ws].tiles.high:
      for iW in 0..this.workSpaces[i_ws].tiles[iT].windows.high:
        setControllsVisibility(this.workSpaces[i_ws].tiles[iT].windows[iW], false)






#________________________________________________________________



#
#       ######  ##     ## ########   ######   #######  ########
#      ##    ## ##     ## ##     ## ##    ## ##     ## ##     ##
#      ##       ##     ## ##     ## ##       ##     ## ##     ##
#      ##       ##     ## ########   ######  ##     ## ########
#      ##       ##     ## ##   ##         ## ##     ## ##   ##
#      ##    ## ##     ## ##    ##  ##    ## ##     ## ##    ##
#       ######   #######  ##     ##  ######   #######  ##     ##
#
proc parkCursor*(app:App){.inline.} # FW declaration


proc saveCursorPosAndAttrs*(){.inline.}=
  stdout.write("\e7")
proc restoreCursorPosAndAttrs*(){.inline.}=
  stdout.write("\e8")


# app.cursorPos is a buffer for controlls, users to hold cursor pos
proc setCursorPos*(app: App){.inline.}=
  stdout.write "\e[1A\n" #! this should make cursor more visible after updates
  terminal_extra.setCursorPos(app.cursorPos.x, app.cursorPos.y)

proc setCursorPos*(app: App, x,y: int){.inline.}=
  app.cursorPos.x = x
  app.cursorPos.y = y
  terminal_extra.setCursorPos(app.cursorPos.x, app.cursorPos.y)

#[  CursorStyle* = enum <------- remark
    blinkingBlock = 1,
    steadyBlock,
    blinkingUnderline,
    steadyUnderline ]#
proc setCursorStyle*(Ps: CursorStyle){.inline.}=
  stdout.write("\e[" & $int(Ps) & " q")
proc setCursorStyle*(Ps: int){.inline.}=
  stdout.write("\e[" & $Ps & " q")
#[ proc hideCursor*()= <------- exists in terminal.nim
  stdout.write "\e[?25l"
proc showCursor*()=
  stdout.write "\e[?25l" ]#


#*******************************************************************************
#*******************************************************************************
#*******************************************************************************
#*******************************************************************************


###   ##      ## #### ##    ## ########   #######  ##      ##    ###   ###
###   ##  ##  ##  ##  ###   ## ##     ## ##     ## ##  ##  ##   ##       ##
###   ##  ##  ##  ##  ####  ## ##     ## ##     ## ##  ##  ##  ##         ##
###   ##  ##  ##  ##  ## ## ## ##     ## ##     ## ##  ##  ##  ##         ##
###   ##  ##  ##  ##  ##  #### ##     ## ##     ## ##  ##  ##  ##         ##
###   ##  ##  ##  ##  ##   ### ##     ## ##     ## ##  ##  ##   ##       ##
###    ###  ###  #### ##    ## ########   #######   ###  ###     ###   ###

proc draw*(this: Window)
proc draw*(this: App)
proc redraw*(app:App)
proc recalc*(this: App)
proc drawTitle*(this: Window)

proc setTitle*(this:Window,label:string)=
  ## set Window title and redraw title
  this.label = label
  this.drawTitle()

proc isVisible(this:Window):bool=
  result = false
  for t in this.app.activeWorkspace.tiles:
    if this in t.windows: return true

proc pgUp*(this: Window)=
  if this.currentPage > 0:
    for iC in 0..this.pages[this.currentPage].controlls.high :
      this.pages[this.currentPage].controlls[iC].visible = false

    if this.app.activeControll.blur != nil:
      this.app.activeControll.blur(this.app.activeControll)
    this.currentPage = this.currentPage - 1
    this.draw()
    this.app.activeControll = this

proc pgDown*(this:Window)=
  if this.currentPage < this.pages.high:
    for iC in 0..this.pages[this.currentPage].controlls.high :
      this.pages[this.currentPage].controlls[iC].visible = false

    if this.app.activeControll != nil and this.app.activeControll.blur != nil:
      this.app.activeControll.blur(this.app.activeControll)
    this.currentPage = this.currentPage + 1
    this.draw()
    this.app.activeControll = this

proc window_onScroll(this:Controll, event:KMEvent)=
  case event.evType:
    of KMEventKind.ScrollUp: Window(this).pgUp()
    of KMEventKind.ScrollDown: Window(this).pgDown()
    else: discard

proc window_onClick(this:Controll, event:KMEvent)=
  let win = Window(this)
  if event.y == win.y1: # header
    if event.x == win.x1 + 1: # menu
      this.trigger("menu")

    elif win.pages.len > 1 :
      if event.x == win.x1 + 3: # pageUp
        win.pgUp()

      elif event.x == win.x1 + 6: # pageUp
        win.pgDown()


proc windowBlur(this:Controll)=
  discard
proc windowFocus(this:Controll)=
  discard
proc windowDrawit(this: Controll, updateOnly: bool = false)=
  discard


#*****************************************************************

proc swapWindows*(this:Tile, newWindows: seq[Window]): seq[Window] =
  # swap tiles window, returns old windows for store/swap back
  result = this.windows
  hideControlls(this)
  this.windows = newWindows



#*****************************************************************


proc setActiveWorkSpace*(app:App, ws:WorkSpace)=
  for iT in app.activeWorkSpace.tiles:
    for iW in iT.windows:
      for iC in iW.controlls:
        iC.visible = false
  app.activeWorkSpace = ws
  app.activeTile = if ws.tiles.len > 0 : ws.tiles[0] else: nil
  app.recalc()
  app.draw()
  app.parkCursor()


proc setActiveWorkSpace*(app: App, id:string)=
  for wS in app.workSpaces:
    if wS.id == id:
      app.setActiveWorkSpace wS


#*******************************************************************************
#*******************************************************************************
#*******************************************************************************
#*******************************************************************************


#                              #     # ####### #     #
#   #    # ###### #    #       ##    # #       #  #  #       #    # ###### #    #
#   ##   # #      #    #       # #   # #       #  #  #       ##   # #      #    #
#   # #  # #####  #    #       #  #  # #####   #  #  #       # #  # #####  #    #
#   #  # # #      # ## #       #   # # #       #  #  #       #  # # #      # ## #
#   #   ## #      ##  ##       #    ## #       #  #  #       #   ## #      ##  ##
#   #    # ###### #    #       #     # #######  ## ##        #    # ###### #    #
#


proc parseSizeStr*(width:string): tuple[width_unit:string,width_value:int]=
  var
    width_unit:string
    width_value:int

  if width == "auto":
    width_unit = "auto"
  else:
    var w_str: string # discard
    var count_numeric = width.parseUntil(w_str, {'%', 'c', 'p'}, 0)
    width_unit = if count_numeric > 0 : width.substr(count_numeric) else: "%"
    discard width.parseInt(width_value)

  result.width_unit = width_unit
  result.width_value = width_value





proc newColumnBreak*(win: Window): ColumnBreak =
  result = new ColumnBreak
  result.activeStyle = win.styles["window"]
  win.controlls.add(result)

proc newPageBreak*(win: Window): PageBreak =
  result = new PageBreak
  #result.activeStyle = win.styles["window"]
  win.controlls.add(result)


proc newPage*(): Page =
  result = new Page
  result.controlls = @[]

proc newPage*(win: Window): Page =
  result = new Page
  result.controlls = @[]
  result.app = win.app
  result.styles.deepCopy win.app.styles
  result.activeStyle = result.styles["window"]
  win.pages.add(result)


proc newWindow*(tile: Tile, label:string="Window"): Window =
  result = new Window
  result.pages = @[]
  result.controlls = @[]
  result.currentPage = 0
  result.listeners = @[]
  result.tile = tile
  result.app = tile.app
  result.label = label

  result.onClick = window_onClick
  result.onScroll = window_onScroll

  result.styles.deepCopy tile.app.styles
  result.activeStyle = result.styles["window"]

  result.blur = windowBlur
  result.focus = windowFocus
  result.drawit = windowDrawit

  tile.windows.add(result)


proc newTile*(ws: WorkSpace, width: string) : Tile =
  result = new Tile
  #[ if width == "auto":
    result.width_unit = "auto"
  else:
    var w_str: string
    var count_numeric = width.parseUntil(w_str, {'%', 'c', 'p'}, 0)
    result.width_unit = width.substr(count_numeric)
    discard width.parseInt(result.width_value) ]#
  (result.width_unit, result.width_value) = parseSizeStr(width)

  result.windows = @[]
  result.styles.deepCopy ws.app.styles
  result.activeStyle = result.styles["window"]
  result.app = ws.app
  ws.tiles.add(result)


proc newWorkSpace*(app: var App, id:string="default"): WorkSpace =
  result = new WorkSpace
  result.tiles = @[]
  result.app = app
  result.id = if id == "default": genID() else: id
  app.workSpaces.add(result)
  if app.activeWorkSpace == nil: # for convinience. but you better set/track it manually!
    app.activeWorkSpace = result


proc appOnKeypress*(app:App, event: KMEvent):bool #! FWD

proc newApp*(appDir: string): App = # appDir for themes
  result = new App

  initLock(result.termlock)

  result.listeners = @[]
  result.timers = @[]

  result.onKeypress = appOnKeypress

  result.availRect.x1 = 1
  result.availRect.y1 = 1
  result.availRect.x2 = terminalWidth()
  result.availRect.y2 = terminalHeight()

  result.cursorPos.x = 2
  result.cursorPos.y = 1

  result.workSpaces = @[]

  # init StyleSheet
  result.colorMode = getColorMode()

  result.styles = newStyleSheets() ## newTable[string, StyleSheetRef](8)
  block LOAD_TSS:

    # _Terminal_Style_Sheet
    #debugEcho getCurrentDir()
    var
      dict = loadConfig(appDir & DirSep & "stui" & DirSep & "theme.tss")

    # default background colors:

    # window background
    result.styles.add("window",styleSheetRef_fromConfig(dict,"window"))
    result.activeStyle = result.styles["window"] # ???

    result.styles.add("dock",styleSheetRef_fromConfig(dict,"dock")) # alt. win style

    # Controll's defaults
    result.styles.add("input", styleSheetRef_fromConfig(dict,"input"))

    # inverse for progressbar, etc - alt. "input" style
    var styleInverse: StyleSheetRef = new StyleSheetRef
    styleInverse.deepcopy result.styles["input"]
    styleInverse.fgColor = result.styles["input"].bgColor
    styleInverse.fgColor[0] -= 10
    styleInverse.fgColor[1] -= 10
    styleInverse.bgColor = result.styles["input"].fgColor
    styleInverse.bgColor[0] += 10
    styleInverse.bgColor[1] += 10
    result.styles.add("input:inverse",styleInverse)

    result.styles.add("input:focus",styleSheetRef_fromConfig(dict,"input-focus"))

    result.styles.add("input:disabled",styleSheetRef_fromConfig(dict,"input-disabled"))

    result.styles.add("input:drag",styleSheetRef_fromConfig(dict,"input-drag"))

    result.styles.add("input:even",styleSheetRef_fromConfig(dict,"input-even"))
    result.styles.add("input:odd",styleSheetRef_fromConfig(dict,"input-odd"))

    result.styles.add("input:even_dark",styleSheetRef_fromConfig(dict,"input-even_dark"))
    result.styles.add("input:odd_dark",styleSheetRef_fromConfig(dict,"input-odd_dark"))
    #............








#*******************************************************************************
#*******************************************************************************
#*******************************************************************************
#*******************************************************************************


#
#             #####  ######  ####    ##   #       ####
#       ##### #    # #      #    #  #  #  #      #    # #####
# #####       #    # #####  #      #    # #      #            #####
#       ##### #####  #      #      ###### #      #      #####
#             #   #  #      #    # #    # #      #    #
#             #    # ######  ####  #    # ######  ####



proc outerHeigth(this: Controll): int {.inline.} =
  ## used by recalc
  if this.heigth_value > 0: # relative heigth used (percent)

    if this.activeStyle.border != "none" and this.activeStyle.border != "": # has border
      if this.heigth_value == 100:
        this.heigth = this.win.heigth - 1 -
          this.win.activeStyle.padding.top -
          this.win.activeStyle.padding.bottom -
          this.activeStyle.margin.top - this.activeStyle.margin.bottom - 2 # 2->border
      else:
        this.heigth = int(((this.win.heigth - 1 -
          this.win.activeStyle.padding.top -
          this.win.activeStyle.padding.bottom).float / 100.0) * this.heigth_value.float) -
          this.activeStyle.margin.top - this.activeStyle.margin.bottom - 2 # 2->border

    else: # no border
      if this.heigth_value == 100:
        this.heigth = this.win.heigth - 1 -
          this.win.activeStyle.padding.top -
          this.win.activeStyle.padding.bottom -
          this.activeStyle.margin.top - this.activeStyle.margin.bottom
      else:
        this.heigth = int(((this.win.heigth - 1 -
          this.win.activeStyle.padding.top -
          this.win.activeStyle.padding.bottom).float / 100.0) * this.heigth_value.float) -
          this.activeStyle.margin.top - this.activeStyle.margin.bottom

    return this.heigth +
      this.activeStyle.margin.top +
      this.activeStyle.margin.bottom

  else: # egsact heigth value used
    if this.activeStyle.border != "none" and this.activeStyle.border != "": # has border
      return this.heigth + this.activeStyle.margin.top + this.activeStyle.margin.bottom + 2
    else: # no border
      return this.heigth + this.activeStyle.margin.top + this.activeStyle.margin.bottom

proc borderWidth*(this: Controll): int {.inline.} =
  return if this.activeStyle.border == "none" or this.activeStyle.border == "" : 0 else: 1



proc recalc*(this: Window, tile: Tile, layer: int) =

  this.x1 = tile.x1 #see: proc recalc*(this: WorkSpace, availRect: Rect) =
  this.y1 = tile.y1 + layer
  this.x2 = tile.x2
  this.y2 = tile.y2
  this.width = tile.width
  this.heigth = this.y2-this.y1


  var
    availH = this.heigth - this.activeStyle.padding.top
    #iPage: int = 0 # for pages
    # for multiple columns
    xC: int = this.x1 + this.activeStyle.padding.left
    maxX: int = this.x1
    maxAvailH: int = 0 #TODO maxAvailH
    page: Page
    tabStop: int = 0

  #....................................

  proc calcAvailH(): int =
    # number of rows available for controlls
    # 100% width controlls change maxAvailH, wich is the top
    # others change maxX - the starter column
    #TODO maxAvailH
    if maxAvailH == 0:
      result = this.heigth - this.activeStyle.padding.top -
        this.activeStyle.padding.bottom
    else:
      result = maxAvailH #this.heigth - this.activeStyle.padding.top - (maxAvailH - this.y1)

  proc newPage()=
    page =  this.newPage()
    xC = this.x1 + this.activeStyle.padding.left
    maxX = 0
    maxAvailH = 0
    availH = calcAvailH()
    tabStop = 0


  proc newColumn()=
    xC = maxX + 1 # +1: next column, not the .x2 of this controll!
    availH = calcAvailH()

  #....................................
  # clear pages for recalc
  if this.pages.len > 0:
    this.pages = @[]

  if this.controlls.len > 0:
    discard this.newPage()
    page = this.pages[this.pages.low]

    # Column: top to bottom - left to right layout:
    for iC in 0..this.controlls.len - 1:#....................................

      if this.controlls[iC] of PageBreak:
        newPage()
        continue
      if this.controlls[iC] of ColumnBreak:
        newColumn()
        continue

      # if the Controll calculates for self, then do it:
        # so the whole layout is up for the user to handle!
      if this.controlls[iC].recalc != nil:
        this.controlls[iC].recalc(this.controlls[iC])
        this.controlls[iC].tabStop = tabStop
        page.controlls.add(this.controlls[iC])
        tabStop += 1
        availH -= this.controlls[iC].outerHeigth() #?????? can be useful -;)
      else: # if values for width, heigth added - by int or percentage:
        # if relative width used:
        if this.controlls[iC].width_value != 0: # 0 by default == look for heigth prop
          # 100% width, maybe not needed but...:
          if this.controlls[iC].width_value == 100:
            this.controlls[iC].width = (this.width) -
              (this.controlls[iC].activeStyle.margin.left +
              this.controlls[iC].activeStyle.margin.right +
              this.controlls[iC].borderWidth() * 2) -
              this.activeStyle.padding.left -
              this.activeStyle.padding.right

          else:
            this.controlls[iC].width = int((this.width.float / 100) *
              this.controlls[iC].width_value.float) -
              (this.controlls[iC].activeStyle.margin.left +
              this.controlls[iC].activeStyle.margin.right +
              this.controlls[iC].borderWidth() * 2)


        ###### heigth and width should be calculated at this point #####
        ###### see: outerHeigth


        # if no room on bottom / and on side: ------------------------
        #   .x2 precalc to know if controll fits on page
        #
        this.controlls[iC].x2 = xC +
          (this.controlls[iC].width - 1) +
          (this.controlls[iC].borderWidth() * 2) +
          this.controlls[iC].activeStyle.margin.left +
          this.controlls[iC].activeStyle.margin.right #!X2

        if this.controlls[iC].outerHeigth() >= availH or this.controlls[iC].x2 > this.x2:
          # if room on the right: new column
          if maxX + 1 + this.controlls[iC].width +
            this.controlls[iC].activeStyle.margin.left +
            this.controlls[iC].activeStyle.margin.right +
            this.controlls[iC].borderWidth() * 2 < this.x2:

            xC = maxX + 1 # +1: next column, not the x2 of this controll!

            availH = calcAvailH()
          else: # new page
            newPage()
            #[ echo "NEWPAGE: ", this.controlls[iC].outerHeigth(), " vs ", $(availH )
            discard stdin.readLine() ]#

            this.controlls[iC].x2 = xC + (this.controlls[iC].width - 1) +
              (this.controlls[iC].borderWidth() * 2) +
              this.controlls[iC].activeStyle.margin.left +
              this.controlls[iC].activeStyle.margin.right #!X2

            # todo: rethink error MSG
            if this.controlls[iC].outerHeigth() > availH or this.controlls[iC].x2 > this.x2:
              echo "ERR Controll cannot be placed on screen! PRESS ENTER! ", this.controlls[iC].outerHeigth(), " vs ", $(availH + 1)
              #discard stdin.readLine()
              continue
        #...............................................................



        this.controlls[iC].tabStop = tabStop
        page.controlls.add(this.controlls[iC])
        tabStop += 1


        this.controlls[iC].x1 = xC #! xC may changed by newColumn->x2 recalc!!!

        #this.controlls[iC].y1 = this.y1 + (this.heigth - availH) + this.controlls[iC].activeStyle.margin.top + 1
        this.controlls[iC].y1 =  this.y1 + (this.heigth - availH) + 1

        this.controlls[iC].x2 = this.controlls[iC].x1 + (this.controlls[iC].width - 1) + (this.controlls[iC].borderWidth() * 2) + this.controlls[iC].activeStyle.margin.left + this.controlls[iC].activeStyle.margin.right #!X2

        this.controlls[iC].y2 = this.controlls[iC].y1 + (this.controlls[iC].heigth - 1) + (this.controlls[iC].borderWidth() * 2) + this.controlls[iC].activeStyle.margin.top + this.controlls[iC].activeStyle.margin.bottom

        availH -= this.controlls[iC].outerHeigth()

        if this.controlls[iC].width_value == 100: maxAvailH = availH

        if maxX < this.controlls[iC].x1 +
          (this.controlls[iC].width - 1) +
          (this.controlls[iC].borderWidth() * 2) +
          this.controlls[iC].activeStyle.margin.left +
          this.controlls[iC].activeStyle.margin.right and
          this.controlls[iC].width_value != 100:

          maxX =  this.controlls[iC].x1 +
            (this.controlls[iC].width - 1) +
            (this.controlls[iC].borderWidth() * 2) +
            this.controlls[iC].activeStyle.margin.left +
            this.controlls[iC].activeStyle.margin.right



proc recalc*(this: WorkSpace, availRect: Rect) =
  var sum_fixTilesW, num_autoTiles: int
  for iT in 0..this.tiles.len - 1 :
    if this.tiles[iT].width_unit == "ch":
      sum_fixTilesW = sum_fixTilesW + this.tiles[iT].width_value
      this.tiles[iT].width = this.tiles[iT].width_value

  # calc flex tiles
  var flexAvailW = (availRect.x2 - availRect.x1) - sum_fixTilesW
  var sum_flexTilesW: int

  for iT in 0..this.tiles.len - 1 :
    if this.tiles[iT].width_unit == "%":
      this.tiles[iT].width = int(float(flexAvailW) * (float(this.tiles[iT].width_value) * 0.01))
      sum_flexTilesW = sum_flexTilesW + this.tiles[iT].width

    if this.tiles[iT].width_unit == "auto":
      num_autoTiles = num_autoTiles + 1

  var sum_autoTilesW : int
  if num_autoTiles > 0:
    for iT in 0..this.tiles.len - 1:
      if this.tiles[iT].width_unit == "auto":
        this.tiles[iT].width = (flexAvailW - sum_flexTilesW) div num_autoTiles
        sum_autoTilesW = sum_autoTilesW + this.tiles[iT].width

  #handle over/underrun:
  if sum_fixTilesW + sum_flexTilesW + sum_autoTilesW != (availRect.x2 - availRect.x1 + 1):
    if sum_fixTilesW + sum_flexTilesW + sum_autoTilesW > (availRect.x2 - availRect.x1 + 1):
      this.tiles[0].width = this.tiles[0].width - (sum_fixTilesW + sum_flexTilesW + sum_autoTilesW - (availRect.x2 - availRect.x1 + 1) )
    else:
      this.tiles[0].width = this.tiles[0].width + ((availRect.x2 - availRect.x1 + 1) - (sum_fixTilesW + sum_flexTilesW + sum_autoTilesW) )

  # calc x1 .... values
  var w_used: int = availRect.x1 #- 1
  for iT in 0..this.tiles.high :
    #w_used += 1
    this.tiles[iT].x1 = w_used
    this.tiles[iT].y1 = availRect.y1
    this.tiles[iT].x2 = w_used + this.tiles[iT].width - 1
    this.tiles[iT].y2 = availRect.y2

    # calc Windows
    #? relative Heigths?
    if this.tiles[iT].windows.len > 0:
      for iW in 0..this.tiles[iT].windows.high:
        recalc(this.tiles[iT].windows[iW], this.tiles[iT], iW)

    w_used += this.tiles[iT].width


proc recalc*(this: App) =
  #this.availRect.x1 = 1
  #this.availRect.y1 = 1
  #acquire(this.termlock)
  # todo: availrect widgets!!!
  this.availRect.x2 = terminalWidth()
  this.availRect.y2 = terminalHeight()
  this.hideControlls()
  if this.workSpaces.len > 0:
    for i_ws in 0..this.workSpaces.high :
      this.workSpaces[i_ws].recalc(this.availRect)
  #release(this.termlock)










#
#                 #####  #####    ##   #    #
#           ##### #    # #    #  #  #  #    # #####
#     #####       #    # #    # #    # #    #       #####
#           ##### #    # #####  ###### # ## # #####
#                 #    # #   #  #    # ##  ##
#                 #####  #    # #    # #    #

#[  ═
┌─┐═
│ │
└─┘
┏━┓
┃ ┃
┗━┛
 ]#

proc leftX*(this: Controll) : int {.inline.} =
  ## Controlls first column to draw - wo border + margin
  this.x1 + this.activeStyle.margin.left + this.borderWidth()

proc rightX*(this: Controll) : int {.inline.} =
  ## Controlls last column - wo border + margin
  this.x2 - this.activeStyle.margin.right - this.borderWidth()

proc bottomY*(this: Controll) : int {.inline.} =
  ## Controlls last row available for drawing - wo border + margin
  this.y2 - this.activeStyle.margin.bottom - this.borderWidth()

proc topY*(this: Controll) : int {.inline.} =
  ## Controlls first row available for drawing - wo border + margin
  this.y1 + this.activeStyle.margin.top + this.borderWidth()



proc drawRect*(x1,y1,x2,y2:int, pattern: string = " "){.inline.}=
  for y in y1..y2:
    terminal_extra.setCursorPos(x1,y)
    stdout.write(pattern * (x2 - x1 + 1) )


proc drawBorder*(borderStyle: string, x1,y1,x2,y2:int){.inline.}=
  case borderStyle:
    of "block":
      #top
      terminal_extra.setCursorPos(x1,y1)
      stdout.write("█" * (x2 - x1 + 1) )
      #bottom
      terminal_extra.setCursorPos(x1,y2)
      stdout.write("█" * (x2 - x1 + 1) )
      #left
      for i in y1..y2:
        terminal_extra.setCursorPos(x1,i)
        stdout.write("█")
      #right
      for i in y1..y2:
        terminal_extra.setCursorPos(x2,i)
        stdout.write("█")

    of "bold":
      #top
      terminal_extra.setCursorPos(x1+1,y1)
      stdout.write("━" * (x2 - x1) )
      #bottom
      terminal_extra.setCursorPos(x1+1,y2)
      stdout.write("━" * (x2 - x1) )
      #left
      for i in y1 + 1..y2-1:
        terminal_extra.setCursorPos(x1,i)
        stdout.write("┃")
      #right
      for i in y1+1..y2-1:
        terminal_extra.setCursorPos(x2,i)
        stdout.write("┃")
      #corners
      terminal_extra.setCursorPos(x1,y1)
      stdout.write("┏")
      terminal_extra.setCursorPos(x2,y1)
      stdout.write("┓")
      terminal_extra.setCursorPos(x1,y2)
      stdout.write("┗")
      terminal_extra.setCursorPos(x2,y2)
      stdout.write("┛")

    of "solid", "single":
      #top
      terminal_extra.setCursorPos(x1+1,y1)
      stdout.write("─" * (x2 - x1 - 1) )
      #bottom
      terminal_extra.setCursorPos(x1+1,y2)
      stdout.write("─" * (x2 - x1 - 1) )
      #left
      for i in y1 + 1..y2-1:
        terminal_extra.setCursorPos(x1,i)
        stdout.write("│")
      #right
      for i in y1+1..y2-1:
        terminal_extra.setCursorPos(x2,i)
        stdout.write("│")
      #corners
      terminal_extra.setCursorPos(x1,y1)
      stdout.write("┌")
      terminal_extra.setCursorPos(x2,y1)
      stdout.write("┐")
      terminal_extra.setCursorPos(x1,y2)
      stdout.write("└")
      terminal_extra.setCursorPos(x2,y2)
      stdout.write("┘")


    of "double":
      #top
      terminal_extra.setCursorPos(x1+1,y1)
      stdout.write("═" * (x2 - x1 - 1) )
      #bottom
      terminal_extra.setCursorPos(x1+1,y2)
      stdout.write("═" * (x2 - x1 - 1) )
      #left
      for i in y1 + 1..y2-1:
        terminal_extra.setCursorPos(x1,i)
        stdout.write("║")
      #right
      for i in y1+1..y2-1:
        terminal_extra.setCursorPos(x2,i)
        stdout.write("║")
      #corners
      terminal_extra.setCursorPos(x1,y1)
      stdout.write("╔")
      terminal_extra.setCursorPos(x2,y1)
      stdout.write("╗")
      terminal_extra.setCursorPos(x1,y2)
      stdout.write("╚")
      terminal_extra.setCursorPos(x2,y2)
      stdout.write("╝")


    else: discard
#---------------------------------------------





#    [≡]═⟅Unnamed Document 1⟆════════════════════════════════════════════════════
#    [≡]═Unnamed Document 1════════════════════════════════════════════════════
#    [≡]═⦗Unnamed Document 1⦘════════════════════════════════════════════════════
#    [≡]▲ ▼╣Unnamed Document 1╠════════════════════════════════════════════════════  ╕╒
#    [≡]═[Unnamed Document 1]════════════════════════════════════════════════════
# ▲

proc drawTitle*(this: Window) =
  if this.isVisible():
    acquire(this.app.termlock)
    setColors(this.app, this.activeStyle[])
    terminal_extra.setCursorPos(this.x1, this.y1)
    stdout.write("[≡]") # ▪ ≡ ✽  ☰
    var used = 3
    if this.pages.len > 1 and this.width > 7:
      if this.currentPage + 1 > 9 :
        stdout.write("▲" & $(this.currentPage + 1) & "▼")
      else:
        stdout.write("▲ " & $(this.currentPage + 1) & "▼")
      used = used + 4

    if this.width - used >= this.label.runeLen + 2:
      stdout.write("═⟅") # ┨ ╡ ┤ | ▌  ▐
      stdout.write(this.label)
      stdout.write("⟆") # ╞
      stdout.write("═" * (this.width - used - this.label.runeLen - 2 - 1))
    elif this.width - used > 0 :
      stdout.write("⟅") #
      stdout.write(this.label.runeSubstr(0,   (this.width - used - 2) ))
      stdout.write("⟆")
    release(this.app.termlock)


method draw*(this: Controll) {.base.} =
  discard

proc draw*(this: Window) =
  # titlebar: ▲▼ »« ‹› × ̊ ⁰
  acquire(this.app.termlock)
  setColors(this.app, this.activeStyle[])
  drawRect(this.x1, this.y1, this.x2, this.y2)
  release(this.app.termlock)

  if not this.fullScreen: this.drawTitle()

  if this.pages.len > 0 :
    #echo "draw W: DEB: " , this.currentPage , ", " , this.pages[0].controlls.len
    if this.pages[this.currentPage].controlls.len > 0:
      for iC in 0..this.pages[this.currentPage].controlls.high :
        this.pages[this.currentPage].controlls[iC].visible = true
        if this.pages[this.currentPage].controlls[iC].drawit != nil:
          this.pages[this.currentPage].controlls[iC].drawit(this.pages[this.currentPage].controlls[iC], false)

      parkCursor(this.app)



method draw*(this: Tile) =
  if this.windows.len > 0 :
    this.windows[this.windows.high].draw()


proc draw*(this: App) =
  #todo draw app widgets
  #...
  #this.setColors( this.activeStyle[])
  #hideCursor()
  if not isNil this.activeWorkSpace: # if anything to show
    for i_tiles in 0..this.activeWorkSpace.tiles.high:
      this.activeWorkSpace.tiles[i_tiles].draw()

  #this.setColors (this.activeStyle[])
  #showCursor()

#------------------------------------







#      I8                                                                           ,dPYb,
#      I8                                                                           IP'`Yb
#   88888888                                         gg                             I8  8I
#      I8                                            ""                             I8  8'
#      I8     ,ggg,    ,gggggg,   ,ggg,,ggg,,ggg,    gg    ,ggg,,ggg,     ,gggg,gg  I8 dP
#      I8    i8" "8i   dP""""8I  ,8" "8P" "8P" "8,   88   ,8" "8P" "8,   dP"  "Y8I  I8dP
#     ,I8,   I8, ,8I  ,8'    8I  I8   8I   8I   8I   88   I8   8I   8I  i8'    ,8I  I8P
#    ,d88b,  `YbadP' ,dP     Y8,,dP   8I   8I   Yb,_,88,_,dP   8I   Yb,,d8,   ,d8b,,d8b,_
#   88P""Y88888P"Y8888P      `Y88P'   8I   8I   `Y88P""Y88P'   8I   `Y8P"Y8888P"`Y88P'"Y88
#[
XTERM conf
    http://www.futurile.net/2016/06/14/xterm-setup-and-truetype-font-configuration/

~/.Xresources :
    xterm*faceName: DejaVu Sans Mono
    xterm*faceSize: 12
    xterm*renderFont: true
    xterm*background: Black
    xterm*foreground: White

Merge .Xresources and check

    $ xrdb -merge .Xresources
    $ xterm &

For color: env TERM=xterm-256color xterm
 ]#

include termios

proc closeTerminal() {.noconv.} =
  echo "\e[12l" # ? turn back local echo
  echo "\e[?1006l\e[?1002l" #! mouse
  echo "\e[?7h" # ? do wrap
  echo "\ec\e[0m"
  setCursorStyle(CursorStyle.blinkingBlock)
  showCursor()
  #disableCanon() #? does it works for somebody?
  switchToNormalBuffer() #echo "\e[?1049l" #switchToNormalBuffer
  discard execShellCmd("reset && tput reset") #! HAMMER - as the above may not work...

proc closeTerminal*(app:App)=
  withLock app.termlock:
    closeTerminal()

proc initTerminal*(app:App)=
  system.addQuitProc(closeTerminal)
  #system.addQuitProc(resetAttributes)
  switchToAlternateBuffer() #####! COMMENT ME FOR BETTER DEBUGGING ######################
  echo "\ec\e[0m" # ? reset
  echo "\e[?1002h\e[?1006h" #! mouse enable + mode
  echo "\e%G" # ? set UTF8
  echo "\e[?7l" # ? dont wrap
  #enableCanon() #? does it works for somebody?
  hideCursor()
  echo "\e[12h" # turn off local echo

  #if getColorMode() == 3: terminal.enableTrueColors()
  app.terminalHeight = terminalHeight()
  app.terminalWidth = terminalWidth()
  setCursorStyle(CursorStyle.steadyUnderline)












############          #    ######  ######
############         # #   #     # #     #    ###### #    # #    #
############        #   #  #     # #     #    #      #    # ##   #
############       #     # ######  ######     #####  #    # # #  #
############       ####### #       #          #      #    # #  # #
############       #     # #       #          #      #    # #   ##
############       #     # #       #          #       ####  #    #



# todo: make paralell:
proc runTimers*(this:App)=
  var time = epochTime()
  if this.timers.len > 0:
    for iT in 0..this.timers.high:
      if time - this.timers[iT].lastrun >= this.timers[iT].interval:
        this.timers[iT].action()
        this.timers[iT].lastrun = time

#-------------------------------------------------------------------------------
#[
  # activate is written before check for prevStyle != nil was inserted into blur()

  activate is useful to pass focus to other controll like selectbox->chooser
]#
proc activate*(app: App, controll:Controll)=
  ## activate the selected controll
  ## controll should be visible for now - TODO
  if app.activeControll != nil:
    if app.activeControll.blur != nil:
      app.activeControll.blur(app.activeControll)
      app.activeControll.drawit(app.activeControll, false)

  if controll.focus != nil: controll.focus(controll)
  app.activeControll = controll
  controll.drawit(controll, false)



proc `activeWindow`*(this:App): Window {.inline.} =
  return this.activeTile.windows[this.activeTile.windows.high]

proc `activePage`*(this:App): Page {.inline.} =
  return this.activeTile.windows[this.activeTile.windows.high].pages[this.activeTile.windows[this.activeTile.windows.high].currentPage]


proc parkCursor*(app:App){.inline.}=
  ## move cursor to "parking" position
  ## proc blur() uses it mostly
  withLock app.termlock:
    terminal_extra.setCursorPos(app.activeWindow.x1 + 1, app.activeWindow.y1)
    app.cursorPos.x = app.activeWindow.x1 + 1
    app.cursorPos.y = app.activeWindow.y1


proc redraw*(app:App)=
  app.recalc()
  app.draw()



###############################################################################
###############################################################################


proc getUIElementAtPos*(app:App, x,y:int, setActive: bool = false): Controll =
  ## gets Controll at mouse pos, make it activ if asked
  result = nil

  # todo: WIDGETS!!!!!
  # todo: WIDGETS!!!!!
  # todo: WIDGETS!!!!!
  # todo: WIDGETS!!!!!

  for iT in 0..app.activeWorkSpace.tiles.len - 1: # TODO WORKSPACES...TODO WORKSPACES...TODO WORKSPACES...
    let tile = app.activeWorkSpace.tiles[iT]

    if  tile.x1 <= x and tile.x2 >= x and tile.y1 <= y and tile.y2 >= y:
      #echo tile.id
      #echo tile.windows[tile.windows.high].currentPage
      app.activeTile = app.activeWorkSpace.tiles[iT]

      if tile.windows.len > 0 and tile.windows[tile.windows.high].pages.len > 0:
        let page = tile.windows[tile.windows.high].pages[tile.windows[tile.windows.high].currentPage]

        for iE in 0..page.controlls.len - 1:
          if  page.controlls[iE].x1 <= x and
            page.controlls[iE].x2 >= x and
            page.controlls[iE].y1 <= y and
            page.controlls[iE].y2 >= y and
            page.controlls[iE].visible :
            #echo "FOUNDIT"

            if setActive and app.activeControll != page.controlls[iE]: #! changed
              #var currentControll = page.controlls[iE]
              # blur active controll:
              if app.activeControll != nil #[ and app.activeControll != page.controlls[iE] ]# :
                if app.activeControll.blur != nil:
                  app.activeControll.blur(app.activeControll)
                  app.activeControll.drawit(app.activeControll, false)
                #[ else:
                  echo repr app.activeControll.blur
              else:
                echo "?-?" ]#

              # set active controll
              app.activeControll = page.controlls[iE]
              if app.activeControll.focus != nil:
                app.activeControll.focus(app.activeControll)

            return page.controlls[iE]

      # if no controll found but Tile
      if app.activeControll != nil and setActive:
        if app.activeControll.blur != nil:
          app.activeControll.blur(app.activeControll)
          app.activeControll.drawit(app.activeControll, false)
      if setActive:
        app.activeControll = app.activeTile.windows[app.activeTile.windows.high] #app.workSpaces[0].tiles[iT]
        result = app.activeControll #app.workSpaces[0].tiles[iT]
      else:
        result = app.activeTile.windows[app.activeTile.windows.high]



###############################################################################
###############################################################################

proc focusFWD*(app:App)=
  ## jump focus to next tabstop
  # HINT: pageBreak is not added to PAGE controlls :)
  if app.activeControll != nil:
    var newTabStop: int = app.activeControll.tabStop

    if app.activeControll.tabStop < app.activePage.controlls.high and not (app.activeControll of Window):
      newTabStop += 1
    else:
      newTabStop = 0

    if app.activeControll.blur != nil:
      app.activeControll.blur(app.activeControll)
      app.activeControll.drawit(app.activeControll, false)

    app.activeControll = app.activePage.controlls[newTabStop]

    if app.activeControll.focus != nil:
      app.activeControll.focus(app.activeControll)
      app.activeControll.drawit(app.activeControll, false)

proc appOnKeypress*(app:App, event: KMEvent):bool=
  ## default actions if app handles keypress.
  ## KeyPgUp, KeyPgDown triggers controlls proc first then apps.
  ## if not defined here, it will try to trigger eventlistener:
  ##   (if app.listeners[i].name == event.key)
  ## if result == false, mainloop will try to run activeControlls onKeypressed proc
  result = false
  case event.evType:

    of KMEventKind.FnKey:
      case event.key:
        of KeyPgDown:
          app.activeWindow.pgDown()
          result = true
        of KeyPgUp:
          app.activeWindow.pgUp()
          result = true
        of KeyF5:
          app.recalc()
          app.draw()
          result = true
        of KeyF10:
          if app.quit != nil:
            app.quit()
          else:
            quit()
        else: #! new feature test!
          if app.listeners.len > 0:
            for i in 0..app.listeners.high:
              if app.listeners[i].name == event.key:
                for j in 0..app.listeners[i].actions.high:
                  app.listeners[i].actions[j]()
                result = true

    of KMEventKind.CtrlKey:
      case event.ctrlKey:
        of 9: # TAB
          # *HINT: pageBreak is not added to PAGE controlls :)
          if app.activeControll != nil:
            focusFWD(app)
            result = true
          else:
            discard
            #echo "???"

        else: discard

    else: discard

#------------------------------------------------------------------------

###############################################################################
###############################################################################


#########      ###### #    # ###### #    # #####  ####
#########      #      #    # #      ##   #   #   #
#########      #####  #    # #####  # #  #   #    ####
#########      #      #    # #      #  # #   #        #
#########      #       #  #  #      #   ##   #   #    #
#########      ######   ##   ###### #    #   #    ####


proc mouseEventHandler*(app: App, event: KMEvent):void =
  ## mouse event dispatcher
  ## gets the controll by x,y coordinates and
  ## calls the controlls event handler proc

  if event.evType == KMEventKind.Drop :
    ## needed to remove "drag path" from screen
    app.draw()

  var eventTarget: Controll
  if event.evType in [KMEventKind.Release,KMEventKind.Drag, KMEventKind.ScrollDown,KMEventKind.ScrollUp]:
    ## getuielement fires blur and sets activecontroll if asked
    eventTarget = app.getUIElementAtPos(event.x,event.y, false)
  else:
    eventTarget = app.getUIElementAtPos(event.x,event.y, true)

  if eventTarget != nil:
    event.target = eventTarget
    if event.evType == KMEventKind.Click :
      if eventTarget.onClick != nil:
        eventTarget.onClick(eventTarget, event)

    if event.evType == KMEventKind.Release :
      if not isNil(eventTarget.onRelease) :
        eventTarget.onRelease(eventTarget, event)


    if event.evType == KMEventKind.DoubleClick :
      if not isNil(eventTarget.onDoubleClick) :
        eventTarget.onDoubleClick(eventTarget, event)

    if event.evType == KMEventKind.Drag and app.dragSource == nil #[ and app.activeControll != nil ]#:
      if app.activeControll != eventTarget: #! patch - if dragged controll is not the activecontroll
        app.activate(eventTarget)

      app.dragSource = app.activeControll
      if app.dragSource.onDrag != nil: app.dragSource.onDrag(eventTarget, event)

    if event.evType == KMEventKind.Drop :
      if app.dragSource != eventTarget and not app.dragSource.disabled and not eventTarget.disabled: # dont fire drop on itself OR disabled
        event.source = app.dragSource
        if eventTarget.onDrop != nil : eventTarget.onDrop(eventTarget, event)
      else:
        if eventTarget.focus != nil :
          eventTarget.blur(eventTarget)
          eventTarget.focus(eventTarget) # focus blurs source -> style reset

      app.dragSource = nil

    if event.evType in [KMEventKind.ScrollDown, KMEventKind.ScrollUp] :
      if eventTarget.onScroll != nil : eventTarget.onScroll(eventTarget, event)





proc addEventListener*(controll:Controll, evtname:string, fun:proc(source:Controll):void)=
  var exists = false
  var newListener: Listener
  for i in 0..controll.listeners.high:
    if controll.listeners[i].name == evtname:
      controll.listeners[i].actions.add(fun)
      exists = true
  if not exists:
    newListener.name = evtname
    newListener.actions = @[]
    newListener.actions.add(fun)
    controll.listeners.add(newListener)


proc removeEventListener*(controll:Controll, evtname:string, fun:proc(source:Controll):void)=
  for i in 0..controll.listeners.high:
    if controll.listeners[i].name == evtname:
      for j in 0..controll.listeners[i].actions.high:
        if controll.listeners[i].actions[j] == fun:
          controll.listeners[i].actions.del(j)


proc trigger*(controll:Controll, evtname:string )=
  for i in 0..controll.listeners.high:
    if controll.listeners[i].name == evtname:
      for j in 0..controll.listeners[i].actions.high:
        controll.listeners[i].actions[j](controll)

#[ # should work but... ???
proc trigger*[T](obj:T, evtname:string )=
  for i in 0..obj.listeners.high:
    if obj.listeners[i].name == evtname:
      for j in 0..obj.listeners[i].actions.high:
        obj.listeners[i].actions[j](obj) ]#


proc addEventListener*(app:App, evtname:string, fun:proc():void)=
  ## among many others, this can be used to
  ## add FunctionKey onclick events like F10 quit, F2 menu, etc...
  var exists = false
  for i in 0..app.listeners.high:
    if app.listeners[i].name == evtname:
      app.listeners[i].actions.add(fun)
      exists = true
  if not exists:
    var newListener: tuple[name:string, actions: seq[proc():void]]
    newListener.name = evtname
    newListener.actions = @[]
    newListener.actions.add(fun)
    app.listeners.add(newListener)


proc removeEventListener*(app:App, evtname:string, fun:proc():void)=
  for i in 0..app.listeners.high:
    if app.listeners[i].name == evtname:
      for j in 0..app.listeners[i].actions.high:
        if app.listeners[i].actions[j] == fun:
          app.listeners[i].actions.del(j)

proc trigger*(app:App, evtname:string )=
  for i in 0..app.listeners.high:
    if app.listeners[i].name == evtname:
      for j in 0..app.listeners[i].actions.high:
        app.listeners[i].actions[j]()



proc clickedInside*(this:Controll, event:KMEvent): bool =
  ## check if click occured on border, etc - or in usable area of controlls
  result = false
  if this.topY + 1 <= event.y and # +1 label
    this.bottomY >= event.y and
    this.leftX <= event.x and
    this.rightX >= event.x:
      result = true
##############################################################
#[
Notes:

  Label and Border wont have style other than Panel:
    Controll styling seems sufficient

]#
##############################################################
when isMainModule:
  if isTrueColorSupported():
    terminal.enableTrueColors()
    setBackgroundColor(stdout, colDarkBlue)
  else:
    setBackgroundColor(bgBlue)
  eraseScreen()

