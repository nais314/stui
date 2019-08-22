import colors, strutils, terminal_extra, terminal
import colors/colors256
import colors/colorsRGBto256
import os, osproc


#type ColorTable = array[int, tuple[name: string, color:int]]

const colorNames16* = [
  ("fgBlack",30),
  ("fgRed",31),
  ("fgGreen",32),
  ("fgYellow",33),
  ("fgBlue",34),
  ("fgMagenta",35),
  ("fgCyan",36),
  ("fgWhite",37),

  ("bgBlack",40),
  ("bgRed",41),
  ("bgGreen",42),
  ("bgYellow",43),
  ("bgBlue",44),
  ("bgMagenta",45),
  ("bgCyan",46),
  ("bgWhite",47),


  ("fgBrightBlack",90),
  ("fgBrightRed",91),
  ("fgBrightGreen",92),
  ("fgBrightYellow",93),
  ("fgBrightBlue",94),
  ("fgBrightMagenta",95),
  ("fgBrightCyan",96),
  ("fgBrightWhite",97),

  ("bgBrightBlack",100),
  ("bgBrightRed",101),
  ("bgBrightGreen",102),
  ("bgBrightYellow",103),
  ("bgBrightBlue",104),
  ("bgBrightMagenta",105),
  ("bgBrightCyan",106),
  ("bgBrightWhite",107)  
]


type 
  PackedRGB*  = distinct int32
  Color16* = distinct int


proc extractRGB*(a: int): tuple[r, g, b: range[0..255]] =
  ## extracts the red/green/blue components of the color `a`.
  result.r = a.int shr 16 and 0xff
  result.g = a.int shr 8 and 0xff
  result.b = a.int and 0xff
proc extractRGB*(a: PackedRGB): tuple[r, g, b: range[0..255]] = extractRGB(int(a))


proc packRGB*(r,g,b:int): PackedRGB =
  ## pack r,g,b values into 1 int32, PackedRGB
  result = PackedRGB(r shl 16 or g shl 8 or b)
proc packRGB*(a:seq[string]): PackedRGB =
  ## pack r,g,b values into 1 int32, PackedRGB
  var
    r,g,b:int

  r = parseInt(a[0])
  g = parseInt(a[1])
  b = parseInt(a[2])

  result = PackedRGB(r shl 16 or g shl 8 or b)

proc `$`*(a: PackedRGB): string =
  $int(a)










proc searchColorTable*(
  colorTable: openArray[tuple[name: string, col: int]],
  colorName: string): int =
  ## returns color number or -1 if not found

  result = -1 # not found
  for i in 0..colorTable.high:
    if toLowerAscii(colorTable[i].name) == toLowerAscii(colorName):
      return colorTable[i].col


#[ proc getColorMode(): int =
var str = getEnv("COLORTERM") #$execProcess("printenv COLORTERM")
if str notin ["truecolor", "24bit"]:
str = $execProcess("tput colors")

case str:
of   "8": result = 0
of  "16": result = 1
of "256": result = 2
else: result = 1
else:
result = 3 ]#


proc parseColor*(colorName: string, colorMode: int): int {.gcsafe.}=
  ## searches for colors int value by name
  ## you better search for valid color names... ;)
  case colorMode:
    of 0,1: result = searchColorTable(colorNames16, colorName) 
    of 2:   
      result = searchColorTable(colorNames256, colorName) 
      if result == -1:
        result = searchColorTable(colorNamesRGBto256, colorName)
    of 3:
        try:
          result = int(colors.parseColor( toLowerAscii(colorName)))
        except:
          result = 0
    else: result = 0

proc parseColor*(colorName: string): int = parseColor(colorName, getColorMode())











# 16 colors 8 + bright...
# "Later terminals added the ability to directly specify the "bright" colors with 90-97 and 100-107. "
# - but for me, only adding styleBright gives good results
proc setForegroundColor*(f: File, col: Color16) =
  f.write("\e[" & $int(col) & "m")

proc setForegroundColor*(col: Color16) =
  setForegroundColor(stdout, col)

proc setBackgroundColor*(f: File, col: Color16) =
  f.write("\e[" & $int(col) & "m")

proc setBackgroundColor*(col: Color16) =
  setForegroundColor(stdout, col)



# Color256   Color256   Color256   Color256   Color256   Color256   
proc setBackgroundColor*(f: File, col: Color256) =
  f.write("\e[48;5;" & $int(col) & "m")

proc setBackgroundColor*(col: Color256) =
  setBackgroundColor(stdout, col)

proc setForegroundColor*(f: File, col: Color256) =
  f.write("\e[38;5;" & $int(col) & "m")

proc setForegroundColor*(col: Color256) =
  setForegroundColor(stdout, col)



# RGB colors RGB   RGB   RGB   RGB   RGB   RGB   RGB   RGB   RGB   
proc setForegroundColor*(f: File, col: PackedRGB) =
  let color = extractRGB(col)
  f.write("\e[38;2;" & $color.r & ";" & $color.g & ";" & $color.b & "m")

proc setForegroundColor*(col: PackedRGB) =
  setForegroundColor(stdout, col)


proc setBackgroundColor*(f: File, col: PackedRGB) =
  let color = extractRGB(col)
  f.write("\e[48;2;" & $color.r & ";" & $color.g & ";" & $color.b & "m")

proc setBackgroundColor*(col: PackedRGB) =
  setBackgroundColor(stdout, col)



proc setBackgroundColor*(color: int){.gcsafe.} =
  let cmode = getColorMode()
  case cmode:
    of 0,1:
      colors_extra.setBackgroundColor(Color16(color))
    of 2:
      colors_extra.setBackgroundColor(Color256(color))
    of 3:
      colors_extra.setBackgroundColor(PackedRGB(color))
    else: discard
#................................

proc setForegroundColor*(colorname: string){.gcsafe.} =
  let cmode = getColorMode()
  let color = colors_extra.parseColor(colorname, cmode)
  case cmode:
    of 0,1:
      colors_extra.setForegroundColor(Color16(color))
    of 2:
      colors_extra.setForegroundColor(Color256(color))
    of 3:
      colors_extra.setForegroundColor(PackedRGB(color))
    else: discard


proc setForegroundColor*(color: int){.gcsafe.} =
  let cmode = getColorMode()
  case cmode:
    of 0,1:
      colors_extra.setForegroundColor(Color16(color))
    of 2:
      colors_extra.setForegroundColor(Color256(color))
    of 3:
      colors_extra.setForegroundColor(PackedRGB(color))
    else: discard

#...............................................................................



when isMainModule:#------------------------------------------------
  echo packRGB(214,200,113)
  echo extractRGB(packRGB(214,200,113))
