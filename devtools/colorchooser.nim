import terminal, colors, stui/colors/colors256, strutils

var 
    c256: Color256
    c8fg: ForegroundColor = fgGreen
    c8bg: BackgroundColor = bgBlack

var i: int

echo "\n\nFG 256 COLORS [38;5;<col#>m [48;5;<col#>m  ************************************\n"

while i < 256:
    c256 = Color256(i)
    stdout.write("\e[38;5;" & $int(c256) & "m " & "███ " & $c256 & "\e[0m" & " " & $i)
    i.inc
    c256 = Color256(i)
    stdout.write("\e[38;5;" & $int(c256) & "m " & "███ " & $c256 & "\e[0m" & " " & $i)
    i.inc

    c256 = Color256(i)
    stdout.write("\e[38;5;" & $int(c256) & "m " & "███ " & $c256 & "\e[0m" & " " & $i)
    i.inc
    c256 = Color256(i)
    stdout.write("\e[38;5;" & $int(c256) & "m " & "███ " & $c256 & "\e[0m" & " " & $i)
    i.inc

    echo '\n'
# white BG:    
while i < 256:
    c256 = Color256(i)
    stdout.write("\e[48;5;15m")
    stdout.write("\e[38;5;" & $int(c256) & "m " & "███ " & $c256 & "\e[0m" & " " & $i)
    i.inc
    c256 = Color256(i)
    stdout.write("\e[48;5;15m")
    stdout.write("\e[38;5;" & $int(c256) & "m " & "███ " & $c256 & "\e[0m" & " " & $i)
    i.inc

    c256 = Color256(i)
    stdout.write("\e[48;5;15m")
    stdout.write("\e[38;5;" & $int(c256) & "m " & "███ " & $c256 & "\e[0m" & " " & $i)
    i.inc
    c256 = Color256(i)
    stdout.write("\e[48;5;15m")
    stdout.write("\e[38;5;" & $int(c256) & "m " & "███ " & $c256 & "\e[0m" & " " & $i)
    i.inc

    echo '\n'
# 256 background : [48;5;<col#>m

echo "\n\nFG COLORS [<col#>m ****************************************************\n"
i = 30
while i < 38:
    c8fg = ForegroundColor(i)
    stdout.write("\e[" & $int(c8fg) & "m " & "███ " & $c8fg & "\e[0m" & " " & $i)
    i.inc

echo "\n\nBRIGHT FG COLORS [<col#>;1m ==========================================================\n"
i = 30
while i < 38:
    c8fg = ForegroundColor(i)
    stdout.write("\e[" & $int(c8fg) & ";1m " & "███ " & $c8fg & "\e[0m" & " " & $i)
    i.inc

echo "\n\nBG COLORS [<col#>m ****************************************************\n"
i = 40
while i < 48:
    c8bg = BackgroundColor(i)
    stdout.write("\e[" & $int(c8bg) & "m " & "    " & $c8bg & "\e[0m" & " " & $i)
    i.inc

echo "\n\nBRIGHT BG COLORS [<col#>;1m ****************************************************\n"
i = 40
while i < 48:
    c8bg = BackgroundColor(i)
    stdout.write("\e[" & $int(c8bg) & ";1m " & "    " & $c8bg & "\e[0m" & " " & $i)
    i.inc

echo "\n\nTRUECOLOR [38;2;<r#>;<g#>;<b#>m [48;2;<r#>;<g#>;<b#>m ........................\n"
echo "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"
echo "\x1b[48;2;255;100;0mTRUECOLOR\x1b[0m\n"

echo '\n'

import os, osproc
var 
    str = getEnv("COLORTERM") #$execProcess("printenv COLORTERM")

    colorNamesRGB = [
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

terminal.resetAttributes()

var r,g,b: int

if str in ["truecolor", "24bit"]:
    enableTrueColors()
    for col in colorNamesRGB:

        #[ stdout.write "\e[0m"
        setBackgroundColor(Color(col[1]))
        setForegroundColor(colWhite)
        stdout.write alignLeft("    " & col[0], 25)
        stdout.write "\e[0m"

        setBackgroundColor(Color(col[1]))
        setForegroundColor(colBlack)
        stdout.write alignLeft("    " & col[0], 25) ]#

        stdout.write "\e[0m"
        (r,g,b) = extractRGB(col[1])
        stdout.write "\x1b[38;2;0;0;0m\x1b[48;2;" & $r & ";" & $g & ";" & $b & "m" & alignLeft("    " & $col[0], 25) & "\x1b[0m"
        stdout.write "\x1b[38;2;" & $r & ";" & $g & ";" & $b & "m" & alignLeft("    " & $col[0], 25) & "\x1b[0m\n"
        
        stdout.write "\e[0m"
        stdout.write "\n"


echo "\e[1mBold: \\u001b[1m \e[0m"
echo "\e[4mUnderline: \\u001b[4m \e[0m"
echo "\e[7mReversed: \\u001b[7m \e[0m"

echo "\e[5mBlink: \\u001b[5m \e[0m"
echo "\e[3mStandout: \\u001b[3m \e[0m"
echo "\e[2mDIM: \\u001b[2m \e[0m"

echo '\n'
echo '\n'

var w: int = terminalWidth()
for i in 0..55:
    w -= 26
    if w < 26:
        stdout.write "\n"
        w = terminalWidth()
    stdout.write "\e[" & $i & "m This is a test " & $i & "\e[0m      "
#[ 
    Font Effects
    https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences

    ╔══════════╦════════════════════════════════╦═════════════════════════════════════════════════════════════════════════╗
    ║  Code    ║             Effect             ║                                   Note                                  ║
    ╠══════════╬════════════════════════════════╬═════════════════════════════════════════════════════════════════════════╣
    ║ 0        ║  Reset / Normal                ║  all attributes off                                                     ║
    ║ 1        ║  Bold or increased intensity   ║                                                                         ║
    ║ 2        ║  Faint (decreased intensity)   ║  Not widely supported.                                                  ║
    ║ 3        ║  Italic                        ║  Not widely supported. Sometimes treated as inverse.                    ║
    ║ 4        ║  Underline                     ║                                                                         ║
    ║ 5        ║  Slow Blink                    ║  less than 150 per minute                                               ║
    ║ 6        ║  Rapid Blink                   ║  MS-DOS ANSI.SYS; 150+ per minute; not widely supported                 ║
    ║ 7        ║  [[reverse video]]             ║  swap foreground and background colors                                  ║
    ║ 8        ║  Conceal                       ║  Not widely supported.                                                  ║
    ║ 9        ║  Crossed-out                   ║  Characters legible, but marked for deletion.  Not widely supported.    ║
    ║ 10       ║  Primary(default) font         ║                                                                         ║
    ║ 11–19    ║  Alternate font                ║  Select alternate font `n-10`                                           ║
    ║ 20       ║  Fraktur                       ║  hardly ever supported                                                  ║
    ║ 21       ║  Bold off or Double Underline  ║  Bold off not widely supported; double underline hardly ever supported. ║
    ║ 22       ║  Normal color or intensity     ║  Neither bold nor faint                                                 ║
    ║ 23       ║  Not italic, not Fraktur       ║                                                                         ║
    ║ 24       ║  Underline off                 ║  Not singly or doubly underlined                                        ║
    ║ 25       ║  Blink off                     ║                                                                         ║
    ║ 27       ║  Inverse off                   ║                                                                         ║
    ║ 28       ║  Reveal                        ║  conceal off                                                            ║
    ║ 29       ║  Not crossed out               ║                                                                         ║
    ║ 30–37    ║  Set foreground color          ║  See color table below                                                  ║
    ║ 38       ║  Set foreground color          ║  Next arguments are `5;n` or `2;r;g;b`, see below                       ║
    ║ 39       ║  Default foreground color      ║  implementation defined (according to standard)                         ║
    ║ 40–47    ║  Set background color          ║  See color table below                                                  ║
    ║ 48       ║  Set background color          ║  Next arguments are `5;n` or `2;r;g;b`, see below                       ║
    ║ 49       ║  Default background color      ║  implementation defined (according to standard)                         ║
    ║ 51       ║  Framed                        ║                                                                         ║
    ║ 52       ║  Encircled                     ║                                                                         ║
    ║ 53       ║  Overlined                     ║                                                                         ║
    ║ 54       ║  Not framed or encircled       ║                                                                         ║
    ║ 55       ║  Not overlined                 ║                                                                         ║
    ║ 60       ║  ideogram underline            ║  hardly ever supported                                                  ║
    ║ 61       ║  ideogram double underline     ║  hardly ever supported                                                  ║
    ║ 62       ║  ideogram overline             ║  hardly ever supported                                                  ║
    ║ 63       ║  ideogram double overline      ║  hardly ever supported                                                  ║
    ║ 64       ║  ideogram stress marking       ║  hardly ever supported                                                  ║
    ║ 65       ║  ideogram attributes off       ║  reset the effects of all of 60-64                                      ║
    ║ 90–97    ║  Set bright foreground color   ║  aixterm (not in standard)                                              ║
    ║ 100–107  ║  Set bright background color   ║  aixterm (not in standard)                                              ║
    ╚══════════╩════════════════════════════════╩══════════════════════════════════════════
 ]#


echo "\e[0m" 