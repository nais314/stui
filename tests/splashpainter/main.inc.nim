import stui/[ui_fileselect, ui_button, ui_textbox]
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

#...............................................................................

proc toHelpWS()=
  app.setActiveWorkSpace("helpWS")
app.addEventListener(KeyF1, toHelpWS)

proc toAppWS()=
  app.setActiveWorkSpace("appWS")
app.addEventListener(KeyF2, toAppWS)

proc toImgWS()=
  app.setActiveWorkSpace("imgWS")
app.addEventListener(KeyF3, toImgWS)

proc toToolWS()=
  app.setActiveWorkSpace("toolWS")
app.addEventListener(KeyF4, toToolWS)


#!==============================================================================


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
  F4: Toolbox
"""


#!==============================================================================


# imgWS for painting
#TODO widget statusbar
#DONE fullscreen window - no titlebar

var imgWS = app.newWorkSpace("imgWS")
discard imgWS.newTile("auto")
imgWS.tiles[0].id = "imgWS"

var imgWin = imgWS.tiles[0].newWindow()
imgWin.styles["window"].padding.left = 1
imgWin.styles["window"].padding.top = 1
imgWin.label = "Image"
imgWin.fullScreen = true

#imgWin.changeBGColor("window", "black")

#.......................................
import stui/ui_canvas
var canvas = imgWin.newCanvas("canvas")

proc canvasOnClick(this: Controll, event:KMEvent)=
  #var canvas = Canvas(this)
  case event.evType:
  of KMEventKind.Click:
    if canvas.innerClick(event):
      case canvas.activeFrame.activeLayer.typ:
      of LayerKind.Image:
        case canvas.tool:
        of ToolKind.Pencil:
          discard
        else: discard #TODO
  else: discard #TODO



#!==============================================================================


# controllWS for colors, characters
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