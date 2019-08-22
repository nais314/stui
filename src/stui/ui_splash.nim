include "controll_inc.nim"

type
  SplashKind* = enum
    skText,
    skStuiImageFormat,
    skANS
  Splash* = ref object of Controll
    typ*: SplashKind
    case kind: SplashKind
    of skText:
      lines*: seq[string]
    of skStuiImageFormat:
      frames*: seq[seq[string]] ## frames, lines (i) 66milsec sleep for 15fps
      header*: seq[int] 
      ## header first line: `\e\x01 ..;..;.. \e[2K`
      ## width, height,
    of skANS:
      content*: string
    #lines*: seq[string] ## the image, characters only
    #[ colors*: seq[int] ## the colors
    colorMode*: int ## parsed from file ]#



proc draw*(this: Splash, updateOnly: bool = false)=
    #if this.visible: # visibility not applies here
    acquire(this.app.termlock)

    this.app.hideControlls() #! test

    setColors(this.app, this.activeStyle[])

    terminal_extra.clearScreen()

    #[ drawRect(this.leftX,
      this.topY,
      this.rightX,
      this.bottomY) ]#
    #...

    case this.typ:
    of skText:
      var
        x0 = (this.app.terminalWidth - this.width) div 2
        y0 = (this.app.terminalHeight - this.lines.len) div 2

      terminal_extra.setCursorPos(x0, y0)

      for L in this.lines:
        echo L
        terminal_extra.cursorForward(x0 - 1)

    else: discard
    #this.app.parkCursor()
    this.app.setCursorPos()

    release(this.app.termlock)
  

    
proc drawit(this: Controll, updateOnly: bool = false) =
  ## *MANDATORY* called by redraw or other Controll iterators
  draw(Splash(this), updateOnly)



proc show*(this: Splash, timeout: int = 0)=
  this.app.hideControlls()
  this.draw()
  if timeout > 0:
    sleep(timeout)
    this.app.redraw()


proc focus(this: Controll)=
  this.prevStyle = this.activeStyle 
  this.activeStyle = this.styles["input:focus"]


proc blur(this: Controll)=
  if this.prevStyle != nil: this.activeStyle = this.prevStyle # prevstyle may not initialized

proc cancel(this: Controll)=discard

# made public to call if replaced - new method of event listener adding
proc onClick*(this: Controll, event:KMEvent)= discard

proc onDrag(this: Controll, event:KMEvent)= discard

proc onDrop(this: Controll, event:KMEvent)= discard

proc onKeyPress(this: Controll, event:KMEvent)= discard





proc newSplash*(win:Window, kind: SplashKind): Splash =
  result = Splash(kind: kind)

  result.visible = false
  result.disabled = false
  result.width = 0

  result.app = win.app
  result.win = win
  result.listeners = @[]

  result.styles = newStyleSheets()

  var styleNormal: StyleSheetRef = new StyleSheetRef
  styleNormal.deepcopy win.app.styles["window"]
  result.styles.add("window",styleNormal)  
  result.activeStyle = result.styles["window"]
   
  #[ var styleFocused: StyleSheetRef = new StyleSheetRef
  styleFocused.deepcopy win.app.styles["input:focus"]
  result.styles.add("input:focus",styleFocused)

  var styleDragged: StyleSheetRef = new StyleSheetRef
  styleDragged.deepCopy win.app.styles["input:drag"]
  result.styles.add("input:drag",styleDragged)

  var styleDisabled: StyleSheetRef = new StyleSheetRef
  styleDisabled.deepcopy win.app.styles["input:disabled"]
  result.styles.add("input:disabled", styleDisabled) ]#

  result.drawit = drawit
  
  # dont add to win
  #win.controlls.add(result) # typical finish line


proc newSplash*(win:Window, str: string): Splash =
  result = newSplash(win, kind = skText)
  for L in strutils.splitLines(str):
    result.lines.add(L)
    if L.runeLen > result.width: result.width = L.runeLen





#[ 
proc parse*(splash:Splash, str:string)=
  ## to get information, the splash file or string needs to be parsed...
  ## it can be a simple string, or string with ansi escape sequences;
  ## or even an animation - a multi page ansi text.
  ## because of the escape sequences, line width is unknown, and 
  ## to center splash on screen, width needed.
  ## (height comes from num lines)
  var
    parsingEsc: bool = false # state
    esc: string
    currentLineLen, maxLineLen, currentFrame: int

  for line in lines(str):
    if line == "\x0C": # new frame FormFeed FF ASCII
      currentFrame.inc
    currentLineLen = 0
    for R in runes(line):
      if parsingEsc: # if we are in the middle of an escape sequence
        if not (($R)[0] in ['A','B','C','D','F','H','P','Q','R','S','~', 'M', 'm']): # not EOE
          esc &= $R
          continue
        else:
          esc &= $R
          #parseEsc(splash, esc)
          
          parsingEsc = false
          continue

      if R == '\e'.Rune: # escape, begin parsing
        parsingEsc = true

      currentLineLen.inc
      # END for R in runes(line)

    if currentLineLen > maxLineLen: maxLineLen = currentLineLen

    splash.frames[currentFrame].add(line)

    #END for line in lines(str)

  splash.width = maxLineLen ]#