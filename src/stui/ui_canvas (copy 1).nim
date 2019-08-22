include "controll_inc.nim"
import uiext_scrollable
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
    Eraser,
    Move

  Brush = ref object
    size*: int
    rune*: string
    fgColor*: StyleColor # array[0..3, int]
    bgColor*: StyleColor # array[0..3, int]
    #shape*:

  LayerKind* {.pure.} = enum
    Image,
    UTFImage

  Layer* = ref object of RootObj
    name*: string
    level*: int
    typ*: LayerKind
    x*,y*,w*,h*: int

    offscreen: bool # is it visible or off-screen

    visible*: bool #? may put into props tuple?
    visibleArea*: tuple[x1,y1,x2,y2:int]

  AsciiImageLayer* = ref object of Layer
    runes*:seq[string]
    fgColor*: seq[seq[StyleColor]] # y,x, colormode
    bgColor*: seq[seq[StyleColor]] # y,x, colormode
    #[ colors16*:seq[seq[int]] #? int vs uint8 - ram vs speed
    colors256*:seq[seq[int]]
    colorsRGB*:seq[seq[int]] ]#

  UTFImageLayer* = ref object of Layer
    runes*:seq[seq[Rune]]
    colors16*:seq[seq[int]] #? int vs uint8 - ram vs speed
    colors256*:seq[seq[int]]
    colorsRGB*:seq[seq[int]]


  Frame* = ref object of RootObj
    #name*:string
    dur*:int # duration
    #effect*:TransitionEffect
    layers*:seq[Layer]
    currentLayer*:int

  Canvas* = ref object of ScrollableControll
    frames*: seq[Frame]
    asciiOnly*: bool

    currentFrame*: int

    tool*: ToolKind
    brush*: Brush
    eraser*: Brush

#!------------------------------------------------------------------------------

template activeLayer*(canvas:Canvas): Layer =
  canvas.frames[canvas.currentFrame].layers[canvas.frames[canvas.currentFrame].currentLayer]

template activeFrame*(canvas:Canvas): Frame =
  canvas.frames[canvas.currentFrame]

template activeLayer*(frame:Frame): Layer =
  frame.layers[frame.currentLayer]


#.....................................
#      ###     ######   ######  #### ####       #### ##     ##  ######   
#     ## ##   ##    ## ##    ##  ##   ##         ##  ###   ### ##    ##  
#    ##   ##  ##       ##        ##   ##         ##  #### #### ##        
#   ##     ##  ######  ##        ##   ##  #####  ##  ## ### ## ##   #### 
#   #########       ## ##        ##   ##         ##  ##     ## ##    ##  
#   ##     ## ##    ## ##    ##  ##   ##         ##  ##     ## ##    ##  
#   ##     ##  ######   ######  #### ####       #### ##     ##  ######   

proc newAsciiImageLayer*(name: string = "layer", w:int=80, h:int=25):AsciiImageLayer=
  result = AsciiImageLayer(name: name, w:w, h:h)
  result.runes = newSeq[string](h)
  for i in 0..h-1:
    result.runes[i].setLen(w)
    result.runes[i] = " " * w

  result.fgColor = newSeq[seq[StyleColor]](h)
  for i in 0..h-1:
    result.fgColor[i] = newSeq[StyleColor](w)

  result.bgColor = newSeq[seq[StyleColor]](h)
  for i in 0..h-1:
    result.bgColor[i] = newSeq[StyleColor](w)

  #[ result.fgColor = newSeq[seq[seq[int]]](4)
  for ic in 0..3:
    result.fgColor[ic] = newSeq[seq[int]](h)
    for iy in 0..h-1:
      result.fgColor[ic][iy] = newSeq[int](w) ]#
  #[ result.colors16 = newSeq[seq[int]](h)
  result.colors256 = newSeq[seq[int]](h)
  result.colorsRGB = newSeq[seq[int]](h)
  for i in 0..h-1:
    result.colors16[i] = newSeq[int](w)
    result.colors256[i] = newSeq[int](w)
    result.colorsRGB[i] = newSeq[int](w) ]#

template newAsciiImageLayer*(frame:Frame, name: string = "layer", w:int=80, h:int=25)=
  var layer = newAsciiImageLayer(name,w,h)
  frame.layers.add(layer)

template newAsciiImageLayer*(frame:Frame,at:int = int.high, name: string = "layer", w:int=80, h:int=25)=
  var layer = newAsciiImageLayer(name,w,h)
  if at == int.high:
    frame.layers.add(layer)
  else:
    #sequtils proc insert[T](dest: var seq[T]; src: openArray[T]; pos = 0)
    frame.layers.insert(layer,at)

template newAsciiImageLayer*(canvas:Canvas, name: string = "layer", w:int=80, h:int=25)=
  canvas.activeFrame.newAsciiImageLayer(name,w,h)
#.....................................


proc newFrame*():Frame =
  result = new Frame
  result.layers = @[]

template addNewFrame*(canvas:Canvas)=
  canvas.frames.add(newFrame())

#!------------------------------------------------------------------------------

proc isOffCanvas(canvas:Canvas, layer:Layer):bool=
  if layer.x < 0:
    if layer.x + layer.w - canvas.scrollX < 0: return false
  else:
    if layer.x - canvas.scrollX > canvas.width: return false

  if layer.y < 0:
    if layer.y + layer.h - canvas.scrollY < 0: return false
  else:
    if layer.y - canvas.scrollY > canvas.height: return false
  
  return true


proc calcVisibleAreas*(this_elem:Controll)=
  let this = Canvas(this_elem)
  for layer in this.activeFrame.layers:
    if layer of AsciiImageLayer:
      layer.visibleArea.x1 = this.scrollX +
                              AsciiImageLayer(layer).x #TODO EDGETEST

      layer.visibleArea.x2 = this.scrollX +
                              AsciiImageLayer(layer).x +
                              this.width - 1 #TODO EDGETEST
      if layer.visibleArea.x2 > AsciiImageLayer(layer).w:
        layer.visibleArea.x2 = AsciiImageLayer(layer).x + 
                                AsciiImageLayer(layer).w - 1 #TODO EDGETEST

      layer.visibleArea.y1 = this.scrollY +
                              AsciiImageLayer(layer).y #TODO EDGETEST

      layer.visibleArea.y2 = this.scrollY +
                              this.height - 1 + #TODO EDGETEST
                              AsciiImageLayer(layer).y

  #debug "calcVisibleAreas" #TODO



proc drawPixel*(this:Canvas, cx,cy:int)=
  ## draw a pixel after event occurs, event.x event.y
  #[ let
    cx = x
    cy = y ]#

  for layer in this.activeFrame.layers:
    if layer of AsciiImageLayer:
      if cx in layer.visibleArea.x1 .. layer.visibleArea.x2 and
        cy in layer.visibleArea.y1 .. layer.visibleArea.y2:

          setForegroundColor(AsciiImageLayer(layer).
            fgColor[(this.scrollY + layer.y) + cy][(this.scrollX + layer.x) + cx][this.app.colorMode])
          setBackgroundColor(AsciiImageLayer(layer).
            bgColor[(this.scrollY + layer.y) + cy][(this.scrollX + layer.x) + cx][this.app.colorMode])

          terminal_extra.setCursorPos(this.leftX + cx, this.topY + cy)
          stdout.write(AsciiImageLayer(layer).
            runes[(this.scrollY + layer.y) + cy][(this.scrollX + layer.x) + cx])
          
          #echo "X" #!DEBUG

proc setPixelColor*(layer:AsciiImageLayer, x,y:int, fgColor:StyleColor, bgColor:StyleColor)=
  layer.fgColor[y][x] = fgColor
  layer.bgColor[y][x] = bgColor

proc draw*(this: Canvas, updateOnly: bool = false) =
  #calcVisibleAreas(this)
  if this.visible:
    acquire(this.app.termlock)

    #[ if not updateOnly:
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
        ) ]# ]#


    # clear / background
    setColors(this.app, this.activeStyle[])
    drawRect(this.leftX(), this.topY(), this.rightX(), this.bottomY())
    #echo " debug: ", getTotalMem(), " = ", getTotalMem() div 1024, "kb "#times.epochTime() #! DEBUG
    #terminal_extra.setCursorPos(this.leftX, this.topY - 1) #! DEBUG
    #echo "12345678901234567890" #! DEBUG

    for layer in this.activeFrame.layers:
      if layer of AsciiImageLayer:
        var
          #[ x = Canvas(this).scrollX
          y = Canvas(this).scrollY ]#
          visibleRows, visibleCols:int


        #if this.scrollX + this.width
        if this.scrollX + this.width >
          (AsciiImageLayer(layer).w + AsciiImageLayer(layer).x):

            visibleCols = (AsciiImageLayer(layer).w + 
                          AsciiImageLayer(layer).x) -
                          this.scrollX
            if visibleCols < 0: visibleCols = 0
        
        else:
          visibleCols = this.width

        #.............................
        if this.scrollY + this.height > 
          (AsciiImageLayer(layer).runes.len + AsciiImageLayer(layer).y):

            visibleRows = (AsciiImageLayer(layer).runes.len + 
                          AsciiImageLayer(layer).y) - 
                          this.scrollY
            
            if visibleRows < 0: visibleRows = 0

        else:
          visibleRows = this.height

        #.............................

        if visibleRows > 0 and visibleCols > 0:
          var cursorY = this.topY
          for cy in (this.scrollY + AsciiImageLayer(layer).y) .. 
            (visibleRows - 1) + (this.scrollY + AsciiImageLayer(layer).y):

              terminal_extra.setCursorPos(this.leftX, cursorY)

              for cx in (this.scrollX + AsciiImageLayer(layer).x) .. 
                (this.scrollX + AsciiImageLayer(layer).x) + (visibleCols - 1):

                  setForegroundColor(AsciiImageLayer(layer).fgColor[cy][cx][this.app.colorMode])
                  setBackgroundColor(AsciiImageLayer(layer).bgColor[cy][cx][this.app.colorMode])

                  stdout.write(AsciiImageLayer(layer).runes[cy][cx])
              #[ stdout.write(AsciiImageLayer(layer).runes[c][
                (this.scrollX + AsciiImageLayer(layer).x) .. 
                (this.scrollX + AsciiImageLayer(layer).x) + (visibleCols - 1)]) ]#

              cursorY += 1
        #echo visibleRows #! DEBUG
        #setColors(this.app, this.win.activeStyle[]) #! DEBUG
        #echo "\n", layer.visibleArea,"\n", this.width #! DEBUG


      if layer of UTFImageLayer: discard



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


proc newCanvas*(win:Window, label: string, width:int=20, height:int=20): Canvas =
  result = new Canvas
  result.width = width
  result.height = height
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
  result.onRecalc = calcVisibleAreas

  #var styleNormal: StyleSheetRef = new StyleSheetRef
  result.styles.add("input", new StyleSheetRef)
  result.activeStyle = result.styles["input"]
  result.changeBGColor("input", "black")
  result.changeFGColor("input", "green")

  result.tool = ToolKind.Brush
  result.brush = new Brush
  result.brush.size = 1
  result.brush.rune = "#"
  result.brush.fgColor = [37,37,15,int(packRGB(255,255,255))]
  result.brush.bgColor = [40,40,0,int(packRGB(0,0,0))]

  result.eraser = new Brush
  result.eraser.size = 1
  result.eraser.rune = " "
  result.eraser.fgColor = [0,0,0,int(packRGB(0,0,0))]
  result.eraser.bgColor = [0,0,0,int(packRGB(0,0,0))]

  result.frames = @[]


proc newCanvas*(win:Window, label: string, width:string, height:string): Canvas =
  result = newCanvas(win, label)
  discard width.parseInt(result.width_value)
  discard height.parseInt(result.height_value)