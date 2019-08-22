import RGBx256table, stui/colors_extra, math, stui/colors256, strutils

proc getMin*[T](args: varargs[T]):T=
  result = T.high
  for arg in args:
    if arg < result:
      result = arg

proc getMax*[T](args: varargs[T]):T=
  for arg in args:
    if arg > result:
      result = arg

type
  By = range[0..255]

const maxcolors = 35
var
  arr: array[0..2, By]
  ma,mi:By
  res: int

  cats: set[0..320]

  basec: array[0..maxcolors, int]


for col in 0..15:
  (arr[0],arr[1],arr[2]) = extractRGB(Color256RGB[col])

  ma = getMax(arr[0],arr[1],arr[2])
  mi = getMax(arr[0],arr[1],arr[2])
  res = 1
  for ia in 0 .. arr.high:
    res = res shl 2

    if arr[ia].float < ma / 2:
      res = res or 1
    else:
      if arr[ia] == ma:
        res = res or 3
      else:
        res = res or 2

  echo res, "\t", Color256(col), "\t", toBin(res,8), "\t", arr

  cats.incl(res)

  basec[col] = res

echo cats.card, " ", cats


var
  incr: int = 51
  arr2: array[0..2,int]
  choice:int

for rc in countup(0,255,incr):
  for gc in countup(0,255,incr):
    for bc in countup(0,255,incr):
      arr2 = [rc,gc,bc]

      ma = getMax(arr2[0],arr2[1],arr2[2])
      mi = getMax(arr2[0],arr2[1],arr2[2])
      res = 1
      for ia in 0 .. arr2.high:
        res = res shl 2
    
        if arr2[ia].float < ma / 2:
          res = res or 1
        else:
          if arr2[ia] == ma:
            res = res or 3
          else:
            res = res or 2

      choice = 0
      for i in 0..maxcolors:
        if abs(basec[i] - res) < abs(basec[choice] - res) and
          rc 
          choice = i

      echo "R:", rc,
        ", G:", gc,
        ", B:", bc,
        " \x1b[38;2;" & $rc & ";" & $gc & ";" & $bc & "m ███\x1b[0m ", res,
        " choice: \e[38;5;" & $int(choice) & "m " & "███ " & $choice & "\e[0m ",
        basec[choice]