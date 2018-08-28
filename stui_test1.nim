# todo: ListItem, ListBox - header, table columns, ???
# todo: window menu, buttons
# todo: widgets: class, activearea
# todo: ColumnBreak test
# todo: app addeventlistener fnkey action trigger test
# done: WS: switch ok, recalc ok
# todo: window onclick, rightclick
# todo: tss.nim
# todo: setDragdata()
# todo: intro, doc
# todo: splash
# todo: filechooser (dir, fname, exists)
# todo: setEnabled(this:Controll) ?: set style to what?
# todo: banner?
# todo: CTRL+C, CTRL+V

import stui, terminal, colors, colors_extra, terminal_extra, kmloop, threadpool, os, tables, locks

import textbox, button, textarea

import strformat, unicode

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
# longer version:
discard app.workSpaces[0].tiles[0].newWindow()
app.workSpaces[0].tiles[0].windows[0].styles["panel"].padding.left = 1
app.workSpaces[0].tiles[0].windows[0].styles["panel"].padding.top = 1
app.workSpaces[0].tiles[0].windows[0].title = "Unnamed Document 1"



discard app.workSpaces[0].newTile("24ch")
var ws1_W2 = app.workSpaces[0].tiles[1].newWindow()
#ws1_W2.styles["panel"].bgColor[2] = 25
#ws1_W2.styles["panel"].bgColor[3] = int(packRGB(51, 102, 153))
ws1_W2.styles.add("dock", app.styles["dock"])
ws1_W2.activeStyle = ws1_W2.styles["dock"]
ws1_W2.title = "öüóőúéá1234567890asdfghjklé0987456321yxcvbnmpoi1234567890asdfghjklé0987456321yxcvbnmpoi1234567890asdfghjklé0987456321yxcvbnmpoi"


#-------------------------------------------------------------------------------








#-------------------------------------------------------------------------------



echo "TextBox 1"

var tb = app.activeWindow.newTextBox("12345678901234567890",20,20)
tb.value= "colorMode: " & $app.colorMode
tb.activeStyle = tb.styles["input:disabled"]
tb.setMargin("bottom", 1)
tb.setMargin("left", 1)
tb.setBorder("bold")
tb.setDisabled()

#------------------------------------------------------------

echo "TextBox 2"

var tb2 = app.activeWindow.newTextBox("TextBox 2",20,20)
tb2.value= "teszt2"

tb2.activeStyle.fgColor = app.styles["panel"].fgColor
tb2.activeStyle.bgColor = app.styles["panel"].bgColor

tb2.setMargin("bottom", 1)
tb2.setMargin("left", 1)
tb2.setBorder("solid")

proc tb2test(pbPtr: ptr, app: ptr)=
    while true:
        (pbPTR[]).val = genId(5)
        pbPTR[].draw(true)
        app[].setCursorPos()
        sleep(rand(2000))

spawn tb2test(addr tb2, addr app)

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
Handle the tty line connected to standard input. Without arguments, prints baud rate, line discipline, and deviations from stty sane. In settings, CHAR is taken literally, or coded as in ^c, 0x37, 0177 or 127; special values ^- or undef used to disable special characters.

GNU coreutils online help: <http://www.gnu.org/software/coreutils/> Report stty translation bugs to <http://translationproject.org/team/>   
END"""




#-------------------------------------------------------------------------------

import selectbox

echo "selectbox"
echo "A"
var sb1 = app.activeWindow.newSelectBox("opciók",true,20)
sb1.id = genId(3)
sb1.setMargin("bottom", 1)

var opt = (name:"", value:"", selected:true)
#sb1.options[].add(opt)
for i in 1..5:
    opt = (name:"name-" & $i, value: $i, selected:false)
    sb1.options[].add(opt)

#............................

echo "selectbox 2"

var sb2 = app.activeWindow.newSelectBox("opciók 222",false,20)
sb2.setMargin("bottom", 1)
sb2.setMargin("left", 1)
sb2.setBorder("solid")
for i in 1..5:
    opt = (name:"name-" & $i, value: $i, selected:false)
    sb2.options[].add(opt)

#------------------------------------------------------------

var btn = app.activeWindow.newButton("12345")

btn.setMargin("left", 1)
btn.setMargin("bottom", 1)

btn.setBorder("block")

proc btnClick(this:Controll)=
    #var event = new KMEvent
    #[ this.app.activeControll = sb2
    sb2.focus(sb2) ]#
    this.app.activate(sb2)
    sb2.onClick(sb2, new KMEvent)
    this.toggleBlink()

addEventListener(Controll(btn), "click", btnClick)

#------------------------------------------------------------

import progressbar

#-----------------

var prog1 = app.activeWindow.newProgressBar("progbar1")

prog1.setBorder("solid")

proc prog1test(pbPtr: ptr, app: ptr)=
    while true:
        (pbPTR[]).val += 5
        if (pbPTR[]).val > 100: (pbPTR[]).val = 0
        progressbar.draw(pbPTR[], true)
        #withLock app[].termlock : app[].setCursorPos()
        sleep(rand(750))

spawn prog1test(addr prog1, addr app)
#------------------------------------------------------------

var prog2 = app.activeWindow.newProgressBar("progbar2")

prog2.val = 0

#prog2.setBorder("solid")

proc prog2test(pbPtr: ptr, app: ptr)=
    while true:
        (pbPTR[]).val += 10
        if (pbPTR[]).val > 100: (pbPTR[]).val = 0
        progressbar.draw(pbPTR[], true)
        #withLock app[].termlock : app[].setCursorPos()
        sleep(rand(2500))

spawn prog2test(addr prog2, addr app)






#------------------------------------------------------------
import fineprogressbar

var fineprog = app.activeWindow.newFineProgressBar("fine progbar1")

fineprog.setBorder("solid")

proc fineprogtest(pbPtr: ptr, app: ptr)=
    while true:
        (pbPTR[]).val += 2
        if (pbPTR[]).val > 100: (pbPTR[]).val = 0
        fineprogressbar.draw(pbPTR[], true)
        sleep(rand(500))

spawn fineprogtest(addr fineprog, addr app)
#------------------------------------------------------------
var fineprog2 = app.activeWindow.newFineProgressBar(
        "fine progbar1", 
        levels=(33,66))

fineprog2.setBorder("solid")

spawn fineprogtest(addr fineprog2, addr app)
#------------------------------------------------------------








echo "TextBox 33%"

var tb33 = app.activeWindow.newTextBox("Relative W","100%",20)
tb33.value= "Relative Width Test"
#tb.activeStyle = tb.styles["input:disabled"]
tb33.setMargin("bottom", 1)
tb33.setMargin("left", 1)
tb33.setBorder("bold")
#tb.setDisabled()


#------------------------------------------------------------








proc tbOnChange(this:Controll)=
    #echo "Change"
    this.removeEventListener("change", tbOnChange)


import random
for i in 2..20:
    var tb2 = app.activeWindow.newTextBox("Teszt" & $i,20,20)
    tb2.id = genId(5)

    randomize()
    tb2.val = "teszt " & tb2.id & genId(rand(25))

    tb2.setMargin("bottom", 1)
    tb2.setMargin("left", 1)

    tb2.addEventListener("change", tbOnChange)




#------------------------------------------------------------

for i in 2..20:
    var tb2 = ws1_W2.newTextBox("Teszt" & $i,20,20)
    tb2.id = genId(5)

    randomize()
    tb2.val = "teszt " & tb2.id & genId(rand(25))

    tb2.setMargin("bottom", 1)
    tb2.setMargin("left", 1)

    tb2.addEventListener("change", tbOnChange)

    if i == 6: discard ws1_W2.newPageBreak()


   
 


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
    if pbPtr != nil and app != nil and sty!= nil:
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
#===============================================================================




var ws2 = app.newWorkSpace()
var ws2T1 = ws2.newTile("auto")

var ws2T1W1 = ws2T1.newWindow()
ws2T1W1.styles["panel"].padding.left = 1
ws2T1W1.styles["panel"].padding.top = 1
ws2T1W1.title = "ws2T1W1"

#...............................................................................


var wsSwitch1 = ws1_W2.newButton("switch to WS 2!")


proc wsSwitch1_Click(this:Controll)=
    app.setActiveWorkSpace(ws2)
    app.draw()

addEventListener(Controll(wsSwitch1), "click", wsSwitch1_Click)
#.....


var wsSwitch2 = ws2T1W1.newButton("switch to WS 1!")


#[ 
# the default method of event cb adding: 
proc wsSwitch2_Click(this:Controll)=
    app.setActiveWorkSpace("firstWS")
    app.draw()

addEventListener(Controll(wsSwitch2), "click", wsSwitch2_Click) ]#

#alternate method:
proc alt_wsSwitch2_Click(this:Controll, event:KMEvent)=
    button.onClick(this, event)
    app.setActiveWorkSpace("firstWS")
    app.draw()

wsSwitch2.onClick = alt_wsSwitch2_Click

#...............................................................................

var relTA = ws2T1W1.newTextArea("Relative W+H test", "100", "90")
relTA.value="""
The quick brown fox jumped over the lazy dog.
Árvíztűrő tükörfúrógép.
Lorem ipsum dolor sit ameth.
"""

#===============================================================================
#===============================================================================
#===============================================================================



include "mainloop.inc.nim"



################################################################################
################################################################################
################################################################################
################################################################################