import os, osproc
import termios

#[
    http://www.termsys.demon.co.uk/vtansi.htm
]#

proc getColorMode*(): int =
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

proc switchToAlternateBuffer*() {.inline.} =
    stdout.write "\e[?1049h\e[H" #and move to home position

proc switchToNormalBuffer*() {.inline.} =
    stdout.write "\e[?1049l"


proc setCursorPos*(x,y:int) {.inline.} =
    stdout.write("\e[" & $y & ";" & $x & "H") # H-ome : standard, more referenced
    #stdout.write("\e[" & $y & ";" & $x & "f") # f-orce : this should be it...


#[ 

# not working as espected - disabling ECHO should remove mouse output on screen
# and enable Channels/sleep on main thread but it hides cursor (?)

proc disableEchoAndCanon*()=
    # from terminal readPassword
    let fd = stdin.getFileHandle()
    var cur: Termios
    discard fd.tcgetattr(cur.addr)
    cur.c_lflag = cur.c_lflag and not Cflag(ECHO)
    cur.c_lflag = cur.c_lflag or Cflag(ICANON)
    discard fd.tcsetattr(TCSANOW, cur.addr) #TCSADRAIN

proc enableEchoAndCanon*()=
    # from terminal readPassword
    let fd = stdin.getFileHandle()
    var cur: Termios
    discard fd.tcgetattr(cur.addr)
    cur.c_lflag = cur.c_lflag or Cflag(ECHO)
    cur.c_lflag = cur.c_lflag and not Cflag(ICANON)
    discard fd.tcsetattr(TCSANOW, cur.addr)
 ]#

# looks like resetting terminal resets this too, bt anyway...
proc disableCanon*()=
    # from terminal readPassword
    let fd = stdin.getFileHandle()
    var cur: Termios
    discard fd.tcgetattr(cur.addr)
    cur.c_lflag = cur.c_lflag or Cflag(ICANON)
    discard fd.tcsetattr(TCSANOW, cur.addr) #TCSADRAIN

# if not used, after stdout.write a '\n' needs to be written!! for screen update
# looks like \n needs to be written anyway... ?!
proc enableCanon*()=
    # from terminal readPassword
    let fd = stdin.getFileHandle()
    var cur: Termios
    discard fd.tcgetattr(cur.addr)
    cur.c_lflag = cur.c_lflag and not Cflag(ICANON)
    discard fd.tcsetattr(TCSANOW, cur.addr)


proc setReversed*(){.inline.}=
    stdout.write "\e[7m"

proc setDimmed*(){.inline.}=
    stdout.write "\e[2m"

proc setUnderline*(){.inline.}=
    stdout.write "\e[4m"

proc resetStyle*(){.inline.}=
    ## Reset all attributes
    stdout.write "\e[0m"

proc resetTerminal*() {.inline.}= 
    ## Reset all terminal settings to default
    stdout.write "\ec"


proc clearScreen*(){.inline.}=
    ## Erases the screen with the background colour and moves the cursor to home.
    stdout.write "\e[2J\e[H"

proc cursorForward*(n:int=1){.inline.}=
    ## Move Cursor to the right with n characters
    stdout.write "\e[" & $n & "C"
