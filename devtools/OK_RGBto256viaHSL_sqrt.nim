import HSL256table, math, HSLtools


var
  incr = 17 #51
  #r,g,b:int
  #hslDist:float
  choice: int
  hsl, dist: tuple[h,s,l:float]
  found:bool
  #hslDist256, hueDistance:float
  huec:int
  huedivider = 14#8


for r in countup(0,255, incr):
  for g in countup(0,255, incr):
    for b in countup(0,255, incr):

      hsl = RGBtoHSL(r.float,g.float,b.float)
      #hslDist = getHSLDistance(hsl)
      huec = getCluster(hsl.h, huedivider)

      found = false
      #hueDistance = 0
      #hslDist256 = 9999
      dist.h = 99
      dist.s = 99
      dist.l = 99
      #[ while not found and hueDistance < 1:
        hueDistance += 0.05 ]#
      block SEARCH:
        for d in 0..255:
          if huec == getCluster(HSL256[d][0], huedivider):

            if abs(hsl.l - HSL256[d][2]) < dist.l + 0.03 and
              abs(hsl.s - HSL256[d][1]) < dist.s + 0.07 and
              abs(hsl.h - HSL256[d][0]) < dist.h + 0.125 
              :  
                choice = d
                found = true
                dist.h = abs(hsl.h - HSL256[d][0])
                dist.s = abs(hsl.s - HSL256[d][1])
                dist.l = abs(hsl.l - HSL256[d][2])


      echo found,  ", R:", r,
        ", G:", g,
        ", B:", b,
        " \x1b[38;2;" & $r & ";" & $g & ";" & $b & "m ███\x1b[0m",
        " choice ", $choice, ": \e[38;5;" & $int(choice) & "m " & "███ " & $choice & "\e[0m",
        " H: ", HSL256[choice][0], " vs ", hsl.h