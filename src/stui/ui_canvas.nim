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
    UTF8_Buffer -> aka draw a canvas1 onto canvas2.layer, to do RGB effects, like overlay?
    BufferedDraw -> draw layers onto buffer, to allow effects?
    Ascii-Grayscale-Layer??? @BRP$X0ocv+!;,.

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
    Fill, Ink,
    Move

  Brush* = ref object of RootObj
    size*: int #TODO
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
    visibleArea*: tuple[cx1,cy1,cx2,cy2, x1,y1,x2,y2:int]
    isVisible*: bool



  ImageLayer* = ref object of Layer
    fgColor*: seq[seq[StyleColor]] # y,x, colormode
    bgColor*: seq[seq[StyleColor]] # y,x, colormode

  AsciiImageLayer* = ref object of ImageLayer
    runes*:seq[string] # y,x

  UTFImageLayer* = ref object of ImageLayer
    #runes*:seq[seq[Rune]]
    runes*:seq[seq[string]]



  Frame* = ref object of RootObj
    #name*:string
    dur*:int # duration
    #effect*:TransitionEffect
    layers*:seq[Layer]
    currentLayer*:int

  Canvas* = ref object of ScrollableControll
    frames*: seq[Frame]
    asciiOnly*: bool # experimental
    bufferedDraw*: bool

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



#    ██╗   ██╗████████╗███████╗    ██╗      █████╗ ██╗   ██╗███████╗██████╗ 
#    ██║   ██║╚══██╔══╝██╔════╝    ██║     ██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗
#    ██║   ██║   ██║   █████╗      ██║     ███████║ ╚████╔╝ █████╗  ██████╔╝
#    ██║   ██║   ██║   ██╔══╝      ██║     ██╔══██║  ╚██╔╝  ██╔══╝  ██╔══██╗
#    ╚██████╔╝   ██║   ██║         ███████╗██║  ██║   ██║   ███████╗██║  ██║
#     ╚═════╝    ╚═╝   ╚═╝         ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
                                                                       

proc newUTFImageLayer*(name: string = "layer", w:int=80, h:int=25):UTFImageLayer=
  result = UTFImageLayer(name: name, w:w, h:h)
  result.runes = newSeq[seq[string]](h)
  for i in 0..h-1:
    result.runes[i] = newSeq[string](w)
    for s in 0..w-1:
      result.runes[i][s] = " "

  result.fgColor = newSeq[seq[StyleColor]](h)
  for i in 0..h-1:
    result.fgColor[i] = newSeq[StyleColor](w)

  result.bgColor = newSeq[seq[StyleColor]](h)
  for i in 0..h-1:
    result.bgColor[i] = newSeq[StyleColor](w)



template newUTFImageLayer*(frame:Frame, name: string = "layer", w:int=80, h:int=25)=
  var layer = newUTFImageLayer(name,w,h)
  frame.layers.add(layer)

template newUTFImageLayer*(frame:Frame,at:int = int.high, name: string = "layer", w:int=80, h:int=25)=
  var layer = newUTFImageLayer(name,w,h)
  if at == int.high:
    frame.layers.add(layer)
  else:
    #sequtils proc insert[T](dest: var seq[T]; src: openArray[T]; pos = 0)
    frame.layers.insert(layer,at)

template newUTFImageLayer*(canvas:Canvas, name: string = "layer", w:int=80, h:int=25)=
  canvas.activeFrame.newUTFImageLayer(name,w,h)
#.....................................







proc newFrame*():Frame =
  result = new Frame
  result.layers = @[]

template addNewFrame*(canvas:Canvas)=
  canvas.frames.add(newFrame())

#!------------------------------------------------------------------------------

#[ proc isVisible(canvas:Canvas, layer:Layer):bool=
  if layer.x < 0:
    if layer.x + layer.w - canvas.scrollX < 0: return false
  else:
    if layer.x - canvas.scrollX > canvas.width: return false

  if layer.y < 0:
    if layer.y + layer.h - canvas.scrollY < 0: return false
  else:
    if layer.y - canvas.scrollY > canvas.height: return false
  
  return true
 ]#

proc calcVisibleAreas*(this_elem:Controll)=
  ## calculates wich portion of the layer is visible, if any
  ##  sets layer.isVisible and layer.visibleArea
  let this = Canvas(this_elem)


  for layer in this.activeFrame.layers:
    # set layer.isVisible
    if layer.x < 0:
      if layer.x + layer.w - this.scrollX < 0: layer.isVisible = false
    else:
      if layer.x - this.scrollX > this.width - 1: layer.isVisible = false

    if layer.y < 0:
      if layer.y + layer.h - this.scrollY < 0: layer.isVisible = false
    else:
      if layer.y - this.scrollY > this.height - 1: layer.isVisible = false
    
    layer.isVisible = true

      
    if layer of AsciiImageLayer or layer of UTFImageLayer:
      # the canvases first x position 
      layer.visibleArea.cx1 = layer.x - this.scrollX # scrollX is positive
      if layer.visibleArea.cx1 < 0: layer.visibleArea.cx1 = 0

      # the canvases first y position 
      layer.visibleArea.cy1 = layer.y - this.scrollY # scrollY is positive
      if layer.visibleArea.cy1 < 0: layer.visibleArea.cy1 = 0


      # the layers first visible x in layer coordinates
      layer.visibleArea.x1 = layer.x - this.scrollX #TODO EDGETEST
      if layer.visibleArea.x1 < 0:
        layer.visibleArea.x1 = layer.visibleArea.x1 * -1
      else:
        layer.visibleArea.x1 = 0

      # the layers first visible y in layer coordinates
      layer.visibleArea.y1 = layer.y - this.scrollY
      if layer.visibleArea.y1 < 0:
        layer.visibleArea.y1 = layer.visibleArea.y1 * -1
      else: layer.visibleArea.y1 = 0

      # the layers Last visible x in layer coordinates
      layer.visibleArea.x2 = layer.visibleArea.x1 +
        getMin(layer.w - layer.visibleArea.x1,
          this.width - layer.visibleArea.cx1) - 1

      # the layers Last visible y in layer coordinates
      layer.visibleArea.y2 = layer.visibleArea.y1 +
        getMin(layer.h - layer.visibleArea.y1,
          this.height - layer.visibleArea.cy1) - 1

  #debug "calcVisibleAreas" #TODO





proc calcImgPos*(canvas:Canvas, layer:Layer, x,y:int):tuple[visible:bool, x,y:int]=
  ## calculates layer position from terminal position
  result.visible = false
  ## calc click position on image
  var diffX, diffY: int
  diffX = (x - canvas.leftX)
  diffY = (y - canvas.topY)

  # screen coordinates to layer coordinates
  if canvas.activeFrame.activeLayer.x == 0:
    result.x = diffX
  if canvas.activeFrame.activeLayer.x < 0:
    result.x = abs(canvas.activeFrame.activeLayer.x) + diffX
  if canvas.activeFrame.activeLayer.x > 0:
    result.x = diffX - canvas.activeFrame.activeLayer.x

  result.x += canvas.scrollX

  if canvas.activeFrame.activeLayer.y == 0:
    result.y = diffY
  if canvas.activeFrame.activeLayer.y < 0:
    result.y = abs(canvas.activeFrame.activeLayer.y) + diffY
  if canvas.activeFrame.activeLayer.y > 0:
    result.y = diffY - canvas.activeFrame.activeLayer.y

  result.y += canvas.scrollY

  if result.x < canvas.activeLayer.w and result.y < canvas.activeLayer.h:
    result.visible = true


proc drawPixel*(this:Canvas, cx,cy:int)= #TODO
  ## draw a pixel after event occurs, event.x event.y
  #[ let
    cx = x
    cy = y ]#

  for layer in this.activeFrame.layers:
    if layer of AsciiImageLayer:
      let imgPos = calcImgPos(this,layer,cx,cy)

      if imgPos.visible #[ and
        imgPos.x in layer.visibleArea.x1 .. layer.visibleArea.x2 and
        imgPos.y in layer.visibleArea.y1 .. layer.visibleArea.y2 ]#
        :

          setForegroundColor(AsciiImageLayer(layer).
            fgColor[imgPos.y][imgPos.x][this.app.colorMode])
          setBackgroundColor(AsciiImageLayer(layer).
            bgColor[imgPos.y][imgPos.x][this.app.colorMode])

          terminal_extra.setCursorPos(cx, cy)
          stdout.write(AsciiImageLayer(layer).
            runes[imgPos.y][imgPos.x])
          
          #echo "X" #!DEBUG

proc setPixelColor*(layer:ImageLayer, x,y:int, fgColor:StyleColor, bgColor:StyleColor)=
  layer.fgColor[y][x] = fgColor
  layer.bgColor[y][x] = bgColor







proc drawPixelBuffered*(this:Canvas, cx,cy:int)= #TODO
  ## draw a pixel after event occurs, event.x event.y
  var buffer : tuple[rune:string, fgColor,bgColor:StyleColor]

  for layer in this.activeFrame.layers:
    if layer of AsciiImageLayer:
      let imgPos = calcImgPos(this,layer,cx,cy)

      if imgPos.visible #[ and
        imgPos.x in layer.visibleArea.x1 .. layer.visibleArea.x2 and
        imgPos.y in layer.visibleArea.y1 .. layer.visibleArea.y2 ]#
        :

        if AsciiImageLayer(layer).bgColor[imgPos.y][imgPos.x][1] != 0:
          buffer.rune = $AsciiImageLayer(layer).runes[imgPos.y][imgPos.x]
          buffer.fgColor = AsciiImageLayer(layer).fgColor[imgPos.y][imgPos.x]
          buffer.bgColor = AsciiImageLayer(layer).bgColor[imgPos.y][imgPos.x]

    if layer of UTFImageLayer:
      let imgPos = calcImgPos(this,layer,cx,cy)

      if imgPos.visible #[ and
        imgPos.x in layer.visibleArea.x1 .. layer.visibleArea.x2 and
        imgPos.y in layer.visibleArea.y1 .. layer.visibleArea.y2 ]#
        :

        if  UTFImageLayer(layer).bgColor[imgPos.y][imgPos.x][1] != 0:
          buffer.rune = UTFImageLayer(layer).runes[imgPos.y][imgPos.x]
          buffer.fgColor = UTFImageLayer(layer).fgColor[imgPos.y][imgPos.x]
          buffer.bgColor = UTFImageLayer(layer).bgColor[imgPos.y][imgPos.x]
          #echo "X" #!DEBUG
  setForegroundColor(buffer.fgColor[this.app.colorMode])
  setBackgroundColor(buffer.bgColor[this.app.colorMode])

  terminal_extra.setCursorPos(cx, cy)
  stdout.write(buffer.rune)




proc drawBuffered*(this: Canvas, updateOnly: bool = false) =
  if this.visible:
    acquire(this.app.termlock)

    if not updateOnly:
      calcVisibleAreas(this)

    # clear / background
    setColors(this.app, this.activeStyle[])
    drawRect(this.leftX(), this.topY(), this.rightX(), this.bottomY())
    #echo " debug: ", getTotalMem(), " = ", getTotalMem() div 1024, "kb "#times.epochTime() #! DEBUG
    #terminal_extra.setCursorPos(this.leftX, this.topY - 1) #! DEBUG
    #echo "12345678901234567890" #! DEBUG


    var buffer = newUTFImageLayer("buffer", this.app.terminalWidth, this.app.terminalHeight)

    for layer in this.activeFrame.layers:
      if layer of AsciiImageLayer:
        #terminal_extra.setCursorPos(this.leftX, this.topY - 1) #! DEBUG
        #echo layer.visibleArea

        var
          lx = layer.visibleArea.x1
          ly = layer.visibleArea.y1
        for cy in layer.visibleArea.cy1..this.bottomY:
          for cx in layer.visibleArea.cx1..this.rightX:

            if AsciiImageLayer(layer).bgColor[ly][lx][1] != 0:
              buffer.runes[cy][cx] = $AsciiImageLayer(layer).runes[ly][lx]
              buffer.fgColor[cy][cx] = AsciiImageLayer(layer).fgColor[ly][lx]
              buffer.bgColor[cy][cx] = AsciiImageLayer(layer).bgColor[ly][lx]

            if lx == layer.visibleArea.x2:
              lx = layer.visibleArea.x1
              break
            lx += 1
          
          if ly == layer.visibleArea.y2:
            break
          ly += 1


        #setColors(this.app, this.win.activeStyle[]) #! DEBUG
        #echo "\n", layer.visibleArea,"\n", this.width #! DEBUG


      if layer of UTFImageLayer:
        #terminal_extra.setCursorPos(this.leftX, this.topY - 1) #! DEBUG
        #echo layer.visibleArea
        var
          lx = layer.visibleArea.x1
          ly = layer.visibleArea.y1
        for cy in layer.visibleArea.cy1..this.bottomY:
          for cx in layer.visibleArea.cx1..this.rightX:

            if UTFImageLayer(layer).bgColor[ly][lx][1] != 0:
              buffer.runes[cy][cx] = UTFImageLayer(layer).runes[ly][lx]
              buffer.fgColor[cy][cx] = UTFImageLayer(layer).fgColor[ly][lx]
              buffer.bgColor[cy][cx] = UTFImageLayer(layer).bgColor[ly][lx]

            if lx == layer.visibleArea.x2:
              lx = layer.visibleArea.x1
              break
            lx += 1
          
          if ly == layer.visibleArea.y2:
            break
          ly += 1


    for cy in this.scrollY .. this.scrollY + this.height - 1:
      if cy >= buffer.h: break
      for cx in this.scrollX .. this.scrollX + this.width - 1:
        if cx >= buffer.w: break
        terminal_extra.setCursorPos(this.leftX + cx - this.scrollX, 
            this.topY + cy - this.scrollY)
        setForegroundColor(buffer.fgColor[cy][cx][this.app.colorMode])
        setBackgroundColor(buffer.bgColor[cy][cx][this.app.colorMode])
        stdout.write(buffer.runes[cy][cx])



    this.app.setCursorPos()
    release(this.app.termlock)






proc draw*(this: Canvas, updateOnly: bool = false) = #--------------------------
  #calcVisibleAreas(this)
  if this.bufferedDraw:
    drawBuffered(this, updateOnly)
  else:
      
    if this.visible:
      acquire(this.app.termlock)

      if not updateOnly:
        calcVisibleAreas(this)


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
          #terminal_extra.setCursorPos(this.leftX, this.topY - 1) #! DEBUG
          #echo layer.visibleArea

          var
            lx = layer.visibleArea.x1
            ly = layer.visibleArea.y1
          for cy in layer.visibleArea.cy1..this.bottomY:
            for cx in layer.visibleArea.cx1..this.rightX:
              #terminal_extra.setCursorPos(this.x1 + cx, this.y1 + cy)
              terminal_extra.setCursorPos(this.leftX + cx, this.topY + cy)

              setForegroundColor(AsciiImageLayer(layer).fgColor[ly][lx][this.app.colorMode])
              setBackgroundColor(AsciiImageLayer(layer).bgColor[ly][lx][this.app.colorMode])

              stdout.write(AsciiImageLayer(layer).runes[ly][lx])            

              if lx == layer.visibleArea.x2:
                lx = layer.visibleArea.x1
                break
              lx += 1
            
            if ly == layer.visibleArea.y2:
              break
            ly += 1


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