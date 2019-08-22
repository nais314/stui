import RGBx256table, stui/colors_extra, math, stui/colors/colors256, strutils, algorithm

import HSLtools

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


proc `div`(x,y:float):float=
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

proc lightness*[T](args: varargs[T], maxlight:int=255):float=
  result = (sum(args) / args.len).float / maxlight.float #(T.high).float
  #result = ((result) * (1 + result)) / 2
  #result = (getMax(args) + getMin(args)) / 2 / 255


proc saturation*[T](args: varargs[T], maxlight:int=255):float=
  var ma = getMax(args)
  #result = lightness(args) / (ma / (ma - getMin(args)))
  result = (ma - getMin(args)) / maxlight

  #result = ((result) * (1 + result)) / 2
  #result = 1 - 1 / ((1 + result) * (1 + result))
  #result = 1.float / ( ma.float / ( (sum(args) - ma).float / (args.len - 1).float ) )
  if math.classify(result) == fcNan: result = 0
  #echo result
  #[ if lightness(args) <= 0.5:
    result = result - (0.4 - lightness(args)) ]#
  #result = result - (1 - lightness(args))



type
  HSL = object
    h: float
    s: float
    l: float

const maxcolors = 15
var
  arr: array[0..2, int]

  res:HSL

  basec: array[0..maxcolors, HSL]


proc `$`*(hsl:HSL):string=
  result = "("
  result &= formatFloat(hsl.h, ffDecimal, 4) & ", "
  result &= formatFloat(hsl.s, ffDecimal, 3) & ", "
  result &= formatFloat(hsl.l, ffDecimal, 3)
  result &= ")"


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


proc closerHSL(a,b,c:HSL):bool=
  result = false

  if abs(a.h - b.h) + abs(a.s - b.s) + abs(a.l - b.l) <
    abs(a.h - c.h) + abs(a.l - c.l) + abs(a.s - c.s) 
  :
      result = true

    

proc inHUERange*(hsl:HSL, rngbgn, rngend:float):bool=
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

  



for col in 0..maxcolors:
  (arr[0],arr[1],arr[2]) = extractRGB(Color256RGB[col])

  res = RGBtoHSL(arr)
  basec[col] = res

  echo arr, ": \e[38;5;" & $col & "m " & "███ " & $col & "\e[0m ", res



var
  incr: int = 51 #51
  arr2: array[0..2,int]
  choice:int
  found:bool

  seqfound: seq[int]
  searchregion: float
  srstep:float

  hreg,hreg2:float
  

for rc in countup(0,255,incr):
  for gc in countup(0,255,incr):
    for bc in countup(0,255,incr):
#[ for rc in countup(200,250,incr):
  for gc in countup(200,250,incr):
    for bc in countup(200,250,incr): ]#
#[ for rc in countup(100,150,incr):
  for gc in countup(100,150,incr):
    for bc in countup(100,150,incr): ]#

      arr2 = [rc,gc,bc]

      res = RGBtoHSL(arr2)
      found = false
      choice = 0

      searchregion = 0
      srstep = 0.05
      seqfound = @[]

      hreg = (res.h div 0.15) * 0.15
      hreg2 = hreg + 0.15

      echo hreg, ", ", hreg2

      for ireg in countDown(res.h, hreg, 0.025):
        for i in countdown(maxcolors,0):
          if abs(basec[i].h - ireg) < 0.001:
            #echo "down: ", basec[i].h ,", ", ireg
            seqfound.add(i)
            found = true

            if closerHSL(res, basec[i], basec[choice]):
              choice = i
              #found = true
              if res == basec[i]: break

      for ireg in countUp(res.h, hreg2, 0.025):
        for i in countdown(maxcolors,0):
          if abs(basec[i].h - ireg) < 0.001:
            #echo "upp: ", basec[i].h ,", ", ireg
            seqfound.add(i)
            found = true

            if closerHSL(res, basec[i], basec[choice]):
              choice = i
              #found = true
              if res == basec[i]: break


      while not found and searchregion < 1.0 :
        #echo "wide search method"

        for i in countdown(maxcolors,0):

          basec[i] = basec[i]


          if (
            inHUERange(res, (basec[i].h + searchregion),  (basec[i].h + searchregion + srstep)) or
            inHUERange(res, (basec[i].h - (searchregion + srstep)),  (basec[i].h - searchregion))
            ) #[ and

            ((res.s + searchregion <= basec[i].s and
            res.s + (searchregion + srstep) >= basec[i].s) or
            (res.s - searchregion >= basec[i].s and
            res.s - (searchregion + srstep) <= basec[i].s)) and

            ((res.l + searchregion <= basec[i].l and
            res.l + (searchregion + srstep) >= basec[i].l) or
            (res.l - searchregion >= basec[i].l and
            res.l - (searchregion + srstep) <= basec[i].l)) ]#
          :
            seqfound.add(i)
            found = true

            if closerHSL(res, basec[i], basec[choice]):
              choice = i
              #found = true
              if res == basec[i]: break


        if not found:
          #echo "NFFFF"
          searchregion = (searchregion + srstep)


      echo found, 
        #" R:", rc, ", G:", gc, ", B:", bc,
        " \x1b[38;2;" & $rc & ";" & $gc & ";" & $bc & "m ███\x1b[0m ", 
        " choice: \e[38;5;" & $choice & "m " & "███ "  & "\e[0m " & $choice & " ",
        #res.s * res.l, " & ", basec[choice].s * basec[choice].l, "  ",
        res, " ", basec[choice], seqfound, searchregion
        #extractRGB(Color256RGB[choice])

