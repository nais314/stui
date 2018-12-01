# TODO: style inheriting option! - via app property or proc ?
# todo: RGB to 256 to 16 / 8 color converter table
# done: add label to T Controll, + `label=` + if label=="" + labelHeigth==0
# todo: TEST all controlls relative w/h
# TODO: auto id for objects
# done: proc onClick(this:Controll, event:KMEvent)=  if not this.disabled:
# todo: widgets: class, activearea
#? style for popup windows? 38,38,38
# doing: intro, doc
# todo: ColumnBreak test
# done: app addeventlistener fnkey action trigger test
# done: WS: switch ok, recalc ok
# todo: window rightclick
# done: controll.header.inc.nim
# todo: tss.nim - openTSS, readTSS, withTSS,...
#? todo: setDragdata()
# todo: ui_splash
# doing: ui_filechooser (dir, fname, exists) ▲ ▣ ■ 
# todo: ui_ table columns, ???
# todo: setEnabled(this:Controll) ?: set style to what?
# todo: CTRL+C, CTRL+V HELP!
# todo: ui_switchbtn, ui_intbox, ui_floatbox, ui_scale, ui_datepicker
# todo: ui_bargraph
# todo: ui_banner? ui_checkbox?
# done/doing progressbar to show value?
#? todo: progbar block character if RGB/16C/256C/BW
#? colorMode 0 change from 8C to 1C? (or 2C - BW, YW, CW???)
#! page style is useless
################################################################################

import stui, terminal, colors, colors_extra, terminal_extra, kmloop, threadpool, os, tables, locks

import ui_textbox, ui_button, ui_textarea, ui_stringlistbox

import strformat, unicode, strutils, parseutils

import random, parsecfg


#-------------------------------------------------------------------------------
# Basic App init
var app = newApp()
acquire(app.termlock) # whatever im creating, i dont want output yet ;)
# at start, set activeWorkspace & activeTile manually!
app.activeWorkSpace = app.newWorkSpace("firstWS")
app.activeTile = app.activeWorkSpace.newTile("auto")
#discard app.workSpaces[0].newTile("50%")
app.workSpaces[0].tiles[0].id = "TILE ID" # == app.activeTile.id = "TILE ID"



#-------------------------------------------------
# longer version: app.workSpaces[0].tiles[0].windows[0] -vs- var
discard app.workSpaces[0].tiles[0].newWindow()
app.workSpaces[0].tiles[0].windows[0].styles["window"].padding.left = 1
app.workSpaces[0].tiles[0].windows[0].styles["window"].padding.top = 1
app.workSpaces[0].tiles[0].windows[0].label = "Unnamed Document 1"



discard app.workSpaces[0].newTile("24ch") # 24 char wide tile
var ws1_W2 = app.workSpaces[0].tiles[1].newWindow()
ws1_W2.styles.add("dock", app.styles["dock"])
ws1_W2.activeStyle = ws1_W2.styles["dock"]
ws1_W2.label = "dock" #"öüóőúéá1234567890asdfghjklé0987456321yxcvbnmpoi1234567890asdfghjklé0987456321yxcvbnmpoi1234567890asdfghjklé0987456321yxcvbnmpoi"


#-------------------------------------------------------------------------------








#-------------------------------------------------------------------------------



echo "TextBox 1"

var tb = app.activeWindow.newTextBox("12345678901234567890",20,20)
tb.value= "colorMode: " & $app.colorMode
tb.setMargin("bottom", 1)
tb.setMargin("left", 1)
tb.setBorder("bold")
tb.setDisabled()
#tb.activeStyle = tb.styles["input:disabled"] # tb.setDisabled() handles this

#------------------------------------------------------------

echo "TextBox 2"

var tb2 = app.activeWindow.newTextBox("TextBox 2",20,20)
tb2.value= "teszt2"

tb2.activeStyle.fgColor = app.styles["window"].fgColor
tb2.activeStyle.bgColor = app.styles["window"].bgColor

tb2.setMargin("bottom", 1)
tb2.setMargin("left", 1)
tb2.setBorder("solid")

# test threads::::::::::::::::::::

#[ proc tb2test(pbPtr: ptr, app: ptr)=
    while true:
        (pbPTR[]).val = genId(5)
        pbPTR[].draw(true)
        app[].setCursorPos()
        sleep(rand(2000))

spawn tb2test(addr tb2, addr app) ]#
#[ proc tb2test(){.gcsafe.}=
    while true:
        tb2.val = genId(5)
        tb2.draw(true)
        tb2.app.setCursorPos()
        sleep(rand(2000)) ]#
proc tb2test(pbPtr: ptr TextBox){.gcsafe.}=
    while true:
        pbPTR[].val = genId(5)
        pbPTR[].draw(true)
        pbPTR[].app.setCursorPos()
        sleep(rand(2000))
        

spawn tb2test(addr tb2)

proc tb2test2(pbPtr: ptr, app: ptr)=
    while true:
        (pbPTR[]).activeStyle = (pbPTR[]).styles["input:focus"]
        pbPTR[].draw(true)
        app[].setCursorPos()
        sleep(rand(2000))
        (pbPTR[]).activeStyle = (pbPTR[]).styles["input"]
        pbPTR[].draw(true)
        app[].setCursorPos()
        sleep(1000)

spawn tb2test2(addr tb2, addr app)





#-------------------------------------------------------------------------------


var tA1 = app.activeWindow.newTextArea("Diary_1", 20,10)

tA1.value="""
scroll with mouse-wheel on window, textarea, lists.
F10: Quit - standard
F2: Menu - user
ESC+ESC: cancel, quit
Menu nav: cursors/mouse
Selectbox: space, enter, mouse
TAB: navigate to next controll
PgUP/Down: window/controll paging

have fun, write comments :)"""

tA1.setMargin("left", 1)


#-------------------------------------------------------------------------------

import ui_selectbox

echo "selectbox"
echo "A"
var sb1 = app.activeWindow.newSelectBox("⒮ selectbox1",true,20)
sb1.id = genId(3)
sb1.setMargin("bottom", 1)
sb1.setMargin("left", 1)

var opt = (name:"", value:"", selected:true)
#sb1.options[].add(opt)
for i in 1..5:
    opt = (name:"name-" & $i, value: $i, selected:false)
    sb1.options[].add(opt)

#............................

echo "selectbox 2"

var sb2 = app.activeWindow.newSelectBox("ColorMode Changer :)",false,20)
sb2.setMargin("bottom", 1)
sb2.setMargin("left", 1)
sb2.setBorder("solid")
#[ for i in 1..5:
    opt = (name:"name-" & $i, value: $i, selected:false)
    sb2.options[].add(opt) ]#
opt = (name:"16 Colors", value: "1", selected: false)
sb2.options[].add(opt)
opt = (name:"256 Colors", value: "2", selected: false)
sb2.options[].add(opt)
opt = (name:"RGB Colors", value: "3", selected: true)
sb2.options[].add(opt)

proc changeColorMode(source:Controll)=
    discard parseInt(sb2.value, source.app.colorMode)
    source.app.draw()
    #echo "Color Mode: ", sb2.value, " : ", source.app.colorMode

sb2.addEventListener("change", changeColorMode)

sb2.value = $getColorMode()



#-------------------------------------------------------------------------------



var btn = app.activeWindow.newButton("BTN: open selectbox", 1,1)

btn.setMargin("left", 1)
btn.setMargin("bottom", 1)

#btn.setBorder("block")

proc btnClick(this:Controll)=
    this.app.activate(sb2)
    sb2.onClick(sb2, new KMEvent)
    #this.toggleBlink()

addEventListener(Controll(btn), "click", btnClick)

#-------------------------------------------------------------------------------

import ui_menu


# MENU -------------------------------------------------------------------------
# window menu - quit
var menuW = app.newMenu()
menuW.setMargin("all",2)
discard menuW.currentNode.addChild("Quit",proc() = quit())
app.workSpaces[0].tiles[0].windows[0].addEventListener("menu", proc(c:Controll) = menuW.show())
app.workSpaces[0].tiles[1].windows[0].addEventListener("menu", proc(c:Controll) = menuW.show())



#-------------------------------------

# test menu
var menu1 = app.newMenu()
menu1.setMargin("all",2)

proc dummy(): void = echo "discard"

proc genNewChilds(nMN: MenuNode, level:int = 0)=
    if level < 3:
        for iM in 0..60:
            var child = nMN.addChild("test-" & $iM, nil)
            genNewChilds(child, level + 1)  
            #[ if rand(1) > 0:
                var a = nMN.addChild("test-" & $iM, nil)
                a.action = dummy
            else:
                var child = nMN.addChild("test-" & $iM, nil)
                genNewChilds(child, level + 1)  ]#               

genNewChilds(menu1.currentNode, 0)

#...............

var btn2 = app.activeWindow.newButton("Menu", 1,1)

btn2.setMargin("left", 1)
btn2.setMargin("bottom", 1)


proc btn2Click(this:Controll)=
    menu1.show()

addEventListener(Controll(btn2), "click", btn2Click)

#...............
# app menu KeyF2
app.addEventListener(KeyF2, proc() = menu1.show())


#-------------------------------------------------------------------------------

import ui_progressbar

#-----------------

var prog1 = app.activeWindow.newProgressBar("progbar1", showValue = true)

prog1.setBorder("solid")
prog1.setMargin("left", 1)

proc prog1test(pbPtr: ptr, app: ptr)=
    while true:
        (pbPTR[]).val += 5
        if (pbPTR[]).val > 100: (pbPTR[]).val = 0
        ui_progressbar.draw(pbPTR[], true)
        #withLock app[].termlock : app[].setCursorPos()
        sleep(rand(750))

spawn prog1test(addr prog1, addr app)
#------------------------------------------------------------

var prog2 = app.activeWindow.newProgressBar("progbar2")

prog2.val = 0

#prog2.setBorder("solid")
prog2.setMargin("left", 1)


proc prog2test(pbPtr: ptr, app: ptr)=
    while true:
        (pbPTR[]).val += 10
        if (pbPTR[]).val > 100: (pbPTR[]).val = 0
        ui_progressbar.draw(pbPTR[], true)
        #withLock app[].termlock : app[].setCursorPos()
        sleep(rand(2500))

spawn prog2test(addr prog2, addr app)






#-------------------------------------------------------------------------------
import ui_fineprogressbar

var fineprog = app.activeWindow.newFineProgressBar("fine progbar1")

fineprog.setBorder("solid")
fineprog.setMargin("left", 1)


proc fineprogtest(pbPtr: ptr, app: ptr)=
    while true:
        (pbPTR[]).val += 2
        if (pbPTR[]).val > 100: (pbPTR[]).val = 0
        ui_fineprogressbar.draw(pbPTR[], true)
        sleep(rand(500))

spawn fineprogtest(addr fineprog, addr app)
#------------------------------------------------------------
var fineprog2 = app.activeWindow.newFineProgressBar(
        "fine progbar2 w levels", 
        levels=(33,66))

fineprog2.setBorder("solid")
fineprog2.setMargin("left", 1)


spawn fineprogtest(addr fineprog2, addr app)
#-------------------------------------------------------------------------------








echo "TextBox 33%"

var tb33 = app.activeWindow.newTextBox("Relative W","100%",20)
tb33.value= "Relative Width Test"
tb33.setMargin("bottom", 1)
tb33.setMargin("left", 1)
tb33.setBorder("bold")
#tb.setDisabled()



#-------------------------------------------




proc tbOnChange(this:Controll)=
    #echo "Change"
    this.removeEventListener("change", tbOnChange) # ;)


import random
for i in 2..20:
    var tb2 = app.activeWindow.newTextBox("Teszt" & $i,20,20)
    tb2.id = genId(5)

    randomize()
    tb2.val = "teszt " & tb2.id & genId(rand(25))

    tb2.setMargin("bottom", 1)
    tb2.setMargin("left", 1)

    tb2.addEventListener("change", tbOnChange)



#------------------------------------------------------------------------------



let slb1 = app.activeWindow.newStringListBox("String ListBox", 20, 5)

for i in 0..10:
    slb1.options.add((genId(10), nil)) # tuple[name:string, action:proc():void]
    slb1.options[i].action = proc() = app.setActiveWorkSpace("secondWS")

slb1.setMargin("left",1)
slb1.setMargin("bottom",1)
slb1.setBorder("block")
    

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#    ##      ## #### ##    ## ########   #######  ##      ##  #######  
#    ##  ##  ##  ##  ###   ## ##     ## ##     ## ##  ##  ## ##     ## 
#    ##  ##  ##  ##  ####  ## ##     ## ##     ## ##  ##  ##        ## 
#    ##  ##  ##  ##  ## ## ## ##     ## ##     ## ##  ##  ##  #######  
#    ##  ##  ##  ##  ##  #### ##     ## ##     ## ##  ##  ## ##        
#    ##  ##  ##  ##  ##   ### ##     ## ##     ## ##  ##  ## ##        
#     ###  ###  #### ##    ## ########   #######   ###  ###  ######### 


for i in 2..20:
    var tb2 = ws1_W2.newTextBox("Teszt" & $i,20,20)
    tb2.id = genId(5)

    randomize()
    tb2.val = "teszt " & tb2.id & genId(rand(25))

    tb2.setMargin("bottom", 1)
    tb2.setMargin("left", 1)

    tb2.addEventListener("change", tbOnChange)

    if i == 6: discard ws1_W2.newPageBreak()


#------------------------------------------------------------------------------  
#------------------------------------------------------------------------------



#===============================================================================
#===============================================================================
#===============================================================================

####                  ########  ######   ######  
####                     ##    ##    ## ##    ## 
####                     ##    ##       ##       
####                     ##     ######   ######  
####                     ##          ##       ## 
####                     ##    ##    ## ##    ## 
####                     ##     ######   ######  

   
var
    statusTss = loadConfig("status.tss")
    status_styles = newStyleSheets()

status_styles.add("error", styleSheetRef_fromConfig(statusTss,"error"))
status_styles.add("warning", styleSheetRef_fromConfig(statusTss,"warning"))
status_styles.add("info", styleSheetRef_fromConfig(statusTss,"info"))
status_styles.add("success", styleSheetRef_fromConfig(statusTss,"success"))


proc statusTss_test(pbPtr: ptr, app: ptr, sty: ptr)=
    randomize()
    if pbPtr != nil and app != nil and sty != nil:
        while true:
            for i in 0..(pbPTR[]).controlls.high :
                if (pbPTR[]).controlls[i] of TextBox:
                    case rand(10):
                        of 0: 
                            (pbPTR[]).controlls[i].styles["input"].fgColor = (app[]).styles["input"].fgColor
                            (pbPTR[]).controlls[i].styles["input"].bgColor = (app[]).styles["input"].bgColor
                        of 1: 
                            (pbPTR[]).controlls[i].styles["input"].fgColor = sty[]["error"].fgColor
                            (pbPTR[]).controlls[i].styles["input"].bgColor = sty[]["error"].bgColor
                        of 2: 
                            (pbPTR[]).controlls[i].styles["input"].fgColor = sty[]["warning"].fgColor
                            (pbPTR[]).controlls[i].styles["input"].bgColor = sty[]["warning"].bgColor
                        of 3: 
                            (pbPTR[]).controlls[i].styles["input"].fgColor = sty[]["info"].fgColor
                            (pbPTR[]).controlls[i].styles["input"].bgColor = sty[]["info"].bgColor
                        of 4:
                            (pbPTR[]).controlls[i].styles["input"].fgColor = sty[]["success"].fgColor
                            (pbPTR[]).controlls[i].styles["input"].bgColor = sty[]["success"].bgColor
                        else:
                            (pbPTR[]).controlls[i].styles["input"].fgColor = (app[]).styles["input"].fgColor
                            (pbPTR[]).controlls[i].styles["input"].bgColor = (app[]).styles["input"].bgColor

                    (pbPTR[]).controlls[i].drawit(((pbPTR[]).controlls[i]), true)
                

            withLock app[].termlock : app[].setCursorPos()
            sleep(2000)

randomize()
spawn statusTss_test(addr ws1_W2, addr app, addr status_styles)












#===============================================================================
#                       _                              _____ 
#                      | |                            / __  \
#   __      _____  _ __| | _____ _ __   __ _  ___ ___ `' / /'
#   \ \ /\ / / _ \| '__| |/ / __| '_ \ / _` |/ __/ _ \  / /  
#    \ V  V / (_) | |  |   <\__ \ |_) | (_| | (_|  __/./ /___
#     \_/\_/ \___/|_|  |_|\_\___/ .__/ \__,_|\___\___|\_____/
#                               | |                          
#                               |_|                          
#===============================================================================


var ws2 = app.newWorkSpace("secondWS")
var ws2T1 = ws2.newTile("auto")

var ws2T1W1 = ws2T1.newWindow()
ws2T1W1.styles["window"].padding.left = 1
ws2T1W1.styles["window"].padding.top = 1
ws2T1W1.label = "ws2T1W1"

#...............................................................................


var wsSwitch1 = ws1_W2.newButton("switch to WS 2!")
wsSwitch1.setMargin("left", 1)
wsSwitch1.setMargin("bottom", 1)
wsSwitch1.setMargin("top", 1)
wsSwitch1.setPaddingV 1
wsSwitch1.setPaddingH 1

# swapp to front >:)
ws1_W2.controlls[ws1_W2.controlls.high] = ws1_W2.controlls[0]
ws1_W2.controlls[0] = wsSwitch1


proc wsSwitch1_Click(this:Controll)=
    app.setActiveWorkSpace(ws2)
    app.draw()

addEventListener(Controll(wsSwitch1), "click", wsSwitch1_Click)


#...................................................


var wsSwitch2 = ws2T1W1.newButton("switch to WS 1!")
wsSwitch2.setMargin("left", 1)

#[ 
# the default method of event cb adding: 
proc wsSwitch2_Click(this:Controll)=
    app.setActiveWorkSpace("firstWS")
    app.draw()

addEventListener(Controll(wsSwitch2), "click", wsSwitch2_Click) ]#

#alternate method:
proc alt_wsSwitch2_Click(this:Controll, event:KMEvent)=
    ui_button.onClick(this, event)
    app.setActiveWorkSpace("firstWS")
    #app.draw()

wsSwitch2.onClick = alt_wsSwitch2_Click

#...............................................................................

var relTA = ws2T1W1.newTextArea("Relative W+H test", "75", "75")
relTA.value="""
The quick brown fox jumped over the lazy dog.
Árvíztűrő tükörfúrógép.
Lorem ipsum dolor sit ameth.
"""

relTA.setMargin("left", 1)



#-------------------------------------------------------------------------------
#   ██████╗ ██╗███████╗ █████╗ ██████╗ ██╗     ███████╗██████╗ ███████╗
#   ██╔══██╗██║██╔════╝██╔══██╗██╔══██╗██║     ██╔════╝██╔══██╗██╔════╝
#   ██║  ██║██║███████╗███████║██████╔╝██║     █████╗  ██║  ██║███████╗
#   ██║  ██║██║╚════██║██╔══██║██╔══██╗██║     ██╔══╝  ██║  ██║╚════██║
#   ██████╔╝██║███████║██║  ██║██████╔╝███████╗███████╗██████╔╝███████║
#   ╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚═════╝ ╚══════╝
                                                                   


var tA2 = app.activeWindow.newTextArea("TA Disabled", 20,10)

tA2.value="""
Handle the tty line connected to standard input. Without arguments, prints baud rate, line discipline, and deviations from stty sane. In settings, CHAR is taken literally, or coded as in ^c, 0x37, 0177 or 127; special values ^- or undef used to disable special characters.

GNU coreutils online help: <http://www.gnu.org/software/coreutils/> Report stty translation bugs to <http://translationproject.org/team/>   
END"""

tA2.setDisabled()
tA2.setMargin("bottom",1)
tA2.setMargin("left",1)

#...............................................................................
#   ██████╗ ███████╗██╗      █████╗ ████████╗██╗██╗   ██╗███████╗███████╗
#   ██╔══██╗██╔════╝██║     ██╔══██╗╚══██╔══╝██║██║   ██║██╔════╝██╔════╝
#   ██████╔╝█████╗  ██║     ███████║   ██║   ██║██║   ██║█████╗  ███████╗
#   ██╔══██╗██╔══╝  ██║     ██╔══██║   ██║   ██║╚██╗ ██╔╝██╔══╝  ╚════██║
#   ██║  ██║███████╗███████╗██║  ██║   ██║   ██║ ╚████╔╝ ███████╗███████║
#   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝  ╚══════╝╚══════╝
                                                                     
discard app.activeWindow.newButton("100% width", "100", paddingV = 1)
let btn25pc = app.activeWindow.newButton("25% width", "25", paddingV = 1)
btn25pc.setDisabled()
btn25pc.setMargin("top",1)


let fp50 = app.activeWindow.newFineProgressBar("50% width", width = "50")
fp50.value2= 66
fp50.setMargin("top",1)


let pb50 = app.activeWindow.newProgressBar("50% w - Click Me!", width = "50")
pb50.value2= 66
pb50.setMargin("top",1)

proc pb50onClick(this:Controll, event:KMEvent) =
    ProgressBar(this).value2= rand(100)
pb50.onClick = pb50onClick


let sb50 = app.activeWindow.newSelectBox("50% width", multiSelect = false, width = "50")
sb50.setMargin("top",1)


let slb50 = app.activeWindow.newStringListBox("50% width", "50", "25")
slb50.setMargin("top",1)
#slb50.setDisabled()
for i in 0..1:
    slb50.options.add((genId(10), nil)) # tuple[name:string, action:proc():void]
    #slb50.options[i].action = proc() = app.setActiveWorkSpace("secondWS")


################################################################################
################################################################################
#      
#      ██████╗ ███████╗██╗   ██╗███████╗██╗     
#      ██╔══██╗██╔════╝██║   ██║██╔════╝██║     
#      ██║  ██║█████╗  ██║   ██║█████╗  ██║     
#      ██║  ██║██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║     
#      ██████╔╝███████╗ ╚████╔╝ ███████╗███████╗
#      ╚═════╝ ╚══════╝  ╚═══╝  ╚══════╝╚══════╝
#


#discard app.activeWindow.newTextBox("dummy")


let statt = app.activeWindow.newStaticTextArea("static text")
statt.value= "Welcome to the Page of new Developments :)"



import ui_fileselect

let fch1 = app.activeWindow.newFileSelect("FileSelect1 fch1")
fch1.setMargin("top",1)
fch1.setMargin("left",1)



import ui_shdbutton

let shdbtn1 = app.activeWindow.newShdButton("shdbtn1")
shdbtn1.setMargin("top",1)
shdbtn1.setMargin("left",1)

let shdbtn2 = app.activeWindow.newShdButton("shdbtn2",1,1)
shdbtn2.setMargin("top",1)
shdbtn2.setMargin("left",1)



import ui_togglebutton

let tgbtn1 = app.activeWindow.newToggleButton("tgbtn1", "on", "off")
tgbtn1.setMargin("top",1)
tgbtn1.setMargin("left",1)

let tglbtn2 = app.activeWindow.newToggleButton("tglbtn2", "on", "off", 2, 1)
tglbtn2.setMargin("top",1)
tglbtn2.setMargin("left",1)

let tglbtn3 = app.activeWindow.newToggleButton("tglbtn3", "on", "off", "50", 1)
tglbtn3.setMargin("top",1)
tglbtn3.setMargin("left",1)



#...............................................................................
import ui_linegraph

let lg1 = newLineGraph( win = app.activeWindow,
                        label = "LineGraph 1",
                        width = 23, heigth = 20,
                        showMarks = true,
                        showScale = true, 
                        showDetail = true, 
                        dataType = 'f',
                        floatPrecision = 2,
                        rightReading = false)

for i in 1 .. 50:
    if i mod 3 == 0:
        discard FloatDataset2D(lg1.dataset).add(($i, (rand(30).float * -1)))
        #discard FloatDataset2D(lg1.dataset).add(($i,i.float * -1))
    else:
        discard FloatDataset2D(lg1.dataset).add(($i,rand(30).float))
        #discard FloatDataset2D(lg1.dataset).add(($i,i.float))

#[ for i in 0 .. 6:
    discard FloatDataset2D(lg1.dataset).add(($(i * -1), (i.float * -1))) ]#

proc lg1_conditionalFormat(this: FloatDataset2D, val:float)=
    if val == this.maxValue or val == this.minValue:
        #stdout.write "\e[31m\e[1m" # for max compatibility, 8 colors mode >:)
        colors_extra.setForegroundColor("red") # 256c or RGB

FloatDataset2D(lg1.dataSet).conditionalStyler = lg1_conditionalFormat

var
    lineGraphTss = loadConfig("linegraph.tss")
    #lineGraph_styles = newStyleSheets()

lg1.styles.add("mark:positive", styleSheetRef_fromConfig(lineGraphTss,"mark-positive"))
lg1.styles.add("mark:negative", styleSheetRef_fromConfig(lineGraphTss,"mark-negative"))
lg1.styles.add("graph:positive", styleSheetRef_fromConfig(lineGraphTss,"graph-positive"))
lg1.styles.add("graph:negative", styleSheetRef_fromConfig(lineGraphTss,"graph-negative"))
lg1.styles.add("graph:selected", styleSheetRef_fromConfig(lineGraphTss,"graph-selected"))

#...............................................


let lg2 = newLineGraph( win = app.activeWindow,
                        label = "LineGraph 2",
                        width = "25", heigth = 12,
                        showMarks = true,
                        showScale = true, 
                        showDetail = true, 
                        dataType = 'f',
                        floatPrecision = 2,
                        rightReading = false)

for i in 1 .. 50:
    if i mod 3 == 0:
        discard FloatDataset2D(lg2.dataset).add(($i, (rand(30).float * -1)))
        #discard FloatDataset2D(lg1.dataset).add(($i,i.float * -1))
    else:
        discard FloatDataset2D(lg2.dataset).add(($i,rand(30).float))
        #discard FloatDataset2D(lg1.dataset).add(($i,i.float))

lg2.setMargin("all", 1)

#..............................................

let lg3MaxItems = 100

var lg3 = newLineGraph( win = app.activeWindow,
        label = "LineGraph 3",
        width = "50", heigth = "50",
        showMarks = true,
        showScale = true, 
        showDetail = true, 
        dataType = 'f',
        floatPrecision = 2,
        rightReading = true,
        maxItems=lg3MaxItems)

lg3.lockOnNew = true
lg3.setMargin("all", 1)

proc lg3DoubleClick(this_elem: Controll, event: KMEvent):void =
    LineGraph(this_elem).lockOnNew = not LineGraph(this_elem).lockOnNew

lg3.onDoubleClick = lg3DoubleClick

for i in 1 .. lg3MaxItems:
    discard FloatDataset2D(lg3.dataset).add(($i,rand(50).float))
    #[ if i mod 3 == 0:
        discard FloatDataset2D(lg3.dataset).add(($i, (rand(100).float * -1)))
        #discard FloatDataset2D(lg1.dataset).add(($i,i.float * -1))
    else:
        discard FloatDataset2D(lg3.dataset).add(($i,rand(100).float))
        #discard FloatDataset2D(lg1.dataset).add(($i,i.float)) ]#


#...........................
proc lg3sim(lg3Ptr: ptr) {.gcsafe.} =
    # lot of work because add is not gcsafe !?
    #discard FloatDataset2D(lg3.dataset).add(("added from thread", 25.float))
    var r:float
    while true:
        #FloatDataset2D(lg3Ptr.dataset).values.add(("added from thread", 25.float))
        r = rand([5,10,20,30,40,50,60,70,80,100]).float
        FloatDataset2D(lg3Ptr.dataset).values.add(("added from thread", r))
        
        if FloatDataset2D(lg3Ptr.dataset).maxValue < r : 
            FloatDataset2D(lg3Ptr.dataset).maxValue = r
        if FloatDataset2D(lg3Ptr.dataset).minValue > r : 
            FloatDataset2D(lg3Ptr.dataset).minValue = r
        
        if FloatDataset2D(lg3Ptr.dataset).values.len > lg3Ptr.dataset.maxItems :
            FloatDataset2D(lg3Ptr.dataset).values.delete(0)
        LineGraph(lg3Ptr[]).draw(false)
        sleep(1000)

let lg3Ptr: ptr = addr lg3
spawn lg3sim(addr lg3)
#..........................

lg3.activeStyle.fgColor[0] = colors_extra.parseColor("fgGreen",1)
lg3.activeStyle.fgColor[1] = colors_extra.parseColor("fgGreen",1)
lg3.activeStyle.fgColor[2] = colors_extra.parseColor("lime",2)
lg3.activeStyle.fgColor[3] = colors_extra.parseColor("lime",3)
lg3.activeStyle.setTextStyle("styleBright")

################################################################################
################################################################################
#
#      ███╗   ███╗ █████╗ ██╗███╗   ██╗██╗      ██████╗  ██████╗ ██████╗ 
#      ████╗ ████║██╔══██╗██║████╗  ██║██║     ██╔═══██╗██╔═══██╗██╔══██╗
#      ██╔████╔██║███████║██║██╔██╗ ██║██║     ██║   ██║██║   ██║██████╔╝
#      ██║╚██╔╝██║██╔══██║██║██║╚██╗██║██║     ██║   ██║██║   ██║██╔═══╝ 
#      ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║███████╗╚██████╔╝╚██████╔╝██║     
#      ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝     
#                                                                  
#
#
include "mainloop.inc.nim"
#
#
#
################################################################################
################################################################################
