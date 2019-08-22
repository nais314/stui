import stui/[ui_fileselect, ui_button, ui_textbox, ui_selectbox]
import stui/colors/[Color256RGB, rgbtoterminal, HSLtools]
################################################################################

# appWS for opening, saving, new, etc

app.activeWorkSpace = app.newWorkSpace("appWS")
app.activeTile = app.activeWorkSpace.newTile("auto")
app.activeTile.id = "appWS" # == app.workSpaces[0].tiles[0].id = "TILE ID"

let appWin = app.activeTile.newWindow()
#app.activeTile.windows[0].styles["window"].padding.left = 1
#app.activeTile.windows[0].styles["window"].padding.top = 1
app.activeTile.windows[0].label = "File"

#[ discard app.workSpaces[0].newTile("24ch") # 24 char wide tile
var ws1_W2 = app.workSpaces[0].tiles[1].newWindow()
ws1_W2.styles.add("dock", app.styles["dock"])
ws1_W2.activeStyle = ws1_W2.styles["dock"]
ws1_W2.label = "dock" ]#

#.........................................................................

let infoText = app.activeWindow.newStaticTextArea("static text", 27,5)
infoText.value= """
Welcome to Splash Painter!
press:
F1: Help
"""



#import stui/ui_fileselect
let fileSelect = appWin.newFileSelect("image file")
proc fileSelectOnChange()=
  ## open or create file
  discard

let openBtn = appWin.newButton("Open file", 1,0)
let saveBtn = appWin.newButton("Save file", 1,0)

let widthTxt = appWin.newTextBox("image width")
widthTxt.value= "80"
let heightTxt = appWin.newTextBox("image height")
heightTxt.value= "25"

appWin.controlls.setMargin("top","1", "left","1")




#!==============================================================================

#         ##     ## ######## ##       ########  
#         ##     ## ##       ##       ##     ## 
#         ##     ## ##       ##       ##     ## 
#         ######### ######   ##       ########  
#         ##     ## ##       ##       ##        
#         ##     ## ##       ##       ##        
#         ##     ## ######## ######## ##        


var helpWS = app.newWorkSpace("helpWS")
discard helpWS.newTile("auto")
helpWS.tiles[0].id = "helpWS"

var helpWin = helpWS.tiles[0].newWindow()
helpWin.styles["window"].padding.left = 1
helpWin.styles["window"].padding.top = 1
helpWin.label = "Help"

var helpText = helpWin.newStaticTextArea("help", "100","100")
helpText.value = """
Welcome to Splash Painter!
(scroll this textbox to read more)

WorkSpaces:
  F1: Help - this screen
  F2: File menu
  F3: Paint area
  F4: Colorpicker F4, again: Toolbox
"""


#!==============================================================================


#          ######     ###    ##    ## ##     ##    ###     ######  
#         ##    ##   ## ##   ###   ## ##     ##   ## ##   ##    ## 
#         ##        ##   ##  ####  ## ##     ##  ##   ##  ##       
#         ##       ##     ## ## ## ## ##     ## ##     ##  ######  
#         ##       ######### ##  ####  ##   ##  #########       ## 
#         ##    ## ##     ## ##   ###   ## ##   ##     ## ##    ## 
#          ######  ##     ## ##    ##    ###    ##     ##  ######  



# imgWS for painting
#TODO widget statusbar
#DONE fullscreen window - no titlebar

var imgWS = app.newWorkSpace("imgWS")
discard imgWS.newTile("auto")
imgWS.tiles[0].id = "imgWS"

var imgWin = imgWS.tiles[0].newWindow()
#imgWin.styles["window"].padding.left = 1
#imgWin.styles["window"].padding.top = 1
imgWin.label = "Image"
imgWin.fullScreen = true

imgWin.activeStyle.bgColor = [44,44,237,packRGB(128,128,128).int]

#.......................................
import stui/ui_canvas
import stui/canvasasciitools, stui/canvasutftools
var canvas = imgWin.newCanvas("canvas",40,15)
canvas.bufferedDraw = true

canvas.addNewFrame() # == canvas.frames.add(newFrame())
canvas.newUTFImageLayer(name="zumm", 10,10)
canvas.newAsciiImageLayer() # == canvas.activeFrame.newAsciiImageLayer()
#TODO layers across canvas? or tween layers?
#TODO difference img vs sprite: move handling: fill \x00 vs

#         ######## ##     ## ######## ##    ## ######## 
#         ##       ##     ## ##       ###   ##    ##    
#         ##       ##     ## ##       ####  ##    ##    
#         ######   ##     ## ######   ## ## ##    ##    
#         ##        ##   ##  ##       ##  ####    ##    
#         ##         ## ##   ##       ##   ###    ##    
#         ########    ###    ######## ##    ##    ##    

proc canvasOnClick(this: Controll, event:KMEvent)=
  #var canvas = Canvas(this)
  var imgX, imgY, RX, RY: int

  proc calcImgPos():bool=
    result = false
    ## calc click position on image
    var diffX, diffY: int
    diffX = (event.x - canvas.leftX)
    diffY = (event.y - canvas.topY)

    # screen coordinates to layer coordinates
    if canvas.activeFrame.activeLayer.x == 0:
      RX = diffX
    if canvas.activeFrame.activeLayer.x < 0:
      RX = abs(canvas.activeFrame.activeLayer.x) + diffX
    if canvas.activeFrame.activeLayer.x > 0:
      RX = diffX - canvas.activeFrame.activeLayer.x

    RX += canvas.scrollX

    if canvas.activeFrame.activeLayer.y == 0:
      RY = diffY
    if canvas.activeFrame.activeLayer.y < 0:
      RY = abs(canvas.activeFrame.activeLayer.y) + diffY
    if canvas.activeFrame.activeLayer.y > 0:
      RY = diffY - canvas.activeFrame.activeLayer.y

    RY += canvas.scrollY

    if RX < canvas.activeLayer.w and RY < canvas.activeLayer.h:
      result = true

  #..................................
  






  case event.evType:
  of KMEventKind.Click, KMEventKind.InnerDrag, KMEventKind.Drag:
    if canvas.innerClick(event):
      if canvas.activeLayer of ImageLayer:
        #[ canvas.activeLayer of AsciiImageLayer or
        canvas.activeLayer of UTFImageLayer
      : ]#
        if calcImgPos():
          #echo RX,", ", RY, ",,", canvas.activeLayer.w#!DEBUG

          case canvas.tool:
          of ToolKind.Pencil: # char only
            if canvas.activeLayer of AsciiImageLayer:
              AsciiImageLayer(canvas.activeLayer).runes[RY][RX] = canvas.brush.rune[0]
            else:
              UTFImageLayer(canvas.activeLayer).runes[RY][RX] = canvas.brush.rune
            #canvas.drawPixel(event.x, event.y)
            #canvas.draw(true)
            canvas.drawPixelBuffered(event.x, event.y)

          of ToolKind.Brush: # char and color
            tryIt:
              if canvas.activeLayer of AsciiImageLayer:
                AsciiImageLayer(canvas.activeLayer).runes[RY][RX] = canvas.brush.rune[0]
              else:
                UTFImageLayer(canvas.activeLayer).runes[RY][RX] = canvas.brush.rune

              ImageLayer(canvas.activeLayer).setPixelColor(
                RX, RY, canvas.brush.fgColor,
                canvas.brush.bgColor)
              #canvas.drawPixel(event.x, event.y)
              #canvas.draw(true)
              canvas.drawPixelBuffered(event.x, event.y)

          of ToolKind.Airbrush: # only color
            ImageLayer(canvas.activeLayer).setPixelColor(
              RX, RY, canvas.brush.fgColor,
              canvas.brush.bgColor)
            #canvas.drawPixel(event.x, event.y)
            #canvas.draw(true)
            canvas.drawPixelBuffered(event.x, event.y)

          of ToolKind.Eraser:
            if canvas.activeLayer of AsciiImageLayer:
              AsciiImageLayer(canvas.activeLayer).runes[RY][RX] = canvas.eraser.rune[0]
            else:
              UTFImageLayer(canvas.activeLayer).runes[RY][RX] = canvas.brush.rune

            ImageLayer(canvas.activeLayer).setPixelColor(
              RX, RY, canvas.eraser.fgColor,
              canvas.eraser.bgColor)
            #canvas.drawPixel(event.x, event.y)
            #canvas.draw(true)
            canvas.drawPixelBuffered(event.x, event.y)




          of ToolKind.Fill:

            
            #...........................

            if calcImgPos():
              var
                oldColor = new Brush

              oldColor.fgColor = ImageLayer(canvas.activeLayer).fgColor[RY][RX]
              oldColor.bgColor = ImageLayer(canvas.activeLayer).bgColor[RY][RX]

              tryIt:
                #canvas.brush.rune = "+"
                #floodFillScanline(RX,RY, canvas.brush, oldColor)
                if canvas.activeLayer of AsciiImageLayer:
                  oldColor.rune = $AsciiImageLayer(canvas.activeLayer).runes[RY][RX]
                  #oldColor.fgColor = AsciiImageLayer(canvas.activeLayer).fgColor[RY][RX]
                  #oldColor.bgColor = AsciiImageLayer(canvas.activeLayer).bgColor[RY][RX]
                  floodFillScanline(AsciiImageLayer(canvas.activeLayer), RX,RY,
                                                        canvas.brush, oldColor)
                else:
                  oldColor.rune = UTFImageLayer(canvas.activeLayer).runes[RY][RX]
                  #oldColor.fgColor = UTFImageLayer(canvas.activeLayer).fgColor[RY][RX]
                  #oldColor.bgColor = UTFImageLayer(canvas.activeLayer).bgColor[RY][RX]
                  UTFImageLayer(canvas.activeLayer).floodFillScanline(RX,RY,
                                                        canvas.brush, oldColor)

              canvas.draw(true)




          of ToolKind.Ink:
            #...........................

            if calcImgPos():
              var
                oldColor = new Brush
              oldColor.fgColor = AsciiImageLayer(canvas.activeLayer).fgColor[RY][RX]
              oldColor.bgColor = AsciiImageLayer(canvas.activeLayer).bgColor[RY][RX]

              tryIt:
                floodInkScanline(ImageLayer(canvas.activeLayer), RX,RY, canvas.brush, oldColor)

              canvas.draw(true)

          of ToolKind.Move:
            discard
            #TODO save x,y











      #[ if canvas.activeLayer of UTFImageLayer:
        if calcImgPos():
          #echo RX,", ", RY, ",,", canvas.activeLayer.w#!DEBUG

          case canvas.tool:
          of ToolKind.Pencil: # char only
            UTFImageLayer(canvas.activeLayer).runes[RY][RX] = canvas.brush.rune
            #canvas.drawPixel(event.x, event.y)
            #canvas.draw(true)
            canvas.drawPixelBuffered(event.x, event.y)

          of ToolKind.Brush: # char and color
            tryIt:
              UTFImageLayer(canvas.activeLayer).runes[RY][RX] = canvas.brush.rune
              UTFImageLayer(canvas.activeLayer).setPixelColor(
                RX, RY, canvas.brush.fgColor,
                canvas.brush.bgColor)
              #canvas.drawPixel(event.x, event.y)
              #canvas.draw(true)
              canvas.drawPixelBuffered(event.x, event.y)

          else: discard ]#

  else: discard

canvas.onClick = canvasOnClick
canvas.onInnerDrag = canvasOnClick
canvas.onDrag = canvasOnClick


var prevOnRecalc = canvas.onRecalc
proc canvasOnRecalc(this_elem:Controll)=
  var this = Canvas(this_elem)

  if this.app.terminalWidth - 1 > this.width:
    this.x1 += (this.app.terminalWidth - this.width) div 2
    this.x2 += (this.app.terminalWidth - this.width) div 2

  if this.app.terminalHeight - 1 > this.height:
    this.y1 += (this.app.terminalHeight - this.height) div 2
    this.y2 += (this.app.terminalHeight - this.height) div 2

  debug this.app.terminalWidth, ", ", this.width

  #calcVisibleAreas(this_elem) #! it would be overwritten
  prevOnRecalc(this_elem)

canvas.onRecalc = canvasOnRecalc

#-------------------------------------------------------------------------------

proc canvasOnKeypress(this: Controll, event: KMEvent)=
  if not this.disabled:
    case event.evType:
    of KMEventKind.FnKey, KMEventKind.Char: #.....FnKey.....FnKey.....FnKey.....FnKey
      this.trigger(event.key):
    of KMEventKind.CtrlKey:
      this.trigger($ event.ctrlKey)
    else: discard

canvas.onKeypress = canvasOnKeypress

#TODO visibleareas?
proc canvasOnKeyRight(source:Controll)=
  canvas.scrollX += 1
  sleep(5)
  canvas.draw(false)

proc canvasOnKeyLeft(source:Controll)=
  if canvas.scrollX > 0:
    canvas.scrollX -= 1
    sleep(5)
    canvas.draw(false)

canvas.addEventListener(KeyRight, canvasOnKeyRight)
canvas.addEventListener(KeyLeft, canvasOnKeyLeft)


#!==============================================================================


#       ########  #######   #######  ##        ######  
#          ##    ##     ## ##     ## ##       ##    ## 
#          ##    ##     ## ##     ## ##       ##       
#          ##    ##     ## ##     ## ##        ######  
#          ##    ##     ## ##     ## ##             ## 
#          ##    ##     ## ##     ## ##       ##    ## 
#          ##     #######   #######  ########  ######  

#TODO piped dual monitor setup -- appbase

var toolWS = app.newWorkSpace("toolWS")
discard toolWS.newTile("auto")
toolWS.tiles[0].id = "controllWS" # == app.workSpaces[0].tiles[0].id = "TILE ID"

var toolWin = toolWS.tiles[0].newWindow()
toolWin.styles["window"].padding.left = 1
toolWin.styles["window"].padding.top = 1
toolWin.label = "Tools"

discard toolWS.newTile("24ch") # 24 char wide tile
var toolWin2 = toolWS.tiles[1].newWindow()
toolWin2.styles.add("dock", app.styles["dock"])
toolWin2.activeStyle = toolWin2.styles["dock"]
toolWin2.label = "dock"


var 
  btnPencil = toolWin.newButton("pencil", "20")
  btnBrush = toolWin.newButton("brush", "20")
  btnAirbrush = toolWin.newButton("airbrush", "20")
  btnEraser = toolWin.newButton("eraser", "20")
  btnFill = toolWin.newButton("fill", "20")
  btnInk = toolWin.newButton("ink", "20")

#btnBrush.activeStyle = btnBrush.styles["input:focus"]
btnBrush.setActiveStyle("input:focus")

for i in 0..toolWin.controlls.high:
  toolWin.controlls[i].setMargin("bottom", 1)
  if toolWin.controlls[i] of Button:
    toolWin.controlls[i].blur = nil

proc resetBtns()=
  for i in 0..toolWin.controlls.high:
    if toolWin.controlls[i] of Button:
      toolWin.controlls[i].activeStyle = toolWin.controlls[i].styles["input"]
      toolWin.controlls[i].drawit(toolWin.controlls[i], false)

proc usePencil(source: Controll)=
  canvas.tool = ToolKind.Pencil
  resetBtns()
  btnPencil.activeStyle = btnPencil.styles["input:focus"]
  btnPencil.draw()

btnPencil.addEventListener("click", usePencil)

btnBrush.addEventListener("click", proc(source: Controll)= 
  canvas.tool = ToolKind.Brush
  resetBtns()
  btnBrush.activeStyle = btnBrush.styles["input:focus"]
  btnBrush.draw()
  )


btnAirbrush.addEventListener("click", proc(source: Controll)= 
  canvas.tool = ToolKind.Airbrush
  resetBtns()
  btnAirbrush.activeStyle = btnAirbrush.styles["input:focus"]
  btnAirbrush.draw()
  )


btnEraser.addEventListener("click", proc(source: Controll)= 
  canvas.tool = ToolKind.Eraser
  resetBtns()
  btnEraser.activeStyle = btnEraser.styles["input:focus"]
  btnEraser.draw()
  )


btnFill.addEventListener("click", proc(source: Controll)= 
  canvas.tool = ToolKind.Fill
  resetBtns()
  btnFill.activeStyle = btnFill.styles["input:focus"]
  btnFill.draw()
  )


btnInk.addEventListener("click", proc(source: Controll)= 
  canvas.tool = ToolKind.Ink
  resetBtns()
  btnInk.activeStyle = btnInk.styles["input:focus"]
  btnInk.draw()
  )
#!==============================================================================


#          ######   #######  ##        #######  ########  
#         ##    ## ##     ## ##       ##     ## ##     ## 
#         ##       ##     ## ##       ##     ## ##     ## 
#         ##       ##     ## ##       ##     ## ########  
#         ##       ##     ## ##       ##     ## ##   ##   
#         ##    ## ##     ## ##       ##     ## ##    ##  
#          ######   #######  ########  #######  ##     ## 

#TODO piped dual monitor setup -- appbase

var colorWS = app.newWorkSpace("colorWS")
discard colorWS.newTile("auto")
colorWS.tiles[0].id = "colorWS" # == app.workSpaces[0].tiles[0].id = "TILE ID"

var colorWin = colorWS.tiles[0].newWindow()
colorWin.styles["window"].padding.left = 1
colorWin.styles["window"].padding.top = 1
colorWin.label = "Colors"

discard colorWS.newTile("24ch") # 24 char wide tile
var colorWin2 = colorWS.tiles[1].newWindow()
colorWin2.styles.add("dock", app.styles["dock"])
colorWin2.activeStyle = colorWin2.styles["dock"]
colorWin2.label = "dock"


var
  #cp256 = colorWin.newColorpicker256(width="100", height="100")
  cp256 = colorWin.newColorpicker256(width=32)
  btnFGC = colorWin2.newButton("FG","100")
  btnBGC = colorWin2.newButton("BG","100")
btnFGC.changeFGColor("input","black")
btnFGC.changeBGColor("input","white")
btnBGC.changeFGColor("input","white")
btnBGC.changeBGColor("input","black")



proc colorPicker256onClick(source:Controll)=
  # now change FG color to val
  btnFGC.styles["input"].bgColor[2] = Colorpicker256(source).val
  btnFGC.styles["input"].bgColor[3] = Color256RGB[Colorpicker256(source).val]
  btnFGC.styles["input"].bgColor[1] = 
    RGBto16Color(extractRGB(Color256RGB[Colorpicker256(source).val]))

  canvas.brush.fgColor[1] = btnFGC.styles["input"].bgColor[1]
  canvas.brush.fgColor[2] = btnFGC.styles["input"].bgColor[2]
  canvas.brush.fgColor[3] = btnFGC.styles["input"].bgColor[3]

  if vibrancy(extractRGB(Color256RGB[Colorpicker256(source).val])) > 0.5 or
      lightness(extractRGB(Color256RGB[Colorpicker256(source).val])) > 0.65:
    changeFGColor(btnFGC, "input", "black")
  else:
    changeFGColor(btnFGC, "input", "white")

  btnFGC.drawit(btnFGC,true)

  terminal_extra.setCursorPos(1,2)
  #echo vibrancy(extractRGB(Color256RGB[Colorpicker256(source).val]))

cp256.addEventListener("click",colorPicker256onClick)

#..........................
proc colorPicker256onRightClick(source:Controll)=
  # now change FG color to val
  btnBGC.styles["input"].bgColor[2] = Colorpicker256(source).val
  btnBGC.styles["input"].bgColor[3] = Color256RGB[Colorpicker256(source).val]
  btnBGC.styles["input"].bgColor[1] = 
    RGBto16Color(extractRGB(Color256RGB[Colorpicker256(source).val]))

  canvas.brush.bgColor[1] = btnBGC.styles["input"].bgColor[1]
  canvas.brush.bgColor[2] = btnBGC.styles["input"].bgColor[2]
  canvas.brush.bgColor[3] = btnBGC.styles["input"].bgColor[3]

  if vibrancy(extractRGB(Color256RGB[Colorpicker256(source).val])) > 0.5 or
    lightness(extractRGB(Color256RGB[Colorpicker256(source).val])) > 0.65:
      changeFGColor(btnBGC, "input", "black")
  else:
      changeFGColor(btnBGC, "input", "white")

  btnBGC.drawit(btnBGC,true)

  terminal_extra.setCursorPos(1,2)
  #echo lightness(extractRGB(Color256RGB[Colorpicker256(source).val]))

cp256.addEventListener("rightclick",colorPicker256onRightClick)

#...............................................................................

var cpselect = app.activeWindow.newSelectBox("Colorpicker Changer",false,20)
cpselect.setMargin("bottom", 1)
cpselect.setMargin("left", 1)
cpselect.setMargin("top", 1)
cpselect.setBorder("solid")

var opt = (name:"", value:"", selected:true)
opt = (name:"16 Colors", value: "1", selected: false)
cpselect.options[].add(opt)
opt = (name:"256 Colors", value: "2", selected: false)
cpselect.options[].add(opt)
opt = (name:"RGB Colors", value: "3", selected: false)
cpselect.options[].add(opt)


proc changeColorpicker(source:Controll)=
  #discard parseInt(cpselect.value, source.app.colorMode)
  source.app.draw()

cpselect.addEventListener("change", changeColorpicker)

cpselect.value = $getColorMode()

#!==============================================================================


proc toHelpWS()=
  app.setActiveWorkSpace("helpWS")
app.addEventListener(KeyF1, toHelpWS)

proc toAppWS()=
  app.setActiveWorkSpace("appWS")
app.addEventListener(KeyF2, toAppWS)

proc toImgWS()=
  app.setActiveWorkSpace("imgWS")
app.addEventListener(KeyF3, toImgWS)
app.addEventListener("1", toImgWS)

proc toToolWS()=
  if app.activeWorkSpace == toolWS:
    app.setActiveWorkSpace("colorWS")
  else:
    app.setActiveWorkSpace("toolWS")
app.addEventListener(KeyF4, toToolWS)
app.addEventListener("2", toToolWS)

proc toColorWS()=
  app.setActiveWorkSpace("colorWS")
app.addEventListener("3", toColorWS)
