import HSLDist256table, math


proc getMin*[T](args: varargs[T]):T=
  result = T.high
  for arg in args:
    if arg < result:
      result = arg

proc getMax*[T](args: varargs[T]):T=
  for arg in args:
    if arg > result:
      result = arg

iterator countUp*(x,y,step:float):float=
  var r = x
  while r + step < y:
    yield r
    r += step

proc getCluster*(x:float, divider:int=10, max:float=1.0):int=
  var counter: int
  for c in countUp(max / divider.float, max, max / divider.float):
    if x <= c: 
      return counter
    counter += 1
  return counter


proc RGBtoHSL*(red,green,blue:float): tuple[h,s,l:float]=
  var 
    r = red
    b = blue
    g = green
    h,l,s:float
    mi, ma:float

  r /= 255
  g /= 255
  b /= 255
  mi = getMin( r,g,b )
  ma = getMax( r,g,b )
  #h = (ma + mi) / 2
  l = (ma + mi) / 2
  #s = (ma + mi) / 2

  if ma == mi:
    h = 0
    s = 0
  else:
    h = l
    s = l

    var d = ma - mi

    s = if l > 0.5 : d / (2 - ma - mi) else: d / (ma + mi)

    if ma == r: h = (g - b) / d + (if g < b : 6 else: 0)
    if ma == g: h = (b - r) / d + 2
    if ma == b: h = (r - g) / d + 4

    h /= 6

  result = (h,s,l)

proc getHSLDistance*(v:tuple[h,s,l:float]):float=
  result = sqrt(v.h * v.h + v.s * v.s + v.l * v.l  )

var
  incr = 50
  r,g,b:int
  hslDist256, hslDist:float
  c256: int
  hsl, dist: tuple[h,s,l:float]
  found:bool
  hueDistance:float
  huec:int


for r in countup(0,255, incr):
  for g in countup(0,255, incr):
    for b in countup(0,255, incr):

      hsl = RGBtoHSL(r.float,g.float,b.float)
      hslDist = getHSLDistance(hsl)
      huec = getCluster(hsl.h, 50)

      found = false
      hueDistance = 0
      hslDist256 = 9999
      dist.h = 99
      dist.s = 99
      dist.l = 99
      #[ while not found and hueDistance < 1:
        hueDistance += 0.05 ]#
      block SEARCH:
        for d in 0..255:
          if huec == getCluster(HSLD256[d][0], 50):
          #if hsl.h - hueDistance < HSLD256[d][0] and hsl.h + hueDistance > HSLD256[d][0]:

            #echo hsl.h, " vs ", HSLD256[d][0], "    ", hueDistance
            #if abs(hslDist - HSLD256[d][3]) < hslDist256 and #!
            #if  abs(hsl.h - HSLD256[d][0]) < dist.h and
              #[ (abs(hsl.s - HSLD256[d][1]) + abs(hsl.l - HSLD256[d][2]) < 
              dist.s + dist.l): ]#
            #[ if  (abs(hsl.s - HSLD256[d][1]) < dist.s or
              abs(hsl.l - HSLD256[d][2]) < dist.l) : ]#

            if abs(hsl.l - HSLD256[d][2]) < dist.l and 
              abs(hsl.s - HSLD256[d][1]) < dist.s + 0.05 and
              abs(hsl.h - HSLD256[d][0]) < dist.h + 0.1:  
                c256 = d
                hslDist256 = abs(hslDist - HSLD256[d][3])
                found = true
                dist.h = abs(hsl.h - HSLD256[d][0])
                dist.s = abs(hsl.s - HSLD256[d][1])
                dist.l = abs(hsl.l - HSLD256[d][2])

            #[ if abs(hsl.h - HSLD256[d][0]) < dist.h and
              (abs(hsl.s - HSLD256[d][1]) < dist.s or
              abs(hsl.l - HSLD256[d][2]) < dist.l) :
                  c256 = d
                  dist.h = abs(hsl.h - HSLD256[d][0])
                  dist.s = abs(hsl.s - HSLD256[d][1])
                  dist.l = abs(hsl.l - HSLD256[d][2])
                  found = true ]#

      echo found,  ", R:", r,
        ", G:", g,
        ", B:", b,
        " \x1b[38;2;" & $r & ";" & $g & ";" & $b & "m ███\x1b[0m",
        " C256 ", $c256, ": \e[38;5;" & $int(c256) & "m " & "███ " & $c256 & "\e[0m",
        " H: ", HSLD256[c256][0], " vs ", hsl.h