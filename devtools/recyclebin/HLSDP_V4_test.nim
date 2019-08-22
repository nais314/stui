import HSLDP256table, math, HSLtools, strutils


var
  incr = 50
  r,g,b:int
  hslDist256, hslDist:float
  c256: int
  hsl, dist: tuple[h,s,l:float]
  found:bool
  hueDistance:float
  huec:int
  rgbform:int
  choice: tuple[r,g,b:int]


for r in countup(0,255, incr):
  for g in countup(0,255, incr):
    for b in countup(0,255, incr):

      hsl = RGBtoHSL(r.float,g.float,b.float)
      huec = getCluster(hsl.h, 100)
      rgbform = parseInt(getForm(r,g,b))

      found = false
      #[ hueDistance = 0
      hslDist256 = 9999
      dist.h = 99
      dist.s = 99
      dist.l = 99 ]#
      choice.r = 999
      choice.g = 999
      choice.b = 999

      block SEARCH:
        for d in 0..255:
          if huec == getCluster(HSLDP256[d][0], 100):
            if rgbform == HSLDP256[d][1].int:
              #echo rgbform , " ", HSLDP256[d][1].int
              #[ if abs( (r+g+b) - (HSLDP256[d][2].int + HSLDP256[d][3].int + HSLDP256[d][4].int) ) <
                abs( (r+g+b) - (choice.r + choice.g + choice.b) ): ]#
              if getMax( abs(r - HSLDP256[d][2].int),
                abs(g - HSLDP256[d][3].int),
                abs(b - HSLDP256[d][4].int)
                ) < getMax( abs(r - choice.r),
                abs(g - choice.g),
                abs(b - choice.b)
                ):
                    choice.r = r
                    choice.g = g
                    choice.b = b
                    found = true
                    c256 = d

      echo found,  ", R:", r,
        ", G:", g,
        ", B:", b,
        " \x1b[38;2;" & $r & ";" & $g & ";" & $b & "m ███\x1b[0m",
        " C256 ", $c256, ": \e[38;5;" & $int(c256) & "m " & "███ " & $c256 & "\e[0m"