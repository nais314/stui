include "controll.inc.nim"
#[
  file format v1: using streams #? binary or text
    header:\x01: HS, w,h,colorm,frames,layers .. \e[2K
    1 line of runes; \x00 == transparent
    row of colors : bg,fg, bg,fg, ...
    \xFF\n if new frame
    layer: \x01 .. \x01: visible, type
      image: \x01 .. \x01: w,h
      sprite: \x01 .. \x01: w,h,frames
      object:  \x01 .. \x01: x,y, type:string \n data:string
    \x02 .. \x03
  
  objects:
    canvas: is a viewport: w,h,frames,layers
    frame: name, duration,  effect
      layer: visible, level for group support
      type:
        image: x,y, w,h, runes,colors
        #sprite: x,y, name : seq[image] - but how to draw sprites? as new canvases? new doc?
        #xsprite: x,y, name : seq[sprite]
        #object: rect, circle, line, text \n data
        #userobject: x,y, name,proc : call proc(x,y,name, canvas)

    sprite, xsprite: table[name, sprite]

  planned:
    drawbox, drawline, drawcircle?, drawtext,
    RGB effects - paintbrush: color only, size

  export: picture, anim

  open future:
    sprites, 
    transformations,
    color transition effects
]#
type
  #[imgPlacementKind* = enum
      ipkNone,
      ipkCenter,
      ipkScale

    Image* = ref object of RootObj 
      placement*: imgPlacementKind
  ]#

  #TransitionEffect = enum
  #  tfxNone

  ToolKind* {.pure.} = enum
    Pencil, # rune only no color
    Brush, # rune and color
    Airbrush, # color only
    Move

  Brush = ref object
    size*: int
    rune*: string
    color*: StyleColor # array[0..3, int]
    #shape*:

  LayerKind* {.pure.} = enum
    Image

  Layer* = ref object of RootObj
    visible*:bool
    level*:int
    typ*:LayerKind
    x,y,w,h:int
    case kind : LayerKind
    of LayerKind.Image:
      
      runes:seq[string]
      colors16:seq[int] # int vs uint8 - ram vs speed
      colors256:seq[int]
      colorsRGB:seq[int]


  Frame* = ref object of RootObj
    name*:string
    dur*:int # duration
    #effect*:TransitionEffect
    layers*:seq[Layer]
    currentLayer*:int

  Canvas* = ref object of Controll
    frames*: seq[Frame]
    asciiOnly*: bool

    currentFrame*:int

    tool*:ToolKind
    brush*: Brush


template activeLayer*(canvas:Canvas): Layer =
  canvas.frames[canvas.currentFrame].layers[canvas.frames[canvas.currentFrame].currentLayer]

template activeFrame*(canvas:Canvas): Frame =
  canvas.frames[canvas.currentFrame]

template activeLayer*(frame:Frame): Layer =
  frame.layers[frame.currentLayer]



proc draw*(this: Canvas, updateOnly: bool = false) =
  if this.visible:
    acquire(this.app.termlock)

    if not updateOnly:
      setColors(this.app, this.win.activeStyle[])
      terminal_extra.setCursorPos(this.x1 + this.activeStyle.margin.left,
                this.y1 + this.activeStyle.margin.top)
      stdout.write this.label

      
      #[ # draw border
      drawBorder(this.activeStyle.border, 
        this.x1 + this.activeStyle.margin.left,
        this.y1 + this.activeStyle.margin.top + 1 #[label]#,
        this.x2 - this.activeStyle.margin.right,
        this.y2 - this.activeStyle.margin.bottom
        ) ]#


    # clear / background
    setColors(this.app, this.activeStyle[])
    drawRect(this.leftX(), this.topY() + 1 , this.rightX(), this.bottomY())



    this.app.setCursorPos()
    release(this.app.termlock)


###* MANDATORY *###
proc drawit(this: Controll, updateOnly: bool = false){.gcsafe.} =
  Canvas(this).draw(updateOnly)
    

proc innerClick*(this:Canvas,event:KMEvent):bool=
  result = event.x >= this.leftX and
    event.x <= this.rightX and
    event.y >= this.topY and
    event.y <= this.bottomY


proc newCanvas*(win:Window, label: string, width:int=20, heigth:int=20): Canvas =
  result = new Canvas
  result.width = width
  result.heigth = heigth
  result.label=label
  result.visible = false
  result.disabled = false
  result.styles = newStyleSheets()
  result.app = win.app
  result.win = win
  result.listeners = @[]
  win.controlls.add(result)

  result.drawit = drawit
  #result.blur = blur
  #result.focus = focus
  #result.onClick = onClick
  #result.onDrag = onDrag
  #result.onDrop = onDrop
  #result.cancel = cancel
  #result.onKeypress = onKeyPress
  #result.onScroll = onScroll

  #var styleNormal: StyleSheetRef = new StyleSheetRef
  result.styles.add("input", new StyleSheetRef)
  result.activeStyle = result.styles["input"]
  result.changeBGColor("input", "black")
  result.changeFGColor("input", "green")