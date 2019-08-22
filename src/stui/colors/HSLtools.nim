#import math, strutils

from math import classify, FloatClass, sum
from strutils import formatFloat, FloatFormatMode


type
  HSL* = object
    h*: float
    s*: float
    l*: float

proc `$`*(hsl:HSL):string=
  result = "("
  result &= formatFloat(hsl.h, ffDecimal, 4) & ", "
  result &= formatFloat(hsl.s, ffDecimal, 3) & ", "
  result &= formatFloat(hsl.l, ffDecimal, 3)
  result &= ")"




proc getMin*[T](args: varargs[T]):T=
  result = T.high
  for arg in args:
    if arg < result:
      result = arg

proc getMax*[T](args: varargs[T]):T=
  result = 0
  for arg in args:
    if arg > result:
      result = arg


proc `div`*(x,y:float):float=
  var i:int=1
  while y * i.float < x:
    i += 1
  return i.float - 1


iterator countUp*(x,y,step:float):float=
  var r = x
  while r + step < y:
    yield r
    r += step

iterator countDown*(x,y,step:float):float=
  var r = x
  while r - step > y:
    yield r
    r -= step


proc getHUERegion*(hsl:HSL):int=
 var r = (hsl.h div 0.15) * 0.15
 result = if r < hsl.h: r.int + 1 else: r.int


#[ proc getCluster*(x:float, divider:int=10, max:float=1.0):int=
  ## classifier function
  ## for RGB HUE best values are 14, 8, 16
  var counter: int
  for c in countUp(max / divider.float, max, max / divider.float):
    if x <= c: 
      return counter
    counter += 1
  return counter ]#




proc lightness*[T](args: varargs[T]):float=
  ## absolute lightness of RGB color
  ## maxlight:int=255
  result = (sum(args) / args.len) / 255

template lightness*(rgb:tuple[r,g,b:int]):float=
  lightness(rgb.r,rgb.g,rgb.b)

proc saturation*[T](args: varargs[T]):float=
  ## absolute saturation of RGB color
  var ma = getMax(args)
  result = (ma - getMin(args)) / 255

  # relative saturation would be:
  #result = lightness(args) / (ma / (ma - getMin(args)))

  if math.classify(result) == fcNan: result = 0

template saturation*(rgb:tuple[r,g,b:int]):float=
  saturation(rgb.r,rgb.g,rgb.b)

template vibrancy*(rgb:tuple[r,g,b:int]):float=
  (lightness(rgb.r,rgb.g,rgb.b) + saturation(rgb.r,rgb.g,rgb.b)) / 2.float

proc getHUE*[T](args:varargs[T]):float=
  var 
    ma = getMax(args)
    mi = getMin(args)

  if args[0] == ma:
    result = (args[1] - args[2]) / (args[0] - mi) * 0.5
    if result < 0 : result = 3 + result

  if args[1] == ma:
    result = (args[2] - args[0]) / (args[1] - mi) * 0.5 + 1

  if args[2] == ma:
    result = (args[0] - args[1]) / (args[2] - mi) * 0.5 + 2

  result = result / 3

  if math.classify(result) == fcNan: result = 0



proc RGBtoHSL*[T](arr:varargs[T]):HSL=
  result.h = getHUE(arr) #RGBtoHSL(arr[0].float,arr[1].float,arr[2].float).h
  result.s = saturation(arr)
  result.l = lightness(arr)


proc closerHSL*(a,b,c:HSL):bool=
  ## uses absolute-error, the sum of differencies, to compare
  result = false

  if abs(a.h - b.h) + abs(a.s - b.s) + abs(a.l - b.l) <
    abs(a.h - c.h) + abs(a.l - c.l) + abs(a.s - c.s) 
  :
      result = true


proc diffHSL*(a,b:HSL):float=
  result = (abs(a.h - b.h) + abs(a.s - b.s) + abs(a.l - b.l))
    

proc inHUERange*(hsl:HSL, rngbgn, rngend:float):bool=
  ## returns true if HUE within range rngbgn - rngend
  ## handles the HUE circle: 1.03 is really 0.03
  ## - it wraps around
  var
    rngbgn = rngbgn
    rngend = rngend
  if rngend <= 1.0:
    if hsl.h >= rngbgn and hsl.h <= rngend: result = true
  else:
    if rngbgn > 1:
      rngbgn -= 1.0
      rngend -= 1.0
      if hsl.h >= rngbgn and hsl.h <= rngend: result = true
    else:
      if hsl.h >= rngbgn and hsl.h <= 1.0: result = true

      rngend -= 1.0
      if hsl.h >= 0 and hsl.h <= rngend: result = true













#[ 
proc RGBtoHSL*(red,green,blue:float): tuple[h,s,l:float]=
  ## from: https://gist.github.com/mjackson/5311256
  ## * Converts an RGB color value to HSL. Conversion formula
  ## * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
  ## * Assumes r, g, and b are contained in the set [0, 255] and
  ## * returns h, s, and l in the set [0, 1].
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
  #h = (ma + mi) / 2 # moved to else
  l = (ma + mi) / 2
  #s = (ma + mi) / 2 # moved to else, see below

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
 ]#