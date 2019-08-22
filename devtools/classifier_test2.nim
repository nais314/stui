import RGBx256table, stui/colors_extra, math, stui/colors256, strutils, algorithm

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

proc lightness*[T](args: varargs[T]):float=
  result = (sum(args) / args.len).float / 256 #(T.high).float

proc saturation*[T](args: varargs[T]):float=
  var ma = getMax(args)
  result = 1.float / ( ma.float / ( (sum(args) - ma).float / (args.len - 1).float ) )
  if math.classify(result) == fcNan: result = 0
  #echo result

#[ proc getMin*[T](args: openarray[T]):T=
  result = T.high
  for arg in args:
    if arg < result:
      result = arg

proc getMax*[T](args: openarray[T]):T=
  for arg in args:
    if arg > result:
      result = arg    ]#   

type
  By = range[0..255]

const maxcolors = 255
var
  arr: array[0..2, int]
  #ma,mi:int
  #res: int
  res:float

  #cats: set[0..320]

  basec: array[0..maxcolors, float]


proc classify*[T](args:varargs[T]):int=
  var 
    mi = getMin(args)
    arr : seq[T]

  arr = newSeq[T](args.len)
  for ia in 0 .. args.high:
    arr[ia] = args[ia] - mi

  var ma = getMax(arr)
  #result = 1
  var h = arr.len * arr.len
  for ia in 0 .. arr.high:
    if arr[ia] >= T(ma / 2): #== ma: #
      result = result + h
      h = h - 1
    else:
      h = h - arr.len

  result = result shl 5

proc classifyArray*[T](arr:varargs[T]):float=
  result = saturation(arr) + lightness(arr) + classify(arr).float 

#[ for col in 0..maxcolors:
  var rgb = extractRGB(Color256RGB[col])
  echo  Color256(col), "\t",
        classify(rgb.r,rgb.g,rgb.b), " S: ",
        
        saturation(rgb.r,rgb.g,rgb.b), " L: ",
        lightness(rgb.r,rgb.g,rgb.b), " -C: ",
        " -- ",
        sqrt( saturation(rgb.r,rgb.g,rgb.b) * saturation(rgb.r,rgb.g,rgb.b) +
          lightness(rgb.r,rgb.g,rgb.b) * lightness(rgb.r,rgb.g,rgb.b)
        ) + classify(rgb.r,rgb.g,rgb.b).float,
        " > ",
        saturation(rgb.r,rgb.g,rgb.b) + lightness(rgb.r,rgb.g,rgb.b) +
        classify(rgb.r,rgb.g,rgb.b).float  ]#




for col in 0..maxcolors:
  (arr[0],arr[1],arr[2]) = extractRGB(Color256RGB[col])

  res = classifyArray(arr)
  basec[col] = res

  echo arr, ": \e[38;5;" & $col & "m " & "███ " & $col & "\e[0m ", res,
    " > ", classify(arr), " + ", saturation(arr), " + ", lightness(arr)


#basec.sort()
#echo basec

var
  incr: int = 51
  arr2: array[0..2,int]
  choice:int
  found:bool

for rc in countup(0,255,incr):
  for gc in countup(0,255,incr):
    for bc in countup(0,255,incr):
      arr2 = [rc,gc,bc]

      res = classifyArray(arr2)
      found = false
      choice = maxcolors
      for i in 0..maxcolors:
        if basec[i] == res:
          choice = i
          found = true
          #echo " egssact ", choice
          #break
        elif abs(res - basec[i]) < abs(res - basec[choice])
        :
          choice = i
          found = true
          #echo i

      echo found, " R:", rc,
        ", G:", gc,
        ", B:", bc,
        " \x1b[38;2;" & $rc & ";" & $gc & ";" & $bc & "m ███\x1b[0m ", 
        " choice: \e[38;5;" & $choice & "m " & "███ "  & "\e[0m " & $choice & " ",
        res, " ", basec[choice] 




#[ 
for col in 0..maxcolors:
  (arr[0],arr[1],arr[2]) = extractRGB(Color256RGB[col])

  res = classify(arr)

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

      res = classify(arr2)

      choice = 0
      for i in 0..maxcolors:
        var 
          ar3 = [extractRGB(Color256RGB[i]).r, extractRGB(Color256RGB[i]).g, extractRGB(Color256RGB[i]).b]
          ar4 = [extractRGB(Color256RGB[choice]).r, extractRGB(Color256RGB[choice]).g, extractRGB(Color256RGB[choice]).b]
        #echo abs(lightness(rc,gc,bc) - lightness(ar3)), " : ",  abs(lightness(rc,gc,bc) - lightness(ar4))  
        if abs(basec[i] - res) <= abs(basec[choice] - res) and
          abs(lightness(rc,gc,bc) - lightness(ar3)) <
          abs(lightness(rc,gc,bc) - lightness(ar4)) 
        :
          choice = i

      echo "R:", rc,
        ", G:", gc,
        ", B:", bc,
        " \x1b[38;2;" & $rc & ";" & $gc & ";" & $bc & "m ███\x1b[0m ", res,
        " choice: \e[38;5;" & $int(choice) & "m " & "███ " & $choice & "\e[0m ",
        basec[choice] ]#