import parsecsv, parseutils, stui/colors_extra, stui/colors256, math

var 
  ofile, o2file, o3file: File

#[ ofile = open("devtools/HSLx256.nim",fmWrite)
ofile.write("const\n")

o2file = open("devtools/HSLDist256.nim",fmWrite)
o2file.write("const\n") ]#

o3file = open("devtools/HSLDP256table.nim",fmWrite)
o3file.write("const HSLDP256* = [\n")

proc getMin*[T](args: varargs[T]):T=
  result = T.high
  for arg in args:
    if arg < result:
      result = arg

proc getMax*[T](args: varargs[T]):T=
  for arg in args:
    if arg > result:
      result = arg

proc getDistance*(red,green,blue:float):float=
  result = sqrt(red * red + green * green + blue * blue  )

proc getDistance*(v:tuple[h,s,l:float]):float=
  result = sqrt(v.h * v.h + v.s * v.s + v.l * v.l  )


proc getForm*(red,green,blue:int):string=
  if red.int == green.int:
    result = "1"
  elif red.int < green.int:
    result = "2"
  else: result = "3"

  if green.int == blue.int:
    result &= "1"
  elif green.int < blue.int:
    result &= "2"
  else: result &= "3"  

  if blue.int == red.int:
    result &= "1"
  elif blue.int < red.int:
    result &= "2"
  else: result &= "3"  


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

var 
  r,g,b:int
  h,l,s:float
  str1:string
  tok1:int
  counter:int
  c1,c2:int
  d1,d2:float
  choice: tuple[d:float, c, r,g,b:int]

c1 = getCluster(RGBtoHSL(0.0, 127.0, 255.0).h)
d1 = getDistance(RGBtoHSL(0.0, 127.0, 255.0))


var p: CsvParser
p.open("devtools/256colornames.tsv",'\t')
while p.readRow():
  #echo p.row[3]
  tok1 = p.row[3].parseUntil(str1, '(') + 1
  
  tok1 += parseInt(p.row[3],r,tok1) + 1
  tok1 += parseInt(p.row[3],g,tok1) + 1
  tok1 += parseInt(p.row[3],b,tok1)
  #echo r, " ", g, " ", b

  (h,s,l) = RGBtoHSL(r.float,g.float,b.float)

  #[ c2 = getCluster(h)
  if c2 == c1 :
    d2 = getDistance((h,s,l))

    echo "clustermatch: " , $Color256(counter), "\t", $d1, " > ", $d2
    #TODO: what if 0.1 no result? enlarge while result.
    if d2 + 0.1 > d1 and d2 - 0.1 < d1: 
      echo "distance match: " , $Color256(counter)
      if abs(d1 - d2) < abs(d1 - choice.d):
        choice.d = d2
        choice.c = counter
        
        choice.r = r.int
        choice.g = g.int
        choice.b = b.int ]#


  #[ ofile.write("  HSL_" & $Color256(counter) & " = ( " & $h & ", " & $s & ", " & $l & " ),\n")

  o2file.write("  HSLDistance_" & $Color256(counter) & " = " & $getDistance((h,s,l)) & ",\n") ]#

  o3file.write("  [" & $h & ", " & getForm(r,g,b) & ", "  & $r & ", " & $g & ", " & $b & "],\n")

  counter += 1

p.close()

ofile.close()
o2file.close()

o3file.write("]")


#[ echo "\n Choice: ", $Color256(choice.c),
  ", R", choice.r,
  ", G", choice.g,
  ", B", choice.b,
  "\e[38;5;" & $int(choice.c) & "m " & "███ " & $choice.c & "\e[0m",
  "\x1b[38;2;0;127;255m ███\x1b[0m\n"
  #"\x1b[38;2;" & $needle.r & ";" & $needle.g & ";" & $needle.b & "m ███\x1b[0m\n" ]#