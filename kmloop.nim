import terminal, parseutils, threadpool, os, times, stui



#[ type
    MouseCallback  = proc (app: App, mEv: MouseEvent) {.closure.}
    EscapeCallback = proc (app: App, kEv: KeyEvent) {.closure.}
    CharCallback   = proc (app: App, kEv: KeyEvent)   {.closure.} ]#

    

var 
    mouse_state: int8 = -1
#[
    10: 1 click
    11: 1 release
    12: 1 drag

    20,20,22: btn2 middle
    30,31,32: btn3 right
]#

    clickEpoch: float


# problem with doubleclik/single click sends before...
proc mouse_parser*(mstring: var string, c: var char): KMEvent {.inline.}=
    var
        mbtn, mx, my: int

    result = new KMEvent

    var cursor : int = 0
    var pstr : string = ""
    cursor.inc parseUntil(mstring, pstr, ';', cursor)
    cursor.inc
    discard parseInt(pstr, mbtn, 0)
    cursor.inc parseUntil(mstring, pstr, ';', cursor)
    cursor.inc
    discard parseInt(pstr, mx, 0)
    cursor.inc parseUntil(mstring, pstr, ';', cursor)
    cursor.inc
    discard parseInt(pstr, my, 0)
    
    
    #proc mouse_cb(mbtn, mx, my :int, c:char) =


    let clickInterval = epochTime() - clickEpoch

    case mbtn:
        of 0,1,2:
            if c == 'M':
                #clickM += 1
                result.evType = "Click"
                if clickEpoch == 0:
                    clickEpoch = epochTime()
                    #echo " c " & $clickEpoch
                else:
                    #echo "  " & $clickInterval
                    if clickInterval < 0.4 :
                        #echo "DoubleClick " & $clickInterval
                        result.evType = "DoubleClick"
                        clickEpoch = 0
                    else:
                        clickEpoch = epochTime()
                    
            elif c  == 'm' :
                result.evType = "Release"
                #clickM2 += 1
                if clickEpoch != 0 :#and clickM == clickM2:
                    if clickInterval > 1.3:
                        #echo "LOMGLCLICK  "  & $clickInterval
                        result.evType = "LongClick"
                        clickEpoch = 0

            if mouse_state == 1:
                mouse_state = 2 #drop
                result.evType = "Drop"
            else:
                mouse_state = 0 #reset

        of 32,33,34: 
            if mouse_state != 3: 
                mouse_state = 1 #drag-1 if not cancelled-3
                terminal.setCursorPos(mx, my)
                terminal.setForegroundColor(fgMagenta,true)
                stdout.write("◉") # •
            result.evType = "Drag"
            clickEpoch = 0

        of 65:
            result.evType = "ScrollDown"
        of 64:
            result.evType = "ScrollUp"

        else: discard


    #echo "btn: " , mbtn , " X: " , mx , " Y: " , my , if c == 'M': " pressed" else: " release"

    #case mouse_state:
    #    of 1: echo "drag"
    #    of 2: echo "drop"
    #    else: discard

    
    result.c = c
    result.btn = mbtn
    result.x = mx
    result.y = my

    # CALL TARGETOBJ.onClick(mEvent) ---------------

#-----------------------------------
# todo: maybe a enum to interpret?
proc esc_parser(str:string): KMEvent {.inline.}=
    #echo "esc: ", str
    result = new KMEvent
    result.key = str
    result.evType = "FnKey"

proc char_parser(str:string): KMEvent {.inline.}=
    if str.len == 1 and (ord(str[0]) < 32 or ord(str[0]) == 127): #1-32, 127 control char
        #echo "ctrl: ", ord(str[0])
        #var res = new CtrlKeyEvent
        result = new KMEvent
        result.key = str
        result.ctrlKey = ord(str[0])
        result.evType = "CtrlKey"
        return result
    else:    
        #echo "char: ", str
        result = new KMEvent
        result.key = str
        result.evType = "Char"
        if mouse_state == 1:
            #echo "cancel drag op"
            mouse_state = 0





#
#              ███╗   ███╗ █████╗ ██╗███╗   ██╗
#              ████╗ ████║██╔══██╗██║████╗  ██║
#              ██╔████╔██║███████║██║██╔██╗ ██║
#              ██║╚██╔╝██║██╔══██║██║██║╚██╗██║
#              ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
#              ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
#

proc kmLoop*(): KMEvent  =
    var c: char
    var str: string = ""
    block tobreak:
        #while true:
            str = ""
            c = getch()
            if c == '\e':
                #str = str & "esc:"
                c = getch()
                str = str & c
                if c == '\e': # else CSI: [
                    #break tobreak
                    result=new KMEvent
                    result.evType = "EXIT"
                    return result
                c = getch()  # CSI begins here

                if c == '<': # mouse event
                    #var mbtn, mx, my:int
                    str = "" # reset to get parsable string
                    while not (c in ['M', 'm']) : #read mouse 'til end
                        c = getch()
                        if  c != 'M' and c != 'm'  : str = str & c
                    result = mouse_parser(str, c)
                    #mouse_cb(app, mEv )
                    return result

                
                else: # function key
                    while not (c in ['A','B','C','D','F','H','P','Q','R','S','~', 'M']) :
                        str = str & c
                        c = getch()
                    str = str & c
                    #echo str
                    result =  esc_parser(str)
                    #esc_cb(app, esc_parser(str) )
                    return result
                    #str = ""
            else :
                str = str & c
                #echo uint8(c) shr 7
                # https://zaemis.blogspot.com/2011/06/reading-unicode-utf-8-in-c.html
                var utf8len : int = 0
                if (uint8(c) and 192) == 192 : utf8len.inc
                if (uint8(c) and 224) == 224 : utf8len.inc
                if (uint8(c) and 240) == 240 : utf8len.inc
                #echo utf8len + 1
                if utf8len > 0:
                    for i in 1..utf8len:
                        c = getch()
                        str = str & c
                #echo str
                #char_cb( app, char_parser(str) )
                result = char_parser(str)
                return result


#                ████████╗███████╗███████╗████████╗
#                ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝
#                   ██║   █████╗  ███████╗   ██║   
#                   ██║   ██╔══╝  ╚════██║   ██║   
#                   ██║   ███████╗███████║   ██║   
#                   ╚═╝   ╚══════╝╚══════╝   ╚═╝   
                                                                  


when isMainModule:
    resetAttributes()
    echo "\e[?1002h\e[?1006h"
    #............
                    
   

    #............
    echo "\e[?1006l\e[?1002l"
    resetAttributes()