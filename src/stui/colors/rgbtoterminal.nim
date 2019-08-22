## this module helps convert RGB to 256, 16, 8 color mode

import stui/colors_extra
import stui/colors/HSLtools
import stui/colors/Color256RGB
import strutils

proc RGBtoTerminalColor*(r,g,b:int, maxcolors:int=256):int=
  let maxcolors = maxcolors - 1

  var
    arr: array[0..2, int]
    hsl:HSL
    hslList: seq[HSL]

  hslList.setLen(maxcolors + 1)
  for col in 0..maxcolors:
    (arr[0],arr[1],arr[2]) = extractRGB(Color256RGB[col])

    hsl = RGBtoHSL(arr)
    hslList[col] = hsl

    #echo arr, ": \e[38;5;" & $col & "m " & "███ " & $col & "\e[0m ", hsl



  var
    #incr: int = 51 #51
    #arr: array[0..2,int]
    #result:int
    found:bool

    #seqfound: seq[int]
    f1:float
    f2:float

  arr = [r,g,b]

  hsl = RGBtoHSL(arr)
  found = false
  result = 0
  #seqfound = @[]

  f1 = (hsl.h div 0.15) * 0.15
  f2 = f1 + 0.15
  #echo f1, ", ", f2

  for ireg in countDown(hsl.h, f1, 0.025):
    for i in countdown(maxcolors,0):
      if abs(hslList[i].h - ireg) < 0.001:
        #echo "down: ", hslList[i].h ,", ", ireg
        #seqfound.add(i)
        found = true

        if closerHSL(hsl, hslList[i], hslList[result]):
          result = i
          #found = true
          if hsl == hslList[i]: break

  for ireg in countUp(hsl.h, f2, 0.025):
    for i in countdown(maxcolors,0):
      if abs(hslList[i].h - ireg) < 0.001:
        #echo "upp: ", hslList[i].h ,", ", ireg
        #seqfound.add(i)
        found = true

        if closerHSL(hsl, hslList[i], hslList[result]):
          result = i
          if hsl == hslList[i]: break

  #echo diffHSL(hsl, hslList[result])
  # if not found, then search in a widening range, from the pont of
  # the searched color
  # its like an exapnding cube.
  # searched regions are not searched again
  # well, once it was a cube, now wo lightness and saturation it is not ;)

  #[ when isMainModule:
    if (not found and f1 < 1.0) or 
      (diffHSL(hsl, hslList[result]) > 0.5 and maxcolors == 255):
        echo "wider search method" ]#

  f1 = 0 # begin of range
  f2 = 0.05 # increment or step
  while (not found and f1 < 1.0) or 
    (diffHSL(hsl, hslList[result]) > 0.5 and maxcolors == 255):

    for i in countdown(maxcolors,0):

      if (
        # right edge - inHUERange is capable to wrap around
        inHUERange(hsl, (hslList[i].h + f1),  (hslList[i].h + f1 + f2)) or
        # left edge
        inHUERange(hsl, (hslList[i].h - (f1 + f2)),  (hslList[i].h - f1))
        )
      :
        #seqfound.add(i)
        found = true

        if closerHSL(hsl, hslList[i], hslList[result]):
          result = i
          if hsl == hslList[i]: break


    if not found:
      f1 = (f1 + f2)



template RGBto256Color*(r,g,b:int):int=
  RGBtoTerminalColor*(r,g,b, maxcolors=256)


proc RGBto16Color*(r,g,b:int, isForegroundColor:bool=true):int=
  result = RGBtoTerminalColor(r,g,b,16)

  if result > 7:
    result = result - 8 + 90
  else:
    result = result + 30

  if not isForegroundColor:
    result += 10

template RGBto16Color*(rgb: tuple[r,g,b:int], isForegroundColor:bool=true):int=
  RGBto16Color(rgb.r,rgb.g,rgb.b, isForegroundColor)


proc RGBto8Color*(r,g,b:int, isForegroundColor:bool=true):int=
  result = RGBtoTerminalColor(r,g,b,8)

  result = result + 30

  if not isForegroundColor:
    result += 10

#!------------------------------------------------------------------------------
when isMainModule:
  import colors

  const colorNames = [
      ("aliceblue", colAliceBlue),
      ("antiquewhite", colAntiqueWhite),
      ("aqua", colAqua),
      ("aquamarine", colAquamarine),
      ("azure", colAzure),
      ("beige", colBeige),
      ("bisque", colBisque),
      ("black", colBlack),
      ("blanchedalmond", colBlanchedAlmond),
      ("blue", colBlue),
      ("blueviolet", colBlueViolet),
      ("brown", colBrown),
      ("burlywood", colBurlyWood),
      ("cadetblue", colCadetBlue),
      ("chartreuse", colChartreuse),
      ("chocolate", colChocolate),
      ("coral", colCoral),
      ("cornflowerblue", colCornflowerBlue),
      ("cornsilk", colCornsilk),
      ("crimson", colCrimson),
      ("cyan", colCyan),
      ("darkblue", colDarkBlue),
      ("darkcyan", colDarkCyan),
      ("darkgoldenrod", colDarkGoldenRod),
      ("darkgray", colDarkGray),
      ("darkgreen", colDarkGreen),
      ("darkkhaki", colDarkKhaki),
      ("darkmagenta", colDarkMagenta),
      ("darkolivegreen", colDarkOliveGreen),
      ("darkorange", colDarkorange),
      ("darkorchid", colDarkOrchid),
      ("darkred", colDarkRed),
      ("darksalmon", colDarkSalmon),
      ("darkseagreen", colDarkSeaGreen),
      ("darkslateblue", colDarkSlateBlue),
      ("darkslategray", colDarkSlateGray),
      ("darkturquoise", colDarkTurquoise),
      ("darkviolet", colDarkViolet),
      ("deeppink", colDeepPink),
      ("deepskyblue", colDeepSkyBlue),
      ("dimgray", colDimGray),
      ("dodgerblue", colDodgerBlue),
      ("firebrick", colFireBrick),
      ("floralwhite", colFloralWhite),
      ("forestgreen", colForestGreen),
      ("fuchsia", colFuchsia),
      ("gainsboro", colGainsboro),
      ("ghostwhite", colGhostWhite),
      ("gold", colGold),
      ("goldenrod", colGoldenRod),
      ("gray", colGray),
      ("green", colGreen),
      ("greenyellow", colGreenYellow),
      ("honeydew", colHoneyDew),
      ("hotpink", colHotPink),
      ("indianred", colIndianRed),
      ("indigo", colIndigo),
      ("ivory", colIvory),
      ("khaki", colKhaki),
      ("lavender", colLavender),
      ("lavenderblush", colLavenderBlush),
      ("lawngreen", colLawnGreen),
      ("lemonchiffon", colLemonChiffon),
      ("lightblue", colLightBlue),
      ("lightcoral", colLightCoral),
      ("lightcyan", colLightCyan),
      ("lightgoldenrodyellow", colLightGoldenRodYellow),
      ("lightgrey", colLightGrey),
      ("lightgreen", colLightGreen),
      ("lightpink", colLightPink),
      ("lightsalmon", colLightSalmon),
      ("lightseagreen", colLightSeaGreen),
      ("lightskyblue", colLightSkyBlue),
      ("lightslategray", colLightSlateGray),
      ("lightsteelblue", colLightSteelBlue),
      ("lightyellow", colLightYellow),
      ("lime", colLime),
      ("limegreen", colLimeGreen),
      ("linen", colLinen),
      ("magenta", colMagenta),
      ("maroon", colMaroon),
      ("mediumaquamarine", colMediumAquaMarine),
      ("mediumblue", colMediumBlue),
      ("mediumorchid", colMediumOrchid),
      ("mediumpurple", colMediumPurple),
      ("mediumseagreen", colMediumSeaGreen),
      ("mediumslateblue", colMediumSlateBlue),
      ("mediumspringgreen", colMediumSpringGreen),
      ("mediumturquoise", colMediumTurquoise),
      ("mediumvioletred", colMediumVioletRed),
      ("midnightblue", colMidnightBlue),
      ("mintcream", colMintCream),
      ("mistyrose", colMistyRose),
      ("moccasin", colMoccasin),
      ("navajowhite", colNavajoWhite),
      ("navy", colNavy),
      ("oldlace", colOldLace),
      ("olive", colOlive),
      ("olivedrab", colOliveDrab),
      ("orange", colOrange),
      ("orangered", colOrangeRed),
      ("orchid", colOrchid),
      ("palegoldenrod", colPaleGoldenRod),
      ("palegreen", colPaleGreen),
      ("paleturquoise", colPaleTurquoise),
      ("palevioletred", colPaleVioletRed),
      ("papayawhip", colPapayaWhip),
      ("peachpuff", colPeachPuff),
      ("peru", colPeru),
      ("pink", colPink),
      ("plum", colPlum),
      ("powderblue", colPowderBlue),
      ("purple", colPurple),
      ("red", colRed),
      ("rosybrown", colRosyBrown),
      ("royalblue", colRoyalBlue),
      ("saddlebrown", colSaddleBrown),
      ("salmon", colSalmon),
      ("sandybrown", colSandyBrown),
      ("seagreen", colSeaGreen),
      ("seashell", colSeaShell),
      ("sienna", colSienna),
      ("silver", colSilver),
      ("skyblue", colSkyBlue),
      ("slateblue", colSlateBlue),
      ("slategray", colSlateGray),
      ("snow", colSnow),
      ("springgreen", colSpringGreen),
      ("steelblue", colSteelBlue),
      ("tan", colTan),
      ("teal", colTeal),
      ("thistle", colThistle),
      ("tomato", colTomato),
      ("turquoise", colTurquoise),
      ("violet", colViolet),
      ("wheat", colWheat),
      ("white", colWhite),
      ("whitesmoke", colWhiteSmoke),
      ("yellow", colYellow),
      ("yellowgreen", colYellowGreen)]


  var r,g,b,choice:int
  for color in colorNames:
    #echo color[1]
    (r,g,b) = extractRGB(color[1])
    #echo (r,g,b)

    choice = RGBtoTerminalColor(r,g,b)
    var choice16 = RGBtoTerminalColor(r,g,b,16)
    var choice8 = RGBtoTerminalColor(r,g,b,8)

    echo  " \x1b[38;2;" & $r & ";" & $g & ";" & $b & "m ███\x1b[0m ", 
          " choice: \e[38;5;" & $choice & "m " & "███ "  & "\e[0m " & intToStr(choice,4),
          " choice16: \e[38;5;" & $choice16 & "m " & "███ "  & "\e[0m " & intToStr(choice16,4),
          " choice8: \e[38;5;" & $choice8 & "m " & "███ "  & "\e[0m " & intToStr(choice8,3)
    

